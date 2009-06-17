From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
	in
Date: Wed, 17 Jun 2009 15:47:57 +0530
Message-ID: <37d33d830906170317n52afe885y31da8180457fc843@mail.gmail.com>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	 <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	 <37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
	 <921ca19c0906170102s2928dbbeqb76fc933f2ee60f7@mail.gmail.com>
	 <37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
	 <921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
	 <37d33d830906170232s75421f5as2e6bbd9db1fe10ac@mail.gmail.com>
	 <921ca19c0906170237o79ba438dpbcaf00c9a4ab56b@mail.gmail.com>
	 <19000.48877.539325.500493@notabene.brown>
	 <37d33d830906170315k4087d532nc2426879c2063fd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636e90f6cf41c83046c889a92
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830906170315k4087d532nc2426879c2063fd7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--001636e90f6cf41c83046c889a92
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Neil,

I am attaching the patch file as I am seeing some issues with
copy-paste into the mail.

On Wed, Jun 17, 2009 at 3:45 PM, SandeepKsinha<sandeepksinha@gmail.com> wro=
te:
> Hi Neil,
> My Mistake. I missed "stg refresh". Here is the updated one.
> Sorry for the inconvinience.
>
> Signed-off-by:=A0Sandeep K Sinha <sandeepksinha@gmail.com>
> =A0=A0 =A0Due to the lack of memory ordering guarantees, we may have race=
s around
> mddev->conf. This patch addresses the same using rcu protection to avoid
> such race conditions.
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 9ad6ec4..f254a8a 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -28,10 +28,11 @@
> =A0static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sector)
> =A0{
> =A0 int lo, mid, hi;
> - linear_conf_t *conf =3D mddev_to_conf(mddev);
> -
> + linear_conf_t *conf;
> +
> =A0 lo =3D 0;
> =A0 hi =3D mddev->raid_disks - 1;
> + conf =3D rcu_dereference(mddev->private);
>
> =A0 /*
> =A0 * Binary Search
> @@ -45,7 +46,6 @@ static inline dev_info_t *which_dev(mddev_t *mddev,
> sector_t sector)
> =A0 else
> =A0 lo =3D mid + 1;
> =A0 }
> -
> =A0 return conf->disks + lo;
> =A0}
>
> @@ -66,7 +66,9 @@ static int linear_mergeable_bvec(struct request_queue *=
q,
> =A0 unsigned long maxsectors, bio_sectors =3D bvm->bi_size >> 9;
> =A0 sector_t sector =3D bvm->bi_sector + get_start_sect(bvm->bi_bdev);
>
> + rcu_read_lock();
> =A0 dev0 =3D which_dev(mddev, sector);
> + rcu_read_unlock();
> =A0 maxsectors =3D dev0->end_sector - sector;
>
> =A0 if (maxsectors < bio_sectors)
> @@ -86,36 +88,49 @@ static int linear_mergeable_bvec(struct request_queue
> *q,
> =A0static void linear_unplug(struct request_queue *q)
> =A0{
> =A0 mddev_t *mddev =3D q->queuedata;
> - linear_conf_t *conf =3D mddev_to_conf(mddev);
> + linear_conf_t *conf;
> =A0 int i;
>
> + rcu_read_lock();
> + conf =3D rcu_dereference(mddev->private);
> +
> =A0 for (i=3D0; i < mddev->raid_disks; i++) {
> =A0 struct request_queue *r_queue =3D bdev_get_queue(conf->disks[i].rdev-=
>bdev);
> =A0 blk_unplug(r_queue);
> =A0 }
> + rcu_read_unlock();
> =A0}
>
> =A0static int linear_congested(void *data, int bits)
> =A0{
> =A0 mddev_t *mddev =3D data;
> - linear_conf_t *conf =3D mddev_to_conf(mddev);
> + linear_conf_t *conf;
> =A0 int i, ret =3D 0;
>
> + rcu_read_lock();
> + conf =3D rcu_dereference(mddev->private);
> +
> =A0 for (i =3D 0; i < mddev->raid_disks && !ret ; i++) {
> =A0 struct request_queue *q =3D bdev_get_queue(conf->disks[i].rdev->bdev)=
;
> =A0 ret |=3D bdi_congested(&q->backing_dev_info, bits);
> =A0 }
> +
> + rcu_read_unlock();
> =A0 return ret;
> =A0}
>
> =A0static sector_t linear_size(mddev_t *mddev, sector_t sectors, int
> raid_disks)
> =A0{
> - linear_conf_t *conf =3D mddev_to_conf(mddev);
> -
> + linear_conf_t *conf;
> + sector_t array_sectors;
> + rcu_read_lock();
> + conf =3D rcu_dereference(mddev->private);
> =A0 WARN_ONCE(sectors || raid_disks,
> =A0 =A0"%s does not support generic reshape\n", __func__);
> -
> - return conf->array_sectors;
> + array_sectors =3D conf->array_sectors;
> + rcu_read_unlock();
> +
> + return array_sectors;
> =A0}
>
> =A0static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
> @@ -215,15 +230,14 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t
> *rdev)
> =A0 return -EINVAL;
>
> =A0 rdev->raid_disk =3D rdev->saved_raid_disk;
> -
> - newconf =3D linear_conf(mddev,mddev->raid_disks+1);
> + newconf =3D linear_conf(mddev,mddev->raid_disks + 1);
>
> =A0 if (!newconf)
> =A0 return -ENOMEM;
>
> =A0 newconf->prev =3D mddev_to_conf(mddev);
> - mddev->private =3D newconf;
> =A0 mddev->raid_disks++;
> + rcu_assign_pointer(mddev->private,newconf);
> =A0 md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
> =A0 set_capacity(mddev->gendisk, mddev->array_sectors);
> =A0 return 0;
> @@ -231,8 +245,15 @@ static int linear_add(mddev_t *mddev, mdk_rdev_t *rd=
ev)
>
> =A0static int linear_stop (mddev_t *mddev)
> =A0{
> - linear_conf_t *conf =3D mddev_to_conf(mddev);
> -
> + linear_conf_t *conf;
> +
> + /*
> + * We do not require rcu protection here since
> + * we hold reconfig_mutex for both linear_add and
> + * linear_stop, so they cannot race.
> + */
> +
> + conf =3D rcu_dereference(mddev->private);
> =A0 blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
> =A0 do {
> =A0 linear_conf_t *t =3D conf->prev;
> @@ -262,7 +283,9 @@ static int linear_make_request (struct request_queue =
*q,
> struct bio *bio)
> =A0 =A0 =A0 =A0bio_sectors(bio));
> =A0 part_stat_unlock();
>
> + rcu_read_lock();
> =A0 tmp_dev =3D which_dev(mddev, bio->bi_sector);
> + rcu_read_unlock();
> =A0=A0 =A0 start_sector =3D tmp_dev->end_sector - tmp_dev->rdev->sectors;
>
> =A0 if (unlikely(bio->bi_sector >=3D (tmp_dev->end_sector)
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the learner=
.=94
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learner.=
=94

--001636e90f6cf41c83046c889a92
Content-Type: text/x-patch; charset=US-ASCII; name="linear-rcu.patch"
Content-Disposition: attachment; filename="linear-rcu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fw1w3br30

Y29tbWl0IDg0OGNlYTM5NzRhNmM2M2E4YTgxMGI4ZTc0Yzg3YTQyZWE3MjczOTkKQXV0aG9yOiBT
YW5kZWVwIEsgU2luaGEgPHNhbmRlZXBrc2luaGFAZ21haWwuY29tPgpEYXRlOiAgIFdlZCBKdW4g
MTcgMTU6MzM6MzcgMjAwOSArMDUzMAoKICAgIER1ZSB0byB0aGUgbGFjayBvZiBtZW1vcnkgb3Jk
ZXJpbmcgZ3VhcmFudGVlcywgd2UgbWF5IGhhdmUgcmFjZXMgYXJvdW5kCm1kZGV2LT5jb25mLiBU
aGlzIHBhdGNoIGFkZHJlc3NlcyB0aGUgc2FtZSB1c2luZyByY3UgcHJvdGVjdGlvbiB0byBhdm9p
ZApzdWNoIHJhY2UgY29uZGl0aW9ucy4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2xpbmVhci5j
IGIvZHJpdmVycy9tZC9saW5lYXIuYwppbmRleCA5YWQ2ZWM0Li5mMjU0YThhIDEwMDY0NAotLS0g
YS9kcml2ZXJzL21kL2xpbmVhci5jCisrKyBiL2RyaXZlcnMvbWQvbGluZWFyLmMKQEAgLTI4LDEw
ICsyOCwxMSBAQAogc3RhdGljIGlubGluZSBkZXZfaW5mb190ICp3aGljaF9kZXYobWRkZXZfdCAq
bWRkZXYsIHNlY3Rvcl90IHNlY3RvcikKIHsKIAlpbnQgbG8sIG1pZCwgaGk7Ci0JbGluZWFyX2Nv
bmZfdCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOwotCQorCWxpbmVhcl9jb25mX3QgKmNv
bmY7CQorCiAJbG8gPSAwOwogCWhpID0gbWRkZXYtPnJhaWRfZGlza3MgLSAxOworCWNvbmYgPSBy
Y3VfZGVyZWZlcmVuY2UobWRkZXYtPnByaXZhdGUpOwogCiAJLyoKIAkgKiBCaW5hcnkgU2VhcmNo
CkBAIC00NSw3ICs0Niw2IEBAIHN0YXRpYyBpbmxpbmUgZGV2X2luZm9fdCAqd2hpY2hfZGV2KG1k
ZGV2X3QgKm1kZGV2LCBzZWN0b3JfdCBzZWN0b3IpCiAJCWVsc2UKIAkJCWxvID0gbWlkICsgMTsK
IAl9Ci0KIAlyZXR1cm4gY29uZi0+ZGlza3MgKyBsbzsKIH0KIApAQCAtNjYsNyArNjYsOSBAQCBz
dGF0aWMgaW50IGxpbmVhcl9tZXJnZWFibGVfYnZlYyhzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwK
IAl1bnNpZ25lZCBsb25nIG1heHNlY3RvcnMsIGJpb19zZWN0b3JzID0gYnZtLT5iaV9zaXplID4+
IDk7CiAJc2VjdG9yX3Qgc2VjdG9yID0gYnZtLT5iaV9zZWN0b3IgKyBnZXRfc3RhcnRfc2VjdChi
dm0tPmJpX2JkZXYpOwogCisJcmN1X3JlYWRfbG9jaygpOwogCWRldjAgPSB3aGljaF9kZXYobWRk
ZXYsIHNlY3Rvcik7CisJcmN1X3JlYWRfdW5sb2NrKCk7CiAJbWF4c2VjdG9ycyA9IGRldjAtPmVu
ZF9zZWN0b3IgLSBzZWN0b3I7CiAKIAlpZiAobWF4c2VjdG9ycyA8IGJpb19zZWN0b3JzKQpAQCAt
ODYsMzYgKzg4LDQ5IEBAIHN0YXRpYyBpbnQgbGluZWFyX21lcmdlYWJsZV9idmVjKHN0cnVjdCBy
ZXF1ZXN0X3F1ZXVlICpxLAogc3RhdGljIHZvaWQgbGluZWFyX3VucGx1ZyhzdHJ1Y3QgcmVxdWVz
dF9xdWV1ZSAqcSkKIHsKIAltZGRldl90ICptZGRldiA9IHEtPnF1ZXVlZGF0YTsKLQlsaW5lYXJf
Y29uZl90ICpjb25mID0gbWRkZXZfdG9fY29uZihtZGRldik7CisJbGluZWFyX2NvbmZfdCAqY29u
ZjsKIAlpbnQgaTsKIAorCXJjdV9yZWFkX2xvY2soKTsKKwljb25mID0gcmN1X2RlcmVmZXJlbmNl
KG1kZGV2LT5wcml2YXRlKTsKKwkKIAlmb3IgKGk9MDsgaSA8IG1kZGV2LT5yYWlkX2Rpc2tzOyBp
KyspIHsKIAkJc3RydWN0IHJlcXVlc3RfcXVldWUgKnJfcXVldWUgPSBiZGV2X2dldF9xdWV1ZShj
b25mLT5kaXNrc1tpXS5yZGV2LT5iZGV2KTsKIAkJYmxrX3VucGx1ZyhyX3F1ZXVlKTsKIAl9CisJ
cmN1X3JlYWRfdW5sb2NrKCk7CiB9CiAKIHN0YXRpYyBpbnQgbGluZWFyX2Nvbmdlc3RlZCh2b2lk
ICpkYXRhLCBpbnQgYml0cykKIHsKIAltZGRldl90ICptZGRldiA9IGRhdGE7Ci0JbGluZWFyX2Nv
bmZfdCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOworCWxpbmVhcl9jb25mX3QgKmNvbmY7
CiAJaW50IGksIHJldCA9IDA7CiAKKwlyY3VfcmVhZF9sb2NrKCk7CisJY29uZiA9IHJjdV9kZXJl
ZmVyZW5jZShtZGRldi0+cHJpdmF0ZSk7CisJCiAJZm9yIChpID0gMDsgaSA8IG1kZGV2LT5yYWlk
X2Rpc2tzICYmICFyZXQgOyBpKyspIHsKIAkJc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBiZGV2
X2dldF9xdWV1ZShjb25mLT5kaXNrc1tpXS5yZGV2LT5iZGV2KTsKIAkJcmV0IHw9IGJkaV9jb25n
ZXN0ZWQoJnEtPmJhY2tpbmdfZGV2X2luZm8sIGJpdHMpOwogCX0KKworCXJjdV9yZWFkX3VubG9j
aygpOwogCXJldHVybiByZXQ7CiB9CiAKIHN0YXRpYyBzZWN0b3JfdCBsaW5lYXJfc2l6ZShtZGRl
dl90ICptZGRldiwgc2VjdG9yX3Qgc2VjdG9ycywgaW50IHJhaWRfZGlza3MpCiB7Ci0JbGluZWFy
X2NvbmZfdCAqY29uZiA9IG1kZGV2X3RvX2NvbmYobWRkZXYpOwotCisJbGluZWFyX2NvbmZfdCAq
Y29uZjsKKwlzZWN0b3JfdCBhcnJheV9zZWN0b3JzOworCXJjdV9yZWFkX2xvY2soKTsKKwljb25m
ID0gcmN1X2RlcmVmZXJlbmNlKG1kZGV2LT5wcml2YXRlKTsKIAlXQVJOX09OQ0Uoc2VjdG9ycyB8
fCByYWlkX2Rpc2tzLAogCQkgICIlcyBkb2VzIG5vdCBzdXBwb3J0IGdlbmVyaWMgcmVzaGFwZVxu
IiwgX19mdW5jX18pOwotCi0JcmV0dXJuIGNvbmYtPmFycmF5X3NlY3RvcnM7CisJYXJyYXlfc2Vj
dG9ycyA9IGNvbmYtPmFycmF5X3NlY3RvcnM7CisJcmN1X3JlYWRfdW5sb2NrKCk7CisJCisJcmV0
dXJuIGFycmF5X3NlY3RvcnM7CiB9CiAKIHN0YXRpYyBsaW5lYXJfY29uZl90ICpsaW5lYXJfY29u
ZihtZGRldl90ICptZGRldiwgaW50IHJhaWRfZGlza3MpCkBAIC0yMTUsMTUgKzIzMCwxNCBAQCBz
dGF0aWMgaW50IGxpbmVhcl9hZGQobWRkZXZfdCAqbWRkZXYsIG1ka19yZGV2X3QgKnJkZXYpCiAJ
CXJldHVybiAtRUlOVkFMOwogCiAJcmRldi0+cmFpZF9kaXNrID0gcmRldi0+c2F2ZWRfcmFpZF9k
aXNrOwotCi0JbmV3Y29uZiA9IGxpbmVhcl9jb25mKG1kZGV2LG1kZGV2LT5yYWlkX2Rpc2tzKzEp
OworCW5ld2NvbmYgPSBsaW5lYXJfY29uZihtZGRldixtZGRldi0+cmFpZF9kaXNrcyArIDEpOwog
CiAJaWYgKCFuZXdjb25mKQogCQlyZXR1cm4gLUVOT01FTTsKIAogCW5ld2NvbmYtPnByZXYgPSBt
ZGRldl90b19jb25mKG1kZGV2KTsKLQltZGRldi0+cHJpdmF0ZSA9IG5ld2NvbmY7CiAJbWRkZXYt
PnJhaWRfZGlza3MrKzsKKwlyY3VfYXNzaWduX3BvaW50ZXIobWRkZXYtPnByaXZhdGUsbmV3Y29u
Zik7CiAJbWRfc2V0X2FycmF5X3NlY3RvcnMobWRkZXYsIGxpbmVhcl9zaXplKG1kZGV2LCAwLCAw
KSk7CiAJc2V0X2NhcGFjaXR5KG1kZGV2LT5nZW5kaXNrLCBtZGRldi0+YXJyYXlfc2VjdG9ycyk7
CiAJcmV0dXJuIDA7CkBAIC0yMzEsOCArMjQ1LDE1IEBAIHN0YXRpYyBpbnQgbGluZWFyX2FkZCht
ZGRldl90ICptZGRldiwgbWRrX3JkZXZfdCAqcmRldikKIAogc3RhdGljIGludCBsaW5lYXJfc3Rv
cCAobWRkZXZfdCAqbWRkZXYpCiB7Ci0JbGluZWFyX2NvbmZfdCAqY29uZiA9IG1kZGV2X3RvX2Nv
bmYobWRkZXYpOwotICAKKwlsaW5lYXJfY29uZl90ICpjb25mOworCisJLyoKKwkgKiBXZSBkbyBu
b3QgcmVxdWlyZSByY3UgcHJvdGVjdGlvbiBoZXJlIHNpbmNlCisJICogd2UgaG9sZCByZWNvbmZp
Z19tdXRleCBmb3IgYm90aCBsaW5lYXJfYWRkIGFuZAorCSAqIGxpbmVhcl9zdG9wLCBzbyB0aGV5
IGNhbm5vdCByYWNlLgorCSAqLworCisJY29uZiA9IHJjdV9kZXJlZmVyZW5jZShtZGRldi0+cHJp
dmF0ZSk7CiAJYmxrX3N5bmNfcXVldWUobWRkZXYtPnF1ZXVlKTsgLyogdGhlIHVucGx1ZyBmbiBy
ZWZlcmVuY2VzICdjb25mJyovCiAJZG8gewogCQlsaW5lYXJfY29uZl90ICp0ID0gY29uZi0+cHJl
djsKQEAgLTI2Miw3ICsyODMsOSBAQCBzdGF0aWMgaW50IGxpbmVhcl9tYWtlX3JlcXVlc3QgKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCiAJCSAgICAgIGJpb19zZWN0
b3JzKGJpbykpOwogCXBhcnRfc3RhdF91bmxvY2soKTsKIAorCXJjdV9yZWFkX2xvY2soKTsKIAl0
bXBfZGV2ID0gd2hpY2hfZGV2KG1kZGV2LCBiaW8tPmJpX3NlY3Rvcik7CisJcmN1X3JlYWRfdW5s
b2NrKCk7CiAgICAgc3RhcnRfc2VjdG9yID0gdG1wX2Rldi0+ZW5kX3NlY3RvciAtIHRtcF9kZXYt
PnJkZXYtPnNlY3RvcnM7CiAKIAlpZiAodW5saWtlbHkoYmlvLT5iaV9zZWN0b3IgPj0gKHRtcF9k
ZXYtPmVuZF9zZWN0b3IpCg==
--001636e90f6cf41c83046c889a92--
