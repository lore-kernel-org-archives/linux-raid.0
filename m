From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: trouble adding spare
Date: Wed, 14 Jan 2009 11:43:00 +0200
Message-ID: <496DB3A4.4090605@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID5 array using 6 disks and 2 spares. I took one spare away 
for a few months for another purpose (OS X) and am having trouble adding 
it back in as a spare.

I can add it manually :

sudo /sbin/mdadm /dev/md2 -a /dev/sdi

but it doesn't want to add itself in after rebooting (the other spare is 
added ok).

I'm sure this is simple for someone...

Max.

/dev/md2:
        Version : 00.90
  Creation Time : Sat Aug  6 05:18:41 2005
     Raid Level : raid5
     Array Size : 976804480 (931.55 GiB 1000.25 GB)
  Used Dev Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Jan 14 11:27:11 2009
          State : clean
 Active Devices : 6
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 15bfec75:595ac793:0914f8ee:862effd8
         Events : 0.9341278

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       8       96        1      active sync   /dev/sdg
       2       8       16        2      active sync   /dev/sdb
       3       8       48        3      active sync   /dev/sdd
       4       8       32        4      active sync   /dev/sdc
       5       8       64        5      active sync   /dev/sde

       6       8      128        -      spare   /dev/sdi
       7       8      112        -      spare   /dev/sdh

..../etc/mdadm/mdadm.conf
DEVICE /dev/sd[bcdefghi]

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR davidmaxwaterman@fastmail.co.uk

# definitions of existing MD arrays
ARRAY /dev/md2 level=raid5 num-devices=6 
UUID=15bfec75:595ac793:0914f8ee:862effd8 spares=2

