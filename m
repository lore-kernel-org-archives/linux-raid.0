From: Lewis Shobbrook <mylists@blue-matrix.org>
Subject: raid1 boot issues
Date: Thu, 25 Aug 2005 19:03:46 +1000
Message-ID: <200508251903.47194.mylists@blue-matrix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
I have a problem attempting to boot a raid 1 system from lilo. =A0I hav=
e=20
succeeded at this many times in the past, but am completely stumped as =
to=20
what the issue is in this instance. I have the boot and root partitions=
=20
seperate on /dev/md0 & /dev/md1 respectively, both raid1. =A0
The mdadm examination  for =A0the components is clean and the superbloc=
ks appear=20
as they ought. =A0I'm using Debian unstable with std. apt kernel-image.=
 =A0The=20
correct modules are in place for the initrd.
The boot partition fails to mount during =A0the boot process...
fsck.ext3: invalid argument while trying to open /dev/md0
The superblock can not be read or does not describe a correct ext2=20
filesystem.... omitted usual stuff...
Root password for maintenance or Control-D to continue...

The bizarre thing is that it appears perfectly clean, I've re-zero'd th=
e=20
superblocks and completely recreated the device, but the result is alwa=
ys the=20
same. =A0
mdrun loads /dev/md0 in a clean state straight away and it mounts=20
cleanly. =A0/dev/md1 is no problem.=20
mdadm -E of the components is clean, as is mdadm -d for the device.
My fstab & mtab are the same as systems running the same kernel that wo=
rk=20
fine.

I found the system laying around from about 12 months ago which had ori=
ginally=20
been set-up using raidtools. =A0I upgraded the system using dist-upgrad=
e=20
installed mdadm; after zeroing all superblocks for both drives and comp=
onent=20
partitions, I created the devices with the following ...

mdadm -C /dev/md0 -l1 -n2 /dev/hda1 missing
reformatted ext3 and restored the files before adding the missing devic=
es and=20
resyncing. =A0
I'm stumped!
Anyone got any ideas?

Cheers,

Lewis
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
