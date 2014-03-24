From: Mark Munoz <mark.munoz@rightthisminute.com>
Subject: Missing superblocks from almost all my drives
Date: Mon, 24 Mar 2014 15:55:00 -0700
Message-ID: <5CF8E6CF-6A14-4AFA-A265-766134B7A381@rightthisminute.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have a rather complex setup.  I have 1 RAID 6 array with 128k blocks =
1.2 metadata with 25 drives 1 of which is a hot spare and is md0.
I have a a second RAID 6 array with 128k blocks 1.2 metadata with 20 dr=
ives 1 of which is a hot spare is md1
I then have a striped RAID set made up from md0 and md1 which makes md2=
=2E  All 128k block size and 1.2 metadata.

Earlier this week two drives in md1 failed back to back within moments =
of each other.  I let it rebuild over the weekend to get it have only 1=
 degraded disk before I took out the two bad drives and attempting to g=
et the array to clean and another hot spare.  It all shut down properly=
 but on reboot md0 rebuilt as normal but md1 didn=92t, which is what I =
sort of expected as it was degraded.  However I was having a tough time=
 trying to figure which of my two new drives were what device because a=
ccording the mdstat it partially assembled the array but it was short 3=
 drives instead of just 2.  I then stopped md1 and was going to walk th=
rough each device with examine and see what was what.  However after st=
opping md1 all the drives display this:

[root@kingpin ~]# mdadm --examine /dev/sdad
/dev/sdad:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)


Getting examine info on the md0 drives reported everything fine.  So I =
shut down again thinking it may be smart to write down the serials of t=
he two new drives and then just --assemble =97force it without the two =
new drives.

Now when it boots all but 3 of my drives have missing superblock inform=
ation.  I have read rebooting sometimes brings it back but I have reboo=
ted about 6 times with no luck.  I have rebooted with just my known goo=
d drives, I have rebooted putting back in the bad drives, booted with n=
ew blank drives as well and each time I am getting the same output as a=
bove on examine.

The way these drives boots is fairly predictable so I am fairly certain=
 /dev/sd[b-z] belong to md0 and /dev/sda[a-t] belong to md1 but since m=
d1 has had failed drives I think the order is now out of whack.

Are my options to now =97create =97assume-clean then just test a bunch =
of different device orders until I get the correct setup?  I am running=
 CentOS 6.4 Final and mdadm v3.2.5 and Linux version 2.6.32-358.el6.x86=
_64 (mockbuild@c6b8.bsys.dev.centos.org) (gcc version 4.4.7 20120313 (R=
ed Hat 4.4.7-3) (GCC) ) #1 SMP Fri Feb 22 00:31:26 UTC 2013

Here at the commands I used to create all three arrays initially:

mdadm --create --verbose /dev/md0 --chunk=3D128 --level=3D6 --raid-devi=
ces=3D24 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh=
 /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sd=
p /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/s=
dx /dev/sdy --spare-devices=3D1 /dev/sdz

mdadm --create --verbose /dev/md1 --chunk=3D128 --level=3D6 --raid-devi=
ces=3D19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /dev/sdae /dev/sdaf /d=
ev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /de=
v/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas --spare-device=
s=3D1 /dev/sdat

mdadm --create --verbose /dev/md2 --chunk=3D128 --level=3D0 --raid-devi=
ces=3D2 /dev/md0 /dev/md1

Thanks so much for your help!

Mark Munoz--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
