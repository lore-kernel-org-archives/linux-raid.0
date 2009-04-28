From: Dan Williams <dan.j.williams@intel.com>
Subject: array_state_store: 'inactive' versus 'clean' race
Date: Mon, 27 Apr 2009 18:24:03 -0700
Message-ID: <1240881843.30002.42.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I am debugging what appears to be a race between mdadm and mdmon
manipulating md/array_state. The following warnings were originally
triggered by the validation team in Poland.  I was not able to reproduce
it on my development system until I modified mdmon to hammer on
array_state and can now produce the same failure signature:

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x35/0x3d()
Hardware name:
sysfs: duplicate filename 'sync_action' can not be created
Modules linked in: raid10...
Supported: Yes
Pid: 8696, comm: mdmon Tainted: G           X 2.6.29-6-default #1
Call Trace:
 [<ffffffff8020ff31>] try_stack_unwind+0x70/0x127
 [<ffffffff8020f0c0>] dump_trace+0x9a/0x2a6
 [<ffffffff8020fc82>] show_trace_log_lvl+0x4c/0x58
 [<ffffffff8020fc9e>] show_trace+0x10/0x12
 [<ffffffff804f5777>] dump_stack+0x72/0x7b
 [<ffffffff80248353>] warn_slowpath+0xb1/0xed
 [<ffffffff8032ac84>] sysfs_add_one+0x35/0x3d
 [<ffffffff8032a6d1>] sysfs_add_file_mode+0x57/0x8b
 [<ffffffff8032c3d0>] internal_create_group+0xea/0x174
 [<ffffffff8032c47b>] sysfs_create_group+0xe/0x13
 [<ffffffff80448bc2>] do_md_run+0x54d/0x856
 [<ffffffff80449130>] array_state_store+0x265/0x291
 [<ffffffff80444ce6>] md_attr_store+0x81/0xa9
 [<ffffffff8032a133>] sysfs_write_file+0xdf/0x114
 [<ffffffff802d6b4e>] vfs_write+0xae/0x157
 [<ffffffff802d6d05>] sys_write+0x4c/0xa5
 [<ffffffff8020c4aa>] system_call_fastpath+0x16/0x1b
 [<00007f1251cd3950>] 0x7f1251cd3950
---[ end trace a00c6d28b22a64ae ]---
md: cannot register extra attributes for md126
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x35/0x3d()
Hardware name:
sysfs: duplicate filename 'rd3' can not be created
Modules linked in: raid10...
Supported: Yes
Pid: 8696, comm: mdmon Tainted: G        W  X 2.6.29-6-default #1
Call Trace:
 [<ffffffff8020ff31>] try_stack_unwind+0x70/0x127
 [<ffffffff8020f0c0>] dump_trace+0x9a/0x2a6
 [<ffffffff8020fc82>] show_trace_log_lvl+0x4c/0x58
 [<ffffffff8020fc9e>] show_trace+0x10/0x12
 [<ffffffff804f5777>] dump_stack+0x72/0x7b
 [<ffffffff80248353>] warn_slowpath+0xb1/0xed
 [<ffffffff8032ac84>] sysfs_add_one+0x35/0x3d
 [<ffffffff8032bb78>] sysfs_do_create_link+0xd3/0x141
 [<ffffffff8032bc01>] sysfs_create_link+0xe/0x11
 [<ffffffff80448ca7>] do_md_run+0x632/0x856
 [<ffffffff80449130>] array_state_store+0x265/0x291
 [<ffffffff80444ce6>] md_attr_store+0x81/0xa9

mdadm in another thread has just finished writing 'inactive' to
array_state which will have the effect of setting mddev->pers to NULL.
mdmon is still managing the array and before noticing the 'inactive'
state writes 'clean' as part of its normal operation.  The
array_state_store() call for mdmon notices that mddev->pers is not set
and calls do_md_run().

Is it the case that we only need array_state_store() to call do_md_run()
when performing initial assembly?  If so it seems a flag is needed to
prevent reactivation before the old sysfs context is destroyed.

Thanks,
Dan

