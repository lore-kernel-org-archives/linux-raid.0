From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: 2.6.39: raid1 check blocks jbd on other md more than 120 seconds
Date: Thu, 2 Jun 2011 11:36:44 +0200
Message-ID: <20110602093644.GA8620@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The system runs FC14 with an (almost) stock 2.6.39 kernel, configured to
panic if it seems to hang. That's exactly what started to happen without
anything being logged in the normal way except over netconsole.

/proc/mdstat:
Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] 
md3 : active raid1 sda3[0] sdb3[1]
      1885338488 blocks super 1.2 [2/2] [UU]
      
md1 : active raid1 sda1[0] sdb1[1]
      33555384 blocks super 1.2 [2/2] [UU]

kernel messages:
	(/etc/cron.weekly/99-raid-check kicks in)
Jun  2 04:04:00 janus md: data-check of RAID array md3
Jun  2 04:04:00 janus md: delaying data-check of md1 until md3 has finished (they share one or more physical units)
Jun  2 04:04:00 janus md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jun  2 04:04:00 janus md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Jun  2 04:04:00 janus md: using 128k window, over a total of 1885338488 blocks.
Jun  2 04:55:54 janus INFO: task jbd2/md1-8:1188 blocked for more than 120 seconds.
Jun  2 04:55:54 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun  2 04:55:54 janus jbd2/md1-8     D
Jun  2 04:55:54  f5739e68
Jun  2 04:55:54 janus    0  1188      2 0x00000000
Jun  2 04:55:54  f5739e78
Jun  2 04:55:54  00000046
Jun  2 04:55:54  00000002
Jun  2 04:55:54  f5739e68
Jun  2 04:55:54  00000000
Jun  2 04:55:54  01000000
Jun  2 04:55:54  f5739e08
Jun  2 04:55:54  f6124f00
Jun  2 04:55:54 janus
Jun  2 04:55:54  c1999c00
Jun  2 04:55:54  00000001
Jun  2 04:55:54  c1999680
Jun  2 04:55:54  c1999680
Jun  2 04:55:54  00000003
Jun  2 04:55:54  f6126940
Jun  2 04:55:54  f6126ac0
Jun  2 04:55:54  f6786680
Jun  2 04:55:54 janus
Jun  2 04:55:54  000045d1
Jun  2 04:55:54  00000000
Jun  2 04:55:54  00000000
Jun  2 04:55:54  57087b88
Jun  2 04:55:54  000045d1
Jun  2 04:55:54  000045d1
Jun  2 04:55:54  f6686c00
Jun  2 04:55:54  f6686c10
Jun  2 04:55:54 janus
Jun  2 04:55:54 Call Trace:
Jun  2 04:55:54  [<c103822b>] ? get_parent_ip+0xb/0x40
Jun  2 04:55:54  [<c11698a2>] jbd2_journal_commit_transaction+0x182/0x1500
Jun  2 04:55:54  [<c100249f>] ? __switch_to+0xcf/0x1c0
Jun  2 04:55:54  [<c103822b>] ? get_parent_ip+0xb/0x40
Jun  2 04:55:54  [<c162f05c>] ? schedule+0x2ac/0x730
Jun  2 04:55:54  [<c1056c90>] ? wake_up_bit+0x80/0x80
	(reboots)

-- 
Frank
