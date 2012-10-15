From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: convert metadata version: possible/wise?
Date: Mon, 15 Oct 2012 11:49:03 -0700
Message-ID: <vd2uk9xo62.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

The default CentOS 6 install media creates md devices with metadata 1.1
(or, it seems like, 1.0 for /boot).  I was wondering, first off, is
there any advantage to try to attempt to migrate these to metadata 1.2?
I suppose that RHEL/CentOS had some reason for making /boot 1.0 (perhaps
the newer metadata formats can not be booted), so for now let's just
consider migrating from 1.1 to 1.2.  If there are any advantages, what
would they be?  And would it generally be a big advantage or a
relatively minor one?

If there actually is a significant advantage to migrate to 1.2, is the
general process to do so basically the same as what Neil wrote last
year?

http://marc.info/?l=linux-raid&m=130895284716309

If it helps any, my mdadm and uname for one example is below.  As you
can see the md devices are made from partitions--the CentOS installer
doesn't easily support a RAID1 on the entire boot drive.  I'm not tied
to any of the data on these arrays, but an in-place migration (even if
single-user is needed e.g. to operate on /usr) would be easier.

--keith


# mdadm -D /dev/md3
/dev/md3:
        Version : 1.1
  Creation Time : Wed Oct 10 14:59:54 2012
     Raid Level : raid1
     Array Size : 20478908 (19.53 GiB 20.97 GB)
  Used Dev Size : 20478908 (19.53 GiB 20.97 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Oct 15 11:41:13 2012
          State : active 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : XXXXX
           UUID : 741b351c:dd186205:745aa46b:0331a8ff
         Events : 82

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
# uname -a
Linux XXXXXX 2.6.32-279.9.1.el6.x86_64 #1 SMP Tue Sep 25 21:43:11 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux



-- 
kkeller@wombat.san-francisco.ca.us


