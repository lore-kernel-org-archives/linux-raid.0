From: Vladimir Trebicky <trebicky@xhost.cz>
Subject: Ext3 inconsistencies again
Date: Sat, 20 Sep 2003 09:22:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <192290578.20030920092252@xhost.cz>
Reply-To: =?ISO-8859-2?B?VmxhZGlt7XIgVPhlYmlja/0=?= <trebicky@xhost.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

   I've got serious problems with my system partition /dev/md0 (RAID1).
   It has a journal. Recently I did a read-only e2fsck on it and got a
   huge bunch of errors. Till a next reboot everything seemed ok. During
   the next reboot, e2fsck tried to make a disk check but said that
   there are many errors and that I have to do it on my own. So I
   rebooted to single mode and did a e2fsck on it. It tried to repair
   many and many errors and the result was that the system partition
   was badly damaged. E2fsck did the check three times until there
   were no errors. So I rebooted back to normal and recovered the
   system from backups. When everything was done I rebooted back to
   single mode to do e2fsck one more time (read only). The same bunch
   of errors. So I rather did not the real test. I rebooted back with
   those errors and now I'm gathering information...

   Is it possible that the ext3 is somehow permanently damaged?
   Is it possible that the problem is the raid?

Some of the errors:

Illegal block #12 (2150986755) in inode 1884.  IGNORED.
...
Illegal block #23 (4213575656) in inode 1884.  IGNORED.
...
uplicate/bad block(s) in inode 2: 461
Duplicate/bad block(s) in inode 8: 486 489 499 500 512 517 524 525 550 568 579 5
Duplicate/bad block(s) in inode 53: 8960 8962 8964 9010 9057 9059
...
File ... (inode #120064, mod time Fri Sep 19 22:47:47 2003)
  has 1 duplicate block(s), shared with 1 file(s):
        /usr/local/httpd-2.0.44/build/config_vars.mk (inode #104369, mod time We
Clone duplicate/bad blocks? no
...
Entry 'home' in / (2) has deleted/unused inode 105367.  Clear? no
...
Entry '..' in ??? (2983) has deleted/unused inode 105367.  Clear? no
...
Directory inode 2897, block 0, offset 0: directory corrupted
...
Unconnected directory inode 1666 (???)
Connect to /lost+found? no
...
'..' in ... (2407) is ??? (2114), should be <The NULL inode> (0).
Fix? no
...
Inode 31691 ref count is 1, should be 2.  Fix? no
...
Block bitmap differences:  -10649 -11351 -11371 -11424 -(11427--11428) -12136 -1
Fix? no
...

etc etc etc

AND THIS is interesting. These are kernel messages during the test:

Illegal block number passed to ext2fs_test_block_bitmap #3894686857 for multiply claimed block map
Illegal block number passed to ext2fs_test_block_bitmap #4294634368 for multiply claimed block map
Illegal block number passed to ext2fs_test_block_bitmap #2223752585 for multiply claimed block map
Illegal block number passed to ext2fs_test_block_bitmap #75008768 for multiply claimed block map
Illegal block number passed to ext2fs_test_block_bitmap #3894688905 for multiply claimed block map
Illegal block number passed to ext2fs_test_block_bitmap #4294634348 for multiply claimed block map
...

I have also RAID1 on /dev/md1 (data disk) without any problems.

Thanks for ANY information.


-- 
Regards,
 Vladimir Trebicky                          mailto:trebicky@xhost.cz

