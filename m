From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: ext3 on a RAID1 going read only?
Date: Sat, 26 Dec 2009 10:35:59 +1100
Message-ID: <3B0B3DB1-76F2-4420-9879-89A0E39D6C0F@crc.id.au>
References: <A7F4432C-B748-4C21-B2D7-D303C6E74344@crc.id.au>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A7F4432C-B748-4C21-B2D7-D303C6E74344@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 26/12/2009, at 10:17 AM, Steven Haigh wrote:

> Hi guys,
> 
> Not 100% sure where to go with this one.... I've been having an issue with a particular server where after 30 days or so of uptime the / partition will go readonly after spitting the following to the console:
> 
> EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
> Aborting journal on device md2.
> Dec 25 18:17:27 wireless kernel: EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
> Dec 25 18:17:27 wireless kernel: Aborting journal on device md2.
> ext3_abort called.
> Dec 25 18:17:27 EXT3-fs error (device md2): ext3_journal_start_sb: wireless kernel:Detected aborted journal ext3_abort called.
> Remounting filesystem read-only
> Dec 25 18:17:27 wireless kernel: EXT3-fs error (device md2): ext3_journal_start_sb: Detected aborted journal
> Dec 25 18:17:27 wireless kernel: Remounting filesystem read-only
> EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
> Dec 25 18:17:36 wireless kernel: EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
> 
> I'm a bit confused here as from what I understand, if there are bad blocks on a disk the disk should be kicked from the array - however ext3 seems to figure out there's a bad block by itself and nominates /dev/md2 as the culprit...
> 
> Can anyone shine some light on what is going on here - as I'm not quite as cluey with this stuff as I probably should be ;)

I should also mention that this is using CentOS 5.4 with kernel 2.6.18-164.9.1.el5. A few more details:

# mdadm -Q --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Mon Feb 23 17:15:41 2009
     Raid Level : raid1
     Array Size : 300511808 (286.59 GiB 307.72 GB)
  Used Dev Size : 300511808 (286.59 GiB 307.72 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Dec 26 10:34:23 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : fed99e3d:d08fdcc9:b9593a45:2cc09736
         Events : 0.30586

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1      22        3        1      active sync   /dev/hdc3

# cat /proc/mdstat 
Personalities : [raid1] 
md0 : active raid1 hdc1[1] hda1[0]
      521984 blocks [2/2] [UU]
      
md1 : active raid1 hdc2[1] hda2[0]
      10482304 blocks [2/2] [UU]
      
md3 : active raid1 hdc4[1] hda4[0]
      1052160 blocks [2/2] [UU]
      
md2 : active raid1 hdc3[1] hda3[0]
      300511808 blocks [2/2] [UU]
      
unused devices: <none>

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897




