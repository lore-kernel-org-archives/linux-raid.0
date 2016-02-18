From: NeilBrown <neilb@suse.com>
Subject: [PATCH] super-intel: ensure suspended region is removed when reshape completes.
Date: Thu, 18 Feb 2016 15:53:32 +1100
Message-ID: <871t8ar54j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, Ken Moffat <zarniwhoop@ntlworld.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


A recent commit removed a call to abort_reshape() when IMSM reshape
completed.  An unanticipated result of this is that the suspended
region is not cleared as it should be.
So after a reshape, a region of the array will cause all IO to block.

Re-instate the required updates to suspend_{lo,hi} coped from
abort_reshape().

This is caught (sometimes) by the test suite.

Also fix a couple of typos found while exploring the code.

Reported-by: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Fixes: 2139b03c2080 ("imsm: don't call abort_reshape() in imsm_manage_resha=
pe()")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 super-intel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 90b7b6dee5d0..80b48d0fdd47 100644
=2D-- a/super-intel.c
+++ b/super-intel.c
@@ -10465,7 +10465,7 @@ int check_degradation_change(struct mdinfo *info,
  * Function:	imsm_manage_reshape
  * Description:	Function finds array under reshape and it manages reshape
  *		process. It creates stripes backups (if required) and sets
=2D *		checheckpoits.
+ *		checkpoints.
  * Parameters:
  *	afd		: Backup handle (nattive) - not used
  *	sra		: general array info
@@ -10595,7 +10595,7 @@ static int imsm_manage_reshape(
=20
 		start =3D current_position * 512;
=20
=2D		/* allign reading start to old geometry */
+		/* align reading start to old geometry */
 		start_buf_shift =3D start % old_data_stripe_length;
 		start_src =3D start - start_buf_shift;
=20
@@ -10700,6 +10700,9 @@ static int imsm_manage_reshape(
 	ret_val =3D 1;
 abort:
 	free(buf);
+	sysfs_set_num(sra, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
+	sysfs_set_num(sra, NULL, "suspend_hi", 0);
+	sysfs_set_num(sra, NULL, "suspend_lo", 0);
=20
 	return ret_val;
 }
=2D-=20
2.7.1


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxU5MAAoJEDnsnt1WYoG5UEQQAIZkDNjVfezOcVb9fyvmEUIM
yujG9uIWar2OIMag+/Afky5SnOiOG9qmLGtLGZjJyNsdwFo640tFJjPG8UCEjsJL
fL97/xRp8UpZMDYAbfR7ywknNr+drQHcrmauaW599ri1RDqJw19Kqp+FyWvkD83e
2DxdjIMUFdpHFIYb6T1rqpcleH55OIJYNQLdgYdLhRkrGqPOeLDsrcNL5Yd/06Aw
eUe0RbrRmmbFNTaZDYb0lDl+9UrJ5NDci70ue0060WiQBOXaEc1s01TDiBD4ldyV
1knB5AjR+9V2boPFmdnr0iuzl1h4JgK2d8bsu08do+M5gSj1riah5PbYQDZAYlHl
xlL2l+G/wJ6SeAzw/vfLqMO5kTlc2jj509hovIEGBDUKrAblYMW1dNrzvdhV53Ar
fG14AqPVGNGWujcQ27f5Z1ldeeqSajMQoSE0CSfUY5AeBNXUnEfAYZFlZXKmEbzv
nviIMGQ6vpgYm/H0jO3lNsyRa5/jyvG5Xjr/wgElMOXXXFB7h0xV1/MnPqCA8kpm
JW0YMbWVUJVJ6kcjhi0Jp6AcG87Ti6AJ4GwZmmyv7ZiN8VXlegxhToReZNNnxqZl
u8bbKFwZl3w5iZd5UEX/95oNZdgJTwyUqMHHssS9gXLDo0vTy0sra47n2faapEmg
4XprnoW8TcUxXPZN8993
=L8yF
-----END PGP SIGNATURE-----
--=-=-=--
