From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair does not repair errors?
Date: Tue, 4 Feb 2014 15:30:42 +1100
Message-ID: <20140204153042.4288240c@notabene.brown>
References: <52EE3910.3040205@msgid.tls.msk.ru>
	<20140203120431.400a8a1b@notabene.brown>
	<20140203153644.4c530672@notabene.brown>
	<52EF45A0.3010401@msgid.tls.msk.ru>
	<52EFD608.6020106@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ejiGE.zg/sINUzmBXXD+Gx."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EFD608.6020106@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ejiGE.zg/sINUzmBXXD+Gx.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 03 Feb 2014 21:46:48 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> 03.02.2014 11:30, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > 03.02.2014 08:36, NeilBrown wrote:
> > []
> >> Actually I've changed my mind.  That patch won't fix anything.
> >> fix_sync_read_error() is focussed on fixing a read error on ->read_dis=
k.
> >> So we only set uptodate if ->read_disk succeeded.
> >>
> >> So this patch should do it.
> >>
> >> NeilBrown
> >>
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index fd3a2a14b587..0fe5fd469e74 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -1733,7 +1733,8 @@ static void end_sync_read(struct bio *bio, int e=
rror)
> >>  	 * or re-read if the read failed.
> >>  	 * We don't do much here, just schedule handling by raid1d
> >>  	 */
> >> -	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> >> +	if (bio =3D=3D r1_bio->bios[r1_bio->read_disk] &&
> >> +	    test_bit(BIO_UPTODATE, &bio->bi_flags))
> >>  		set_bit(R1BIO_Uptodate, &r1_bio->state);
> >> =20
> >>  	if (atomic_dec_and_test(&r1_bio->remaining))
> >>
> >=20
> > I changed it like this for now:
> >=20
> > --- ../linux-3.10/drivers/md/raid1.c	2014-02-02 16:01:55.003119836 +0400
> > +++ drivers/md/raid1.c	2014-02-03 11:26:59.062845829 +0400
> > @@ -1634,8 +1634,12 @@ static void end_sync_read(struct bio *bi
> >  	 * or re-read if the read failed.
> >  	 * We don't do much here, just schedule handling by raid1d
> >  	 */
> > -	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> > -		set_bit(R1BIO_Uptodate, &r1_bio->state);
> > +	if (bio =3D=3D r1_bio->bios[r1_bio->read_disk]) {
> > +	    if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> > + 		set_bit(R1BIO_Uptodate, &r1_bio->state);
> > +	    else
> > +		printk("end_sync_read: our bio, but !BIO_UPTODATE\n");
> > +	}
> >=20
> >  	if (atomic_dec_and_test(&r1_bio->remaining))
> >  		reschedule_retry(r1_bio);
> >=20
> > and will test it later today (in about 10 hours from now) -- as I
> > mentioned, this is a prod box and testing isn't possible anytime.
>=20
> Hm. With this change, there's nothing interesting in dmesg at all anymore:
>=20
> [  100.571933] md: requested-resync of RAID array md1
> [  100.572430] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  100.573041] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for requested-resync.
> [  100.574135] md: using 128k window, over a total of 2096064k.
> [  202.616277] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 acti=
on 0x0
> [  202.617035] ata6.00: irq_stat 0x40000008
> [  202.617439] ata6.00: failed command: READ FPDMA QUEUED
> [  202.617980] ata6.00: cmd 60/80:c0:00:3e:3e/00:00:00:00:00/40 tag 24 nc=
q 65536 in
> [  202.617980]          res 41/40:00:23:3e:3e/00:00:00:00:00/40 Emask 0x4=
09 (media error) <F>
> [  202.619631] ata6.00: status: { DRDY ERR }
> [  202.620077] ata6.00: error: { UNC }
> [  202.622692] ata6.00: configured for UDMA/133
> [  202.623182] sd 5:0:0:0: [sdd] Unhandled sense code
> [  202.623693] sd 5:0:0:0: [sdd]
> [  202.624011] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [  202.624600] sd 5:0:0:0: [sdd]
> [  202.624929] Sense Key : Medium Error [current] [descriptor]
> [  202.625576] Descriptor sense data with sense descriptors (in hex):
> [  202.626249]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [  202.627276]         00 3e 3e 23
> [  202.627722] sd 5:0:0:0: [sdd]
> [  202.628049] Add. Sense: Unrecovered read error - auto reallocate failed
> [  202.628773] sd 5:0:0:0: [sdd] CDB:
> [  202.629135] Read(10): 28 00 00 3e 3e 00 00 00 80 00
> [  202.629907] end_request: I/O error, dev sdd, sector 4079139
> [  202.630513] ata6: EH complete
> [  205.219181] md: md1: requested-resync done.
>=20
> So my printk is not called, and it still does not try to recover
> the error.
>=20
> So the first condition in that new if -- bio =3D=3D r1_bio->bios[r1_bio->=
read_disk] --
> is not true.
>=20
> So it is - apparently - a wrong guess... ;)
>=20
> BTW, just in case, -- this is a raid1 with 4 drives (yes, 4 copies of
> the same data), not a "usual" 2 disk.
>=20
> I can test something in next 2..3 hours, next test will be possible
> only tomorrow.
>=20
> Thanks,
>=20
> /mjt

I'm really on a roll here, aren't I.

I looked again and that code I've been trying to fix as actually perfectly
fine.  I'm not sure whether to be happy to sad about that.

But... I've found the bug.  I know this time because I actually tested it.
I tested and current mainline and it didn't work.  So I hunted and found a
bug.
But that buggy code isn't in 3.10.
So I tested 3.10 and it crashed.
Ah-ha I though.  So I looked at 3.10.27, and  it has different code.  It has
the buggy code.  So I tested that and  it didn't work.
Then I applied  the patch below, and now it does.

The bug was introduced by

commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 17 15:19:29 2013 +1000

    md/raid1: fix bio handling problems in process_checks()

which moved the clearing for bi_flags up in a function to before it was
tested.  That wasn't really the right thing to do.

When that was backported to 3.10 it fixed the crash, but introduce this new
bug.

Anyway enough of my rambling - here is the patch.  As I don't much feel like
trusting my own results just a the moment I look forward to your
confirmation, one way or the other.

Thanks,
NeilBrown


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index afaa5d425e9a..2328a8c557d4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1854,11 +1854,15 @@ static int process_checks(struct r1bio *r1_bio)
 	for (i =3D 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		int size;
+		int uptodate;
 		struct bio *b =3D r1_bio->bios[i];
 		if (b->bi_end_io !=3D end_sync_read)
 			continue;
-		/* fixup the bio for reuse */
+		/* fixup the bio for reuse, but preserve BIO_UPTODATE */
+		uptodate =3D test_bit(BIO_UPTODATE, &b->bi_flags);
 		bio_reset(b);
+		if (!uptodate)
+			clear_bit(BIO_UPTODATE, &b->bi_flags);
 		b->bi_vcnt =3D vcnt;
 		b->bi_size =3D r1_bio->sectors << 9;
 		b->bi_sector =3D r1_bio->sector +
@@ -1891,11 +1895,14 @@ static int process_checks(struct r1bio *r1_bio)
 		int j;
 		struct bio *pbio =3D r1_bio->bios[primary];
 		struct bio *sbio =3D r1_bio->bios[i];
+		int uptodate =3D test_bit(BIO_UPTODATE, &sbio->bi_flags);
=20
 		if (sbio->bi_end_io !=3D end_sync_read)
 			continue;
+		/*Now we can 'fixup' the BIO_UPTODATE flags */
+		set_bit(BIO_UPTODATE, &sbio->bi_flags);
=20
-		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+		if (uptodate) {
 			for (j =3D vcnt; j-- ; ) {
 				struct page *p, *s;
 				p =3D pbio->bi_io_vec[j].bv_page;
@@ -1910,7 +1917,7 @@ static int process_checks(struct r1bio *r1_bio)
 		if (j >=3D 0)
 			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
 		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-			      && test_bit(BIO_UPTODATE, &sbio->bi_flags))) {
+			      && uptodate)) {
 			/* No need to write to this device. */
 			sbio->bi_end_io =3D NULL;
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);

--Sig_/ejiGE.zg/sINUzmBXXD+Gx.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvBs8znsnt1WYoG5AQLUUxAAuemH2KHzHL+JN3BXtGFnPl8ZZSx8uljP
Dusl/ibeBeyyfli1ld7+4N00b+Sdp+DC44W0ddEnHOgLdfll4CgTvjJV3t6N9SRo
J1k59fMRaFxCtf7R1aoLElWjF5ULlSqBVa2DMTYr2FEI2WfQz55X+jtcom3ZsVkg
Qu/2cVGu7OdL0b9oCDbd3W/zB/yNrrYbfXHa5rJSPXbaLUZx4St56M8MxNPRUUG1
ck42x9Q6dRuS6fb8mXKu/JefqEs7aOZ5PgScOQUVgweyJgwQSoDdTf5r48ELo4fR
3+fye/0wKU8aw7t98nUr8gKuADqYEStaW+5jhRucBF97p+9HLoqD5q346rj7ULZt
zkwy8OVvoAlrJVOYMLAak3v0GB1gx0JwVKlWFcl1pJwZsGcbGUnJLnCZgnOMYoZl
/6u72zQZlbzXnY2s+MJKX0zSPwM4ZlhHXDSAqHsphWgMojG9WaJLaEFPL8haeuqm
6XPX+p8+8kjKjwfNBHWtyXAbkoA2T/StRhUad8W2/lDj8S4eI5ml77bH5bB18/Ue
UppURRR0odPqOrCrATDbmz/bhGs/ZSc5R5YXiXMInZ0PzWftc1zSqRBx4rW5qItn
iJ9h5p4YtnvOyOnfNhI/J654U26uW0w9C8/8H2z0xfvyyTxu6pVFXFYdYD6NVtA1
ygM/3Yoj/vg=
=QX5H
-----END PGP SIGNATURE-----

--Sig_/ejiGE.zg/sINUzmBXXD+Gx.--
