From: Michael A Yehle <myehle@wanadoo.fr>
Subject: Possible bugs in Raidtools-1.00.3
Date: Fri, 7 Mar 2003 22:28:27 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030307212827.GA19491@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey all,  I'm new to linux RAID, sorry if these are duplicates, but I think=
 I've found a couple bugs:

In the raidtab man page, the lines for nr-spare-disks are incorrect:

"       nr-spare-disks count
              Number  of spare devices in the array; there should
              be count spare-disk  entries  later  in  the  file.
              Spare  disks may only be used with RAID4 and RAID5,
              and allow the kernel  to  automatically  build  new
              RAID  disks  as  needed.  "


Spare disks do work with RAID1.

----

The second thing I found is a little stranger:
I've made 4 partitions into a raid 1 array, 2 main and 2 spare.  My raidtab=
 is:
 raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  2
        chunk-size      4
        persistent-superblock   1
        device          /dev/hdd1
        raid-disk       0
        device          /dev/hdd2
        raid-disk       1
        device          /dev/hdd3
        spare-disk      0
        device          /dev/hdd4
        spare-disk      1

(I'm using partitions on the same hd for testing purposes)

I've been starting the array, mounting it and playing around with failures =
- simulating failures by mkfs'ing an unmounted partition.  When the raid-di=
sk 1 fails it falls over to one of the spares just as it's supposed to.  Wh=
en raid-disk 0 fails, mdstart reports the following "invalid argument /dev/=
md0"  If I reverse the raid-disk numbers so that disk 0 is good and disk 1 =
is corrupted everything works fine.   Example:

with the raidtab as above:
mkraid /dev/md0 ; mkfs /dev/md0; mount /dev/md0 /raid_test
copy some contents into /raid_test

umount /dev/mdo; raidstop /dev/md0

=46rom here, if I mkfs /dev/hdd2 (corrupt the partition in raid-disk 1) and=
=20
startraid /dev/md0 it rebuilds the array with one of the spare disks

However, if I mkfs /dev/hdd1 (corrupt raid-disk 0) and startraid it respond=
s with the above error.  Switching raid-disk 0 and 1 in the raidtab allows =
startraid to function and the array is rebuilt on a spare.

Hope I've made this clear...  I've got some free time to work with this if =
it is a problem (and I haven't done something incredibly stupid)...

Mike Y


--=20
"I don't need child-resistant caps on my medicine bottles.  They say,=20
"Well, someone with children might come and visit you."  Forget'em! Let 'em=
=20
take their chances. Anyone who visits me is accepting a certain level of=20
risk in the first place."
  --George Carlin

  myehle at wanadoo dot fr

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+aQ75E8nsBQq/fBwRAnnhAJwLlVjYMhMk9Y0/IK+lgviRO1uPMgCbBR8b
QbBodhYwiXdhAEee1oO0jmo=
=veND
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
