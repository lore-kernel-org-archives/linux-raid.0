From: =?utf-8?Q?=C3=89tienne?= Buira <etienne.buira@gmail.com>
Subject: Probable bug in md with rdev->new_data_offset
Date: Mon, 28 Mar 2016 12:31:24 +0200
Message-ID: <20160328103123.GC8633@rcKGHUlyQfVFW>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Please apologise if i hit the wrong list.

I searched a bit, but could not find bug report or commits that seemed
related, please apologise if i'm wrong here.

I was going to grow a raid6 array (that contained a spare), using this
command:
# mdadm --grow -n 7 /dev/mdx

But when doing so, i got a PAX message saying that a size overflow was
detected in super_1_sync on the decl new_offset. The array was then in
unusable state (presumably because some locks were held).

After printking the values for rdev->new_data_offset and
rdev->data_offset in the
if (rdev->new_data_offset != rdev->data_offset) { ...
block of super_1_sync, i found that new_data_offset (252928 in my case)
where smaller than data_offset (258048), thus, the substraction to
compute sb->new_data_offset yielded an insanely high value.

For all partitions this array is made of, mdadm -E /dev/sdxy reports a
data offset of 258048 sectors (the value of rdev->data_offset).

IMHO, it seems a good idea to put a BUG_ON or similar if
rdev->new_data_offset is smaller than rdev->data offset at this place,
but that would not address the real issue.

I could solve my problem by setting mdadm's backup-file= option.

Kernel version was Gentoo hardened v4.4.2.

Full PAX size overflow detection line:
size overflow detected in function super_1_sync drivers/md/md.c:1683
cicus.1522_314 min, count: 158, decl: new_offset; num: 0; context:
mdp_superblock_1

Call stack (without addresses):
dump_stack
report_size_overflow
super_1_sync
? sched_clock_cpu
md_update_sb
? account_entity_dequeue
? dequeue_task_fair
? mutex_lock
? bitmap_daemon_work
md_check_recovery
raid5d
? try_to_del_timer_sync
? del_timer_sync
md_thread
? wait_woken
? find_pers
kthread
? kthread_create_on_node
ret_from_fork
? kthread_create_on_node

I am not familiar with kernel coding, so i won't create a patch, but i'm
willing to give more information if needed to track this issue.

Regards.

