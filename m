From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: md raid acceleration and the async_tx api
Date: Mon, 27 Aug 2007 12:12:47 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52025B10C6@azsmsx413.amr.corp.intel.com>
References: <200708271249.48684.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7E8DE.415BC9E9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <200708271249.48684.yur@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, Wolfgang Denk <wd@denx.de>, dzu@denx.de
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7E8DE.415BC9E9
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> From: Yuri Tikhonov [mailto:yur@emcraft.com]
>  Hello,
>=20
>  I tested the h/w accelerated RAID-5 using the kernel with PAGE_SIZE
set to
> 64KB and found the bonnie++ application hangs-up during the
"Re-writing"
> test. I made some investigations and discovered that the hang-up
occurs
> because one of the mpage_end_io_read() calls is missing (these are the
> callbacks initiated from the ops_complete_biofill() function).
>=20
>  The fact is that my low-level ADMA driver (the ppc440spe one)
successfully
> initiated the ops_complete_biofill() callback but the
ops_complete_biofill()
> function itself skipped calling the bi_end_io() handler of the
completed bio
> (current dev->read) because during processing of this (current
dev->read) bio
> some other request had come to the sh (current dev_q->toread). Thus
> ops_complete_biofill() scheduled another biofill operation which, as a
> result, overwrote the unacknowledged bio (dev->read in
ops_run_biofill()),
> and so we lost the previous dev->read bio completely.
>=20
>  Here is a patch that solves this problem. Perhaps this might be
implemented
> in some more elegant and effective way. What are your thoughts
regarding
> this?
>=20
>  Regards, Yuri
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 08b4893..7abc96b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -838,11 +838,24 @@ static void ops_complete_biofill(void
*stripe_head_ref)
>  		/* acknowledge completion of a biofill operation */
>  		/* and check if we need to reply to a read request
>  		 */
> -		if (test_bit(R5_Wantfill, &dev_q->flags) &&
!dev_q->toread) {
> +		if (test_bit(R5_Wantfill, &dev_q->flags)) {
>  			struct bio *rbi, *rbi2;
>  			struct r5dev *dev =3D &sh->dev[i];
>=20
> -			clear_bit(R5_Wantfill, &dev_q->flags);
> +			/* There is a chance that another fill operation
> +			 * had been scheduled for this dev while we
> +			 * processed sh. In this case do one of the
following
> +			 * alternatives:
> +			 * - if there is no active completed biofill for
the dev
> +			 *   then go to the next dev leaving Wantfill
set;
> +			 * - if there is active completed biofill for
the dev
> +			 *   then ack it but leave Wantfill set.
> +			 */
> +			if (dev_q->toread && !dev->read)
> +				continue;
> +
> +			if (!dev_q->toread)
> +				clear_bit(R5_Wantfill, &dev_q->flags);
>=20
>  			/* The access to dev->read is outside of the
>  			 * spin_lock_irq(&conf->device_lock), but is
protected

This still looks racy...  I think the complete fix is to make the
R5_Wantfill and dev_q->toread accesses atomic.  Please test the
following patch (also attached) and let me know if it fixes what you are
seeing:

Applies on top of git://lost.foo-projects.org/~dwillia2/git/iop
md-for-linus

---
raid5: fix ops_complete_biofill race in the asynchronous offload case

Protect against dev_q->toread toggling while testing and clearing the
R5_Wantfill bit.  This change prevents all asynchronous completions
(tasklets) from running during handle_stripe.
---

 drivers/md/raid5.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2f9022d..91c14c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -824,6 +824,7 @@ static void ops_complete_biofill(void
*stripe_head_ref)
 		(unsigned long long)sh->sector);
=20
 	/* clear completed biofills */
+	spin_lock(&sq->lock);
 	for (i =3D sh->disks; i--; ) {
 		struct r5dev *dev =3D &sh->dev[i];
 		struct r5_queue_dev *dev_q =3D &sq->dev[i];
@@ -861,6 +862,7 @@ static void ops_complete_biofill(void
*stripe_head_ref)
 	}
 	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
 	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	spin_unlock(&sq->lock);
=20
 	return_io(return_bi);
=20
@@ -2279,7 +2281,7 @@ static int add_queue_bio(struct stripe_queue *sq,
struct bio *bi, int dd_idx,
 		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sq->sector);
=20
-	spin_lock(&sq->lock);
+	spin_lock_bh(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
 	sh =3D sq->sh;
 	if (forwrite) {
@@ -2306,7 +2308,7 @@ static int add_queue_bio(struct stripe_queue *sq,
struct bio *bi, int dd_idx,
 	*bip =3D bi;
 	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sq->lock);
+	spin_unlock_bh(&sq->lock);
=20
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
@@ -2339,7 +2341,7 @@ static int add_queue_bio(struct stripe_queue *sq,
struct bio *bi, int dd_idx,
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sq->lock);
+	spin_unlock_bh(&sq->lock);
 	return 0;
 }
=20
@@ -3127,7 +3129,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		atomic_read(&sh->count), sq->pd_idx,
 		sh->ops.pending, sh->ops.ack, sh->ops.complete);
=20
-	spin_lock(&sq->lock);
+	spin_lock_bh(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
=20
 	s.syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
@@ -3370,7 +3372,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (sh->ops.count)
 		pending =3D get_stripe_work(sh);
=20
-	spin_unlock(&sq->lock);
+	spin_unlock_bh(&sq->lock);
=20
 	if (pending)
 		raid5_run_ops(sh, pending);
@@ -3397,7 +3399,7 @@ static void handle_stripe6(struct stripe_head *sh,
struct page *tmp_page)
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
=20
-	spin_lock(&sq->lock);
+	spin_lock_bh(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
=20
 	s.syncing =3D test_bit(STRIPE_SYNCING, &sh->state);
@@ -3576,7 +3578,7 @@ static void handle_stripe6(struct stripe_head *sh,
struct page *tmp_page)
 	if (s.expanding && s.locked =3D=3D 0)
 		handle_stripe_expansion(conf, sh, &r6s);
=20
-	spin_unlock(&sq->lock);
+	spin_unlock_bh(&sq->lock);
=20
 	return_io(return_bi);



------_=_NextPart_001_01C7E8DE.415BC9E9
Content-Type: application/octet-stream;
	name="md-accel-fix-ops-complete-biofill-race.patch"
Content-Transfer-Encoding: base64
Content-Description: md-accel-fix-ops-complete-biofill-race.patch
Content-Disposition: attachment;
	filename="md-accel-fix-ops-complete-biofill-race.patch"

cmFpZDU6IGZpeCBvcHNfY29tcGxldGVfYmlvZmlsbCByYWNlIGluIHRoZSBhc3luY2hyb25vdXMg
b2ZmbG9hZCBjYXNlCgpGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNv
bT4KClByb3RlY3QgYWdhaW5zdCBkZXZfcS0+dG9yZWFkIHRvZ2dsaW5nIHdoaWxlIHRlc3Rpbmcg
YW5kIGNsZWFyaW5nIHRoZQpSNV9XYW50ZmlsbCBiaXQuICBUaGlzIGNoYW5nZSBwcmV2ZW50cyBh
bGwgYXN5bmNocm9ub3VzIGNvbXBsZXRpb25zCih0YXNrbGV0cykgZnJvbSBydW5uaW5nIGR1cmlu
ZyBoYW5kbGVfc3RyaXBlLgotLS0KCiBkcml2ZXJzL21kL3JhaWQ1LmMgfCAgIDE2ICsrKysrKysr
Ky0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpp
bmRleCAyZjkwMjJkLi45MWMxNGM2IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL3JhaWQ1LmMKKysr
IGIvZHJpdmVycy9tZC9yYWlkNS5jCkBAIC04MjQsNiArODI0LDcgQEAgc3RhdGljIHZvaWQgb3Bz
X2NvbXBsZXRlX2Jpb2ZpbGwodm9pZCAqc3RyaXBlX2hlYWRfcmVmKQogCQkodW5zaWduZWQgbG9u
ZyBsb25nKXNoLT5zZWN0b3IpOwogCiAJLyogY2xlYXIgY29tcGxldGVkIGJpb2ZpbGxzICovCisJ
c3Bpbl9sb2NrKCZzcS0+bG9jayk7CiAJZm9yIChpID0gc2gtPmRpc2tzOyBpLS07ICkgewogCQlz
dHJ1Y3QgcjVkZXYgKmRldiA9ICZzaC0+ZGV2W2ldOwogCQlzdHJ1Y3QgcjVfcXVldWVfZGV2ICpk
ZXZfcSA9ICZzcS0+ZGV2W2ldOwpAQCAtODYxLDYgKzg2Miw3IEBAIHN0YXRpYyB2b2lkIG9wc19j
b21wbGV0ZV9iaW9maWxsKHZvaWQgKnN0cmlwZV9oZWFkX3JlZikKIAl9CiAJY2xlYXJfYml0KFNU
UklQRV9PUF9CSU9GSUxMLCAmc2gtPm9wcy5hY2spOwogCWNsZWFyX2JpdChTVFJJUEVfT1BfQklP
RklMTCwgJnNoLT5vcHMucGVuZGluZyk7CisJc3Bpbl91bmxvY2soJnNxLT5sb2NrKTsKIAogCXJl
dHVybl9pbyhyZXR1cm5fYmkpOwogCkBAIC0yMjc5LDcgKzIyODEsNyBAQCBzdGF0aWMgaW50IGFk
ZF9xdWV1ZV9iaW8oc3RydWN0IHN0cmlwZV9xdWV1ZSAqc3EsIHN0cnVjdCBiaW8gKmJpLCBpbnQg
ZGRfaWR4LAogCQkodW5zaWduZWQgbG9uZyBsb25nKWJpLT5iaV9zZWN0b3IsCiAJCSh1bnNpZ25l
ZCBsb25nIGxvbmcpc3EtPnNlY3Rvcik7CiAKLQlzcGluX2xvY2soJnNxLT5sb2NrKTsKKwlzcGlu
X2xvY2tfYmgoJnNxLT5sb2NrKTsKIAlzcGluX2xvY2tfaXJxKCZjb25mLT5kZXZpY2VfbG9jayk7
CiAJc2ggPSBzcS0+c2g7CiAJaWYgKGZvcndyaXRlKSB7CkBAIC0yMzA2LDcgKzIzMDgsNyBAQCBz
dGF0aWMgaW50IGFkZF9xdWV1ZV9iaW8oc3RydWN0IHN0cmlwZV9xdWV1ZSAqc3EsIHN0cnVjdCBi
aW8gKmJpLCBpbnQgZGRfaWR4LAogCSpiaXAgPSBiaTsKIAliaS0+YmlfcGh5c19zZWdtZW50cyAr
KzsKIAlzcGluX3VubG9ja19pcnEoJmNvbmYtPmRldmljZV9sb2NrKTsKLQlzcGluX3VubG9jaygm
c3EtPmxvY2spOworCXNwaW5fdW5sb2NrX2JoKCZzcS0+bG9jayk7CiAKIAlwcl9kZWJ1ZygiYWRk
ZWQgYmkgYiMlbGx1IHRvIHN0cmlwZSBzIyVsbHUsIGRpc2sgJWQuXG4iLAogCQkodW5zaWduZWQg
bG9uZyBsb25nKWJpLT5iaV9zZWN0b3IsCkBAIC0yMzM5LDcgKzIzNDEsNyBAQCBzdGF0aWMgaW50
IGFkZF9xdWV1ZV9iaW8oc3RydWN0IHN0cmlwZV9xdWV1ZSAqc3EsIHN0cnVjdCBiaW8gKmJpLCBp
bnQgZGRfaWR4LAogIG92ZXJsYXA6CiAJc2V0X2JpdChSNV9PdmVybGFwLCAmc2gtPmRldltkZF9p
ZHhdLmZsYWdzKTsKIAlzcGluX3VubG9ja19pcnEoJmNvbmYtPmRldmljZV9sb2NrKTsKLQlzcGlu
X3VubG9jaygmc3EtPmxvY2spOworCXNwaW5fdW5sb2NrX2JoKCZzcS0+bG9jayk7CiAJcmV0dXJu
IDA7CiB9CiAKQEAgLTMxMjcsNyArMzEyOSw3IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9zdHJpcGU1
KHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gpCiAJCWF0b21pY19yZWFkKCZzaC0+Y291bnQpLCBzcS0+
cGRfaWR4LAogCQlzaC0+b3BzLnBlbmRpbmcsIHNoLT5vcHMuYWNrLCBzaC0+b3BzLmNvbXBsZXRl
KTsKIAotCXNwaW5fbG9jaygmc3EtPmxvY2spOworCXNwaW5fbG9ja19iaCgmc3EtPmxvY2spOwog
CWNsZWFyX2JpdChTVFJJUEVfSEFORExFLCAmc2gtPnN0YXRlKTsKIAogCXMuc3luY2luZyA9IHRl
c3RfYml0KFNUUklQRV9TWU5DSU5HLCAmc2gtPnN0YXRlKTsKQEAgLTMzNzAsNyArMzM3Miw3IEBA
IHN0YXRpYyB2b2lkIGhhbmRsZV9zdHJpcGU1KHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gpCiAJaWYg
KHNoLT5vcHMuY291bnQpCiAJCXBlbmRpbmcgPSBnZXRfc3RyaXBlX3dvcmsoc2gpOwogCi0Jc3Bp
bl91bmxvY2soJnNxLT5sb2NrKTsKKwlzcGluX3VubG9ja19iaCgmc3EtPmxvY2spOwogCiAJaWYg
KHBlbmRpbmcpCiAJCXJhaWQ1X3J1bl9vcHMoc2gsIHBlbmRpbmcpOwpAQCAtMzM5Nyw3ICszMzk5
LDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3N0cmlwZTYoc3RydWN0IHN0cmlwZV9oZWFkICpzaCwg
c3RydWN0IHBhZ2UgKnRtcF9wYWdlKQogCSAgICAgICBhdG9taWNfcmVhZCgmc2gtPmNvdW50KSwg
cGRfaWR4LCByNnMucWRfaWR4KTsKIAltZW1zZXQoJnMsIDAsIHNpemVvZihzKSk7CiAKLQlzcGlu
X2xvY2soJnNxLT5sb2NrKTsKKwlzcGluX2xvY2tfYmgoJnNxLT5sb2NrKTsKIAljbGVhcl9iaXQo
U1RSSVBFX0hBTkRMRSwgJnNoLT5zdGF0ZSk7CiAKIAlzLnN5bmNpbmcgPSB0ZXN0X2JpdChTVFJJ
UEVfU1lOQ0lORywgJnNoLT5zdGF0ZSk7CkBAIC0zNTc2LDcgKzM1NzgsNyBAQCBzdGF0aWMgdm9p
ZCBoYW5kbGVfc3RyaXBlNihzdHJ1Y3Qgc3RyaXBlX2hlYWQgKnNoLCBzdHJ1Y3QgcGFnZSAqdG1w
X3BhZ2UpCiAJaWYgKHMuZXhwYW5kaW5nICYmIHMubG9ja2VkID09IDApCiAJCWhhbmRsZV9zdHJp
cGVfZXhwYW5zaW9uKGNvbmYsIHNoLCAmcjZzKTsKIAotCXNwaW5fdW5sb2NrKCZzcS0+bG9jayk7
CisJc3Bpbl91bmxvY2tfYmgoJnNxLT5sb2NrKTsKIAogCXJldHVybl9pbyhyZXR1cm5fYmkpOwog
Cg==

------_=_NextPart_001_01C7E8DE.415BC9E9--
