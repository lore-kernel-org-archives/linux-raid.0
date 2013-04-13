From: Gimpbully <gimpbully@gmail.com>
Subject: array went wonky
Date: Fri, 12 Apr 2013 22:41:11 -0700
Message-ID: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good Evening Folks,
     Alright, I have a 5 disk raid5, it's worked for years.  Today a disk went "click click" and I dropped the cold spare I had in and started a rebuild.  Everything was great until I checked around 35% rebuild and everything was in the toilet.  Here is the current -E info.  Any advise would be *amazingly* appreciated.  (I can't believe I didn't just put the spare in and just go RAID5...).

/dev/sda1:
         Events : 25952
this     4       8        1        4      active sync   /dev/sda1
   0     0       8       33        0      active sync   /dev/sdc1
   2     2       8       65        2      active sync   /dev/sde1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      spare   /dev/sdf1
/dev/sdb1:
         Events : 25944
this     1       8       17        1      active sync   /dev/sdb1
   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       65        2      active sync   /dev/sde1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      spare   /dev/sdf1
/dev/sdc1:
         Events : 25952
this     0       8       33        0      active sync   /dev/sdc1
   0     0       8       33        0      active sync   /dev/sdc1
   2     2       8       65        2      active sync   /dev/sde1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      spare   /dev/sdf1
/dev/sde1:
         Events : 25952
this     2       8       65        2      active sync   /dev/sde1
   0     0       8       33        0      active sync   /dev/sdc1
   2     2       8       65        2      active sync   /dev/sde1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      spare   /dev/sdf1
/dev/sdf1:
         Events : 25952
this     5       8       81        5      spare   /dev/sdf1
   0     0       8       33        0      active sync   /dev/sdc1
   2     2       8       65        2      active sync   /dev/sde1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       81        5      spare   /dev/sdf1

-- 
~~~~~~~~~
He hates these cans