From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md/raid1: avoid reusing a resync bio after error handling.
Date: Thu, 06 Apr 2017 12:06:37 +1000
Message-ID: <87bmsaguhe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


fix_sync_read_error() modifies a bio on a newly faulty
device by setting bi_end_io to end_sync_write.
This ensure that put_buf() will still call rdev_dec_pending()
as required, but makes sure that subsequent code in
fix_sync_read_error() doesn't try to read from the device.

Unfortunately this interacts badly with sync_request_write()
which assumes that any bio with bi_end_io set to non-NULL
other than end_sync_read is safe to write to.

As the device is now faulty it doesn't make sense to write.
As the bio was recently used for a read, it is "dirty"
and not suitable for immediate submission.
In particular, ->bi_next might be non-NULL, which will cause
generic_make_request() to complain.

Break this interaction by refusing to write to devices
which are marked as Faulty.

Reported-and-tested-by: Michael Wang <yun.wang@profitbricks.com>
Fixes: 2e52d449bcec ("md/raid1: add failfast handling for reads.")
Cc: stable@vger.kernel.org (v4.10+)
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/raid1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a70283753a35..9c1b2231d2db 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2185,6 +2185,8 @@ static void sync_request_write(struct mddev *mddev, s=
truct r1bio *r1_bio)
 		     (i =3D=3D r1_bio->read_disk ||
 		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
 			continue;
+		if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
+			continue;
=20
 		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
 		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljloq0ACgkQOeye3VZi
gbmOqg/+L16AAWpN07CHXEyRIx9ytHAKQA+B5nwDAzimdsGxcVs6UKhgMpNR5UiC
FhJgvp6LSWPQlIIzj1A4drWS906lHba5bTL1lFps754JqrolsPdFKNUri/KJfoKi
p7Mw26Ze5P/3Rcou6LSGKez4F03OyDeVCsrfd6cCfZXbqzT0nAltd9x3tI92JhbJ
KfUJ0FUrBfkTxezqzWR4S38N+8+jNSeIWCmcYSgaYUUw9d6CaOgRzULvs6SyXhba
0koNvLZKfDHAtIyjbQ2UAwOyky3BnW2vRnCm+FwIUkWB3K3VAgjw8jHaqcDVCoKq
bOkGEI/6THucG9+SjrvcY634oiAMXp4RXlcVI8fVW1z1DD+DR2dI4+8pSXoYasS0
WcDHmHxvRmqQ/QrEJf9h94JuFle+PVyEIME2+Ja+57wlqO8tgHW5BYKbgs/vuerl
qe1Z6tySR5B8XXZWMlHaleRVweoI1EnPsK+b7Jagt1c3B0nvhPb0L+2pSkziesNs
n+G0L8ncTkTy7wz/5xQJXAzsM+BYMQf72K/7Dcaql43ORHLqq+LcsqAlFmmV0dPR
uBgHVXPcf7UXNp5pNQ0UeCBaR/rKnnEzEYyOkXvMVWWioh/5CSNVC1DWGTS5hmYj
odyf2jPAcQOMkyLrU4/TwTf1IGl4rCiXdosShesodiJjdog2kjI=
=wKQW
-----END PGP SIGNATURE-----
--=-=-=--
