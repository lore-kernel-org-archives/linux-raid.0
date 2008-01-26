From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: raid1, questions and/or ideas for improvement
Date: Sat, 26 Jan 2008 15:18:56 +0100
Message-ID: <200801261519.00177.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1271626.1ZvkRmA2ou";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart1271626.1ZvkRmA2ou
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

i'm just trying to optimize my raid1 setups. And i found out that a lot of =
my=20
assumption are already realised inside the md raid1.

So there is "--bitmap=3D" option which really improve raid1 resyncs. Great.=
 But=20
my Problem is, if i've baked a raid1 out of logical volumes and i want to=20
grow the whole thing. Problem is, that md doesn't realize a resized block=20
device while in use. So growing lvs and after that growing the raid1 while=
=20
the raid1 is active and clean doesn't work (you also _destroy_ your raid1=20
super block resp. raid1 can't find the super block after the grow of the=20
lvs). So i've to remove one block device, resize it with lvm and reinsert i=
t.=20
But now, the super block can't be found now, so full resync will happen. I=
=20
tried this with version 0.90, 1.1 and 1.2 of super block formats. Neither=20
worked.
So i'm wondering if there is some option to "preserve" the super block and=
=20
copy it back after the resize of the logical volume? (OK, i could dd the=20
superblock, but is this save?)
Another solution would be to tell md raid1 that it should reread the block=
=20
device sizes, so md can manage by himself to move the super block to the=20
correct position? Is there a possibility to tell md raid1 to reread block=20
device sizes of the unerlaying block devices and moving super blocks=20
correctly?
Another solution could be handy for resyncing almost equal disks. If md rai=
d1=20
could be told when adding a "new" disk that the new disk is almost equal th=
e=20
raid1 could do something like a resync, meaning reading the good and the ne=
w=20
disk, comparing, and only write to the new disk if blocks are not equal. Th=
e=20
benefit with this kind of resync is, that normally block devices can faster=
=20
read than write. Is this kind of resync already possible with md raid1?
Another crazy improvement with this feature would be, you could make sparse=
=20
block devices (with dm zero and dm snapshots) and do full resync with this=
=20
method without allocating each byte of the to be synced sparse block device.

There's also "--write-mostly" and "--write-behind=3D" but i only managed to=
 use=20
and set this on creation time. Is there a possibility to set "--write-mostl=
y"=20
and "--write-behind=3D" while a md raid1 is onine and active?
With this feature i could do dm snapshot of one device of the raid1, set th=
is=20
to "--write-mostly" and "--write-behind=3D" in the raid1 and make a backup =
of=20
the snapshot. So while doing the backup, the performance of the raid1 would=
=20
be better because dm snapshots are not that fast. And if the block devices =
of=20
the raid1 are on different SANs, i can do the backups alternating an SAN1 a=
nd=20
SAN2 with previously setting "--write-mostly" and "--write-behind=3D" on th=
e=20
device which will be backuped.


Speaking of SANs, a configurable timeout in md raid1 would be great ;-) , b=
ut=20
as i see on this maling list, there seems to be not much effort in this=20
direction. So I only want to say, me too.


It would be nice if someone could answer my questions and/or comment my ide=
as.=20
Perhaps all is already there and i didn't find it or there are preventions =
i=20
didn't recognize.



PS: For the ones who want to know my setup due to i came to this ideas: I'v=
e=20
build Xen-clusters out of standard hardware. Two (or more) storage servers=
=20
which take all their disks to a (striping) logical volume group. Exporting=
=20
logical volumes over separated (SAN1 and SAN1) networks to the Xen-hosts.=20
Inside a Xen-guest I do the raid1, so also the connection of one block devi=
ce=20
between Xen-host and Xen-guest can break without makeing me problems. I do=
=20
online growing the filesystem (harddisks and raid1) inside the Xen-guest.=20
Actually i've to remove one disk from the raid1, grow it with lvm and=20
reinsert it which results in a full resync. Than the same with the second=20
disk. After that i can do a --grow on the raid1 and then do resize2fs. This=
=20
works perfectly, but it costs a lot of resources (twice a full resync) whic=
h=20
i will lower.
Another solution of the growing would be to use sparse block devices (with=
=20
device mapper you make a zero block device of great size and than snapshot =
it=20
with real hard disk space). With this solution I can make a big filesystem =
on=20
the snapshot device and hard disk blocks will only be allocated as they are=
=20
written. Of course i've to watch and grow the snapshot size, but this can b=
e=20
automated. I've also a problem if the real disk space is consumed and this=
=20
has to be prevented. But I like this solution because i don't have to=20
manually grow the block devices and filesystems. And this solution would=20
totally break if a full resync would be done on a sparse block device, you=
=20
see? So the thing with a "read-mostly resync" would be great for this.


=2D-=20
greetings

eMHa

--nextPart1271626.1ZvkRmA2ou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHm0FUXT3LE+AjWCsRAhlAAKCi2JSffIGKDn8yzKUTvQHn3doFRACfVwBr
hqhZQeNq1cpjG2QsOWKxWws=
=FYZ2
-----END PGP SIGNATURE-----

--nextPart1271626.1ZvkRmA2ou--
