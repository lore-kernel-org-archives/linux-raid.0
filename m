From: Sasha Levin <sasha.levin@oracle.com>
Subject: md: NULL ptr deref on xfstests generic/040
Date: Thu, 09 Apr 2015 15:37:32 -0400
Message-ID: <5526D4FC.1050206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I'm seeing the following warnings and NULL ptr deref when running xfstest generic/040
on the latest -next kernel.

[ 7023.673973] run fstests generic/040 at 2015-04-09 10:31:57
[ 7025.777329] kobject: 'sdd' (ffff8837b7c5e0a8): kobject_uevent_env
[ 7025.777344] kobject: 'sdd' (ffff8837b7c5e0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:03.2/0000:50:00.0/host0/target0:2:3/0:2:3:0/block/sdd'
[ 7025.969112] kobject: '251:0' (ffff881ff2554810): kobject_add_internal: parent: 'bdi', set: 'devices'
[ 7025.969161] ------------[ cut here ]------------
[ 7025.969181] WARNING: CPU: 7 PID: 30467 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x86/0xa0()
[ 7025.969187] sysfs: cannot create duplicate filename '/devices/virtual/bdi/251:0'
[ 7025.969192] Modules linked in: dm_flakey intel_rapl ast iosf_mbi x86_pkg_temp_thermal ttm intel_powerclamp coretemp drm_kms_helper kvm_intel kvm drm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryptd joydev i2c_algo_bit syscopyarea sysfillrect sysimgblt ipmi_si sb_edac ipmi_msghandler edac_core ioatdma shpchp lpc_ich mac_hid btrfs xor mlx4_en vxlan raid6_pq hid_generic usbhid hid ixgbe mlx4_core ahci dca ptp libahci megaraid_sas pps_core mdio
[ 7025.969328] CPU: 7 PID: 30467 Comm: dmsetup Not tainted 4.0.0-rc7-next-20150408+ #6
[ 7025.969335] Hardware name: Oracle Corporation OVCA X3-2             /ASSY,MOTHERBOARD,1U   , BIOS 17021300 06/19/2012
[ 7025.969342]  ffffffff82b37a40 ffff881fda8073f8 ffffffff82947148 0000000000000000
[ 7025.969354]  ffff881fda807478 ffff881fda807448 ffffffff8115a04a 0000000000000001
[ 7025.969365]  ffffffff81770d56 ffff881fda807498 ffffed03fb500e8b ffff881ff2533a30
[ 7025.969376] Call Trace:
[ 7025.969389] dump_stack (lib/dump_stack.c:52)
[ 7025.969400] warn_slowpath_common (kernel/panic.c:447)
[ 7025.969410] ? sysfs_warn_dup (fs/sysfs/dir.c:33)
[ 7025.969418] warn_slowpath_fmt (kernel/panic.c:453)
[ 7025.969427] ? warn_slowpath_common (kernel/panic.c:453)
[ 7025.969439] ? trace_hardirqs_on (kernel/locking/lockdep.c:2630)
[ 7025.969448] sysfs_warn_dup (fs/sysfs/dir.c:33)
[ 7025.969458] sysfs_create_dir_ns (fs/sysfs/dir.c:59)
[ 7025.969471] kobject_add_internal (lib/kobject.c:72 lib/kobject.c:229)
[ 7025.969481] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.969493] ? __mutex_unlock_slowpath (./arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:755 kernel/locking/mutex.c:766)
[ 7025.969502] kobject_add (lib/kobject.c:384)
[ 7025.969509] ? kobject_add_internal (lib/kobject.c:384)
[ 7025.969518] ? mutex_unlock (kernel/locking/mutex.c:444)
[ 7025.969532] device_add (drivers/base/core.c:1025)
[ 7025.969541] ? device_private_init (drivers/base/core.c:977)
[ 7025.969554] ? kfree (include/trace/events/kmem.h:136 mm/slub.c:3422)
[ 7025.969564] device_create_groups_vargs (drivers/base/core.c:1618)
[ 7025.969572] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:3091)
[ 7025.969581] device_create_vargs (drivers/base/core.c:1660)
[ 7025.969592] bdi_register (mm/backing-dev.c:347)
[ 7025.969600] ? wait_iff_congested (mm/backing-dev.c:337)
[ 7025.969609] ? vsnprintf (lib/vsprintf.c:2008)
[ 7025.969617] bdi_register_dev (mm/backing-dev.c:367)
[ 7025.969629] add_disk (block/genhd.c:616)
[ 7025.969636] ? pointer.isra.23 (lib/vsprintf.c:1878)
[ 7025.969644] ? lockdep_init_map_type (kernel/locking/lockdep.c:3009)
[ 7025.969651] ? trace_hardirqs_on (kernel/locking/lockdep.c:2630)
[ 7025.969660] ? blk_alloc_devt (block/genhd.c:583)
[ 7025.969667] ? sprintf (lib/vsprintf.c:2138)
[ 7025.969673] ? scnprintf (lib/vsprintf.c:2138)
[ 7025.969682] ? lockdep_init_map (kernel/locking/lockdep.c:3041)
[ 7025.969692] dm_create (drivers/md/dm.c:2318 drivers/md/dm.c:2598)
[ 7025.969701] dev_create (drivers/md/dm-ioctl.c:747)
[ 7025.969709] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.969716] ctl_ioctl (drivers/md/dm-ioctl.c:1848)
[ 7025.969726] ? semctl_main (ipc/sem.c:1330)
[ 7025.969734] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.969741] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.969751] ? free_params (drivers/md/dm-ioctl.c:1793)
[ 7025.969760] ? SYSC_semtimedop (ipc/sem.c:2010)
[ 7025.969771] dm_ctl_ioctl (drivers/md/dm-ioctl.c:1866)
[ 7025.969783] do_vfs_ioctl (fs/ioctl.c:44 fs/ioctl.c:607)
[ 7025.969792] ? ioctl_preallocate (fs/ioctl.c:557)
[ 7025.969803] ? mntput (fs/namespace.c:1106)
[ 7025.969812] ? SyS_semctl (ipc/sem.c:1601 ipc/sem.c:1577)
[ 7025.969820] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.969828] ? __fget_light (fs/file.c:684)
[ 7025.969836] SyS_ioctl (fs/ioctl.c:622 fs/ioctl.c:613)
[ 7025.969845] system_call_fastpath (arch/x86/kernel/entry_64.S:261)
[ 7025.969853] ---[ end trace 734c93b316c19e43 ]---
[ 7025.969862] ------------[ cut here ]------------
[ 7025.969873] WARNING: CPU: 7 PID: 30467 at lib/kobject.c:240 kobject_add_internal+0x6ff/0x920()
[ 7025.969879] kobject_add_internal failed for 251:0 with -EEXIST, don't try to register things with the same name in the same directory.
[ 7025.969883] Modules linked in: dm_flakey intel_rapl ast iosf_mbi x86_pkg_temp_thermal ttm intel_powerclamp coretemp drm_kms_helper kvm_intel kvm drm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryptd joydev i2c_algo_bit syscopyarea sysfillrect sysimgblt ipmi_si sb_edac ipmi_msghandler edac_core ioatdma shpchp lpc_ich mac_hid btrfs xor mlx4_en vxlan raid6_pq hid_generic usbhid hid ixgbe mlx4_core ahci dca ptp libahci megaraid_sas pps_core mdio
[ 7025.969997] CPU: 7 PID: 30467 Comm: dmsetup Tainted: G        W       4.0.0-rc7-next-20150408+ #6
[ 7025.970003] Hardware name: Oracle Corporation OVCA X3-2             /ASSY,MOTHERBOARD,1U   , BIOS 17021300 06/19/2012
[ 7025.970008]  ffffffff82bc7b60 ffff881fda807458 ffffffff82947148 0000000000000000
[ 7025.970019]  ffff881fda8074d8 ffff881fda8074a8 ffffffff8115a04a 0000000000000001
[ 7025.970029]  ffffffff81bdf32f ffff881fda8074f8 ffffed03fb500e97 00000000ffffffef
[ 7025.970040] Call Trace:
[ 7025.970048] dump_stack (lib/dump_stack.c:52)
[ 7025.970056] warn_slowpath_common (kernel/panic.c:447)
[ 7025.970064] ? kobject_add_internal (lib/kobject.c:237 (discriminator 1))
[ 7025.970072] warn_slowpath_fmt (kernel/panic.c:453)
[ 7025.970080] ? warn_slowpath_common (kernel/panic.c:453)
[ 7025.970089] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:77 include/linux/spinlock_api_smp.h:154 kernel/locking/spinlock.c:183)
[ 7025.970097] kobject_add_internal (lib/kobject.c:237 (discriminator 1))
[ 7025.970105] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.970113] ? __mutex_unlock_slowpath (./arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:755 kernel/locking/mutex.c:766)
[ 7025.970121] kobject_add (lib/kobject.c:384)
[ 7025.970129] ? kobject_add_internal (lib/kobject.c:384)
[ 7025.970137] ? mutex_unlock (kernel/locking/mutex.c:444)
[ 7025.970146] device_add (drivers/base/core.c:1025)
[ 7025.970155] ? device_private_init (drivers/base/core.c:977)
[ 7025.970164] ? kfree (include/trace/events/kmem.h:136 mm/slub.c:3422)
[ 7025.970173] device_create_groups_vargs (drivers/base/core.c:1618)
[ 7025.970181] ? debug_check_no_locks_freed (kernel/locking/lockdep.c:3091)
[ 7025.970190] device_create_vargs (drivers/base/core.c:1660)
[ 7025.970197] bdi_register (mm/backing-dev.c:347)
[ 7025.970205] ? wait_iff_congested (mm/backing-dev.c:337)
[ 7025.970213] ? vsnprintf (lib/vsprintf.c:2008)
[ 7025.970221] bdi_register_dev (mm/backing-dev.c:367)
[ 7025.970229] add_disk (block/genhd.c:616)
[ 7025.970235] ? pointer.isra.23 (lib/vsprintf.c:1878)
[ 7025.970243] ? lockdep_init_map_type (kernel/locking/lockdep.c:3009)
[ 7025.970250] ? trace_hardirqs_on (kernel/locking/lockdep.c:2630)
[ 7025.970259] ? blk_alloc_devt (block/genhd.c:583)
[ 7025.970265] ? sprintf (lib/vsprintf.c:2138)
[ 7025.970271] ? scnprintf (lib/vsprintf.c:2138)
[ 7025.970280] ? lockdep_init_map (kernel/locking/lockdep.c:3041)
[ 7025.970287] dm_create (drivers/md/dm.c:2318 drivers/md/dm.c:2598)
[ 7025.970295] dev_create (drivers/md/dm-ioctl.c:747)
[ 7025.970303] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.970310] ctl_ioctl (drivers/md/dm-ioctl.c:1848)
[ 7025.970318] ? semctl_main (ipc/sem.c:1330)
[ 7025.970326] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.970333] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.970341] ? free_params (drivers/md/dm-ioctl.c:1793)
[ 7025.970350] ? SYSC_semtimedop (ipc/sem.c:2010)
[ 7025.970361] dm_ctl_ioctl (drivers/md/dm-ioctl.c:1866)
[ 7025.970369] do_vfs_ioctl (fs/ioctl.c:44 fs/ioctl.c:607)
[ 7025.970377] ? ioctl_preallocate (fs/ioctl.c:557)
[ 7025.970385] ? mntput (fs/namespace.c:1106)
[ 7025.970393] ? SyS_semctl (ipc/sem.c:1601 ipc/sem.c:1577)
[ 7025.970402] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.970409] ? __fget_light (fs/file.c:684)
[ 7025.970417] SyS_ioctl (fs/ioctl.c:622 fs/ioctl.c:613)
[ 7025.970426] system_call_fastpath (arch/x86/kernel/entry_64.S:261)
[ 7025.970433] ---[ end trace 734c93b316c19e44 ]---
[ 7025.970445] kobject: '251:0' (ffff881ff2554810): kobject_release, parent           (null) (delayed 100)
[ 7025.970484] kobject: 'dm-0' (ffff881ff25578a8): kobject_add_internal: parent: 'block', set: 'devices'
[ 7025.970968] kobject: 'dm-0' (ffff881ff25578a8): kobject_uevent_env
[ 7025.970976] kobject: 'dm-0' (ffff881ff25578a8): kobject_uevent_env: uevent_suppress caused the event to drop!
[ 7025.971006] kobject: 'holders' (ffff881fea16ae00): kobject_add_internal: parent: 'dm-0', set: '<NULL>'
[ 7025.971022] kobject: 'slaves' (ffff881fea16ac00): kobject_add_internal: parent: 'dm-0', set: '<NULL>'
[ 7025.971034] kobject: 'dm-0' (ffff881ff25578a8): kobject_uevent_env
[ 7025.971044] kobject: 'dm-0' (ffff881ff25578a8): fill_kobj_path: path = '/devices/virtual/block/dm-0'
[ 7025.971141] kobject: 'queue' (ffff881fe5f007a8): kobject_add_internal: parent: 'dm-0', set: '<NULL>'
[ 7025.971286] kobject: 'queue' (ffff881fe5f007a8): kobject_uevent_env
[ 7025.971291] kobject: 'queue' (ffff881fe5f007a8): kobject_uevent_env: filter function caused the event to drop!
[ 7025.971307] CONFIG_KASAN_INLINE enabled
[ 7025.971382] GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
[ 7025.971571] Modules linked in: dm_flakey intel_rapl ast iosf_mbi x86_pkg_temp_thermal ttm intel_powerclamp coretemp drm_kms_helper kvm_intel kvm drm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryptd joydev i2c_algo_bit syscopyarea sysfillrect sysimgblt ipmi_si sb_edac ipmi_msghandler edac_core ioatdma shpchp lpc_ich mac_hid btrfs xor mlx4_en vxlan raid6_pq hid_generic usbhid hid ixgbe mlx4_core ahci dca ptp libahci megaraid_sas pps_core mdio
[ 7025.972551] CPU: 23 PID: 30467 Comm: dmsetup Tainted: G        W       4.0.0-rc7-next-20150408+ #6
[ 7025.972770] Hardware name: Oracle Corporation OVCA X3-2             /ASSY,MOTHERBOARD,1U   , BIOS 17021300 06/19/2012
[ 7025.973033] task: ffff881ff0878000 ti: ffff881fda800000 task.ti: ffff881fda800000
[ 7025.973213] RIP: sysfs_do_create_link_sd.isra.2 (fs/sysfs/symlink.c:35)
[ 7025.973475] RSP: 0018:ffff881fda807878  EFLAGS: 00010202
[ 7025.973615] RAX: dffffc0000000000 RBX: 0000000000000040 RCX: 000000001a561a54
[ 7025.973802] RDX: 0000000000000008 RSI: 00000000000000db RDI: ffffffff833dd704
[ 7025.973982] RBP: ffff881fda8078a8 R08: 0000000000000000 R09: 0000000000000000
[ 7025.974163] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
[ 7025.974348] R13: ffffffff82bbc720 R14: ffff881fe5ffd400 R15: ffff881fe5f00000
[ 7025.974532] FS:  00007fc654bcc840(0000) GS:ffff881fffdc0000(0000) knlGS:0000000000000000
[ 7025.974745] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7025.974874] CR2: 00007fed40c85798 CR3: 0000001fe0ab5000 CR4: 00000000000407e0
[ 7025.974972] Stack:
[ 7025.975003]  ffff881fda807888 ffff881ff25578a8 0000000000000001 ffff881ff2557800
[ 7025.975119]  ffff881fda8079e8 ffff881fe5f00000 ffff881fda8078d8 ffffffff81771658
[ 7025.975234]  ffff881fda8078d8 ffffffff81b25cb6 ffff881fda8079e8 ffff881fda8079a8
[ 7025.975349] Call Trace:
[ 7025.975393] sysfs_create_link (fs/sysfs/symlink.c:93)
[ 7025.975474] ? blk_get_queue (block/blk-core.c:794)
[ 7025.975552] add_disk (block/genhd.c:629 (discriminator 8))
[ 7025.975625] ? lockdep_init_map_type (kernel/locking/lockdep.c:3009)
[ 7025.975715] ? trace_hardirqs_on (kernel/locking/lockdep.c:2630)
[ 7025.975798] ? blk_alloc_devt (block/genhd.c:583)
[ 7025.975879] ? sprintf (lib/vsprintf.c:2138)
[ 7025.975949] ? scnprintf (lib/vsprintf.c:2138)
[ 7025.976023] ? lockdep_init_map (kernel/locking/lockdep.c:3041)
[ 7025.976103] dm_create (drivers/md/dm.c:2318 drivers/md/dm.c:2598)
[ 7025.976177] dev_create (drivers/md/dm-ioctl.c:747)
[ 7025.976252] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.976341] ctl_ioctl (drivers/md/dm-ioctl.c:1848)
[ 7025.976414] ? semctl_main (ipc/sem.c:1330)
[ 7025.976492] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.976583] ? list_version_get_info (drivers/md/dm-ioctl.c:735)
[ 7025.976672] ? free_params (drivers/md/dm-ioctl.c:1793)
[ 7025.976749] ? SYSC_semtimedop (ipc/sem.c:2010)
[ 7025.980019] dm_ctl_ioctl (drivers/md/dm-ioctl.c:1866)
[ 7025.983301] do_vfs_ioctl (fs/ioctl.c:44 fs/ioctl.c:607)
[ 7025.986587] ? ioctl_preallocate (fs/ioctl.c:557)
[ 7025.989788] ? mntput (fs/namespace.c:1106)
[ 7025.992915] ? SyS_semctl (ipc/sem.c:1601 ipc/sem.c:1577)
[ 7025.995989] ? debug_lockdep_rcu_enabled (kernel/rcu/update.c:195)
[ 7025.998981] ? __fget_light (fs/file.c:684)
[ 7026.001895] SyS_ioctl (fs/ioctl.c:622 fs/ioctl.c:613)
[ 7026.004724] system_call_fastpath (arch/x86/kernel/entry_64.S:261)
[ 7026.007455] Code: d7 3d 83 41 55 49 89 d5 41 54 41 89 cc 53 48 89 f3 48 83 ec 08 e8 10 b6 1e 01 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 9a 00 00 00 48 8b 1b 48 85 db 74 4d 48 89 df
All code
========
   0:	d7                   	xlat   %ds:(%rbx)
   1:	3d 83 41 55 49       	cmp    $0x49554183,%eax
   6:	89 d5                	mov    %edx,%ebp
   8:	41 54                	push   %r12
   a:	41 89 cc             	mov    %ecx,%r12d
   d:	53                   	push   %rbx
   e:	48 89 f3             	mov    %rsi,%rbx
  11:	48 83 ec 08          	sub    $0x8,%rsp
  15:	e8 10 b6 1e 01       	callq  0x11eb62a
  1a:	48 89 da             	mov    %rbx,%rdx
  1d:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  24:	fc ff df
  27:	48 c1 ea 03          	shr    $0x3,%rdx
  2b:*	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)		<-- trapping instruction
  2f:	0f 85 9a 00 00 00    	jne    0xcf
  35:	48 8b 1b             	mov    (%rbx),%rbx
  38:	48 85 db             	test   %rbx,%rbx
  3b:	74 4d                	je     0x8a
  3d:	48 89 df             	mov    %rbx,%rdi

Code starting with the faulting instruction
===========================================
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 9a 00 00 00    	jne    0xa4
   a:	48 8b 1b             	mov    (%rbx),%rbx
   d:	48 85 db             	test   %rbx,%rbx
  10:	74 4d                	je     0x5f
  12:	48 89 df             	mov    %rbx,%rdi
[ 7026.013551] RIP sysfs_do_create_link_sd.isra.2 (fs/sysfs/symlink.c:35)
[ 7026.016243]  RSP <ffff881fda807878>
[ 7026.142471] kobject: 'holders' (ffff881ff0e9fe00): kobject_cleanup, parent ffff8837b82ee0a8
[ 7026.144127] kobject: 'holders' (ffff881ff0e9fe00): auto cleanup kobject_del
[ 7026.498540] ---[ end trace 734c93b316c19e45 ]---


Thanks,
Sasha
