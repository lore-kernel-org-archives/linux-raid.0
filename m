From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help - raid not assembling right on boot (was: Resizing a
 RAID1)
Date: Thu, 27 Jan 2011 10:06:25 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101271001170.31246@p34.internal.lan>
References: <AANLkTimJiZHjAYkd4+93=-5b3QZfSqxaz2Ap+YPLYLEL@mail.gmail.com> <alpine.DEB.2.00.1101270656230.31246@p34.internal.lan> <AANLkTikP3mVU+=F6Luy5dzj7J9+6cvfZKUaifFW6RUf6@mail.gmail.com> <alpine.DEB.2.00.1101270736480.31246@p34.internal.lan>
 <AANLkTinf5kO9n6xsZ=GUC+BUKR4SSa0HvJE8WgSMH-EE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-2053702380-1296140785=:31246"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinf5kO9n6xsZ=GUC+BUKR4SSa0HvJE8WgSMH-EE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-2053702380-1296140785=:31246
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 27 Jan 2011, Hank Barta wrote:

Hi,

You may just want to dd and start over; or:


If I try to zero the superblock that seems to be in error, I get:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
root@oak:/var/log# mdadm --zero-superblock /dev/sdb
mdadm: Couldn't open /dev/sdb for write - not zeroing
root@oak:/var/log#
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

Have you tried using the partition itself?
/dev/sdb1?

Also, any reason for making partitions on a MD raid device?
[ =A0 16.532107] EXT4-fs (md2p2): bad geometry: block count 485756928
exceeds size of device (483135232 blocks)

This is generally not a good idea.

It sounds like you want to make a raid-1 with two disks and pop it into a=
=20
new system?

Way I typically do this is insert both drives into the new system, boot=20
off a system rescue cd and then create the raid there, boot off the cd=20
again, with root=3D/dev/md2, then run LILO, make sure to use 0.90=20
superblocks.

See below:

USE --assume-clean FOR LARGE FILESYSTEMS so you can reboot directly after
array creation and system restore implantation. (you will want to run an
echo repair > /sys/..sync_action though afterwards)

root@Knoppix:/t/etc# mdadm --create -e 0.90 --verbose /dev/md0 --level=3D1 =
--raid-devices=3D2 /dev/sda1 /dev/sdb1=20
mdadm: size set to 8393856K
mdadm: array /dev/md0 started.
root@Knoppix:/t/etc# cat /proc/mdstat=20
Personalities : [raid1]=20
md0 : active raid1 sdb1[1] sda1[0]
       8393856 blocks [2/2] [UU]
       [>....................]  resync =3D  1.4% (120512/8393856) finish=3D=
3.4min speed=3D40170K/sec

root@Knoppix:/t/etc# mdadm --create -e 0.90 --verbose /dev/md1 --level=3D1 =
--raid-devices=3D2 /dev/sda2 /dev/sdb2
mdadm: size set to 136448K
mdadm: array /dev/md1 started.
root@Knoppix:/t/etc#

root@Knoppix:/t/etc# mdadm --create -e 0.90 --verbose /dev/md2 --level=3D1 =
--raid-devices=3D2 /dev/sda3 /dev/sdb3
mdadm: size set to 382178240K
mdadm: array /dev/md2 started.
root@Knoppix:/t/etc#

root@Knoppix:/t/etc# cat /proc/mdstat=20
Personalities : [raid1]=20
md2 : active raid1 sdb3[1] sda3[0]
       382178240 blocks [2/2] [UU]
         resync=3DDELAYED

md1 : active raid1 sdb2[1] sda2[0]
       136448 blocks [2/2] [UU]
         resync=3DDELAYED

md0 : active raid1 sdb1[1] sda1[0]
       8393856 blocks [2/2] [UU]
       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..........]  resync =3D 51.0% (42830=
72/8393856) finish=3D1.0min speed=3D62280K/sec

unused devices: <none>
root@Knoppix:/t/etc#

After this, you'll need to set them as 0xfd and make sure the boot is boota=
ble,
your LILO config should look something like this:

boot=3D/dev/md1
root=3D/dev/md2
map=3D/boot/map
prompt
delay=3D100
timeout=3D100
lba32
vga=3Dnormal
append=3D""
raid-extra-boot=3D"/dev/sda,/dev/sdb" # make boot blocks on both drives
default=3D2.6.37-3

image=3D/boot/2.6.37-3
   label=3D2.6.37-3
   read-only
   root=3D/dev/md2


Justin.

--655872-2053702380-1296140785=:31246--
