From: Wolfgang Denk <wd@denx.de>
Subject: MD RAID6 corrupted by Avago 9260-4i controller
Date: Sun, 15 May 2016 14:45:34 +0200
Message-ID: <20160515124534.A42D0100879@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I managed to kill a RAID6... My old server mainboard died, the new one
did not have PCI-X any more, so I bought it with an Avago 9260-4i, of
course after asking (but not verifying in the net, sic) that I can
export the disks as plain JBOD. Well, you cannot. So I played around
with a set of spare disks and realized that you can configure a RAID0
consisting of a single disk drive, and when you skip the initialization
of the array, it basically does what I need.  OK, so I added my real
disks, and things looked fine.  Then I added some new disks and
decided to set them up as a HW RAID6 to compare performance.  But,
when I intended to start initialization of this new RAID6, the Avago
firmware silently also initalized all my previously untouched old
disks, and boom!

The original array was created this way:

# mdadm --create --verbose /dev/md2 --metadata=1.2 --level=6 \
	--raid-devices=6 --chunk=16 --assume-clean /dev/sd[abefgh]
mdadm: layout defaults to left-symmetric
mdadm: size set to 976762448K
mdadm: array /dev/md2 started.

# mdadm -Q --detail /dev/md2
/dev/md2:
        Version : 1.02
  Creation Time : Tue Jan 18 12:38:15 2011
     Raid Level : raid6
     Array Size : 3907049792 (3726.05 GiB 4000.82 GB)
  Used Dev Size : 1953524896 (1863.03 GiB 2000.41 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jan 18 12:38:15 2011
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 16K

           Name : 2
           UUID : 7ae2c7ac:74b4b307:69c2de0e:a2735e73
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg
       5       8      112        5      active sync   /dev/sdh


Now, I see this instead:

# cat /proc/mdstat 
Personalities : [raid0] [raid1] 
md120 : active raid0 sdf[0]
      976224256 blocks super external:/md0/5 256k chunks
      
md121 : active raid0 sde[0]
      976224256 blocks super external:/md0/4 256k chunks
      
md122 : active raid0 sdd[0]
      976224256 blocks super external:/md0/3 256k chunks
      
md123 : active raid0 sdc[0]
      976224256 blocks super external:/md0/2 256k chunks
      
md124 : active raid0 sdb[0]
      976224256 blocks super external:/md0/1 256k chunks
      
md125 : active raid0 sda[0]
      976224256 blocks super external:/md0/0 256k chunks
      
md126 : inactive sda[5](S) sdf[4](S) sde[3](S) sdd[2](S) sdc[1](S) sdb[0](S)
      3229968 blocks super external:ddf

# mdadm -Q --detail /dev/md126
/dev/md126:
        Version : ddf
     Raid Level : container
  Total Devices : 6

Working Devices : 6

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

  Member Arrays : /dev/md120 /dev/md121 /dev/md122 /dev/md123 /dev/md124 /dev/md125

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8       32        -        /dev/sdc
       2       8       48        -        /dev/sdd
       3       8       64        -        /dev/sde
       4       8       80        -        /dev/sdf
       5       8        0        -        /dev/sda

# mdadm -Q --detail /dev/md120
/dev/md120:
      Container : /dev/md0, member 5
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf

# mdadm -Q --detail /dev/md121
/dev/md121:
      Container : /dev/md0, member 4
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde

# mdadm -Q --detail /dev/md122
/dev/md122:
      Container : /dev/md0, member 3
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd

# mdadm -Q --detail /dev/md123
/dev/md123:
      Container : /dev/md0, member 2
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc

# mdadm -Q --detail /dev/md124
/dev/md124:
      Container : /dev/md0, member 1
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb

# mdadm -Q --detail /dev/md125
/dev/md125:
      Container : /dev/md0, member 0
     Raid Level : raid0
     Array Size : 976224256 (931.00 GiB 999.65 GB)
   Raid Devices : 1
  Total Devices : 1

          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

 Container GUID : 4C534920:20202020:10000079:10009260:446872B3:105E9355
                  (LSI      05/14/16 08:23:15)
            Seq : 00000019
  Virtual Disks : 11

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda


Yes, I know I was stupid, but can anybody help? Is there a way to get
the old RAID6 setup running, just to recover the data (we have
backups on tape, but I figure the restore takes long....)

For the record: there were also two disks which had partitions which
were used for 2 x RAID1 arrays; these survived the Avago's firmware
initialization:

# mdadm -Q --detail /dev/md126
/dev/md126:
        Version : 1.0
  Creation Time : Fri Jan 21 11:34:46 2011
     Raid Level : raid1
     Array Size : 262132 (256.03 MiB 268.42 MB)
  Used Dev Size : 262132 (256.03 MiB 268.42 MB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun May 15 08:10:48 2016
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : localhost.localdomain:3
           UUID : 28815077:9fe434a1:7fbd6fbb:46816ee0
         Events : 847

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8      113        1      active sync   /dev/sdh1
# mdadm -Q --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed Jan 19 07:28:49 2011
     Raid Level : raid1
     Array Size : 970206800 (925.26 GiB 993.49 GB)
  Used Dev Size : 970206800 (925.26 GiB 993.49 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun May 15 08:41:23 2016
          State : active 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : castor.denx.de:4
           UUID : 0551c50c:30e757d4:83368de2:9a8ff1e1
         Events : 38662

    Number   Major   Minor   RaidDevice State
       2       8       99        0      active sync   /dev/sdg3
       3       8      115        1      active sync   /dev/sdh3


Thanks in advance!

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
I am more bored than you could ever possibly be.  Go back to work.
