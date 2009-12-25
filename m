From: Steven Haigh <netwiz@crc.id.au>
Subject: ext3 on a RAID1 going read only?
Date: Sat, 26 Dec 2009 10:17:39 +1100
Message-ID: <A7F4432C-B748-4C21-B2D7-D303C6E74344@crc.id.au>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

Not 100% sure where to go with this one.... I've been having an issue with a particular server where after 30 days or so of uptime the / partition will go readonly after spitting the following to the console:

EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
Aborting journal on device md2.
Dec 25 18:17:27 wireless kernel: EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
Dec 25 18:17:27 wireless kernel: Aborting journal on device md2.
ext3_abort called.
Dec 25 18:17:27 EXT3-fs error (device md2): ext3_journal_start_sb: wireless kernel:Detected aborted journal ext3_abort called.
Remounting filesystem read-only
Dec 25 18:17:27 wireless kernel: EXT3-fs error (device md2): ext3_journal_start_sb: Detected aborted journal
Dec 25 18:17:27 wireless kernel: Remounting filesystem read-only
EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979
Dec 25 18:17:36 wireless kernel: EXT3-fs error (device md2): ext3_xattr_block_list: inode 4932068: bad block 9873979

I'm a bit confused here as from what I understand, if there are bad blocks on a disk the disk should be kicked from the array - however ext3 seems to figure out there's a bad block by itself and nominates /dev/md2 as the culprit...

Can anyone shine some light on what is going on here - as I'm not quite as cluey with this stuff as I probably should be ;)

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897




