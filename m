From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Help - Urgent!!!
Date: Fri, 13 Nov 2009 10:06:38 +0100
Message-ID: <20091113100638.02c174fe@atak.bl.pg.gda.pl>
References: <200911122253.01626.lrhorer@satx.rr.com>
	<19196.60011.858158.550391@notabene.brown>
	<19196.60094.69339.36550@notabene.brown>
	<200911122314.13426.lrhorer@satx.rr.com>
	<19196.63471.532066.743149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19196.63471.532066.743149@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Fri, 13 Nov 2009 17:08:47 +1100)

> Where do those "'"s come from???

I also have those "'" on one (out of 3) md's. Maybe it's debian
specific? Or only debian etch specific? Or only debian /dev/md0
specific.... It's only on /dev/md0, like this:

backup:~# mdadm -D /dev/md0
/dev/md0:
        Version : 01.00.03
  Creation Time : Wed Oct 31 09:13:41 2007
     Raid Level : raid1
     Array Size : 979924 (957.12 MiB 1003.44 MB)
    Device Size : 979924 (957.12 MiB 1003.44 MB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Nov 13 10:04:02 2009
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

           Name : 'backup':0
           UUID : 75b0f878:79539d6c:eef22092:f47a6e6f
         Events : 482808

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       5      22        1        1      active sync   /dev/hdc1
       2       3        1        2      active sync   /dev/hda1
       4       8       33        3      active sync   /dev/sdc1
       6       8       17        4      active sync   /dev/sdb1


> 
> What exactly is listed in mdadm.conf for /dev/md0??

nothing.

backup:~# cat /etc/mdadm/mdadm.conf 
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks.
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays

# This file was auto-generated on Tue, 23 Oct 2007 22:18:08 +0200
# by mkconf $Id: mkconf 261 2006-11-09 13:32:35Z madduck $



-- 
Janek Kozicki                                                         |
