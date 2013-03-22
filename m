From: Mirko <mirko76@arcor.de>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 15:21:07 +0000 (UTC)
Message-ID: <loom.20130322T161947-958@post.gmane.org>
References: <loom.20130322T084406-543@post.gmane.org> <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com> <loom.20130322T134448-923@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I added the damaged device again to the raid:

/dev/md0:
        Version : 1.2
  Creation Time : Fri Feb 22 22:08:12 2013
     Raid Level : raid5
  Used Dev Size : 976630272 (931.39 GiB 1000.07 GB)
   Raid Devices : 6
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Thu Mar 21 15:50:39 2013
          State : active, degraded, Not Started 
 Active Devices : 5
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : -1, (7->6)

           Name : server:0  (local to host server)
           UUID : 1db312ca:48cd4f30:e8607949:0c721b94
         Events : 38267

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8        1        1      active sync   /dev/sda1
       3       8       81        2      active sync   /dev/sdf1
       3       0        0        3      removed
       5       8       65        4      active sync   /dev/sde1
       6       8       17        5      active sync   /dev/sdb1

       7       8       33        -      spare   /dev/sdc1
       8       8      113        -      spare   /dev/sdh1

But now i have two spare drives.

