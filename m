From: CoolCold <coolthecold@gmail.com>
Subject: chunk size
Date: Thu, 2 Apr 2009 12:57:22 +0400
Message-ID: <f19d625d0904020157x18fa7744y1f72fce544dc5d42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!
I've assembled two raid1 arrays yesterday, and forgot what chunk size
i've specified. Trying to determine this with mdadm -D /dev/md2 but
have no success, reading man didn't help too. How i can get this info?

bandb:~# mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Wed Apr  1 05:29:59 2009
     Raid Level : raid1
     Array Size : 290720192 (277.25 GiB 297.70 GB)
    Device Size : 290720192 (277.25 GiB 297.70 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Apr  2 12:51:26 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 70a701e2:02c0ab22:6973a307:dc8d6229 (local to host
bandb.blabla.ru)
         Events : 0.6

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3


os - debian etch
bandb:~# uname -a
Linux bandb.blabla.ru 2.6.25-2-amd64 #1 SMP Wed May 14 14:04:05 UTC
2008 x86_64 GNU/Linux
bandb:~# mdadm --version
mdadm - v2.5.6 - 9 November 2006

--
--
Best regards,
[COOLCOLD-RIPN]
