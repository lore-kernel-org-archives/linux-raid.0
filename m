From: Maurice Hilarius <maurice@harddata.com>
Subject: RAID startup problem
Date: Wed, 14 May 2003 20:47:00 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030514165613.03b11db0@mail.harddata.com>
References: <3EC2A232.8070308@moeraki.com>
 <B0E6075E55C7D6119DDE0002A53F8BCEFFDD2D@blpfroclab01.bausch.com>
 <20030514194644.GB6949@localhost>
 <3EC2A232.8070308@moeraki.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200305141327.29713.defranco@cup.hp.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi There!

I just set up a server with 2 x 3Ware cards, 16 IDE disks, and am building 
a number of software md raids using mdadm.

Everything built and synched OK, but the raid1 devices don't seem to come 
up upon reboot.

Any suggestions are appreciated!

Here is some fairly detailed info:


Status upon reboot:

md2 : active raid5 sdl1[2] sde1[1] sdd1[0]
       19550848 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md6 : active raid5 sdl2[2] sde2[1] sdd2[0]
       136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md7 : active raid5 sdn2[2] sdm2[1] sdf2[0]
       136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md8 : active raid5 sdo2[2] sdh2[1] sdg2[0]
       136745088 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>


So then I do this:

mdadm -C /dev/md3 -l1 -n2 /dev/sd[ai]4
mdadm: /dev/sda4 appears to contain an ext2fs file system
     size=73143872K  mtime=Tue May 13 17:47:42 2003
mdadm: /dev/sda4 appear to be part of a raid array:
     level=1 devices=2 ctime=Tue May 13 17:47:40 2003
mdadm: /dev/sdi4 appears to contain an ext2fs file system
     size=73143872K  mtime=Tue May 13 17:47:42 2003
mdadm: /dev/sdi4 appear to be part of a raid array:
     level=1 devices=2 ctime=Tue May 13 17:47:40 2003
Continue creating array? y
mdadm: array /dev/md3 started.

It syncs up and appears to be okay, and then reboot...gone.

The motherboard is configured under PnP to Scan the PCI Bus from Lowest to 
Highest (default), the option "pci=nosort" was required to make the linux 
kernel recognize the correct order.

# partition table of sd-ai
unit: sectors

/dev/sdi1 : start=       63, size=   208782, Id=83
/dev/sdi2 : start=   208845, size=  3919860, Id=82
/dev/sdi3 : start=  4128705, size=  5879790, Id=83
/dev/sdi4 : start= 10008495, size=146287890, Id=fd

# partition table of sd-bcjk
unit: sectors

/dev/sde1 : start=       63, size=  6088572, Id=fd
/dev/sde2 : start=        0, size=        0, Id= 0
/dev/sde3 : start=  6088635, size=150207750, Id=fd
/dev/sde4 : start=        0, size=        0, Id= 0

# partition table of sd-defghlmno
unit: sectors

/dev/sdj1 : start=       63, size= 19551042, Id=fd
/dev/sdj2 : start= 19551105, size=136745280, Id=fd
/dev/sdj3 : start=        0, size=        0, Id= 0
/dev/sdj4 : start=        0, size=        0, Id= 0

### r1-0 sda,sdi:

100M -> 100M /bootone,/boottwo
   2G -> 2G   swap
   3G -> 3G   /rootone,/roottwo
  75G -> 75G  /mnt/r1-0         /dev/md3

p1             1 -   13
p2            14 -  257
p3           258 -  623
p4	     624 - 9729

mdadm -C /dev/md3 -l1 -n2 /dev/sd[ai]4
tune2fs -L /mnt/r1-0 /dev/md3


### r1-1 sdb,sdj

3.1G -> 3.1G /tmp              /dev/md0
  75G -> 75G  /mnt/r1-1         /dev/md4

p1             1 -  379
p3           380 - 9729

mdadm -C /dev/md0 -l1 -n2 /dev/sd[bj]1
mdadm -C /dev/md4 -l1 -n2 /dev/sd[bj]3
mkfs.ext3 /dev/md0
mkfs.ext3 /dev/md4
tune2fs -L /tmp              /dev/md0
tune2fs -L /mnt/r1-1         /dev/md4

### r1-2 sdc,sdk:

3.1G -> 3.1G /var              /dev/md1
  75G -> 75G  /mnt/r1-2         /dev/md5

p1             1 -  379
p3           380 - 9729

mdadm -C /dev/md1 -l1 -n2 /dev/sd[ck]1
mdadm -C /dev/md5 -l1 -n2 /dev/sd[ck]3
mkfs.ext3 /dev/md1
mkfs.ext3 /dev/md5
tune2fs -L /var              /dev/md1
tune2fs -L /mnt/r1-2         /dev/md5

###########################################################

### r5-0 sdd,sde,sdl:

10G  -> 10G  -> 10G  /home     /dev/md2
150G -> 150G -> 150G /mnt/r5-0 /dev/md6

p1             1 - 1217
p2          1218 - 9729

mdadm -C /dev/md2 -l5 -n3 /dev/sd[del]1
mdadm -C /dev/md6 -l5 -n3 /dev/sd[del]2
mkfs.ext3 /dev/md2
mkfs.ext3 /dev/md6
tune2fs -L /mnt/r5-0 /dev/md6
tune2fs -L /home     /dev/md2


### r5-1 sdf,sdm,sdn:

10G  -> 10G  -> 10G  blank
150G -> 150G -> 150G /mnt/r5-1 /dev/md7

p1             1 - 1217
p2          1218 - 9729

mdadm -C /dev/md7 -l5 -n3 /dev/sd[fmn]2
mkfs.ext3 /dev/md7
tune2fs -L /mnt/r5-1 /dev/md7

### r5-2 sdg,sdh,sdo:

10G  -> 10G  -> 10G  blank
150G -> 150G -> 150G /mnt/r5-2 /dev/md8

p1             1 - 1217
p2          1218 - 9729

mdadm -C /dev/md8 -l5 -n3 /dev/sd[gho]2
mkfs.ext3 /dev/md8
tune2fs -L /mnt/r5-2 /dev/md8


###
# The following arrays fail to initialize upon reboot
###
mdadm -C /dev/md0 -l1 -n2 /dev/sd[bj]1
mdadm -C /dev/md1 -l1 -n2 /dev/sd[ck]1
mdadm -C /dev/md3 -l1 -n2 /dev/sd[ai]4
mdadm -C /dev/md4 -l1 -n2 /dev/sd[bj]3
mdadm -C /dev/md5 -l1 -n2 /dev/sd[ck]3


# mdadm configuration file
#
# mdadm will function properly without the use of a configuration file,
# but this file is useful for keeping track of arrays and member disks.
# In general, a mdadm.conf file is created, and updated, after arrays
# are created. This is the opposite behavior of /etc/raidtab which is
# created prior to array construction.
#
#
# the config file takes two types of lines:
#
#	DEVICE lines specify a list of devices of where to look for
#	  potential member disks
#
#	ARRAY lines specify information about how to identify arrays so
#	  so that they can be activated
#
# You can have more than one device line and use wild cards. The first
# example includes SCSI the first partition of SCSI disks /dev/sdb,
# /dev/sdc, /dev/sdd, /dev/sdj, /dev/sdk, and /dev/sdl. The second
# line looks for array slices on IDE disks.
#
#DEVICE /dev/sd[bcdjkl]1
#DEVICE /dev/hda1 /dev/hdb1
#
# If you mount devfs on /dev, then a suitable way to list all devices is:
#DEVICE /dev/discs/*/*
#
#
#
# ARRAY lines specify an array to assemble and a method of identification.
# Arrays can currently be identified by using a UUID, superblock minor number,
# or a listing of devices.
#
#	super-minor is usally the minor number of the metadevice
#	UUID is the Universally Unique Identifier for the array
# Each can be obtained using
#
# 	mdadm -D <md>
#
#ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
#ARRAY /dev/md1 superminor=1
#ARRAY /dev/md2 devices=/dev/hda1,/dev/hda2
#
# ARRAY lines can also specify a "spare-group" for each array.  mdadm --monitor
# will then move a spare between arrays in a spare-group if one array has a 
failed
# drive but no spare
#ARRAY /dev/md4 uuid=b23f3c6d:aec43a9f:fd65db85:369432df spare-group=group1
#ARRAY /dev/md5 uuid=19464854:03f71b1b:e0df2edd:246cc977 spare-group=group1
#
# When used in --follow (aka --monitor) mode, mdadm needs a
# mail address and/or a program.  This can be given with "mailaddr"
# and "program" lines to that monitoring can be started using
#    mdadm --follow --scan & echo $! > /var/run/mdadm
# If the lines are not found, mdadm will exit quietly
#MAILADDR root@mydomain.tld
#PROGRAM /usr/sbin/handle-mdadm-events
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=81cc8f4f:701e9eac:47773277:18c7216e
ARRAY /dev/md3 level=raid1 num-devices=2 
UUID=c447f450:7c969497:4c53bac0:83bca3d4
ARRAY /dev/md5 level=raid1 num-devices=2 
UUID=23e25917:0f7657ce:380b4af6:89dd2f77
ARRAY /dev/md4 level=raid1 num-devices=2 
UUID=cd2b2762:05779c04:f73ca962:0c74fc7e
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=e27b007f:23eccfec:bbf767e5:9718900e
ARRAY /dev/md2 level=raid5 num-devices=3 
UUID=a82a43f3:8b6f37ce:d2dedf15:8ab81c60
ARRAY /dev/md6 level=raid5 num-devices=3 
UUID=877f1a1d:1515d873:f957d9d5:24736d93
ARRAY /dev/md7 level=raid5 num-devices=3 
UUID=324fc51f:6d7e54b7:277e5673:dea4c603
ARRAY /dev/md8 level=raid5 num-devices=3 
UUID=31071bc3:9aa6f86e:45577fcc:f502abc7

With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

