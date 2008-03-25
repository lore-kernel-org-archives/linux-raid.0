From: David Chinner <dgc@sgi.com>
Subject: Re: xfs+md(raid5) xfssyncd & kswapd & pdflush hung in d-state
Date: Tue, 25 Mar 2008 14:29:06 +1100
Message-ID: <20080325032906.GC108924158@sgi.com>
References: <20080319150508.GA3087@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080319150508.GA3087@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: David Flynn <davidf@rd.bbc.co.uk>
Cc: linux-kernel@vger.kernel.org, daivdf@rd.bbc.co.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Added linux-raid to cc - this is not an XFS problem

Cheers,

Dave.

On Wed, Mar 19, 2008 at 03:05:10PM +0000, David Flynn wrote:
> We are currently experiencing a problem with writing to xfs on a 20disk
> raid5 array.  It seems very similar to a post in 2007nov09:
> 
>   Re: 2.6.23.1: mdadm/raid5 hung/d-state
> 
> Using kernel 2.6.24.  Unlike the previous post the array was in a clean
> state so no resync was occuring.  We are able to read from the array,
> but any process that writes joins the list of blocked tasks
> 
> The machine is:
>   2 of dual core opteron 280
>   16GiB RAM
>   4 lots of 5 sata disks connected to sil3124 sata hba.
>   Running 2.6.24
> 
> There was a single rsync process accessing the array at the time
> (~40MB/sec).
> 
> Random other bits[1]:
> # cat /sys/block/md1/md/stripe_cache_active
> 256
> # cat /sys/block/md1/md/stripe_cache_size  
> 256
> 
> Example of sysrq-w:
> 
> pdflush       D ffffffff804297c0     0   245      2
>  ffff810274dd1920 0000000000000046 0000000000000000 ffffffff80305ba3
>  ffff810476524680 ffff81047748e000 ffff810276456800 ffff81047748e250
>  00000000ffffffff ffff8102758a0d30 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80293fc7>] new_slab+0x1e5/0x20c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802941b6>] __slab_alloc+0x1c8/0x3a9
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802babc1>] __bio_add_page+0x109/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f46>] :xfs:xfs_submit_ioend+0x88/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff802771e3>] __writepage+0xa/0x23
>  [<ffffffff8027767c>] write_cache_pages+0x176/0x2a5
>  [<ffffffff802771d9>] __writepage+0x0/0x23
>  [<ffffffff802777e7>] do_writepages+0x20/0x2d
>  [<ffffffff802b3ce1>] __writeback_single_inode+0x18d/0x2e0
>  [<ffffffff8026fb13>] delayacct_end+0x7d/0x88
>  [<ffffffff802b4175>] sync_sb_inodes+0x1b6/0x273
>  [<ffffffff802b4595>] writeback_inodes+0x69/0xbb
>  [<ffffffff8027801a>] wb_kupdate+0x9e/0x10d
>  [<ffffffff8027839e>] pdflush+0x0/0x204
>  [<ffffffff802784f8>] pdflush+0x15a/0x204
>  [<ffffffff80277f7c>] wb_kupdate+0x0/0x10d
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> I've attatched the rest of the output.
> Other than the blocked processes, the machine is idle.
> 
> After rebooting the machine, we increased stripe_cache_size to 512 and
> are currently seeing the same processes (now with md1_resync) periodically
> hang in the Dstate, best described as the almost the entire machine
> freezing for upto a minute then recovering.
> 
> I say almost as some processes seem unaffected, eg my existing ssh login
> to echo w > /proc/sysrq-trigger and a vmware virtual
> machine (root filesystem for host and guest is an nfsroot mounted from
> elsewhere).  Trying to login during these periods of tenseness fails
> though.
> 
> During these tense periods everything is idle with anything touching md1
> in the D state.
> 
> Any thoughts?
> 
> ..david

> SysRq : Show Blocked State
>   task                        PC stack   pid father
> pdflush       D ffff81047748e000     0   245      2
>  ffff810274dd1920 0000000000000046 ffff810274618680 ffffffff80305ba3
>  ffff810274618680 ffff81047748e000 ffff810477474000 ffff81047748e250
>  ffff810476159400 ffff8102758a0d30 0000000000000246 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80293fc7>] new_slab+0x1e5/0x20c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802941b6>] __slab_alloc+0x1c8/0x3a9
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802babc1>] __bio_add_page+0x109/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f46>] :xfs:xfs_submit_ioend+0x88/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff802771e3>] __writepage+0xa/0x23
>  [<ffffffff8027767c>] write_cache_pages+0x176/0x2a5
>  [<ffffffff802771d9>] __writepage+0x0/0x23
>  [<ffffffff802777e7>] do_writepages+0x20/0x2d
>  [<ffffffff802b3ce1>] __writeback_single_inode+0x18d/0x2e0
>  [<ffffffff8026fb13>] delayacct_end+0x7d/0x88
>  [<ffffffff802b4175>] sync_sb_inodes+0x1b6/0x273
>  [<ffffffff802b4595>] writeback_inodes+0x69/0xbb
>  [<ffffffff8027801a>] wb_kupdate+0x9e/0x10d
>  [<ffffffff8027839e>] pdflush+0x0/0x204
>  [<ffffffff802784f8>] pdflush+0x15a/0x204
>  [<ffffffff80277f7c>] wb_kupdate+0x0/0x10d
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> kswapd0       D ffffffff804297c0     0   247      2
>  ffff810274dd7880 0000000000000046 ffff810274618680 ffffffff80305ba3
>  ffff810274618680 ffff81047748e800 ffff81047748e000 ffff81047748ea50
>  ffff810476159400 ffff8102758a0d30 0000000000000246 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff80276a69>] __alloc_pages+0x66/0x309
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80293fc7>] new_slab+0x1e5/0x20c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802941b6>] __slab_alloc+0x1c8/0x3a9
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802bac0c>] __bio_add_page+0x154/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f65>] :xfs:xfs_submit_ioend+0xa7/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff8027a93a>] shrink_page_list+0x346/0x570
>  [<ffffffff8027ac81>] shrink_inactive_list+0x11d/0x381
>  [<ffffffff8027afca>] shrink_zone+0xe5/0x108
>  [<ffffffff8027b4c8>] kswapd+0x2fc/0x49b
>  [<ffffffff80414bf4>] thread_return+0x3d/0xab
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8027b1cc>] kswapd+0x0/0x49b
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> kswapd1       D 0000000000000001     0   248      2
>  ffff810274dd9880 0000000000000046 ffff810274dd9848 ffffffff80305ba3
>  ffff810274618680 ffff81047748f000 ffff810475dbb800 ffff81047748f250
>  00000000ffffffff ffff8102758a0d30 0000000000000400 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff88381a55>] :xfs:xfs_start_page_writeback+0x24/0x38
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802babc1>] __bio_add_page+0x109/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f65>] :xfs:xfs_submit_ioend+0xa7/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff8027a93a>] shrink_page_list+0x346/0x570
>  [<ffffffff8027ac81>] shrink_inactive_list+0x11d/0x381
>  [<ffffffff8027afca>] shrink_zone+0xe5/0x108
>  [<ffffffff8027b4c8>] kswapd+0x2fc/0x49b
>  [<ffffffff80414bf4>] thread_return+0x3d/0xab
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8027b1cc>] kswapd+0x0/0x49b
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> xfssyncd      D ffffffff804297c0     0  4132      2
>  ffff81047643db60 0000000000000046 0000000000000000 ffffffff80305ba3
>  ffff810274618680 ffff81047584d000 ffffffff804dc4a0 ffff81047584d250
>  00000000ffffffff ffff8102758a0d30 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022e6a5>] __wake_up+0x38/0x4f
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff8836d61e>] :xfs:xlog_write+0x3e0/0x459
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff8029265d>] get_partial_node+0x15/0x7e
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff8022da0e>] find_busiest_group+0x248/0x6ea
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff8838473f>] :xfs:_xfs_buf_ioapply+0x266/0x291
>  [<ffffffff883847a3>] :xfs:xfs_buf_iorequest+0x39/0x66
>  [<ffffffff8836be90>] :xfs:xlog_bdstrat_cb+0x16/0x3c
>  [<ffffffff8836ce5e>] :xfs:xlog_sync+0x238/0x3fb
>  [<ffffffff8836dac7>] :xfs:xlog_state_sync_all+0xa6/0x1c0
>  [<ffffffff8023e0ff>] try_to_del_timer_sync+0x51/0x5a
>  [<ffffffff8836e02a>] :xfs:_xfs_log_force+0x5c/0x6b
>  [<ffffffff8837ac0d>] :xfs:xfs_syncsub+0x35/0x241
>  [<ffffffff8838925c>] :xfs:xfs_sync_worker+0x17/0x36
>  [<ffffffff883894f1>] :xfs:xfssyncd+0x13b/0x18f
>  [<ffffffff883893b6>] :xfs:xfssyncd+0x0/0x18f
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> rsync         D ffff81047120a000     0  5096      1
>  ffff8104715874b8 0000000000000086 ffff810274618680 ffffffff80305ba3
>  ffff810274618680 ffff81047120a000 ffff81047584d000 ffff81047120a250
>  ffff810476159400 ffff8102758a0d30 0000000000000246 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022e6a5>] __wake_up+0x38/0x4f
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80293fc7>] new_slab+0x1e5/0x20c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802941b6>] __slab_alloc+0x1c8/0x3a9
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802bac0c>] __bio_add_page+0x154/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f65>] :xfs:xfs_submit_ioend+0xa7/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff8027a93a>] shrink_page_list+0x346/0x570
>  [<ffffffff8027ac81>] shrink_inactive_list+0x11d/0x381
>  [<ffffffff8027799a>] get_dirty_limits+0x1d/0x184
>  [<ffffffff8027afca>] shrink_zone+0xe5/0x108
>  [<ffffffff8027bd77>] try_to_free_pages+0x17b/0x288
>  [<ffffffff80276bcd>] __alloc_pages+0x1ca/0x309
>  [<ffffffff8027185f>] __grab_cache_page+0x33/0x6f
>  [<ffffffff802b8d6f>] block_write_begin+0x38/0xcd
>  [<ffffffff88381b35>] :xfs:xfs_vm_write_begin+0x22/0x27
>  [<ffffffff88382155>] :xfs:xfs_get_blocks+0x0/0xe
>  [<ffffffff80272484>] generic_file_buffered_write+0x153/0x670
>  [<ffffffff803a9348>] memcpy_toiovec+0x36/0x66
>  [<ffffffff88388b78>] :xfs:xfs_write+0x54d/0x789
>  [<ffffffff80299018>] do_sync_write+0xc9/0x10c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff80299807>] vfs_write+0xc6/0x16f
>  [<ffffffff80299dc2>] sys_write+0x45/0x6e
>  [<ffffffff8020be2e>] system_call+0x7e/0x83
> 
> bash          D ffffffff804297c0     0  6739   6647
>  ffff81037f4fd768 0000000000000086 0000000000000000 ffffffff80305ba3
>  ffff810274618680 ffff8102836ec800 ffff8102764b6800 ffff8102836eca50
>  00000000ffffffff ffff8102758a0d30 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022e6a5>] __wake_up+0x38/0x4f
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff88381a55>] :xfs:xfs_start_page_writeback+0x24/0x38
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802bac0c>] __bio_add_page+0x154/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f65>] :xfs:xfs_submit_ioend+0xa7/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff802749d0>] get_pageblock_flags_group+0x3e/0x7f
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff8027a93a>] shrink_page_list+0x346/0x570
>  [<ffffffff8027ac81>] shrink_inactive_list+0x11d/0x381
>  [<ffffffff8027799a>] get_dirty_limits+0x1d/0x184
>  [<ffffffff8027afca>] shrink_zone+0xe5/0x108
>  [<ffffffff8027bd77>] try_to_free_pages+0x17b/0x288
>  [<ffffffff80276bcd>] __alloc_pages+0x1ca/0x309
>  [<ffffffff882fde17>] :raid456:grow_one_stripe+0x70/0xd8
>  [<ffffffff882fdf08>] :raid456:raid5_store_stripe_cache_size+0x89/0xac
>  [<ffffffff80276a69>] __alloc_pages+0x66/0x309
>  [<ffffffff882df6a6>] :md_mod:md_attr_store+0x61/0x88
>  [<ffffffff802db3d4>] sysfs_write_file+0xd2/0x110
>  [<ffffffff80299807>] vfs_write+0xc6/0x16f
>  [<ffffffff80299dc2>] sys_write+0x45/0x6e
>  [<ffffffff8020be2e>] system_call+0x7e/0x83
> 
> vim           D ffff810477016800     0  7040   7013
>  ffff81001b11f748 0000000000000086 ffff810274618680 ffffffff80305ba3
>  ffff810274618680 ffff810477016800 ffff81047655e800 ffff810477016a50
>  ffff810476159400 ffff8102758a0d30 0000000000000246 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff80247fd9>] wake_up_bit+0x11/0x22
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802715e0>] find_lock_page+0x1f/0x7f
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff8838473f>] :xfs:_xfs_buf_ioapply+0x266/0x291
>  [<ffffffff883847a3>] :xfs:xfs_buf_iorequest+0x39/0x66
>  [<ffffffff8836be90>] :xfs:xlog_bdstrat_cb+0x16/0x3c
>  [<ffffffff8836ce5e>] :xfs:xlog_sync+0x238/0x3fb
>  [<ffffffff8836dac7>] :xfs:xlog_state_sync_all+0xa6/0x1c0
>  [<ffffffff8836e02a>] :xfs:_xfs_log_force+0x5c/0x6b
>  [<ffffffff88381546>] :xfs:kmem_zone_alloc+0x52/0x9f
>  [<ffffffff883633a0>] :xfs:xfs_iget_core+0x19d/0x63a
>  [<ffffffff802aaf9e>] alloc_inode+0x152/0x1c2
>  [<ffffffff883638d8>] :xfs:xfs_iget+0x9b/0x13f
>  [<ffffffff88378906>] :xfs:xfs_trans_iget+0xae/0x124
>  [<ffffffff88366d36>] :xfs:xfs_ialloc+0xa0/0x536
>  [<ffffffff883792d7>] :xfs:xfs_dir_ialloc+0x84/0x2d1
>  [<ffffffff88376ccc>] :xfs:xfs_trans_reserve+0xdd/0x1b0
>  [<ffffffff802a2618>] __link_path_walk+0xd2d/0xd4e
>  [<ffffffff8837e2e0>] :xfs:xfs_create+0x275/0x4d2
>  [<ffffffff88387b51>] :xfs:xfs_vn_mknod+0x148/0x242
>  [<ffffffff88387262>] :xfs:xfs_vn_permission+0x15/0x19
>  [<ffffffff802a14a6>] vfs_create+0xcf/0x140
>  [<ffffffff802a36b1>] open_namei+0x1a0/0x63c
>  [<ffffffff80297c7e>] do_filp_open+0x1c/0x38
>  [<ffffffff80297969>] get_unused_fd_flags+0x72/0x120
>  [<ffffffff80297ce0>] do_sys_open+0x46/0xc3
>  [<ffffffff8020be2e>] system_call+0x7e/0x83
> 
> rm            D ffffffff804297c0     0  7043   6820
>  ffff810465985bd8 0000000000000082 0000000000000000 ffffffff88178043
>  ffff810465985b68 ffff81047610a000 ffff8102764b6800 ffff81047610a250
>  00000000ffffffff ffffffff88159e20 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff88178043>] :nfs:nfs_do_access+0x2b/0x31b
>  [<ffffffff80415c22>] __down_read+0x82/0x9a
>  [<ffffffff8837bb8c>] :xfs:xfs_access+0x18/0x3f
>  [<ffffffff88387262>] :xfs:xfs_vn_permission+0x15/0x19
>  [<ffffffff8029fd91>] permission+0xb6/0x10b
>  [<ffffffff802a1a41>] __link_path_walk+0x156/0xd4e
>  [<ffffffff88183001>] :nfs:nfs_writepages_callback+0x0/0x21
>  [<ffffffff802a2691>] link_path_walk+0x58/0xe0
>  [<ffffffff80282a54>] __vma_link+0x42/0x4b
>  [<ffffffff802a2a01>] do_path_lookup+0x1a3/0x21b
>  [<ffffffff802a16ac>] getname+0x14c/0x1b3
>  [<ffffffff802a324e>] __user_walk_fd+0x37/0x4c
>  [<ffffffff8029c307>] vfs_lstat_fd+0x18/0x47
>  [<ffffffff80282a54>] __vma_link+0x42/0x4b
>  [<ffffffff8029c34f>] sys_newlstat+0x19/0x31
>  [<ffffffff802a4ad2>] vfs_ioctl+0x243/0x25c
>  [<ffffffff8031315f>] __up_write+0x21/0x10e
>  [<ffffffff804162e9>] error_exit+0x0/0x51
>  [<ffffffff8020be2e>] system_call+0x7e/0x83


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
