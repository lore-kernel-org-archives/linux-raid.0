From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Tue, 06 Apr 2010 12:26:15 -0400
Message-ID: <4BBB60A7.9030205@redhat.com>
References: <4BBA1289.4010705@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF988EE392F0AD6337D6AB7D7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBA1289.4010705@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF988EE392F0AD6337D6AB7D7
Content-Type: multipart/mixed;
 boundary="------------050600050204080701040809"

This is a multi-part message in MIME format.
--------------050600050204080701040809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2010 12:40 PM, Doug Ledford wrote:
> We have incremental mode for supporting hot plug of devices.  However,
> we don't support hot-unplug.  This is something we need in order to
> enable automatic device replacement.  When implementing the support
> though, I found that we had a problem in that the device special file i=
s
> already gone (well, not gone, but both open and lstat fail on the devic=
e
> special file, which really makes Manage_subdevs unhappy) by the time
> udev calls us to remove the device (even if I created a new udev rules
> file with a very low number this was still true).  So, along with addin=
g
> the code shamelessly stolen from Hawrylewicz with modifications to make=

> it work on non-container based arrays, I had to modify Manage_subdevs t=
o
> work on sysfs subdevice entries in the fail and remove cases.  Anyway,
> with this in place, and with the modified udev rules file in place,
> hot-unplug now works (or at least it does in my testing, I didn't try a=

> container device, I'll leave tweaking that to Dan or someone else from
> Intel, although it should more or less work, I don't know the Intel
> metadata rules and so didn't try to make it work myself).  And by
> changing Manage_subdevs to use either a valid device special file or
> sysfs entries, it will work on the command line with virtually any
> kernel, and work from a udev rules file on kernels recent enough to hav=
e
> the state entry in sysfs subdevs directories.
>=20
> Oh, and Neil should review my man page additions to see if they are
> sufficient for his tastes.  I didn't get real wordy about the support,
> it's pretty straight forward.
>=20

Minor incremental fixup:  In the case of passing in faulty or
disconnected as the device name, since we now use the value of tfd to
determine if we should attempt ioctls or go straight to using sysfs
entries, we now need to make sure we init tdf and then set it properly
in both of the loops where we check for faulty and disconnected devices
(although I'm now highly suspicious of the faulty check code as I
suspect all the faulty devices will have the same problem that our hot
unplug code ran into and the faulty devices will not be openable and
that will mean that passing in faulty is probably just broken at this
point in time...but that's another patch for another day).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------050600050204080701040809
Content-Type: text/plain;
 name="mdadm-3.1.2-decremental-2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm-3.1.2-decremental-2.patch"

commit ddda49f6daf481471334f5675fbc1fa149d83ad6
Author: Doug Ledford <dledford@redhat.com>
Date:   Tue Apr 6 12:17:25 2010 -0400

    Minor bug fix to incremental remove support
   =20
    Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/Manage.c b/Manage.c
index 6539eda..b15586b 100644
--- a/Manage.c
+++ b/Manage.c
@@ -386,6 +386,7 @@ int Manage_subdevs(char *devname, int fd,
=20
 		next =3D dv->next;
 		jnext =3D 0;
+		tfd =3D -1;
=20
 		if (strcmp(dv->devname, "failed")=3D=3D0 ||
 		    strcmp(dv->devname, "faulty")=3D=3D0) {
@@ -406,6 +407,7 @@ int Manage_subdevs(char *devname, int fd,
 				stb.st_rdev =3D makedev(disc.major, disc.minor);
 				next =3D dv;
 				jnext =3D j+1;
+				tfd =3D 0;
 				sprintf(dvname,"%d:%d", disc.major, disc.minor);
 				dnprintable =3D dvname;
 				break;
@@ -440,6 +442,7 @@ int Manage_subdevs(char *devname, int fd,
 				stb.st_rdev =3D makedev(disc.major, disc.minor);
 				next =3D dv;
 				jnext =3D j+1;
+				tfd =3D 0;
 				dnprintable =3D dvname;
 				break;
 			}

--------------050600050204080701040809--

--------------enigF988EE392F0AD6337D6AB7D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku7YKcACgkQg6WylM+/8ZQ/vQCeNaQqYXDIxZKE6erpl/hq97cK
LUQAnAnbP2wXSyCrwi5JQdLZxNPiK6xi
=VlDg
-----END PGP SIGNATURE-----

--------------enigF988EE392F0AD6337D6AB7D7--
