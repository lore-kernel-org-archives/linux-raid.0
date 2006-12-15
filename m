From: =?ISO-8859-1?Q?Ask_Bj=F8rn_Hansen?= <ask@develooper.com>
Subject: Help recovering a raid6 device with a kicked drive (too many)
Date: Fri, 15 Dec 2006 03:12:27 -0800
Message-ID: <A0F529BE-0E94-4DC0-A53C-DF905999FAF2@develooper.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I had a drive failing today.  I had a loose cable when I booted after  
replacing the failing drive (doh!) so now some of my md devices had  
an extra failed drive.  "Oh well, it'll just rebuild" I foolishly  
thought.

Of course during the rebuild another drive (sdg12) failed (with read )

During a rebuild one of my raid6 devices failed ("read error not  
correctable").   I'd like to try putting the device together to copy  
as much data as possible off.   From what I read recently on the  
list, I think these command would force the raid going again, is that  
right?

    mdadm -S /dev/md12
    mdadm -C -n 7 -l 6 /dev/md12 /dev/sdf12 /dev/sdg12 /dev/sde12 / 
dev/sdc12 missing missing /dev/sda12

Is there a way to make md not kick the drive again when I try copying  
the data off?

I've posted first the error and then mdadm -E from each of the  
devices in the raid below.

Thanks!

    - ask


This was the failure:

ata6: spurious interrupt (irq_stat 0x8 active_tag -84148995 sactive 0x0)
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
ata7: EH complete
ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata7.00: (BMDMA stat 0x20)
ata7.00: tag 0 cmd 0x25 Emask 0x9 stat 0x51 err 0x40 (media error)
sd 6:0:0:0: SCSI error: return code = 0x08000002
sdg: Current: sense key: Medium Error
     Additional sense: Unrecovered read error - auto reallocate failed
end_request: I/O error, dev sdg, sector 487466631
raid5:md12: read error not correctable (sector 58595328 on sdg12).
raid5: Disk failure on sdg12, disabling device. Operation continuing  
on 4 devices
raid5:md12: read error not correctable (sector 58595336 on sdg12).
raid5:md12: read error not correctable (sector 58595344 on sdg12).
raid5:md12: read error not correctable (sector 58595352 on sdg12).
raid5:md12: read error not correctable (sector 58595360 on sdg12).
raid5:md12: read error not correctable (sector 58595368 on sdg12).
raid5:md12: read error not correctable (sector 58595376 on sdg12).
raid5:md12: read error not correctable (sector 58595384 on sdg12).
raid5:md12: read error not correctable (sector 58595392 on sdg12).
raid5:md12: read error not correctable (sector 58595400 on sdg12).



/dev/sdg12:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : ab10495a:eed4723d:e1075255:4dc67314
   Creation Time : Tue Apr 18 02:58:51 2006
      Raid Level : raid6
     Device Size : 29302464 (27.95 GiB 30.01 GB)
      Array Size : 146512320 (139.73 GiB 150.03 GB)
    Raid Devices : 7
   Total Devices : 5
Preferred Minor : 12

     Update Time : Fri Dec 15 01:16:37 2006
           State : clean
Active Devices : 5
Working Devices : 5
Failed Devices : 2
   Spare Devices : 0
        Checksum : fdcd0960 - correct
          Events : 0.3406784

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8      108        1      active sync   /dev/sdg12

    0     0       8       92        0      active sync   /dev/sdf12
    1     1       8      108        1      active sync   /dev/sdg12
    2     2       8       76        2      active sync   /dev/sde12
    3     3       8       44        3      active sync   /dev/sdc12
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8       12        6      active sync   /dev/sda12

/dev/sda12:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : ab10495a:eed4723d:e1075255:4dc67314
   Creation Time : Tue Apr 18 02:58:51 2006
      Raid Level : raid6
     Device Size : 29302464 (27.95 GiB 30.01 GB)
      Array Size : 146512320 (139.73 GiB 150.03 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 12

     Update Time : Fri Dec 15 02:53:39 2006
           State : clean
Active Devices : 4
Working Devices : 5
Failed Devices : 3
   Spare Devices : 1
        Checksum : fdcd203c - correct
          Events : 0.3406790

      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8       12        6      active sync   /dev/sda12

    0     0       8       92        0      active sync   /dev/sdf12
    1     1       0        0        1      faulty removed
    2     2       8       76        2      active sync   /dev/sde12
    3     3       8       44        3      active sync   /dev/sdc12
    4     4       0        0        4      faulty removed
    5     5       0        0        5      faulty removed
    6     6       8       12        6      active sync   /dev/sda12
    7     7       8       60        7      spare   /dev/sdd12


/dev/sdc12:
           Checksum : fdcd2056 - correct

          Number   Major   Minor   RaidDevice State
    this     3       8       44        3      active sync   /dev/sdc12

       0     0       8       92        0      active sync   /dev/sdf12
       1     1       0        0        1      faulty removed
       2     2       8       76        2      active sync   /dev/sde12
       3     3       8       44        3      active sync   /dev/sdc12
       4     4       0        0        4      faulty removed
       5     5       0        0        5      faulty removed
       6     6       8       12        6      active sync   /dev/sda12
       7     7       8       60        7      spare   /dev/sdd12

/dev/sdd12:
              Checksum : fdcd2068 - correct

             Number   Major   Minor   RaidDevice State
       this     7       8       60        7      spare   /dev/sdd12

          0     0       8       92        0      active sync   /dev/ 
sdf12
          1     1       0        0        1      faulty removed
          2     2       8       76        2      active sync   /dev/ 
sde12
          3     3       8       44        3      active sync   /dev/ 
sdc12
          4     4       0        0        4      faulty removed
          5     5       0        0        5      faulty removed
          6     6       8       12        6      active sync   /dev/ 
sda12
          7     7       8       60        7      spare   /dev/sdd12

/dev/sde12:
             Checksum : fdcd2074 - correct


                Number   Major   Minor   RaidDevice State
          this     2       8       76        2      active sync   / 
dev/sde12

             0     0       8       92        0      active sync   / 
dev/sdf12
             1     1       0        0        1      faulty removed
             2     2       8       76        2      active sync   / 
dev/sde12
             3     3       8       44        3      active sync   / 
dev/sdc12
             4     4       0        0        4      faulty removed
             5     5       0        0        5      faulty removed
             6     6       8       12        6      active sync   / 
dev/sda12
             7     7       8       60        7      spare   /dev/sdd12

/dev/sdf12:
                   Number   Major   Minor   RaidDevice State
             this     0       8       92        0      active sync   / 
dev/sdf12

                0     0       8       92        0      active sync   / 
dev/sdf12
                1     1       0        0        1      faulty removed
                2     2       8       76        2      active sync   / 
dev/sde12
                3     3       8       44        3      active sync   / 
dev/sdc12
                4     4       0        0        4      faulty removed
                5     5       0        0        5      faulty removed
                6     6       8       12        6      active sync   / 
dev/sda12
                7     7       8       60        7      spare   /dev/ 
sdd12


