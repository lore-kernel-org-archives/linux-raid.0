From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: be careful not lot leak internal curr_resync value into metadata.
Date: Fri, 28 Oct 2016 15:59:41 +1100
Message-ID: <8737jht6f6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Viswesh <viswesh.vichu@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



mddev->curr_resync usually records where the current resync is up to,
but during the starting phase it has some "magic" values.

 1 - means that the array is trying to start a resync, but has yielded
     to another array which shares physical devices, and also needs to
     start a resync
 2 - means the array is trying to start resync, but has found another
     array which shares physical devices and has already started resync.

 3 - means that resync has commensed, but it is possible that nothing
     has actually been resynced yet.

It is important that this value not be visible to user-space and
particularly that it doesn't get written to the metadata, as the
resync or recovery checkpoint.  In part, this is because it may be
slightly higher than the correct value, though this is very rare.
In part, because it is not a multiple of 4K, and some devices only
support 4K aligned accesses.

There are two places where this value is propagates into either
=2D>curr_resync_completed or ->recovery_cp or ->recovery_offset.
These currently avoid the propagation of values 1 and 3, but will
allow 3 to leak through.

Change them to only propagate the value if it is > 3.

As this can cause an array to fail, the patch is suitable for -stable.

Cc: stable@vger.kernel.org
Reported-by: Viswesh <viswesh.vichu@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index eac84d8ff724..18d0c4adbd7b 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8144,14 +8144,14 @@ void md_do_sync(struct md_thread *thread)
=20
 	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
=2D	    mddev->curr_resync > 2) {
+	    mddev->curr_resync > 3) {
 		mddev->curr_resync_completed =3D mddev->curr_resync;
 		sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	}
 	mddev->pers->sync_request(mddev, max_sectors, &skipped);
=20
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
=2D	    mddev->curr_resync > 2) {
+	    mddev->curr_resync > 3) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				if (mddev->curr_resync >=3D mddev->recovery_cp) {
=2D-=20
2.10.1


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYEts9AAoJEDnsnt1WYoG5aWsP/iCRJN73A2WpGeaQoLUYdvFU
7g0NneOajD9Tjbmf3f9kc0T/EF8sMwNIU0O3Eb2KfS8xSOY99kCXKZD7ScNWkdG9
jCKQvJOXBFnlGKK6lacQv7NINoJl5t86XRT+9Tt6rJb/RJi4ddglpMYMCgCjtCN8
K/15MMDR7FlomfTlhmkQBd+FZoOTGrhnOYpYQTyYgOad7hiYhBjr2WEtq82x6u0S
GGwJsYXgoe31o/cPa+2Mhw9M54Fqf28/FOnrDzdD50r+bH0Lf94Cr6fbktfeTB11
INbfWyhfiOsCZKISgMcXabfmuInWhOmW1zdWIyFlUNawNju8YWbAup/yJrN2Z/2X
WaKWxEOpFkCx/xqqgDwlJ+nr08iMZEVQPirm2jFFmM+KC1CvGOAbo8M4XBlIF51/
jT0knAFWZlXrQbCBtNYR06ZQfhyQmUTdLuBtjiDOo4ak6fmB213KsDR49azzWurM
iFRV+t9fkFRp6aiDxeq4JbYUIMlRhN+dlerXGXXj0SUCwJkTk5kR3cxRhSXk1ANe
9NXc8UjKoqlCpYg0mgSqY6ynpP+jqurcxkYC2ilUzZBdZ+0ya0EZ9l5EsttnbVg6
0s+C35H6SrRrzZgYyx0QzvvR5NuI8urgmDkq6lhACYe5T/9biTvKS8cPkPDFffaM
Nu4z2NmEKGF5gCpDg3DP
=1rWj
-----END PGP SIGNATURE-----
--=-=-=--
