From: Konrad Rzepecki <krzepecki@dentonet.pl>
Subject: Re: Disk identity crisis on RAID10 recovery (3.1.0)
Date: Tue, 22 Nov 2011 13:22:36 +0100
Message-ID: <4ECB940C.6010707@dentonet.pl>
References: <4ECB7649.6080505@dentonet.pl> <20111122221522.3f525fc6@notabene.brown>
Reply-To: krzepecki@dentonet.pl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111122221522.3f525fc6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

W dniu 22.11.2011 12:15, NeilBrown pisze:
> You can probably get your data back... but really you should have 
> asked for
> help as soon as strange things started happening!

Possibly, but I don't like to bother others when I don't need to. And in 
the beginning
I didn't connect this behavior whit kernel but with some hardware disk 
issues.

Moreover reporting bugs on list is hmm... inconvenient. Please, back 
Bugzilla
online ASAP.

> If you have all important data backed up then just upgrade to 3.1.2 
> and make
> the array again  from scratch.

Probably this is best way...

> If you want to try to recover the array please report that output of 
> "mdadm
> --examine" on all of the devices.

...but I paste output of this commands below. If some of system survive, 
I can
make it up faster. Of course, if it isn't to complicated or take too much of
your time to describe it.

mdadm --examine /dev/sda2
/dev/sda2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423abc - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2


sdb - is back, but this is new empty one.


mdadm --examine /dev/sdc2
/dev/sdc2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423ae6 - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     8       8       34        8      spare   /dev/sdc2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2


mdadm --examine /dev/sdd2
/dev/sdd2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423af2 - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2


mdadm --examine /dev/sde2
/dev/sde2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423b04 - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     4       8       66        4      active sync   /dev/sde2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2


mdadm --examine /dev/sdf2
/dev/sdf2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423b16 - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     5       8       82        5      active sync   /dev/sdf2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2


mdadm --examine /dev/sdg2
/dev/sdg2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423b28 - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     6       8       98        6      active sync   /dev/sdg2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2



mdadm --examine /dev/sdh2
/dev/sdh2:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 0f01ef9e:ab0117cf:3d186b3c:53958f34 (local to host 
(none))
   Creation Time : Wed Aug 17 09:34:04 2011
      Raid Level : raid10
   Used Dev Size : 1463946752 (1396.13 GiB 1499.08 GB)
      Array Size : 5855787008 (5584.51 GiB 5996.33 GB)
    Raid Devices : 8
   Total Devices : 7
Preferred Minor : 1

     Update Time : Tue Nov 22 11:43:58 2011
           State : clean
  Active Devices : 6
Working Devices : 7
  Failed Devices : 2
   Spare Devices : 1
        Checksum : e8423b3a - correct
          Events : 155878

          Layout : near=2
      Chunk Size : 512K

       Number   Major   Minor   RaidDevice State
this     7       8      114        7      active sync   /dev/sdh2

    0     0       8        2        0      active sync   /dev/sda2
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3       8       50        3      active sync   /dev/sdd2
    4     4       8       66        4      active sync   /dev/sde2
    5     5       8       82        5      active sync   /dev/sdf2
    6     6       8       98        6      active sync   /dev/sdg2
    7     7       8      114        7      active sync   /dev/sdh2
    8     8       8       34        8      spare   /dev/sdc2

-- 
    Konrad Rzepecki
