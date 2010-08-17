From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: mdadm -C failure with 3.1.3, but /proc/mdstat reports success
Date: Tue, 17 Aug 2010 06:27:37 -0700
Message-ID: <AANLkTi=Ey79wmK4KC18D=gg9ZzBouRfgnycwzPbLTwc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I am seeing the following on Ubuntu 10.04 64-bit with mdadm 3.1.3 + 1
patch provided by Neil for proper auto-assembly of spares at boot. My
system has 12 drives, all 15K SAS via an LSI 3bps SAS controller. I
partition all the drives using parted. Then, I wait 10 seconds and
issue this command:

mdadm -C -f -e 1.2 -R /dev/md1 -l 6 -n 11 -c 64 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1
/dev/sdk1 /dev/sdl1 -x 1 /dev/sdm1

The command returns with:

Create_string command failed: mdadm: super1.x cannot open /dev/sdb1:
Device or resource busy mdadm: /dev/sdb1 is not suitable for this
array. mdadm: super1.x cannot open /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 is not suitable for this array. mdadm: super1.x
cannot open /dev/sdd1: Device or resource busy mdadm: /dev/sdd1 is not
suitable for this array. mdadm: super1.x cannot open /dev/sde1: Device
or resource busy mdadm: /dev/sde1 is not suitable for this array.
mdadm: super1.x cannot open /dev/sdf1: Device or resource busy mdadm:
/dev/sdf1 is not suitable for this array. mdadm: super1.x cannot open
/dev/sdg1: Device or resource busy mdadm: /dev/sdg1 is not suitable
for this array. mdadm: super1.x cannot open /dev/sdh1: Device or
resource busy mdadm: /dev/sdh1 is not suitable for this array. mdadm:
super1.x cannot open /dev/sdi1: Device or resource busy mdadm:
/dev/sdi1 is not suitable for this array. mdadm: super1.x cannot open
/dev/sdj1: Device or resource busy mdadm: /dev/sdj1 is not suitable
for this array. mdadm: super1.x cannot open /dev/sdk1: Device or
resource busy mdadm: /dev/sdk1 is not suitable for this array. mdadm:
super1.x cannot open /dev/sdl1: Device or resource busy mdadm:
/dev/sdl1 is not suitable for this array. mdadm: super1.x cannot open
/dev/sdm1: Device or resource busy mdadm: /dev/sdm1 is not suitable
for this array. mdadm: create aborted


However, immediately afterwards, /proc/mdstat seems to report success:


cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdj1[8] sdk1[9] sdg1[5] sdb1[0] sdc1[1] sde1[3]
sdf1[4] sdd1[2] sdl1[10] sdh1[6] sdi1[7] sdm1[11](S)
      5274521856 blocks super 1.2 level 6, 64k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]

unused devices: <none>


I've tried zero'ing the superblock (mdadm --zero-superblock) on all
the partitions, deleting the partitions and repartitioning, rebooting,
etc but to no avail and always get this same result.

Please advise on this issue. Thanks a lot!

-Tommy
