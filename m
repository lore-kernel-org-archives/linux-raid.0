From: Doug Ledford <dledford@redhat.com>
Subject: mdadm udev rules file just for incremental assembly/disassembly
Date: Tue, 06 Apr 2010 23:13:30 -0400
Message-ID: <4BBBF85A.6030801@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB4DE570DD52BC5C36C1F33F7"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB4DE570DD52BC5C36C1F33F7
Content-Type: multipart/mixed;
 boundary="------------040001080607000707080506"

This is a multi-part message in MIME format.
--------------040001080607000707080506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I actually don't keep the rules all in one file in Fedora, I have the
udev supplied 64-md-raid.rules file that I don't control and that has
the majority of stuff in it, but none of the incremental assembly stuff.
 Then I have a separate 65-md-incremental.rules file that is part of the
mdadm package and I therefore have direct control over.  That allows me
to turn incremental assembly on and off as I see fit without having to
bother the udev package maintainer.  So, just so you can see how I'm
doing things now that works with dracut, that honors whether or not the
system is set up to use mdadm or dmraid to handle imsm devices, and see
how both incremental assembly and disassembly of devices, and the rule
to handle incremental assembly of containers in a post-initramfs
environment looks like, here it is.

I should note that this is all tested and working at this point, so on
to the next step.  Although I will note that I had to turn down
sync_speed_max on my imsm arrays or a resync would make the system
completely unresponsive until it completed.  And I've got at least one
bug to that effect open right now.  So, I suspect the kernel is not
honoring the "only use idle time" part of the resync speed description.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband

--------------040001080607000707080506
Content-Type: text/plain;
 name="mdadm.rules"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mdadm.rules"

# This file causes block devices with Linux RAID (mdadm) signatures to
# automatically cause mdadm to be run.
# See udev(8) for syntax

SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", ENV{ID_FS_TYPE}=3D=3D"linux_ra=
id_member", \
	RUN+=3D"/sbin/mdadm -I $tempnode"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_FS_TYPE}=3D=3D"linux=
_raid_member", \
	RUN+=3D"/sbin/mdadm -If $env{DEVNAME}"

ENV{rd_NO_MDIMSM}=3D=3D"?*", GOTO=3D"md_imsm_inc_end"
# In case the initramfs only started some of the arrays in our container,=

# run incremental assembly on the container itself.  Note: we ran mdadm
# on the container in 64-md-raid.rules, and that's how the MD_LEVEL
# environment variable is already set.  If that disappears from the other=

# file, we will need to add this line into the middle of the next rule:
#	IMPORT{program}=3D"/sbin/mdadm -D --export $tempnode", \

SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"md*", \
	ENV{MD_LEVEL}=3D=3D"container", RUN+=3D"/sbin/mdadm -I $tempnode"

SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", ENV{ID_FS_TYPE}=3D=3D"isw_raid=
_member", \
	RUN+=3D"/sbin/mdadm -I $tempnode"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"remove", ENV{ID_FS_TYPE}=3D=3D"isw_r=
aid_member", \
	RUN+=3D"/sbin/mdadm -If $env{DEVNAME}"
LABEL=3D"md_imsm_inc_end"


--------------040001080607000707080506--

--------------enigB4DE570DD52BC5C36C1F33F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAku7+FoACgkQg6WylM+/8ZSgaACglcNfR6EnWp5JjOVVzZ3I7Kqm
SGsAl2OZhXNA2pSEmCrsCLKhvY6g230=
=u8Zm
-----END PGP SIGNATURE-----

--------------enigB4DE570DD52BC5C36C1F33F7--
