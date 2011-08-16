From: Iwan Zarembo <iwan@zarembo.de>
Subject: IMSM Raid 5 always read only and gone after reboot
Date: Tue, 16 Aug 2011 22:19:38 +0200
Message-ID: <CAOTVL7JLxjHgyaz0s3Ua9gsgUYHP_2b1DONzk3YNaCLfgxMBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Everyone,
I am not that new to Linux, but I am quite far away from being an
expert :) I am using linux for a few years now and everything worked
just fine, but not this one with IMSM Raid. I googled for some weeks
and asked everyone I know about the problem but without any luck. The
last possibility to find a solution is this mailing list. I realy hope
someone can help me.

I bought some new components to upgrade my old PC. So I bought:
- Intel Core i7-2600k
- Asrock Z68 Extreme4 (with 82801 SATA RAID Controller on it)
- Some RAM and so on

I also wanted to reuse my four old SAMSUNG HD103UJ 1 TB hard drives.
In the past I used mdadm as fake raid level 5 and everything worked
just fine. Now with the upgrade I wanted to use the Intel RAID
Controller on my mainboard. The advantage is that I would be able to
access the raid drive from my alternative windows system.

So what I did was:
Activated RAID functionality in BIOS and started to work with the wiki
https://raid.wiki.kernel.org/index.php/RAID_setup . There I got a raid
container and a volume. Unfortunately I had in the volume an MBR
partition table. So I converted it by using windows 7 build in
functionality to a GPT partition table.
Now when I boot my Ubuntu (up to date 11.04 with gnome 3) I cannot see
the raid array.
So what I did is to take again the information from the ROM:
    # mdadm --detail-platform
           Platform : Intel(R) Matrix Storage Manager
            Version : 10.6.0.1091
        RAID Levels : raid0 raid1 raid10 raid5
        Chunk Sizes : 4k 8k 16k 32k 64k 128k
          Max Disks : 7
        Max Volumes : 2
     I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2
              Port0 : /dev/sda (ML0221F303XN3D)
              Port2 : /dev/sdb (S13PJ9AQ923317)
              Port3 : /dev/sdc (S13PJ9AQ923315)
              Port4 : /dev/sdd (S13PJ9AQ923313)
              Port5 : /dev/sdg (S13PJ9AQ923320)
              Port1 : - no device attached -

I use the hard drives on ports 2-5.

Scan with mdadm for already used raid arrays
    # mdadm --assemble --scan
    mdadm: Container /dev/md/imsm has been assembled with 4 drives

After the command I can see in gnome-disk-utility -> palimpsest an
inactive raid array /dev/md127 (seems to be the default imsm device
name).
More information on the array:

    # mdadm -E /dev/md127
/dev/md127:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : af791bfa
         Family : af791bfa
     Generation : 00000019
           UUID : 438e7dfa:936d0f29:5c4b2c0d:106da7cf
       Checksum : 1bae98dd correct
    MPB Sectors : 2
          Disks : 4
   RAID Devices : 1

  Disk02 Serial : S13PJ9AQ923317
          State : active
             Id : 00020000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

[raid]:
           UUID : 53e9eb47:c77c7222:20004377:481f36d6
     RAID Level : 5
        Members : 4
          Slots : [UUUU]
      This Slot : 2
     Array Size : 5860560896 (2794.53 GiB 3000.61 GB)
   Per Dev Size : 1953520640 (931.51 GiB 1000.20 GB)
  Sector Offset : 0
    Num Stripes : 7630940
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : initialize
      Map State : normal <-- uninitialized
     Checkpoint : 93046 (1024)
    Dirty State : clean

  Disk00 Serial : S13PJ9AQ923313
          State : active
             Id : 00040000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

  Disk01 Serial : S13PJ9AQ923315
          State : active
             Id : 00030000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

  Disk03 Serial : S13PJ9AQ923320
          State : active
             Id : 00050000
    Usable Size : 1953520654 (931.51 GiB 1000.20 GB)

More Details on the container:
# mdadm -D /dev/md127
/dev/md127:
        Version : imsm
     Raid Level : container
  Total Devices : 4

Working Devices : 4


           UUID : 438e7dfa:936d0f29:5c4b2c0d:106da7cf
  Member Arrays :

    Number   Major   Minor   RaidDevice

       0       8       48        -        /dev/sdd
       1       8       32        -        /dev/sdc
       2       8       16        -        /dev/sdb
       3       8       64        -        /dev/sde


mdstat has the following output:
    # cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
      9028 blocks super external:imsm

unused devices: <none>

I started the raid by entering the command:
    # mdadm -I -e imsm /dev/md127
    mdadm: Started /dev/md/raid with 4 devices

Now mdstat has the following output:
    # cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md126 : active (read-only) raid5 sdd[3] sdc[2] sdb[1] sde[0]
      2930280448 blocks super external:/md127/0 level 5, 128k chunk,
algorithm 0 [4/4] [UUUU]
      	resync=3DPENDING

md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
      9028 blocks super external:imsm

unused devices: <none>

I learned that md126 is so long read only until it was used the first
time. So I tried to create a partition with the documentation from the
wiki, but not with ext3. I used ext4 for this.

 #  mkfs.ext4 -v -m .1 -b 4096 -E stride=3D32,stripe-width=3D64 /dev/md=
/raid
The result was:
mke2fs 1.41.14 (22-Dec-2010)
fs_types f=C3=BCr mke2fs.conf L=C3=B6sung: 'ext4'
/dev/md/raid: The operation is not allowed then creating Superblocks.
Original message in German: Die Operation ist nicht erlaubt beim
Erstellen des Superblocks

This is the first problem. I am not able to do anything on the raid dri=
ve.

So I thought maybe a reboot helps and stored the configuration of the
rain in mdadm.conf using command:
# mdadm --detail --scan >> /etc/mdadm/mdadm.conf

By the way output of the command is:
ARRAY /dev/md/imsm metadata=3Dimsm UUID=3D438e7dfa:936d0f29:5c4b2c0d:10=
6da7cf
ARRAY /dev/md/raid container=3D/dev/md/imsm member=3D0
UUID=3D53e9eb47:c77c7222:20004377:481f36d6

I stored the configuration file mdadm.conf in /etc and /etc/mdadm/,
because I was not sure which one works. The content is the following:
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/imsm metadata=3Dimsm UUID=3D438e7dfa:936d0f29:5c4b2c0d:10=
6da7cf
ARRAY /dev/md/raid container=3D/dev/md/imsm member=3D0
UUID=3D53e9eb47:c77c7222:20004377:481f36d6

The second problem is that the raid is gone after the reboot!

Can anyone help me? What am I doing wrong??? What is missing?

Every help is appreciated.

Thanks,

Iwan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
