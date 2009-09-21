From: kwick <kwick@shiftmail.org>
Subject: Re: md data-check causes soft lockup
Date: Mon, 21 Sep 2009 21:13:31 +0200
Message-ID: <4AB7D05B.1040204@shiftmail.org>
References: <4AB7C11E.60801@howardsilvan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4AB7C11E.60801@howardsilvan.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Lee Howard wrote:
> Linux software RAID maintainers and developers,
>
> Two months ago I wrote to the Linux kernel mailing list regarding a 
> condition expressed as "BUG: soft lockup - CPU#3 stuck for 61s!".
> [...CUT...]

I also have seen this problem, on our new server with Ubuntu karmic 
alpha1 with ubuntu kernel 2.6.31-5-server (this is not a stable 2.6.31, 
dunno to which release candidate it corresponds exactly) reproducible if 
I set high stripe cache size of 1024 or higher, while performing "check" 
as you report.

The problem starts with stripe_cache_size around 512 for our mdadm 
raid-6 with 26 drives, already gives a noticeable starvation of disk 
accesses. The higher you set it, the more reproducible is the problem, 
and the longer the starvation time. At 1024 seems already 100% 
reproducible and the starvation time seems endless already, I tried up 
to 32768. 256 seems safe.

All disk activity on the RAID is completely stuck while performing 
check. I mean endless starvation on disk access for high 
stripe_cache_sizes. Luckily one can stop the check, lower the 
stripe_cache_size, then start the check again.

This is the dmesg error for me while on soft lockup (appearing 
periodically on various CPUs.)

    [21652.013121] BUG: soft lockup - CPU#5 stuck for 61s! [md1_raid5:1506]
    [21652.013130] Modules linked in: xfs exportfs snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm snd_timer snd ppdev parport_pc 
soundcore parport snd_page_alloc shpchp i5400_edac psmouse edac_core 
serio_raw i5k_amb tpm_infineon tpm tpm_bios ohci1394 ieee1394 e1000e 
3w_9xxx raid10 raid456 raid6_pqasync_xor async_memcpy async_tx xor raid1 
raid0 multipath linear fbcon tileblit font bitblit softcursor i915 drm 
i2c_algo_bit video output intel_agp
    [21652.013130] CPU 5:
    [21652.013130] Modules linked in: xfs exportfs snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_pcm snd_timer snd ppdev parport_pc 
soundcore parport snd_page_alloc shpchp i5400_edac psmouse edac_core 
serio_raw i5k_amb tpm_infineon tpm tpm_bios ohci1394 ieee1394 e1000e 
3w_9xxx raid10 raid456 raid6_pqasync_xor async_memcpy async_tx xor raid1 
raid0 multipath linear fbcon tileblit font bitblit softcursor i915 drm 
i2c_algo_bit video output intel_agp
    [21652.013130] Pid: 1506, comm: md1_raid5 Tainted: G        W  
2.6.31-5-server #24-Ubuntu empty
    [21652.013130] RIP: 0010:[<ffffffffa00f32a1>]  [<ffffffffa00f32a1>] 
raid6_sse24_gen_syndrome+0x161/0x28e [raid6_pq]
    [21652.013130] RSP: 0018:ffff8808159b7a88  EFLAGS: 00000217
    [21652.013130] RAX: ffff88080e52e000 RBX: ffff8808159b7ab0 RCX: 
ffff88080e52e6e0
    [21652.013130] RDX: 0000000000000005 RSI: ffff88080e52e6c0 RDI: 
00000000000006c0
    [21652.013130] RBP: ffffffff81012b6e R08: 00000000000006f0 R09: 
00000000000006e0
    [21652.013130] R10: 00000000000006d0 R11: 00000000000006c0 R12: 
00000000000005f0
    [21652.013130] R13: 00000000000005e0 R14: 00000000000005d0 R15: 
00000000000005c0
    [21652.013130] FS:  0000000000000000(0000) GS:ffff8800280c7000(0000) 
knlGS:0000000000000000
    [21652.013130] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
    [21652.013130] CR2: 0000000000b20018 CR3: 0000000001001000 CR4: 
00000000000006a0
    [21652.013130] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
    [21652.013130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
    [21652.013130] Call Trace:
    [21652.013130]  [<ffffffffa00f218c>] ? raid6_datap_recov+0x4c/0xc0 
[raid6_pq]
    [21652.013130]  [<ffffffffa010e238>] ? compute_block_2+0x228/0x240 
[raid456]
    [21652.013130]  [<ffffffffa010e39b>] ? 
handle_stripe_fill6+0x14b/0x1e0 [raid456]
    [21652.013130]  [<ffffffffa01103e6>] ? handle_stripe6+0x4c6/0xac0 
[raid456]
    [21652.013130]  [<ffffffffa01113b5>] ? handle_stripe+0x25/0x30 [raid456]
    [21652.013130]  [<ffffffffa01117ba>] ? raid5d+0x20a/0x320 [raid456]
    [21652.013130]  [<ffffffff813cea84>] ? md_thread+0x44/0x120
    [21652.013130]  [<ffffffff81072810>] ? autoremove_wake_function+0x0/0x40
    [21652.013130]  [<ffffffff813cea40>] ? md_thread+0x0/0x120
    [21652.013130]  [<ffffffff81072426>] ? kthread+0x96/0xa0
    [21652.013130]  [<ffffffff8101308a>] ? child_rip+0xa/0x20
    [21652.013130]  [<ffffffff81072390>] ? kthread+0x0/0xa0
    [21652.013130]  [<ffffffff81013080>] ? child_rip+0x0/0x20


Here is a stack trace of vi while it is stuck starved forever, while it 
tries to write the file:
    root@myserver:/proc# cat 7533/stack
        [<ffffffffa030ebd5>] xfs_iget+0xb5/0x1a0 [xfs]
        [<ffffffffa0327e71>] xfs_trans_iget+0xd1/0x100 [xfs]
        [<ffffffffa03111f6>] xfs_ialloc+0x96/0x6c0 [xfs]
        [<ffffffffa0328a4d>] xfs_dir_ialloc+0x7d/0x2d0 [xfs]
        [<ffffffffa032a6d3>] xfs_create+0x3e3/0x5f0 [xfs]
        [<ffffffffa0335c3b>] xfs_vn_mknod+0xab/0x1c0 [xfs]
        [<ffffffffa0335d6b>] xfs_vn_create+0xb/0x10 [xfs]
        [<ffffffff81121fff>] vfs_create+0xaf/0xd0
        [<ffffffff811220dc>] __open_namei_create+0xbc/0x100
        [<ffffffff81125656>] do_filp_open+0x9e6/0xac0
        [<ffffffff81115624>] do_sys_open+0x64/0x160
        [<ffffffff8111574b>] sys_open+0x1b/0x20
        [<ffffffff81011fc2>] system_call_fastpath+0x16/0x1b
        [<ffffffffffffffff>] 0xffffffffffffffff


I have just checked and the same problem happens on our older server 
with Ubuntu Hardy 2.6.24-22-openvz, but only at stripe_cache_size 32768. 
Consider it's a smaller RAID-6 there, 12 devices. At lower 
stripe_cache_sizes I only see a very long wait time for whatever 
application tries to access the disk, such as vi trying to write the file.
Both servers have really plenty of RAM. The older server is a dual-xeon 
5345, the new one is a dual-xeon-5420.

This is the dmesg for the older server:

    [2327104.227028] BUG: soft lockup - CPU#4 stuck for 11s! 
[md1_raid5:3850]
    [2327104.227108] CPU 4:
    [2327104.227110] Modules linked in: nfsd auth_rpcgss exportfs 
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state 
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables 
kvm_intel kvm nfs lockd nfs_acl sunrpc bridge tun bonding i5k_amb 
coretemp w83627hf hwmon_vid adt7470 i2c_i801 i2c_core ipv6 snd_hda_intel 
snd_pcm sr_mod snd_timer cdrom snd_page_alloc snd_hwdep iTCO_wdt 
iTCO_vendor_support ata_generic serio_raw pata_acpi snd i5000_edac 
button container shpchp pci_hotplug edac_core soundcore evdev parport_pc 
parport psmouse pcspkr ext3 jbd mbcache sg sd_mod mptsas mptscsih 
ata_piix mptbase ehci_hcd scsi_transport_sas 3w_9xxx libata ohci1394 
floppy uhci_hcd scsi_mod ieee1394 usbcore e1000 raid10 raid456 async_xor 
async_memcpy async_txxor raid1 raid0 multipath linear md_mod dm_mirror 
dm_snapshot dm_mod thermal processor fan
    [2327104.227267] Pid: 3850, comm: md1_raid5 Not tainted 
2.6.24-22-openvz #1 ovz005
    [2327104.227269] RIP: 0010:[<ffffffff88095237>]  
[<ffffffff88095237>] :raid456:raid6_sse24_gen_syndrome+0x107/0x200
    [2327104.227286] RSP: 0018:ffff810415c65c10  EFLAGS: 00000217
    [2327104.227290] RAX: ffff810316e9e000 RBX: ffff810415c65c78 RCX: 
ffff810316e9eae0
    [2327104.227293] RDX: ffff810316e9eac0 RSI: 0000000000000ac0 RDI: 
0000000000000ac0
    [2327104.227297] RBP: ffffffff80293bca R08: 0000000000000008 R09: 
ffff810415c65c70
    [2327104.227301] R10: ffff810316e1f000 R11: ffff8103819dc000 R12: 
ffff810415c65bb8
    [2327104.227306] R13: ffff81041ab46210 R14: ffff810415c65ba0 R15: 
ffff81041ab461e0
    [2327104.227310] FS:  0000000000000000(0000) 
GS:ffff81041ab12300(0000) knlGS:0000000000000000
    [2327104.227315] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
    [2327104.227317] CR2: 00007ffc53bc5000 CR3: 000000041cd25000 CR4: 
00000000000026e0
    [2327104.227321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
    [2327104.227325] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
    [2327104.227329]
    [2327104.227330] Call Trace:
    [2327104.227340]  [<ffffffff88091db4>] 
:raid456:compute_parity6+0x1e4/0x380
    [2327104.227361]  [<ffffffff8809335d>] 
:raid456:handle_stripe+0xfbd/0x1090
    [2327104.227387]  [<ffffffff8804ce50>] :md_mod:md_thread+0x0/0x100
    [2327104.227394]  [<ffffffff88093774>] :raid456:raid5d+0x344/0x460
    [2327104.227412]  [<ffffffff8804ce50>] :md_mod:md_thread+0x0/0x100
    [2327104.227422]  [<ffffffff8804ce80>] :md_mod:md_thread+0x30/0x100
    [2327104.227432]  [<ffffffff80256fc0>] autoremove_wake_function+0x0/0x30
    [2327104.227443]  [<ffffffff8804ce50>] :md_mod:md_thread+0x0/0x100
    [2327104.227448]  [<ffffffff80256bfb>] kthread+0x4b/0x80
    [2327104.227456]  [<ffffffff8020d278>] child_rip+0xa/0x12
    [2327104.227469]  [<ffffffff80256bb0>] kthread+0x0/0x80
    [2327104.227474]  [<ffffffff8020d26e>] child_rip+0x0/0x12
    [2327104.227479]


The bug can be workarounded by setting a resync_speed_max which is lower 
than what the hardware is capable of. Or by lowering the 
stripe_cache_size as I said.

Thank you MD people for looking into this problem.

