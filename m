From: "Jon =?iso-8859-1?Q?Lur=E5s?=" <jon@irisinfo.net>
Subject: Change disk problem
Date: Sun, 08 Jun 2008 09:58:32 +0200
Message-ID: <WorldClient-F200806080958.AA58320509@irisinfo.net>
References: <S1753847AbYFHHWg/20080608072236Z+62@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1753847AbYFHHWg/20080608072236Z+62@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I got a big problem with replacing disk on Software-RAID.
Whatever I do it just ends up as a spare disk.
I guess the problem is that the faulty disk was not removed from the RAID.
We just shut down and replace'd the disk.
Any idea of how to solve this?

Thanks in advance 

Jon 

DETAILS:

xxxxx:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Jun  7 22:04:01 2008
     Raid Level : raid5
     Array Size : 490223232 (467.51 GiB 501.99 GB)
    Device Size : 245111616 (233.76 GiB 250.99 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jun  7 22:04:01 2008
          State : active, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 7edd5dfe:14b3ffb2:304b0607:0d821dcd
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0      56        1        0      active sync   /dev/hdi1
       1      56       65        1      active sync   /dev/hdj1
       2       0        0        2      removed


xxxxx:~# mdadm --version
mdadm - v2.5.6 - 9 November 2006

xxxxx:~# uname -a
Linux xxxxx 2.4.27-3-386 xxxxxxxxxxxxxxxxxxxxxxxxxx

xxxxx:~# cat /etc/debian_version
Debian 4.0


