From: Richard Scobie <richard@sauce.co.nz>
Subject: INFO messages during resync
Date: Sun, 22 Jun 2008 08:38:05 +1200
Message-ID: <485D66AD.5030302@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Have just updated a Fedora 9 system from 2.6.25.4-30.fc9.x86_64 to 
2.6.25.6-55.fc9.x86_64, which broke smartd support on the SAS controller 
and while doing a resync of an md RAID6 disrupted by this, the log now 
fills with these messages for the duration of the resync:

INFO: task pdflush:260 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pdflush       D ffff81023d493af0     0   260      2
  ffff81023d493ae0 0000000000000046 0000000000000000 ffffffff81134771
  ffff81023d493a60 ffffffff814b4e00 ffffffff814b4e00 0000000000000009
  0000000000000000 ffff81023dc04000 ffff81023f10e000 ffff81023dc04328
Call Trace:
  [<ffffffff81134771>] ? list_add+0xc/0xf
  [<ffffffff811e4507>] md_write_start+0x105/0x11d
  [<ffffffff81046b0b>] ? autoremove_wake_function+0x0/0x38
  [<ffffffff880732eb>] :raid456:make_request+0x61/0x5e6
  [<ffffffff8107795b>] ? find_get_pages_tag+0x3d/0x96
  [<ffffffff8107fb6e>] ? pagevec_lookup_tag+0x22/0x2b
  [<ffffffff8111d29a>] generic_make_request+0x37e/0x3b9
  [<ffffffff8107a00b>] ? mempool_alloc+0x5b/0x113
  [<ffffffff8111d3b5>] submit_bio+0xe0/0xe9
  [<ffffffff8827e32f>] :xfs:_xfs_buf_ioapply+0x203/0x231
  [<ffffffff8827ee6b>] :xfs:xfs_buf_iorequest+0x41/0x6f
  [<ffffffff882828c1>] :xfs:xfs_bdstrat_cb+0x19/0x3b
  [<ffffffff8827b6b0>] :xfs:xfs_bwrite+0x5f/0xc0
  [<ffffffff882758a6>] :xfs:xfs_syncsub+0x129/0x24a
  [<ffffffff88275a09>] :xfs:xfs_sync+0x42/0x47
  [<ffffffff88283e24>] :xfs:xfs_fs_write_super+0x23/0x2c
  [<ffffffff810a562d>] sync_supers+0x61/0xa6
  [<ffffffff8107e982>] wb_kupdate+0x35/0x119
  [<ffffffff8107f344>] pdflush+0x133/0x1db
  [<ffffffff8107e94d>] ? wb_kupdate+0x0/0x119
  [<ffffffff8107f211>] ? pdflush+0x0/0x1db
  [<ffffffff810467eb>] kthread+0x49/0x76
  [<ffffffff8100ccf8>] child_rip+0xa/0x12
  [<ffffffff810467a2>] ? kthread+0x0/0x76
  [<ffffffff8100ccee>] ? child_rip+0x0/0x12

INFO: task xfssyncd:30716 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfssyncd      D ffff8101b5cd4008     0 30716      2
  ffff8101c858dcb0 0000000000000046 0000000000000000 ffff81023d8ce6d8
  ffff8101c858dc10 ffffffff814b4e00 ffffffff814b4e00 ffff81023d8ce6d8
  ffff8101c858dc30 ffff8101b515c000 ffffffff813b9610 ffff8101b515c328
Call Trace:
  [<ffffffff8128ebf0>] __down+0xc5/0xd9
  [<ffffffff8102b55f>] ? default_wake_function+0x0/0xf
  [<ffffffff8128e8b3>] __down_failed+0x35/0x3a
  [<ffffffff8827e068>] ? :xfs:xfs_buf_lock+0x5b/0x60
  [<ffffffff8826eba2>] :xfs:xfs_getsb+0x2d/0x3d
  [<ffffffff88274207>] :xfs:xfs_trans_getsb+0x4c/0x8b
  [<ffffffff8826fb86>] :xfs:xfs_mod_sb+0x24/0x76
  [<ffffffff8826fc7d>] :xfs:xfs_log_sbcount+0xa5/0xce
  [<ffffffff882758c7>] :xfs:xfs_syncsub+0x14a/0x24a
  [<ffffffff88275a09>] :xfs:xfs_sync+0x42/0x47
  [<ffffffff88284d84>] :xfs:xfs_sync_worker+0x1f/0x41
  [<ffffffff88284d27>] :xfs:xfssyncd+0x144/0x182
  [<ffffffff88284be3>] ? :xfs:xfssyncd+0x0/0x182
  [<ffffffff810467eb>] kthread+0x49/0x76
  [<ffffffff8100ccf8>] child_rip+0xa/0x12
  [<ffffffff810467a2>] ? kthread+0x0/0x76
  [<ffffffff8100ccee>] ? child_rip+0x0/0x12

These messages did not occur on the previous kernel and I am wondering 
if these tasks were blocking silently before and have just become 
visible now?

If so, why as I would have expected them to have priority over the resync?

Regards,

Richard
