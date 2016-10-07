From: NeilBrown <neilb@suse.com>
Subject: [PATCH - mdadm] Fix some issues found by clang
Date: Fri, 07 Oct 2016 14:55:20 +1100
Message-ID: <8737k84xuf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


The clang compiler complained about each of these.

The mdmon.h error will only affect 'far' RAID10 arrays using intel or DDF
metadata, and there is no such thing.

The mdopen.c will cause a problem if there are no free md device
numbers in the first 512.  That is fairly unlikely.

The restripe.c error would only affect the 'test_stripe' command, and
probably doesn't change its behaviour.

The super-intel.c fix is purely cosmetic.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 mdmon.h       | 2 +-
 mdopen.c      | 2 +-
 restripe.c    | 2 +-
 super-intel.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mdmon.h b/mdmon.h
index aa750c6811e1..0b08c3d7da2a 100644
=2D-- a/mdmon.h
+++ b/mdmon.h
@@ -101,7 +101,7 @@ static inline int is_resync_complete(struct mdinfo *arr=
ay)
 		break;
 	case 10:
 		l =3D array->array.layout;
=2D		ncopies =3D (l & 0xff) * ((l >> 8) && 0xff);
+		ncopies =3D (l & 0xff) * ((l >> 8) & 0xff);
 		sync_size =3D array->component_size * array->array.raid_disks;
 		sync_size /=3D ncopies;
 		break;
diff --git a/mdopen.c b/mdopen.c
index f818fdf339eb..287b5211631a 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -318,7 +318,7 @@ int create_mddev(char *dev, char *name, int autof, int =
trustworthy,
 	else if (num < 0) {
 		/* need to choose a free number. */
 		char *_devnm =3D find_free_devnm(use_mdp);
=2D		if (devnm =3D=3D NULL) {
+		if (_devnm =3D=3D NULL) {
 			pr_err("No avail md devices - aborting\n");
 			return -1;
 		}
diff --git a/restripe.c b/restripe.c
index 56dca73ea86b..94342c7bc6f9 100644
=2D-- a/restripe.c
+++ b/restripe.c
@@ -462,7 +462,7 @@ int raid6_check_disks(int data_disks, int start, int ch=
unk_size,
 		}
=20
 		if((Px =3D=3D 0) && (Qx =3D=3D 0))
=2D			curr_broken_disk =3D curr_broken_disk;
+			curr_broken_disk =3D prev_broken_disk;
=20
 		if(curr_broken_disk >=3D data_disks + 2)
 			broken_status =3D 2;
diff --git a/super-intel.c b/super-intel.c
index 92817e9ec875..b24777ee3559 100644
=2D-- a/super-intel.c
+++ b/super-intel.c
@@ -10141,7 +10141,7 @@ enum imsm_reshape_type imsm_analyze_change(struct s=
upertype *st,
 				geo->size =3D max_size;
 		}
=20
=2D		if ((direction =3D=3D ROLLBACK_METADATA_CHANGES)) {
+		if (direction =3D=3D ROLLBACK_METADATA_CHANGES) {
 			/* accept size for rollback only
 			*/
 		} else {
=2D-=20
2.10.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX9xyoAAoJEDnsnt1WYoG5TAEQAMFR1L8mKXQhcF6L2g73BJ+G
ntbd9Nuv1qROewDlE/18FBbl05BN1ondd+4WvJd7Ekf7UlxRWae+HZdlAjOzZ1iy
Fr6GY3kV7s1q+NpiD5W0bTImrNdMqhj33QhNNQ2KkeLXcWNIEmvJrBgg1wnBmgPp
D1RIuVOo7xIJ7dEZ7ckhAdg/pMCOH4FoUzysPqiYfgssoEcd+LFYOhIc87Fl3PHK
ZpSXRtdmwxxAGQlnUrMt9SBg3O2AWM8kEwfugoPyuUCGKLvB6HQnhr3i+D7UBtjs
quKfV/6LA8q/SO93ml96wfJHIHdxK28xRWNMh8XLE4+lZUfvH9i0zn//977gezRi
U1G0auhRnFYPUPJrb/H5QXRilaoEGLExnoUcAIKMJpMxU+FUT5UN1bMyw73MRUmo
+56HckEfBUhTrsvX7IfemaZXxIN+nNVygIJVMLkeZH2BM4c6QGnrOF7GQJXR5GPw
k23VRdC87FuFwzHpBU1RCpJGfmwC0jtUGosVsKjyMJGfQa2ARhTOh4qrS+foGUPj
/t+d5HvcsUEggf9IDiXXcsytL1Bs56uf4/2iuqdbYMZCTxlhKNSlVqR9Xg1v6P1z
cgvt1tj2n0QtILlqVNayB0fXcJqldsRlr0OQZwl2s7f+U8UBApURdJYIrbjyrNdT
d4fN39fY24oypFl1ju+B
=EdGi
-----END PGP SIGNATURE-----
--=-=-=--
