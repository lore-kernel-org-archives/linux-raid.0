From: Doug Ledford <dledford@redhat.com>
Subject: mdadm-2.5.4 issues and 2.6.18.1 kernel md issues
Date: Thu, 02 Nov 2006 09:58:23 -0500
Message-ID: <1162479503.2898.338.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-803776+vcWUrS+EeGRCL"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-803776+vcWUrS+EeGRCL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

If I use mdadm 2.5.4 to create a version 1 superblock raid1 device, it
starts a resync.  If I then reboot the computer part way through, when
it boots back up, the resync gets cancelled and the array is considered
clean.  This is against a 2.6.18.1 kernel.

If I create a version 1 superblock raid1 array, mdadm -D <constituent
device> says that the device is not part of a raid array (and likewise
the kernel autorun facility fails to find the device).

If I create a version 1 superblock raid1 array, mdadm -E <constituent
device> sees the superblock.  If I then run mdadm -E --brief on that
same device, it prints out the 1 line ARRAY line, but it misprints the
UUID such that is a 10 digit hex number: 8 digit hex number: 8 digit hex
number: 6 digit hex number.  It also prints the mdadm device in the
ARRAY line as /dev/md/# where as mdadm -D --brief prints the device
as /dev/md#.  Consistency would be nice.

Does the superblock still not store any information about whether or not
the array is a single device or partitionable?  Would be nice if the
superblock gave some clue as to that fact so that it could be used to
set the auto=3D param on an mdadm -E --brief line to the right mode.

Mdadm assumes that the --name option passed in to create an array means
something in particular to the md array name and modifies subsequent
mdadm -D --brief and mdadm -E --brief outputs to include the name option
minus the hostname.  Aka, if I set the name to firewall:/boot, mdadm -E
--brief will then print out the ARRAY line device as /dev/md//boot.  I
don't think this is documented anywhere.  This also raises the question
of how partitionable md devices will be handled in regards to their name
component.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-803776+vcWUrS+EeGRCL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFSgePTzP9PM7pjw8RApj8AJ4+313IEKwom0Xx+L1Se7pKL07OhgCbB/JO
jkyCsrBmVuCOZ4l8qlT5N2s=
=16jP
-----END PGP SIGNATURE-----

--=-803776+vcWUrS+EeGRCL--

