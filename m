From: Sandro Dentella <sandro.dentella@tin.it>
Subject: mdadm --detail output: 2 questions
Date: Thu, 22 Apr 2004 19:58:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040422175833.GA30298@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all, 

  I made a raid5 array with command

   mdadm -Cv /dev/md3 -n5 -x1 -l5  /dev/sd{a,b,c,d,e,f}1

  It took me a while to undertand that while syncing a raid5 mdadm --detail
  marks as failed the spare disk + 1. Is that correct? here the output before
  it was finished and afterwords. The last one really was produced by mdadm 1.5,
  the first one by mdadm 1.2, since 

#######  mdadm --detail /dev/md3    mdadm v. 1.2 - while syncing #############
root@nas-macpro root # mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.00
  Creation Time : Thu Apr 22 12:55:22 2004
     Raid Level : raid5
     Array Size : 980317696 (934.90 GiB 1003.85 GB)
    Device Size : 245079424 (233.73 GiB 250.96 GB)
   Raid Devices : 5
  Total Devices : 7
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Apr 22 12:55:22 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/scsi/host0/bus0/target0/lun0/part1
       1       8       17        1      active sync   /dev/scsi/host0/bus0/target1/lun0/part1
       2       8       33        2      active sync   /dev/scsi/host0/bus0/target2/lun0/part1
       3       8       49        3      active sync   /dev/scsi/host1/bus0/target0/lun0/part1
       4       0        0        4      faulty
       5       8       81        5        /dev/scsi/host1/bus0/target2/lun0/part1
       6       8       65        6        /dev/scsi/host1/bus0/target1/lun0/part1
           UUID : 74aad38c:ee99c8cd:e8df8d30:c2d07f91
         Events : 0.1


#######  mdadm --detail /dev/md3    mdadm v. 1.5  -sync finished  #############
root@nas-macpro root # mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.00
  Creation Time : Thu Apr 22 12:55:22 2004
     Raid Level : raid5
     Array Size : 980317696 (934.90 GiB 1003.85 GB)
    Device Size : 245079424 (233.73 GiB 250.96 GB)
   Raid Devices : 5
  Total Devices : 7
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Apr 22 17:22:01 2004
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/scsi/host0/bus0/target0/lun0/part1
       1       8       17        1      active sync   /dev/scsi/host0/bus0/target1/lun0/part1
       2       8       33        2      active sync   /dev/scsi/host0/bus0/target2/lun0/part1
       3       8       49        3      active sync   /dev/scsi/host1/bus0/target0/lun0/part1
       4       8       65        4      active sync   /dev/scsi/host1/bus0/target1/lun0/part1
       5       8       81        5      spare   /dev/scsi/host1/bus0/target2/lun0/part1
           UUID : 74aad38c:ee99c8cd:e8df8d30:c2d07f91
         Events : 0.2

##########################################################################

in both output I see 7 'Total devices' and 1 Failed but I don't have any
failed in reality nor in the last part of the output. Am I misunderstanding
the output? 

Last question: what is the meaning of  'Events: 0.2' (0.1 during syncing)?

Thaks in advance
sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
