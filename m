From: "Edward Siefker" <hatta00@fastmail.fm>
Subject: Re: Raid 5 to 6 grow stalled
Date: Sat, 09 Apr 2011 09:55:49 -0700
Message-ID: <1302368149.21170.1439272049@webmail.messagingengine.com>
References: <1302366232.12096.1439264077@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1302366232.12096.1439264077@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's a little more info about my array.  

mdadm -D /dev/md2:

/dev/md2:
        Version : 0.90
  Creation Time : Wed Aug  5 22:07:37 2009
     Raid Level : raid6
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Apr  9 11:49:59 2011
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 64K

 Rebuild Status : 0% complete

           UUID : 2a150668:a0e6267d:a6dd356e:c26679ce (local to host
           iblis)
         Events : 0.613692

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       33        1      active sync   /dev/sdc1
       2       8       81        2      active sync   /dev/sdf1
       4       8       65        3      spare rebuilding   /dev/sde1



mdadm -E /dev/sde1:

/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 2a150668:a0e6267d:a6dd356e:c26679ce (local to host
           iblis)
  Creation Time : Wed Aug  5 22:07:37 2009
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Sat Apr  9 11:50:41 2011
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ccecf240 - correct
         Events : 613694

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      spare   /dev/sde1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       81        2      active sync   /dev/sdf1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      spare   /dev/sde1
-- 
  
  hatta00@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

