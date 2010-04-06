From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm] Fix ppc compile error
Date: Tue, 06 Apr 2010 14:11:46 -0400
Message-ID: <4BBB7962.7040403@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig095D3EC142ACBE5EB8E1FC67"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig095D3EC142ACBE5EB8E1FC67
Content-Type: multipart/mixed;
 boundary="------------080206060306050807030304"

This is a multi-part message in MIME format.
--------------080206060306050807030304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

We use -Wall -Werror on our build machines, and this causes our build to
fail on super-intel.c due to a missing cast on ppc64 machines.  This
fixes the build.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------080206060306050807030304
Content-Type: text/plain;
 name="mdadm-3.1.2-powerpc-compile.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-powerpc-compile.patch"

commit 995511f26e8d661d32d1c3fc42a08960989d1e6d
Author: Doug Ledford <dledford@redhat.com>
Date:   Tue Apr 6 14:04:30 2010 -0400

    powerpc compile fix
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/super-intel.c b/super-intel.c
index a196ca3..999b970 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -697,7 +697,7 @@ static void print_imsm_dev(struct imsm_dev *dev, char=
 *uuid, int disk_idx)
 		printf(" <-- %s", map_state_str[map->map_state]);
 		printf("\n     Checkpoint : %u (%llu)",
 		       __le32_to_cpu(dev->vol.curr_migr_unit),
-		       blocks_per_migr_unit(dev));
+		       (unsigned long long)blocks_per_migr_unit(dev));
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");

--------------080206060306050807030304--

--------------enig095D3EC142ACBE5EB8E1FC67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku7eWIACgkQg6WylM+/8ZSg8wCgqX6AKyxWcYBWmXoRzxakyLSW
VGgAnRWQgr4rmMDPqpxU1vhjEm3lNo2w
=/R6B
-----END PGP SIGNATURE-----

--------------enig095D3EC142ACBE5EB8E1FC67--
