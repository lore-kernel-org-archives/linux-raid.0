From: Joey Liao <joeyliao@qnap.com>
Subject: Re: raid5/6: general protection fault in async_copy_data
Date: Mon, 18 Jul 2016 18:47:56 +0800
Message-ID: <CAHvN=inR_Y0p0F_E3_cHrE8rubLAvAVdHwv+MW-EDFgnqMrjKQ@mail.gmail.com>
References: <CAHvN=in6MFvx7=BN1asctsA=EMPZthQBHUfx5TwY5UmUsmcMFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHvN=in6MFvx7=BN1asctsA=EMPZthQBHUfx5TwY5UmUsmcMFw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Does anyone have idea about this call trace in linux 3.19.8...???

2016-07-04 16:07 GMT+08:00 Joey Liao <joeyliao@qnap.com>:
> Hi,
>
> We meet a general protection fault issue when doing the I/O stress
> test. (Please refer the following call trace.)
>
> The linux version what we use is 3.19.8.
>
> Besides, it will not only happen in raid5 but also raid6, and our raid
> is normal and clean (not in resync or rebuild or degraded state) in
> this case.
> The general protection fault logs just show-up suddenly during the I/O
> stress test, and no other logs else are before it.
>
> It seems that it is an old issue that someone has been meet in linux 3.8.13.
> http://comments.gmane.org/gmane.linux.raid/48737
>
> However, it did not come to an exact conclusion then.
> Does anyone have any idea about this situation?
>
>
> <4>[ 8415.258965] general protection fault: 0000 [#1] SMP
> <4>[ 8415.263946] Modules linked in: vfio_pci vfio_iommu_type1 vfio
> vringh virtio_scsi virtio_pci virtio_mmio virtio_console
> virtio_balloon virtio_rng virtio_blk virtio_net virtio_ring virtio
> vhost_net vhost tun macvtap macvlan kvm_intel kvm fbdisk(O) xt_mark
> ipt_MASQUERADE iptable_nat nf_nat_masquerade_ipv4 nf_nat_ipv4 nf_nat
> ppp_deflate bsd_comp ppp_mppe ppp_async ppp_generic slhc iscsi_tcp(O)
> libiscsi_tcp(O) libiscsi(O) scsi_transport_iscsi(O) btusb bluetooth
> bonding bridge stp ipv6 uvcvideo videobuf2_vmalloc videobuf2_memops
> videobuf2_core snd_usb_caiaq snd_usb_audio snd_usbmidi_lib
> snd_seq_midi snd_rawmidi fnotify(PO) udf isofs iTCO_wdt psnap llc
> ufsd(PO) jnl(O) pl2303 usbserial intel_ips drbd(O) flashcache(O)
> dm_thin_pool dm_bio_prison dm_persistent_data hal_netlink(O) coretemp
> r8152 usbnet mii igb e1000e(O) mpt3sas mpt2sas scsi_transport_sas
> raid_class uas usb_storage xhci_pci xhci_hcd usblp uhci_hcd ehci_pci
> ehci_hcd [last unloaded: fbdisk]
> <4>[ 8415.348888] CPU: 0 PID: 4611 Comm: md1_raid5 Tainted: P     U
>  O   3.19.8 #1
> <4>[ 8415.356137] Hardware name: Default string Default string/SKYBAY,
> BIOS QX80AR20 06/07/2016
> <4>[ 8415.364249] task: ffff880847616210 ti: ffff880831950000 task.ti:
> ffff880831950000
> <4>[ 8415.371667] RIP: 0010:[<ffffffff813c4446>]  [<ffffffff813c4446>]
> memcpy+0x6/0x110
> <4>[ 8415.379126] RSP: 0000:ffff880831953990  EFLAGS: 00210206
> <4>[ 8415.384398] RAX: ffff880832e87000 RBX: ffff880831953a18 RCX:
> 0000000000001000
> <4>[ 8415.391475] RDX: 0000000000001000 RSI: 0845080000067000 RDI:
> ffff880832e87000
> <4>[ 8415.398553] RBP: ffff8808319539c8 R08: 0000000000001000 R09:
> ffff880831953a18
> <4>[ 8415.405660] R10: 0000000000000001 R11: 0000000000000001 R12:
> ffffea0020cba1c0
> <4>[ 8415.412750] R13: 0000000000000000 R14: 002100000000000e R15:
> 0000000000067000
> <4>[ 8415.419829] FS:  0000000000000000(0000)
> GS:ffff88086dc00000(0000) knlGS:0000000000000000
> <4>[ 8415.427852] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[ 8415.433550] CR2: 0000000008120480 CR3: 0000000001c7d000 CR4:
> 00000000003407f0
> <4>[ 8415.440648] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> <4>[ 8415.447748] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> <4>[ 8415.454823] Stack:
> <4>[ 8415.456849]  ffffffff8138408f 0000000000001000 0000000000080000
> 0000000000080000
> <4>[ 8415.464283]  0000000000000000 0000000000000000 0000000000001000
> ffff880831953a78
> <4>[ 8415.471720]  ffffffff8169911e ffff880831953a18 ffffffff8138a5b7
> ffff880831953a18
> <4>[ 8415.479144] Call Trace:
> <4>[ 8415.481578]  [<ffffffff8138408f>] ? async_memcpy+0x9f/0x100
> <4>[ 8415.487122]  [<ffffffff8169911e>] async_copy_data+0x12e/0x260
> <4>[ 8415.492824]  [<ffffffff8138a5b7>] ? bio_attempt_front_merge+0xb7/0xf0
> <4>[ 8415.499214]  [<ffffffff81699bb6>] raid_run_ops+0x876/0x1190
> <4>[ 8415.504741]  [<ffffffff8138c5b3>] ? generic_make_request+0xa3/0xf0
> <4>[ 8415.510872]  [<ffffffff8169f716>] ? ops_run_io+0x36/0x820
> <4>[ 8415.516233]  [<ffffffff81085763>] ? __wake_up+0x53/0x70
> <4>[ 8415.521417]  [<ffffffff816a0e7b>] handle_stripe+0xa8b/0x1b50
> <4>[ 8415.527031]  [<ffffffff81085206>] ? __wake_up_common+0x16/0x90
> <4>[ 8415.532816]  [<ffffffff816a22da>] handle_active_stripes+0x39a/0x450
> <4>[ 8415.539035]  [<ffffffff816a2849>] raid5d+0x399/0x630
> <4>[ 8415.543964]  [<ffffffff816ac4ed>] md_thread+0x7d/0x130
> <4>[ 8415.549064]  [<ffffffff81085370>] ? woken_wake_function+0x20/0x20
> <4>[ 8415.555107]  [<ffffffff816ac470>] ? errors_store+0x70/0x70
> <4>[ 8415.560552]  [<ffffffff8106a263>] kthread+0xe3/0xf0
> <4>[ 8415.565411]  [<ffffffff8106a180>] ? kthreadd+0x160/0x160
> <4>[ 8415.570682]  [<ffffffff8192d048>] ret_from_fork+0x58/0x90
> <4>[ 8415.576044]  [<ffffffff8106a180>] ? kthreadd+0x160/0x160
> <4>[ 8415.581315] Code: 24 4c 8b 64 24 08 c9 c3 e8 68 f9 ff ff 41 80
> 7c 24 05 00 75 d3 eb e4 90 90 90 90 90 90 90 90 90 90 90 90 90 90 48
> 89 f8 48 89 d1 <f3> a4 c3 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 20 4c 8b
> 06 4c 8b
> <1>[ 8415.601660] RIP  [<ffffffff813c4446>] memcpy+0x6/0x110
> <4>[ 8415.606788]  RSP <ffff880831953990>
> <4>[ 8415.612291] ---[ end trace 962cfd98d43b82fa ]---
> <4>[ 8415.620528] ------------[ cut here ]------------
