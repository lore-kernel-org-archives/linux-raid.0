From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Soft lockup with 2.6.17-rc1 on amd64
Date: Thu, 20 Apr 2006 04:41:34 +0200
Message-ID: <20060420024134.GA2798@samfundet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

(Please Cc me on any replies, I'm not on the list.)

Hi,

2.6.17-rc1 on amd64 (dual-core, with SMP enabled) gives me:

[   36.829054] md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
[   36.835091] md: bitmap version 4.39
[   36.839010] md: linear personality registered for level -1
[   36.847169] md: raid0 personality registered for level 0
[   36.855434] md: raid1 personality registered for level 1
[   36.863676] md: raid10 personality registered for level 10
[   36.871507] raid5: automatically using best checksumming function: generic_sse
[   36.898420]    generic_sse:  5938.000 MB/sec
[   36.902697] raid5: using function: generic_sse (5938.000 MB/sec)
[   36.909737] md: raid5 personality registered for level 5
[   36.915052] md: raid4 personality registered for level 4
[   36.990294] raid6: int64x1   1833 MB/s
[   37.058190] raid6: int64x2   2497 MB/s
[   37.126118] raid6: int64x4   2154 MB/s
[   37.194059] raid6: int64x8   1619 MB/s
[   37.261962] raid6: sse2x1    2359 MB/s
[   37.329866] raid6: sse2x2    3183 MB/s
[   37.397781] raid6: sse2x4    3405 MB/s
[   37.401564] raid6: using algorithm sse2x4 (3405 MB/s)
[   37.406668] md: raid6 personality registered for level 6
[   37.726168] md: bind<dm-0>
[   37.729096] md: bind<dm-1>
[   37.742155] md: bind<dm-2>
[   37.745266] md: bind<dm-3>
[   47.736121] BUG: soft lockup detected on CPU#1!
[   47.740655] 
[   47.740655] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   47.748483]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   47.758681]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   47.769352]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   47.778304]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   47.787981]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   47.797294]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   47.808192]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   47.817030]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   47.824421]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   47.833605]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   47.844313]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   47.854032]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   47.863675]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   47.871171]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   47.879082]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   47.887012]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   47.896239]        <ffffffff8021817e>{ia32_sysret+0}
[   57.727463] BUG: soft lockup detected on CPU#1!
[   57.732020] 
[   57.732020] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   57.739860]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   57.750049]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   57.760667]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   57.769647]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   57.779342]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   57.788688]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   57.799570]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   57.808355]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   57.815791]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   57.824940]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   57.835724]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   57.845367]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   57.855034]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   57.862530]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   57.870450]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   57.878397]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   57.887633]        <ffffffff8021817e>{ia32_sysret+0}
[   67.718805] BUG: soft lockup detected on CPU#1!
[   67.723353] 
[   67.723354] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   67.731193]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   67.741452]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   67.752089]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   67.761041]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   67.770711]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   67.780031]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   67.790930]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   67.799731]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   67.807151]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   67.816317]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   67.827007]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   67.836725]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   67.846378]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   67.853908]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   67.861871]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   67.869817]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   67.879080]        <ffffffff8021817e>{ia32_sysret+0}
[   77.710148] BUG: soft lockup detected on CPU#1!
[   77.714685] 
[   77.714686] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   77.722545]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   77.732778]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   77.743447]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   77.752409]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   77.762113]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   77.771425]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   77.782349]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   77.791127]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   77.798527]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   77.807676]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   77.818384]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   77.828059]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   77.837701]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   77.845190]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   77.853135]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   77.861083]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   77.870336]        <ffffffff8021817e>{ia32_sysret+0}
[   87.701492] BUG: soft lockup detected on CPU#1!
[   87.706010] 
[   87.706011] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   87.713853]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   87.724015]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   87.734626]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   87.743595]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   87.753291]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   87.762586]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   87.773502]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   87.782303]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   87.789723]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   87.798862]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   87.809579]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   87.819264]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   87.828959]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   87.836438]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   87.844373]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   87.852294]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   87.861548]        <ffffffff8021817e>{ia32_sysret+0}
[   97.696829] BUG: soft lockup detected on CPU#1!
[   97.701351] 
[   97.701352] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[   97.709160]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[   97.719321]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[   97.729977]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[   97.738962]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[   97.748614]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[   97.757979]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   97.768843]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[   97.777646]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[   97.785045]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[   97.794204]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[   97.804953]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[   97.814597]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[   97.824248]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[   97.831779]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[   97.839715]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[   97.847644]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[   97.856854]        <ffffffff8021817e>{ia32_sysret+0}
[  107.688172] BUG: soft lockup detected on CPU#1!
[  107.692746] 
[  107.692747] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[  107.700624]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[  107.710812]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[  107.721491]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[  107.730504]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[  107.740147]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[  107.749485]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[  107.760350]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[  107.769153]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[  107.776561]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[  107.785719]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[  107.796460]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[  107.806129]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[  107.815806]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[  107.823337]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[  107.831266]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[  107.839238]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[  107.848493]        <ffffffff8021817e>{ia32_sysret+0}
[  117.679515] BUG: soft lockup detected on CPU#1!
[  117.684064] 
[  117.684064] Call Trace: <IRQ> <ffffffff80247e68>{softlockup_tick+218}
[  117.691923]        <ffffffff8022f59f>{update_process_times+66} <ffffffff80212ffa>{smp_local_timer_interrupt+35}
[  117.702137]        <ffffffff80213614>{smp_apic_timer_interrupt+65} <ffffffff8020a106>{apic_timer_interrupt+98} <EOI>
[  117.712834]        <ffffffff8028ad41>{mpage_writepages+730} <ffffffff802495bd>{find_get_pages+91}
[  117.721821]        <ffffffff8024fd99>{pagevec_lookup+23} <ffffffff8025096d>{invalidate_mapping_pages+183}
[  117.731498]        <ffffffff80212c8d>{smp_call_function+48} <ffffffff880c44e3>{:md_mod:do_md_run+664}
[  117.740853]        <ffffffff880c5923>{:md_mod:md_ioctl+353} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[  117.751710]        <ffffffff880c68c0>{:md_mod:md_ioctl+4350} <ffffffff80280120>{__d_lookup+173}
[  117.760546]        <ffffffff80277555>{do_lookup+99} <ffffffff8027ef84>{dput+33}
[  117.767946]        <ffffffff802c8786>{blkdev_driver_ioctl+91} <ffffffff802c8e94>{blkdev_ioctl+1690}
[  117.777088]        <ffffffff880c4fad>{:md_mod:md_open+44} <ffffffff8039e667>{__mutex_lock_interruptible_slowpath+816}
[  117.787829]        <ffffffff8039ea47>{__mutex_lock_slowpath+751} <ffffffff80270944>{check_disk_change+29}
[  117.797506]        <ffffffff880c4fdb>{:md_mod:md_open+90} <ffffffff8039e2e6>{__mutex_unlock_slowpath+403}
[  117.807253]        <ffffffff8027170f>{do_open+653} <ffffffff80270cfd>{bdget+274}
[  117.814740]        <ffffffff802709f8>{block_ioctl+25} <ffffffff8027ae59>{do_ioctl+33}
[  117.822668]        <ffffffff8027b0f8>{vfs_ioctl+597} <ffffffff8027b16a>{sys_ioctl+89}
[  117.830668]        <ffffffff80292346>{do_ioctl32_pointer+9} <ffffffff80291ed4>{compat_sys_ioctl+627}
[  117.839904]        <ffffffff8021817e>{ia32_sysret+0}
[  123.802707] raid5: device dm-3 operational as raid disk 3
[  123.808102] raid5: device dm-2 operational as raid disk 2
[  123.813515] raid5: device dm-1 operational as raid disk 1
[  123.818932] raid5: device dm-0 operational as raid disk 0
[  123.824632] raid5: allocated 4262kB for md1
[  123.828873] raid5: raid level 5 set md1 active with 4 out of 4 devices, algorithm 2
[  123.836541] RAID5 conf printout:
[  123.839818]  --- rd:4 wd:4 fd:0
[  123.842973]  disk 0, o:1, dev:dm-0
[  123.846376]  disk 1, o:1, dev:dm-1
[  123.849777]  disk 2, o:1, dev:dm-2
[  123.853187]  disk 3, o:1, dev:dm-3
[  123.888070] md: bind<dm-10>
[  123.913148] md: bind<dm-11>
[  123.927897] raid1: raid set md0 active with 2 out of 2 mirrors

After that, everything keeps working as normal. Any ideas?

/* Steinar */
-- 
Homepage: http://www.sesse.net/

