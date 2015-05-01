From: =?UTF-8?B?SsOpcsO0bWUgVHl0Z2F0?= <jerome.tytgat@sioban.net>
Subject: upgrade to jessie/newer kernel and mdadm problems
Date: Fri, 01 May 2015 11:40:24 +0200
Message-ID: <55434A08.3050505@sioban.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

Sorry for the long post, but I wanted to be as much informative as I can be.
Forgive my lack of knowlegde in mdadm, I know how to create it using the 
debian installer and few things to get information but that's all.
Forgive also my english, I'm not a native in this language.

My system has been installed in 2007, and I've upgraded it several times 
until this week to Debian Jessie (the latest version).

So, I've upgraded my system to jessie today (only partially with apt-get 
upgrade + kernel upgrade) and I faced with a problem with my RAID 1 soft.

I have two disk (/dev/sdb and /dev/sdc) which are members of the raid array
There's 10 partitions on these disks, each one is a array (ie sdb1 and 
sdc1).
All of these form my raids array : md0 to md9

Today , one of my md partition was missing.
Before upgrade I had partitions from md0 to md9, after reboot I'm 
missing md9.

my mdadm.conf before reboot looked like that:
 >-------------------------------------------------------------------------------------------------------------<

    # mdadm.conf
    #
    # Please refer to mdadm.conf(5) for information about this file.
    #

    # by default, scan all partitions (/proc/partitions) for MD superblocks.
    # alternatively, specify devices to scan, using wildcards if desired.
    DEVICE partitions

    # auto-create devices with Debian standard permissions
    CREATE owner=root group=disk mode=0660 auto=yes

    # automatically tag new arrays as belonging to the local system
    HOMEHOST <system>

    # instruct the monitoring daemon where to send mail alerts
    MAILADDR root

    # definitions of existing MD arrays
    ARRAY /dev/md0 level=raid1 num-devices=2
    UUID=350e253f:863b7b04:b1617c47:b213a024
    ARRAY /dev/md1 level=raid1 num-devices=2
    UUID=086e68ed:3607317f:60b56e23:6bae62bc
    ARRAY /dev/md2 level=raid1 num-devices=2
    UUID=0f6e3ed5:aeee975a:c3647deb:763d68ce
    ARRAY /dev/md3 level=raid1 num-devices=2
    UUID=6b560fe8:f24d6f2e:8942bd3a:1903abbc
    ARRAY /dev/md4 level=raid1 num-devices=2
    UUID=462dab96:b7ca2a17:7c4aebf1:d4d7ec3b
    ARRAY /dev/md5 level=raid1 num-devices=2
    UUID=ea511351:3abc7b12:4c81e838:93dbd21a
    ARRAY /dev/md6 level=raid1 num-devices=2
    UUID=da0d76c6:91422584:dc3d6162:37ced53b
    ARRAY /dev/md7 level=raid1 num-devices=2
    UUID=387c831c:8a6d05e3:b649696c:0870b930
    ARRAY /dev/md8 level=raid1 num-devices=2
    UUID=b07c4ab4:39d0ba53:9913afa9:fd9cc323
    ARRAY /dev/md9 level=raid1 num-devices=2
    UUID=36c4edd0:a0492cc9:0cd2fce0:2745e358

    # This file was auto-generated on Wed, 07 Feb 2007 17:15:33 +0000
    # by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $

 >-------------------------------------------------------------------------------------------------------------<

After reboot and after a mdadm -Es, I got this:
 >-------------------------------------------------------------------------------------------------------------<

    # mdadm.conf
    #
    # Please refer to mdadm.conf(5) for information about this file.
    #

    # by default, scan all partitions (/proc/partitions) for MD superblocks.
    # alternatively, specify devices to scan, using wildcards if desired.
    DEVICE partitions

    # auto-create devices with Debian standard permissions
    CREATE owner=root group=disk mode=0660 auto=yes

    # automatically tag new arrays as belonging to the local system
    HOMEHOST <system>

    # instruct the monitoring daemon where to send mail alerts
    MAILADDR root

    # definitions of existing MD arrays
    ARRAY metadata=imsm UUID=d9cfa6d9:2a715e4f:1fbc2095:be342429
    ARRAY /dev/md/raidlin container=d9cfa6d9:2a715e4f:1fbc2095:be342429
    member=0 UUID=91449a9d:9242bfe9:d99bceb0:a59f9314
    ARRAY /dev/md0 UUID=350e253f:863b7b04:b1617c47:b213a024
    ARRAY /dev/md1 UUID=086e68ed:3607317f:60b56e23:6bae62bc
    ARRAY /dev/md2 UUID=0f6e3ed5:aeee975a:c3647deb:763d68ce
    ARRAY /dev/md3 UUID=6b560fe8:f24d6f2e:8942bd3a:1903abbc
    ARRAY /dev/md4 UUID=462dab96:b7ca2a17:7c4aebf1:d4d7ec3b
    ARRAY /dev/md5 UUID=ea511351:3abc7b12:4c81e838:93dbd21a
    ARRAY /dev/md6 UUID=da0d76c6:91422584:dc3d6162:37ced53b
    ARRAY /dev/md7 UUID=387c831c:8a6d05e3:b649696c:0870b930
    ARRAY /dev/md8 UUID=b07c4ab4:39d0ba53:9913afa9:fd9cc323

 >-------------------------------------------------------------------------------------------------------------<

This is what is looking my fdisk extract and /proc/mdstat:
 >-------------------------------------------------------------------------------------------------------------<

    # fdisk -l /dev/sdb

    Disk /dev/sdb: 250.1 GB, 250059350016 bytes
    255 heads, 63 sectors/track, 30401 cylinders, total 488397168 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x0001edee

        Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1   *          63      979964      489951   fd  Linux raid
    autodetect
    /dev/sdb2          979965    10747484     4883760   fd  Linux raid
    autodetect
    /dev/sdb3        10747485    14651279     1951897+  fd  Linux raid
    autodetect
    /dev/sdb4        14651280   488392064   236870392+   5  Extended
    /dev/sdb5        14651343    24418799     4883728+  fd  Linux raid
    autodetect
    /dev/sdb6        24418863    43953839     9767488+  fd  Linux raid
    autodetect
    /dev/sdb7        43953903    53721359     4883728+  fd  Linux raid
    autodetect
    /dev/sdb8        53721423    63488879     4883728+  fd  Linux raid
    autodetect
    /dev/sdb9        63488943    73256399     4883728+  fd  Linux raid
    autodetect
    /dev/sdb10       73256463    83023919     4883728+  fd  Linux raid
    autodetect
    /dev/sdb11       83023983   488392064   202684041   fd  Linux raid
    autodetect

 >-------------------------------------------------------------------------------------------------------------<

    # fdisk -l /dev/sdc

    Disk /dev/sdc: 250.1 GB, 250059350016 bytes
    255 heads, 63 sectors/track, 30401 cylinders, total 488397168 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000c352c

        Device Boot      Start         End      Blocks   Id  System
    /dev/sdc1   *          63      979964      489951   fd  Linux raid
    autodetect
    /dev/sdc2          979965    10747484     4883760   fd  Linux raid
    autodetect
    /dev/sdc3        10747485    14651279     1951897+  fd  Linux raid
    autodetect
    /dev/sdc4        14651280   488392064   236870392+   5  Extended
    /dev/sdc5        14651343    24418799     4883728+  fd  Linux raid
    autodetect
    /dev/sdc6        24418863    43953839     9767488+  fd  Linux raid
    autodetect
    /dev/sdc7        43953903    53721359     4883728+  fd  Linux raid
    autodetect
    /dev/sdc8        53721423    63488879     4883728+  fd  Linux raid
    autodetect
    /dev/sdc9        63488943    73256399     4883728+  fd  Linux raid
    autodetect
    /dev/sdc10       73256463    83023919     4883728+  fd  Linux raid
    autodetect
    /dev/sdc11       83023983   488392064   202684041   fd  Linux raid
    autodetect

 >-------------------------------------------------------------------------------------------------------------<

    # cat /proc/mdstat
    Personalities : [raid1]
    md8 : active raid1 md126p10[0]
           4883648 blocks [2/1] [U_]

    md7 : active raid1 md126p9[0]
           4883648 blocks [2/1] [U_]

    md6 : active raid1 md126p8[0]
           4883648 blocks [2/1] [U_]

    md5 : active raid1 md126p7[0]
           4883648 blocks [2/1] [U_]

    md4 : active raid1 md126p6[0]
           9767424 blocks [2/1] [U_]

    md3 : active raid1 md126p5[0]
           4883648 blocks [2/1] [U_]

    md2 : active (auto-read-only) raid1 md126p3[0]
           1951808 blocks [2/1] [U_]

    md1 : active raid1 md126p2[0]
           4883648 blocks [2/1] [U_]

    md0 : active raid1 md126p1[0]
           489856 blocks [2/1] [U_]

    md126 : active raid1 sdc[1] sdb[0]
           244195328 blocks super external:/md127/0 [2/2] [UU]

    md127 : inactive sdc[1](S) sdb[0](S)
           6306 blocks super external:imsm

    unused devices: <none>

 >-------------------------------------------------------------------------------------------------------------<


I'm not an expert at md at all, so I called a friend and we were able to 
find my lost md9 partition, it was md126p11.

This is what we saw in dmesg:
 >-------------------------------------------------------------------------------------------------------------<

    [    1.593297] md: bind<sdb>
    [    1.598582] md: bind<sdc>
    [    1.599902] md: bind<sdb>
    [    1.600045] md: bind<sdc>
    [    1.606550] md: raid1 personality registered for level 1
    [    1.607396] md/raid1:md126: active with 2 out of 2 mirrors
    [    1.607433] md126: detected capacity change from 0 to 250056015872
    [    1.632396] md: md126 switched to read-write mode.
    [    1.669910]  md126: p1 p2 p3 p4 < p5 p6 p7 p8 p9 p10 p11 >
    [    1.670501] md126: p11 size 405368082 extends beyond EOD, truncated
    [    4.100396] md: md0 stopped.
    [    4.100919] md: bind<md126p1>
    [    4.101708] md/raid1:md0: active with 1 out of 2 mirrors
    [    4.101734] md0: detected capacity change from 0 to 501612544
    [    4.102179]  md0: unknown partition table
    [    4.224625] md: md1 stopped.
    [    4.225109] md: bind<md126p2>
    [    4.225886] md/raid1:md1: active with 1 out of 2 mirrors
    [    4.225911] md1: detected capacity change from 0 to 5000855552
    [    4.226658]  md1: unknown partition table
    [    4.420746] md: md2 stopped.
    [    4.421441] md: bind<md126p3>
    [    4.422216] md/raid1:md2: active with 1 out of 2 mirrors
    [    4.422241] md2: detected capacity change from 0 to 1998651392
    [    4.422677]  md2: unknown partition table
    [    4.595729] md: md3 stopped.
    [    4.596410] md: bind<md126p5>
    [    4.597189] md/raid1:md3: active with 1 out of 2 mirrors
    [    4.597215] md3: detected capacity change from 0 to 5000855552
    [    4.597638]  md3: unknown partition table
    [    4.668224] md: md4 stopped.
    [    4.668693] md: bind<md126p6>
    [    4.669446] md/raid1:md4: active with 1 out of 2 mirrors
    [    4.669474] md4: detected capacity change from 0 to 10001842176
    [    4.669909]  md4: unknown partition table
    [    4.783732] md: md5 stopped.
    [    4.784236] md: bind<md126p7>
    [    4.785024] md/raid1:md5: active with 1 out of 2 mirrors
    [    4.785049] md5: detected capacity change from 0 to 5000855552
    [    4.785479]  md5: unknown partition table
    [    4.970769] md: md6 stopped.
    [    4.971366] md: bind<md126p8>
    [    4.972129] md/raid1:md6: active with 1 out of 2 mirrors
    [    4.972158] md6: detected capacity change from 0 to 5000855552
    [    4.972594]  md6: unknown partition table
    [    5.137394] md: md7 stopped.
    [    5.138011] md: bind<md126p9>
    [    5.138754] md/raid1:md7: active with 1 out of 2 mirrors
    [    5.138779] md7: detected capacity change from 0 to 5000855552
    [    5.139232]  md7: unknown partition table
    [    5.329093] md: md8 stopped.
    [    5.330228] md: bind<md126p10>
    [    5.330977] md/raid1:md8: active with 1 out of 2 mirrors
    [    5.331003] md8: detected capacity change from 0 to 5000855552
    [    5.350896]  md8: unknown partition table

 >-------------------------------------------------------------------------------------------------------------<

note the line "[ 1.670501] md126: p11 size 405368082 extends beyond EOD, 
truncated"

After force mounting /dev/md126p11, I noted these messages in dmesg:
 >-------------------------------------------------------------------------------------------------------------<

    [ 4361.248369] md126p11: rw=32, want=405367936, limit=405366673
    [ 4361.248382] XFS (md126p11): Mounting V4 Filesystem
    [ 4361.657842] XFS (md126p11): Ending clean mount
    [ 4609.295281] md126p11: rw=32, want=405367936, limit=405366673
    [ 4609.295300] XFS (md126p11): Mounting V4 Filesystem
    [ 4609.513109] XFS (md126p11): Ending clean mount

 >-------------------------------------------------------------------------------------------------------------<


and in daemon.log (lines correspond to the reboot after the upgrade, the 
time I lost my md9):
 >-------------------------------------------------------------------------------------------------------------<

    Apr 29 20:26:26 shax mdadm[4735]: DeviceDisappeared event detected
    on md device /dev/md9
    Apr 29 20:26:29 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md8
    Apr 29 20:26:30 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md7
    Apr 29 20:26:31 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md6
    Apr 29 20:26:33 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md5
    Apr 29 20:26:34 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md4
    Apr 29 20:26:35 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md3
    Apr 29 20:26:35 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md2
    Apr 29 20:26:36 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md1
    Apr 29 20:26:37 shax mdadm[4735]: DegradedArray event detected on md
    device /dev/md0
    Apr 29 20:26:37 shax mdadm[4735]: NewArray event detected on md
    device /dev/md127
    Apr 29 20:26:37 shax mdadm[4735]: NewArray event detected on md
    device /dev/md126

 >-------------------------------------------------------------------------------------------------------------<

output of fdisk -l /dev/md126 :

 >-------------------------------------------------------------------------------------------------------------<

    fdisk -l /dev/md126

    Disk /dev/md126: 250.1 GB, 250056015872 bytes
    255 heads, 63 sectors/track, 30400 cylinders, total 488390656 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000c352c

           Device Boot      Start         End      Blocks   Id System
    /dev/md126p1   *          63      979964      489951   fd  Linux
    raid autodetect
    /dev/md126p2          979965    10747484     4883760   fd  Linux
    raid autodetect
    /dev/md126p3        10747485    14651279     1951897+  fd  Linux
    raid autodetect
    /dev/md126p4        14651280   488392064   236870392+   5 Extended
    /dev/md126p5        14651343    24418799     4883728+  fd  Linux
    raid autodetect
    /dev/md126p6        24418863    43953839     9767488+  fd  Linux
    raid autodetect
    /dev/md126p7        43953903    53721359     4883728+  fd  Linux
    raid autodetect
    /dev/md126p8        53721423    63488879     4883728+  fd  Linux
    raid autodetect
    /dev/md126p9        63488943    73256399     4883728+  fd  Linux
    raid autodetect
    /dev/md126p10       73256463    83023919     4883728+  fd  Linux
    raid autodetect
    /dev/md126p11       83023983   488392064   202684041   fd  Linux
    raid autodetect

 >-------------------------------------------------------------------------------------------------------------<

mdadm -E /dev/sdbX ou mdadm -E /dev/sdcX doesn't give anything :
 >-------------------------------------------------------------------------------------------------------------<

    # mdadm -E /dev/sdb1
    mdadm: cannot open /dev/sdb1: No such device or address

    # mdadm -E /dev/sdb2
    mdadm: cannot open /dev/sdb2: No such device or address

    # mdadm -E /dev/sdb3
    mdadm: cannot open /dev/sdb3: No such device or address

    # mdadm -E /dev/sdb4
    mdadm: cannot open /dev/sdb4: No such device or address

    # mdadm -E /dev/sdb5
    mdadm: cannot open /dev/sdb5: No such device or address

    # mdadm -E /dev/sdb6
    mdadm: cannot open /dev/sdb6: No such device or address

    # mdadm -E /dev/sdb7
    mdadm: cannot open /dev/sdb7: No such device or address

    # mdadm -E /dev/sdb8
    mdadm: cannot open /dev/sdb8: No such device or address

    # mdadm -E /dev/sdb9
    mdadm: cannot open /dev/sdb9: No such device or address

    # mdadm -E /dev/sdb10
    mdadm: cannot open /dev/sdb10: No such device or address

    # mdadm -E /dev/sdb11
    mdadm: cannot open /dev/sdb11: No such device or address

 >-------------------------------------------------------------------------------------------------------------<

mdadm -E /dev/md126pX do give something (except for md126p11):
 >-------------------------------------------------------------------------------------------------------------<


    # mdadm -E /dev/md126p1
    /dev/md126p1:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 350e253f:863b7b04:b1617c47:b213a024
       Creation Time : Mon May  7 20:29:35 2007
          Raid Level : raid1
       Used Dev Size : 489856 (478.46 MiB 501.61 MB)
          Array Size : 489856 (478.46 MiB 501.61 MB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 0

         Update Time : Thu Apr 30 08:00:08 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 6372ca75 - correct
              Events : 1769


           Number   Major   Minor   RaidDevice State
    this     0     259        0        0      active sync
      /dev/md/raidlin_0p1

        0     0     259        0        0      active sync
      /dev/md/raidlin_0p1
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p2
    /dev/md126p2:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 086e68ed:3607317f:60b56e23:6bae62bc
       Creation Time : Mon May  7 20:29:41 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 1

         Update Time : Thu Apr 30 20:57:21 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 4fd14bc9 - correct
              Events : 3980


           Number   Major   Minor   RaidDevice State
    this     0     259        1        0      active sync
      /dev/md/raidlin_0p2

        0     0     259        1        0      active sync
      /dev/md/raidlin_0p2
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p3
    /dev/md126p3:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 0f6e3ed5:aeee975a:c3647deb:763d68ce
       Creation Time : Mon May  7 20:29:48 2007
          Raid Level : raid1
       Used Dev Size : 1951808 (1906.38 MiB 1998.65 MB)
          Array Size : 1951808 (1906.38 MiB 1998.65 MB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 2

         Update Time : Thu Apr 30 18:27:58 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 3cc9ac24 - correct
              Events : 1703


           Number   Major   Minor   RaidDevice State
    this     0     259        2        0      active sync
      /dev/md/raidlin_0p3

        0     0     259        2        0      active sync
      /dev/md/raidlin_0p3
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p4
    /dev/md126p4:
        MBR Magic : aa55
    Partition[0] :      9767457 sectors at           63 (type fd)
    Partition[1] :     19535040 sectors at      9767520 (type 05)

    # mdadm -E /dev/md126p5
    /dev/md126p5:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 6b560fe8:f24d6f2e:8942bd3a:1903abbc
       Creation Time : Mon May  7 20:29:55 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 3

         Update Time : Thu Apr 30 20:57:18 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 44e1e6e6 - correct
              Events : 7856


           Number   Major   Minor   RaidDevice State
    this     0     259        4        0      active sync
      /dev/md/raidlin_0p5

        0     0     259        4        0      active sync
      /dev/md/raidlin_0p5
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p6
    /dev/md126p6:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 462dab96:b7ca2a17:7c4aebf1:d4d7ec3b
       Creation Time : Mon May  7 20:30:02 2007
          Raid Level : raid1
       Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
          Array Size : 9767424 (9.31 GiB 10.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 4

         Update Time : Thu Apr 30 20:57:14 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 945d0c07 - correct
              Events : 2999


           Number   Major   Minor   RaidDevice State
    this     0     259        5        0      active sync
      /dev/md/raidlin_0p6

        0     0     259        5        0      active sync
      /dev/md/raidlin_0p6
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p7
    /dev/md126p7:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : ea511351:3abc7b12:4c81e838:93dbd21a
       Creation Time : Mon May  7 20:30:09 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 5

         Update Time : Thu Apr 30 20:57:18 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : 4a634da7 - correct
              Events : 8626


           Number   Major   Minor   RaidDevice State
    this     0     259        6        0      active sync
      /dev/md/raidlin_0p7

        0     0     259        6        0      active sync
      /dev/md/raidlin_0p7
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p8
    /dev/md126p8:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : da0d76c6:91422584:dc3d6162:37ced53b
       Creation Time : Mon May  7 20:30:15 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 6

         Update Time : Thu Apr 30 20:57:31 2015
               State : active
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : c4540a0c - correct
              Events : 30082


           Number   Major   Minor   RaidDevice State
    this     0     259        7        0      active sync
      /dev/md/raidlin_0p8

        0     0     259        7        0      active sync
      /dev/md/raidlin_0p8
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p9
    /dev/md126p9:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : 387c831c:8a6d05e3:b649696c:0870b930
       Creation Time : Mon May  7 20:30:21 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 7

         Update Time : Thu Apr 30 20:57:10 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : c69b931a - correct
              Events : 4852


           Number   Major   Minor   RaidDevice State
    this     0     259        8        0      active sync
      /dev/md/raidlin_0p9

        0     0     259        8        0      active sync
      /dev/md/raidlin_0p9
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p10
    /dev/md126p10:
               Magic : a92b4efc
             Version : 0.90.00
                UUID : b07c4ab4:39d0ba53:9913afa9:fd9cc323
       Creation Time : Mon May  7 20:30:28 2007
          Raid Level : raid1
       Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
          Array Size : 4883648 (4.66 GiB 5.00 GB)
        Raid Devices : 2
       Total Devices : 1
    Preferred Minor : 8

         Update Time : Thu Apr 30 20:57:28 2015
               State : clean
      Active Devices : 1
    Working Devices : 1
      Failed Devices : 1
       Spare Devices : 0
            Checksum : c5f5d015 - correct
              Events : 19271


           Number   Major   Minor   RaidDevice State
    this     0     259        9        0      active sync
      /dev/md/raidlin_0p10

        0     0     259        9        0      active sync
      /dev/md/raidlin_0p10
        1     1       0        0        1      faulty removed

    # mdadm -E /dev/md126p11
    mdadm: No md superblock detected on /dev/md126p11. 

 >-------------------------------------------------------------------------------------------------------------<

Some more commands:
 >-------------------------------------------------------------------------------------------------------------<

    # mdadm -D /dev/md126
    /dev/md126:
           Container : /dev/md/imsm0, member 0
          Raid Level : raid1
          Array Size : 244195328 (232.88 GiB 250.06 GB)
       Used Dev Size : 244195328 (232.88 GiB 250.06 GB)
        Raid Devices : 2
       Total Devices : 2

               State : active
      Active Devices : 2
    Working Devices : 2
      Failed Devices : 0
       Spare Devices : 0


                UUID : 91449a9d:9242bfe9:d99bceb0:a59f9314
         Number   Major   Minor   RaidDevice State
            1       8       32        0      active sync   /dev/sdc
            0       8       16        1      active sync   /dev/sdb

 >-------------------------------------------------------------------------------------------------------------<

    # mdadm -E /dev/sdb
    mdmon: /dev/sdb is not attached to Intel(R) RAID controller.
    mdmon: /dev/sdb is not attached to Intel(R) RAID controller.
    /dev/sdb:
               Magic : Intel Raid ISM Cfg Sig.
             Version : 1.1.00
         Orig Family : 26b5a9e0
              Family : 26b5a9e0
          Generation : 00004db7
          Attributes : All supported
                UUID : d9cfa6d9:2a715e4f:1fbc2095:be342429
            Checksum : 261d2aed correct
         MPB Sectors : 1
               Disks : 2
        RAID Devices : 1

       Disk01 Serial : VFC100R10BE79D
               State : active
                  Id : 00010000
         Usable Size : 488390862 (232.88 GiB 250.06 GB)

    [raidlin]:
                UUID : 91449a9d:9242bfe9:d99bceb0:a59f9314
          RAID Level : 1
             Members : 2
               Slots : [UU]
         Failed disk : none
           This Slot : 1
          Array Size : 488390656 (232.88 GiB 250.06 GB)
        Per Dev Size : 488390656 (232.88 GiB 250.06 GB)
       Sector Offset : 0
         Num Stripes : 1907776
          Chunk Size : 64 KiB
            Reserved : 0
       Migrate State : idle
           Map State : normal
         Dirty State : dirty

       Disk00 Serial : VFC100R10BRKMD
               State : active
                  Id : 00000000
         Usable Size : 488390862 (232.88 GiB 250.06 GB)

 >-------------------------------------------------------------------------------------------------------------<

    # mdadm -E /dev/sdc
    mdmon: /dev/sdc is not attached to Intel(R) RAID controller.
    mdmon: /dev/sdc is not attached to Intel(R) RAID controller.
    /dev/sdc:
               Magic : Intel Raid ISM Cfg Sig.
             Version : 1.1.00
         Orig Family : 26b5a9e0
              Family : 26b5a9e0
          Generation : 00004dbc
          Attributes : All supported
                UUID : d9cfa6d9:2a715e4f:1fbc2095:be342429
            Checksum : 261c2af2 correct
         MPB Sectors : 1
               Disks : 2
        RAID Devices : 1

       Disk00 Serial : VFC100R10BRKMD
               State : active
                  Id : 00000000
         Usable Size : 488390862 (232.88 GiB 250.06 GB)

    [raidlin]:
                UUID : 91449a9d:9242bfe9:d99bceb0:a59f9314
          RAID Level : 1
             Members : 2
               Slots : [UU]
         Failed disk : none
           This Slot : 0
          Array Size : 488390656 (232.88 GiB 250.06 GB)
        Per Dev Size : 488390656 (232.88 GiB 250.06 GB)
       Sector Offset : 0
         Num Stripes : 1907776
          Chunk Size : 64 KiB
            Reserved : 0
       Migrate State : idle
           Map State : normal
         Dirty State : clean

       Disk01 Serial : VFC100R10BE79D
               State : active
                  Id : 00010000
         Usable Size : 488390862 (232.88 GiB 250.06 GB)

 >-------------------------------------------------------------------------------------------------------------<

I see something wicked in there and I don't know how to correct it...
I see at least two problems :
- mdadm is not able to detect md9
- my array does not seems fully operationa

Can you help ?

If you need more logs / command output, tell me which one.
I hope I'm not too much confusing...

kernel : Linux shax 3.16.0-4-686-pae #1 SMP Debian 3.16.7-ckt9-3~deb8u1 
(2015-04-24) i686 GNU/Linux




