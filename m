From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 06 Apr 2010 23:07:47 -0400
Message-ID: <4BBBF703.6030508@redhat.com>
References: <4BBA1289.4010705@redhat.com> <20100407113035.3ca437f2@notabene.brown> <4BBBE7D2.6090608@redhat.com> <4BBBECD5.6010903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDF208B0DC6926AFF80BF8B48"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBBECD5.6010903@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDF208B0DC6926AFF80BF8B48
Content-Type: multipart/mixed;
 boundary="------------030409010005010104090707"

This is a multi-part message in MIME format.
--------------030409010005010104090707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Here's another minor incremental patch to the original.  This makes
hot-remove of imsm devices work.  The sanity tests just needed to be
updated to deal with an already missing device.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------030409010005010104090707
Content-Type: text/plain;
 name="mdadm-3.1.2-decremental-3.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-decremental-3.patch"

commit 1934c67fe5bc25a79393ad78e29bf9ef778bc701
Author: Doug Ledford <dledford@redhat.com>
Date:   Tue Apr 6 23:02:47 2010 -0400

    Only close lfd if we have an external metadata type since that's the =
only
    time we'll have it open.
   =20
    If we weren't able to open the device file, assume the device is gone=

    already and skip the sysfs_unique_holder test as it is guaranteed to
    fail.
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/Manage.c b/Manage.c
index b15586b..a690cfc 100644
--- a/Manage.c
+++ b/Manage.c
@@ -811,6 +811,7 @@ int Manage_subdevs(char *devname, int fd,
 				 * rely on the 'detached' checks
 				 */
 				if (strcmp(dv->devname, "detached") =3D=3D 0 ||
+				    tfd < 0 ||
 				    sysfs_unique_holder(dnum, stb.st_rdev))
 					/* pass */;
 				else {
@@ -878,8 +879,8 @@ int Manage_subdevs(char *devname, int fd,
=20
 				ping_manager(name);
 				free(name);
+				close(lfd);
 			}
-			close(lfd);
 			if (verbose >=3D 0)
 				fprintf(stderr, Name ": hot removed %s\n",
 					dnprintable);

--------------030409010005010104090707--

--------------enigDF208B0DC6926AFF80BF8B48
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku79wMACgkQg6WylM+/8ZSdhQCZAXrN2VkN+bj+LmGiiIEvdGde
QD8An0Me0ISWbzSZIf63X8CJpHZgREKt
=6BBz
-----END PGP SIGNATURE-----

--------------enigDF208B0DC6926AFF80BF8B48--
