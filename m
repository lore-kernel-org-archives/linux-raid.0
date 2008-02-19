From: "Norman Elton" <normelton@gmail.com>
Subject: How many drives are bad?
Date: Tue, 19 Feb 2008 12:23:55 -0500
Message-ID: <6b3a7f010802190923v6b600fedy2a68ad6797449c6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I had my first "failure" today, when I got a report that one drive
(/dev/sdam) failed. I've attached the output of "mdadm --detail". It
appears that two drives are listed as "removed", but the array is
still functioning. What does this mean? How many drives actually
failed?

This is all a test system, so I can dink around as much as necessary.
Thanks for any advice!

Norman Elton

====== OUTPUT OF MDADM =====

        Version : 00.90.03
  Creation Time : Fri Jan 18 13:17:33 2008
     Raid Level : raid5
     Array Size : 6837319552 (6520.58 GiB 7001.42 GB)
    Device Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Mon Feb 18 11:49:13 2008
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : b16bdcaf:a20192fb:39c74cb8:e5e60b20
         Events : 0.110

    Number   Major   Minor   RaidDevice State
       0      66        1        0      active sync   /dev/sdag1
       1      66       17        1      active sync   /dev/sdah1
       2      66       33        2      active sync   /dev/sdai1
       3      66       49        3      active sync   /dev/sdaj1
       4      66       65        4      active sync   /dev/sdak1
       5       0        0        5      removed
       6       0        0        6      removed
       7      66      113        7      active sync   /dev/sdan1

       8      66       97        -      faulty spare   /dev/sdam1
