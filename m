From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair does not repair errors?
Date: Mon, 3 Feb 2014 12:04:31 +1100
Message-ID: <20140203120431.400a8a1b@notabene.brown>
References: <52EE3910.3040205@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.d/_.weSuoK+206K69tTDBW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EE3910.3040205@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.d/_.weSuoK+206K69tTDBW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 02 Feb 2014 16:24:48 +0400 Michael Tokarev <mjt@tls.msk.ru> wrote:

> Hello.
>=20
> This is a followup for a somewhat old thread, --
>  http://thread.gmane.org/gmane.linux.raid/44503
> with the required details.
>=20
> Initial problem was that with a raid1 array on a
> few drives and one of them having a bad sector,
> runnig `repair' action does not actually fix the
> error, it looks like the raid1 code does not see
> the error.
>=20
> This is a production host, so it is very difficult to
> experiment.  When I initially hit this issue there, I
> tried various ways to fix the issue, one of them was
> to removing the bad drive from the array and adding
> it back.  This forced all sectors to be re-written,
> and the problem went away.
>=20
> Now, the same issue happened again - another drive
> developed a bad sector, and again, md `repair' action
> does not fix it.
>=20
> So I added some debugging as requested in the original
> thread, and re-run `repair' action.
>=20
> Here's the changes I added to 3.10 raid1.c file:
>=20
> --- ../linux-3.10/drivers/md/raid1.c	2014-02-02 16:01:55.003119836 +0400
> +++ drivers/md/raid1.c	2014-02-02 16:07:37.913808336 +0400
> @@ -1636,6 +1636,8 @@ static void end_sync_read(struct bio *bi
>  	 */
>  	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +else
> +printk("end_sync_read: !BIO_UPTODATE\n");
>=20
>  	if (atomic_dec_and_test(&r1_bio->remaining))
>  		reschedule_retry(r1_bio);
> @@ -1749,6 +1751,7 @@ static int fix_sync_read_error(struct r1
>  				 * active, and resync is currently active
>  				 */
>  				rdev =3D conf->mirrors[d].rdev;
> +printk("fix_sync_read_error: calling sync_page_io(%Li, %Li<<9)\n", (uint=
64_t)sect, (uint64_t)s);
>  				if (sync_page_io(rdev, sect, s<<9,
>  						 bio->bi_io_vec[idx].bv_page,
>  						 READ, false)) {
> @@ -1931,10 +1934,12 @@ static void sync_request_write(struct md
>=20
>  	bio =3D r1_bio->bios[r1_bio->read_disk];
>=20
> -	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> +	if (!test_bit(R1BIO_Uptodate, &r1_bio->state)) {
>  		/* ouch - failed to read all of that. */
> +printk("sync_request_write: !R1BIO_Uptodate\n");
>  		if (!fix_sync_read_error(r1_bio))
>  			return;
> +	}
>=20
>  	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
>  		if (process_checks(r1_bio) < 0)
>=20
>=20
> And here is the whole dmesg result from the repair run:
>=20
> [   74.288227] md: requested-resync of RAID array md1
> [   74.288719] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [   74.289329] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for requested-resync.
> [   74.290404] md: using 128k window, over a total of 2096064k.
> [  179.213754] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 acti=
on 0x0
> [  179.214500] ata6.00: irq_stat 0x40000008
> [  179.214909] ata6.00: failed command: READ FPDMA QUEUED
> [  179.215452] ata6.00: cmd 60/80:00:00:3e:3e/00:00:00:00:00/40 tag 0 ncq=
 65536 in
> [  179.215452]          res 41/40:00:23:3e:3e/00:00:00:00:00/40 Emask 0x4=
09 (media error) <F>
> [  179.217087] ata6.00: status: { DRDY ERR }
> [  179.217500] ata6.00: error: { UNC }
> [  179.220185] ata6.00: configured for UDMA/133
> [  179.220656] sd 5:0:0:0: [sdd] Unhandled sense code
> [  179.221149] sd 5:0:0:0: [sdd]
> [  179.221476] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [  179.222062] sd 5:0:0:0: [sdd]
> [  179.222398] Sense Key : Medium Error [current] [descriptor]
> [  179.223034] Descriptor sense data with sense descriptors (in hex):
> [  179.223704]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [  179.224726]         00 3e 3e 23
> [  179.225169] sd 5:0:0:0: [sdd]
> [  179.225494] Add. Sense: Unrecovered read error - auto reallocate failed
> [  179.226215] sd 5:0:0:0: [sdd] CDB:
> [  179.226577] Read(10): 28 00 00 3e 3e 00 00 00 80 00
> [  179.227344] end_request: I/O error, dev sdd, sector 4079139
> [  179.227926] end_sync_read: !BIO_UPTODATE
> [  179.228359] ata6: EH complete
> [  181.926457] md: md1: requested-resync done.
>=20
>=20
> So the only printk I've added is seen: "end_sync_read: !BIO_UPTODATE", and
> it looks like rewriting code is never called.
>=20
>=20
> This is root array of a production machine, so I can reboot it only at
> late evenings or at weekends.  But this time I finally want to fix the
> bug for real, so I will not try to fix the erroneous drive until we will
> be able to fix the code.  Just one thing: the fixing process might be
> a bit slow.
>=20
> Thanks,
>=20
> /mjt


Hi,
 thanks for the testing and report.  I see what the problem is now.

We only try to fix a read error when all reads failed rather than when any
read fails.
Most of the time there is only one read so this makes no difference.
However for 'check' and 'repair' we read all devices so the current code wi=
ll
only try to repair a read error if *every*  device failed, which of course
would be pointless.

This patch (against v3.10) should fix it.  It only leaves R1BIO_Uptodate set
if no failure is seen.

NeilBrown


diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6e17f8181c4b..ba38ef6c612b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1633,8 +1633,8 @@ static void end_sync_read(struct bio *bio, int error)
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		clear_bit(R1BIO_Uptodate, &r1_bio->state);
=20
 	if (atomic_dec_and_test(&r1_bio->remaining))
 		reschedule_retry(r1_bio);
@@ -2609,6 +2609,7 @@ static sector_t sync_request(struct mddev *mddev, sec=
tor_t sector_nr, int *skipp
 	/* For a user-requested sync, we read all readable devices and do a
 	 * compare
 	 */
+	set_bit(R1BIO_UPTODATE, &r1_bio->state);
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		atomic_set(&r1_bio->remaining, read_targets);
 		for (i =3D 0; i < conf->raid_disks * 2 && read_targets; i++) {

--Sig_/.d/_.weSuoK+206K69tTDBW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUu7rHznsnt1WYoG5AQLn9Q/9Eho1HFLjxunuGiop2uvWwfGxE7N3v+00
Pyupvs2nvuU+Pzeoa9qTBxEFJ8GB3a/Bf2c6r1xBj320kXtrM0NzB9incR320D0P
B210CMnFbjYTJB7UKl0oUX9+05rsBmMRcWXKi/eijLuSiP4XxATBv6CHiJCWoP2q
qgVjT09eDP1b0mhadgpWrZ7gq55UklmChZP0zDbSo7RfkItU0niaCwcaBaGWl7Xf
++7h2xmij6Pby8zHXvVFoKdVzriX8bFTPUn98JGIf+vkyiih/wL6xSocyh83am/w
pTdjnhA0Yu4MJd0LJ+6HMWb6nKJmvbK8B0tlOtq2ethvBuI9DvzoYQuJTBP56fBu
Re88oamSQ6Y3x7TZeODOhdlCcEGJn6fWSCmudWT9rmAtmtR1f3OxaXgMOipiRTUV
rzA9vU3AxTTQbYx4bmqZ3pvUn/TQXsnnfjE/a10fFCv2bZxUTYGXu4YzWA515Nga
FZt0YFHHyUQpkcprOf2RvPXuwARrAfxlKzu9JU7Rs6jsLEJpr7hSgpgMmXUSadcJ
of/jzPLhDF8rCmJk+l2IfunqRVsMD5/RQzaiDNK180crmxEOYa1fjD7j5G2to6Bj
21eYtY37p7rkzKXB6P7/svaLVYikFzEcnAfdxe6ir8i/ZUjdFAsnkX0ozUK/vxG+
DxyiApSzt/w=
=LILl
-----END PGP SIGNATURE-----

--Sig_/.d/_.weSuoK+206K69tTDBW--
