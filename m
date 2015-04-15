From: Guoqing Jiang <GQJiang@suse.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at sysfs_do_create_link_sd
 (after mdadm)
Date: Wed, 15 Apr 2015 10:44:39 +0800
Message-ID: <552DD097.9010504@suse.com>
References: <20150414171537.GH25394@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150414171537.GH25394@azat>
Sender: linux-raid-owner@vger.kernel.org
To: Azat Khuzhin <a3at.mail@gmail.com>
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, neilb@suse.de
List-Id: linux-raid.ids

Azat Khuzhin wrote:
> $ git describe
> v4.0-2620-gb79013b
>
> During setting up partitions with mdadm, mdadm hung, after attaching to mdadm with strace I got next:
>
> # pgrep mdadm | xargs strace -fp
> Process 27389 attached - interrupt to quit
> unlink("/dev/.tmp.md.27389:9:127")      = 0
> mknod("/tmp/.tmp.md.27389:9:127", S_IFBLK|0600, makedev(9, 127)) = 0
> open("/tmp/.tmp.md.27389:9:127", O_RDWR|O_EXCL|O_DIRECT) <-- *hung*
>
> After, I looked into dmesg, and found this:
> [ 9627.630018] ------------[ cut here ]------------
> [ 9627.630029] WARNING: CPU: 18 PID: 3330 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x5a/0x70()
> [ 9627.630032] sysfs: cannot create duplicate filename '/devices/virtual/bdi/9:127'
>   
sysfs complains about duplicate filename, maybe you tried to create the
array with same node.
> [ 9627.630033] Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables nfsd nfs lockd grace sunrpc ipmi_devintf netconsole configfs loop hid_generic usbhid hid x86_pkg_temp_thermal coretemp ghash_clmulni_intel aesni_intel ioatdma ehci_pci aes_x86_64 iTCO_wdt iTCO_ve
> [ 9627.630074] CPU: 18 PID: 3330 Comm: mdadm Not tainted 4.0.0bl-azat-v6+ #1
> [ 9627.630076] Hardware name: Supermicro X9DRD-7LN4F(-JBOD)/X9DRD-EF/X9DRD-7LN4F, BIOS 3.0a 12/05/2013
> [ 9627.630077]  0000000000000000 ffffffff814e3fcc ffffffff813e590f ffff885f9bcd3808
> [ 9627.630079]  ffffffff8104575c ffff885f96acb000 ffff885fa4b3e3c0 ffff885fa2fec780
> [ 9627.630081]  ffff885fa4bc4000 0000000000000000 ffffffff810457d5 ffffffff814e5d78
> [ 9627.630083] Call Trace:
> [ 9627.630091]  [<ffffffff813e590f>] ? dump_stack+0x40/0x50
> [ 9627.630096]  [<ffffffff8104575c>] ? warn_slowpath_common+0x7c/0xb0
> [ 9627.630098]  [<ffffffff810457d5>] ? warn_slowpath_fmt+0x45/0x50
> [ 9627.630100]  [<ffffffff81185092>] ? kernfs_path+0x42/0x50
> [ 9627.630102]  [<ffffffff811883da>] ? sysfs_warn_dup+0x5a/0x70
> [ 9627.630104]  [<ffffffff8118846e>] ? sysfs_create_dir_ns+0x7e/0x90
> [ 9627.630108]  [<ffffffff811d94ab>] ? kobject_add_internal+0x9b/0x2f0
> [ 9627.630109]  [<ffffffff811d9af6>] ? kobject_add+0x66/0xb0
> [ 9627.630114]  [<ffffffff812bb2e3>] ? device_add+0x263/0x620
> [ 9627.630116]  [<ffffffff812bb8a8>] ? device_create_groups_vargs+0xe8/0x100
> [ 9627.630118]  [<ffffffff812bb8d3>] ? device_create_vargs+0x13/0x20
> [ 9627.630124]  [<ffffffff810ed128>] ? bdi_register+0x68/0x150
> [ 9627.630129]  [<ffffffff811c535d>] ? add_disk+0x14d/0x4a0
> [ 9627.630132]  [<ffffffff811c585f>] ? alloc_disk_node+0xaf/0x100
> [ 9627.630137]  [<ffffffffa0252269>] ? md_alloc+0x1e9/0x350 [md_mod]
> [ 9627.630141]  [<ffffffffa02523db>] ? md_probe+0xb/0x20 [md_mod]
> [ 9627.630143]  [<ffffffff812c0654>] ? kobj_lookup+0x104/0x170
> [ 9627.630147]  [<ffffffffa02523d0>] ? md_alloc+0x350/0x350 [md_mod]
> [ 9627.630149]  [<ffffffff811c4da8>] ? get_gendisk+0x28/0xf0
> [ 9627.630153]  [<ffffffff8115fb74>] ? __blkdev_get+0x114/0x3c0
> [ 9627.630156]  [<ffffffff8115e590>] ? bdev_direct_access+0xa0/0xa0
> [ 9627.630158]  [<ffffffff8115e5a0>] ? bdev_test+0x10/0x10
> [ 9627.630160]  [<ffffffff8115fe58>] ? blkdev_get+0x38/0x310
> [ 9627.630162]  [<ffffffff81160170>] ? blkdev_get_by_dev+0x40/0x40
> [ 9627.630167]  [<ffffffff8112b3d3>] ? do_dentry_open.isra.16+0x153/0x320
> [ 9627.630170]  [<ffffffff811380f3>] ? do_last.isra.51+0x323/0xd50
> [ 9627.630172]  [<ffffffff8111f5b3>] ? kmem_cache_alloc+0x123/0x130
> [ 9627.630174]  [<ffffffff8113a97f>] ? path_openat+0x7f/0x610
> [ 9627.630177]  [<ffffffff810f7480>] ? tlb_flush_mmu_free+0x30/0x50
> [ 9627.630180]  [<ffffffff810fe800>] ? unmap_region+0xb0/0xf0
> [ 9627.630182]  [<ffffffff8113bb3b>] ? do_filp_open+0x2b/0x90
> [ 9627.630187]  [<ffffffff811472ec>] ? __alloc_fd+0x7c/0x120
> [ 9627.630189]  [<ffffffff8112c531>] ? do_sys_open+0x121/0x210
> [ 9627.630193]  [<ffffffff813ea097>] ? system_call_fastpath+0x12/0x6a
> [ 9627.630195] ---[ end trace b7a3e9c6f05c2666 ]---
> [ 9627.630196] ------------[ cut here ]------------
> [ 9627.630198] WARNING: CPU: 18 PID: 3330 at lib/kobject.c:240 kobject_add_internal+0x274/0x2f0()
> [ 9627.630200] kobject_add_internal failed for 9:127 with -EEXIST, don't try to register things with the same name in the same directory.
>   
Ditto, seems the same issue.

Thanks,
Guoqing

