From: "Alan Gibson" <alan.gibson@gmail.com>
Subject: large copy to mdadm array fails, marks readonly
Date: Tue, 5 Sep 2006 02:16:09 -0700
Message-ID: <a2f3b2d90609050216g324d77e1n29f3debfb42e4c58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello all, first message to this group.

Ive recently created a 3 disk raid5 using mdadm. file copy to this
array fails consistently after a few gigs. the array does not die
completely, but rather it is marked readonly.

I created the array on 3 disks of equal partition size with:
sudo mdadm /dev/md0 --create -l5 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1

then formatted with:
mkfs.ext3 /dev/md0

badblocks shows no error on any of the drives.

dyssident@newdeal:~$ cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sda1[0] sdb1[2] sdc1[1]
      234436352 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

dyssident@newdeal:~$ dmesg
[17180879.388000] EXT3 FS on md0, internal journal
[17180879.392000] EXT3-fs: mounted filesystem with ordered data mode.
[17181702.872000] EXT3-fs error (device md0): ext3_new_block:
Allocating block in system zone - block = 38993924
[17181702.872000] Aborting journal on device md0.
[17181702.952000] __journal_remove_journal_head: freeing b_committed_data
[17181702.956000] EXT3-fs error (device md0) in ext3_prepare_write:
Journal has aborted
[17181702.960000] ext3_abort called.
[17181702.960000] EXT3-fs error (device md0): ext3_journal_start_sb:
Detected aborted journal
[17181702.960000] Remounting filesystem read-only

im stumped, any ideas?

thanks much,
alan
