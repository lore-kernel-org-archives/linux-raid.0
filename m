From: Joey Liao <joeyliao@qnap.com>
Subject: Write to the degraded raid5 will trigger the call trace dump when
 skip_copy is enabled
Date: Fri, 29 Apr 2016 18:54:10 +0800
Message-ID: <CAHvN=inPP5ubYK1YkNW_B1b9ouhqBo8qMMfVcGSjddMYekDEng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

For improving the I/O performance, we try to enable the raid 5
skip_copy feature by default. It indeed has some benefit, however, it
will always (not a random issue) dump the following call trace
repeatedly when we try to write the raid 5 block device. It is related
to the following codes in handle_stripe_clean_event() in raid5.c.

WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
WARN_ON(dev->page != dev->orig_page);

Is it a known bug for skip_copy feature?
Does it do harm to the data integrity?
If we would like to prevent this call trace, for your suggestion how
should we do to modify the source code?

Thanks.

<4>[38795.430821] ------------[ cut here ]------------
<4>[38795.430822] WARNING: CPU: 1 PID: 28674 at
drivers/md/raid5.c:3447 handle_stripe_clean_event+0x379/0x3d0()
<4>[38795.430823] Modules linked in: ppp_deflate bsd_comp ppp_mppe
ppp_async ppp_generic crc_ccitt slhc xt_mark ipt_MASQUERADE
iptable_nat nf_nat_masquerade_ipv4 nf_nat_ipv4 nf_nat tun iscsi_tcp(O)
libiscsi_tcp(O) libiscsi(O) scsi_transport_iscsi(O) iscsi_target_mod
target_core_file target_core_iblock target_core_mod fbdisk(O) bonding
bridge stp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
snd_usb_caiaq snd_usb_audio snd_usbmidi_lib snd_seq_midi snd_rawmidi
fnotify(PO) udf isofs iTCO_wdt psnap llc tbs_keys(O) dm_c2f(O)
ufsd(PO) jnl(O) pl2303 usbserial intel_ips drbd(O) flashcache(O)
dm_thin_pool dm_bio_prison dm_persistent_data hal_netlink(O) coretemp
mlx4_en(O) mlx4_core(O) mlx_compat(O) ixgbe mdio igb e1000e(O) mpt3sas
mpt2sas scsi_transport_sas raid_class uas usb_storage xhci_pci
xhci_hcd usblp uhci_hcd ehci_pci ehci_hcd
<4>[38795.430839] CPU: 1 PID: 28674 Comm: md2_resync Tainted: P
W  O   3.19.8 #1
<4>[38795.430840] Hardware name: INSYDE QV96/Type2 - Board Product
Name1, BIOS QV96IR23 10/21/2015
<4>[38795.430840]  ffffffff81ab550a ffff88009510f9c8 ffffffff81362987
ffff88009510fa08
<4>[38795.430841]  ffffffff8105447b ffff88009510fa68 ffff88009897b000
0000000000000000
<4>[38795.430843]  ffff8807d742fe48 ffff8807d742fe40 ffff8807d742f800
ffff88009510fa18
<4>[38795.430844] Call Trace:
<4>[38795.430845]  [<ffffffff81362987>] dump_stack+0x57/0x80
<4>[38795.430847]  [<ffffffff8105447b>] warn_slowpath_common+0x8b/0xd0
<4>[38795.430848]  [<ffffffff810544d5>] warn_slowpath_null+0x15/0x20
<4>[38795.430850]  [<ffffffff8160a829>] handle_stripe_clean_event+0x379/0x3d0
<4>[38795.430851]  [<ffffffff8160e2d2>] handle_stripe+0xe52/0x1b50
<4>[38795.430852]  [<ffffffff816100af>] sync_request+0x5af/0xbf0
<4>[38795.430853]  [<ffffffff810a0a4e>] ? try_to_del_timer_sync+0x4e/0x60
<4>[38795.430854]  [<ffffffff810a0a9d>] ? del_timer_sync+0x3d/0x50
<4>[38795.430855]  [<ffffffff818938a5>] ? schedule_timeout+0xf5/0x160
<4>[38795.430856]  [<ffffffff810a0ab0>] ? del_timer_sync+0x50/0x50
<4>[38795.430858]  [<ffffffff8161be39>] md_do_sync+0x9c9/0xf00
<4>[38795.430860]  [<ffffffff810856c0>] ? woken_wake_function+0x10/0x10
<4>[38795.430861]  [<ffffffff81890fe0>] ? __schedule+0x320/0x860
<4>[38795.430862]  [<ffffffff81075d9d>] ? try_to_wake_up+0xed/0x290
<4>[38795.430864]  [<ffffffff81619175>] md_thread+0x75/0x120
<4>[38795.430865]  [<ffffffff81619100>] ? errors_store+0x70/0x70
<4>[38795.430866]  [<ffffffff81619100>] ? errors_store+0x70/0x70
<4>[38795.430867]  [<ffffffff8106d87e>] kthread+0xde/0xf0
<4>[38795.430869]  [<ffffffff8106d7a0>] ? kthreadd+0x150/0x150
<4>[38795.430870]  [<ffffffff818946c8>] ret_from_fork+0x58/0x90
<4>[38795.430871]  [<ffffffff8106d7a0>] ? kthreadd+0x150/0x150
<4>[38795.430872] ---[ end trace 9d400a29547fb473 ]---
<4>[38795.430872] ------------[ cut here ]------------
<4>[38795.430874] WARNING: CPU: 1 PID: 28674 at
drivers/md/raid5.c:3448 handle_stripe_clean_event+0x1f2/0x3d0()
<4>[38795.430874] Modules linked in: ppp_deflate bsd_comp ppp_mppe
ppp_async ppp_generic crc_ccitt slhc xt_mark ipt_MASQUERADE
iptable_nat nf_nat_masquerade_ipv4 nf_nat_ipv4 nf_nat tun iscsi_tcp(O)
libiscsi_tcp(O) libiscsi(O) scsi_transport_iscsi(O) iscsi_target_mod
target_core_file target_core_iblock target_core_mod fbdisk(O) bonding
bridge stp uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core
snd_usb_caiaq snd_usb_audio snd_usbmidi_lib snd_seq_midi snd_rawmidi
fnotify(PO) udf isofs iTCO_wdt psnap llc tbs_keys(O) dm_c2f(O)
ufsd(PO) jnl(O) pl2303 usbserial intel_ips drbd(O) flashcache(O)
dm_thin_pool dm_bio_prison dm_persistent_data hal_netlink(O) coretemp
mlx4_en(O) mlx4_core(O) mlx_compat(O) ixgbe mdio igb e1000e(O) mpt3sas
mpt2sas scsi_transport_sas raid_class uas usb_storage xhci_pci
xhci_hcd usblp uhci_hcd ehci_pci ehci_hcd
<4>[38795.430891] CPU: 1 PID: 28674 Comm: md2_resync Tainted: P
W  O   3.19.8 #1
<4>[38795.430891] Hardware name: INSYDE QV96/Type2 - Board Product
Name1, BIOS QV96IR23 10/21/2015
<4>[38795.430892]  ffffffff81ab550a ffff88009510f9c8 ffffffff81362987
ffff88009510fa08
<4>[38795.430893]  ffffffff8105447b ffff88009510fa68 ffff88009897b000
0000000000000000
<4>[38795.430894]  ffff8807d742fe48 ffff8807d742fe40 ffff8807d742f800
ffff88009510fa18
<4>[38795.430895] Call Trace:
<4>[38795.430897]  [<ffffffff81362987>] dump_stack+0x57/0x80
<4>[38795.430898]  [<ffffffff8105447b>] warn_slowpath_common+0x8b/0xd0
<4>[38795.430899]  [<ffffffff810544d5>] warn_slowpath_null+0x15/0x20
<4>[38795.430901]  [<ffffffff8160a6a2>] handle_stripe_clean_event+0x1f2/0x3d0
<4>[38795.430902]  [<ffffffff8160e2d2>] handle_stripe+0xe52/0x1b50
<4>[38795.430903]  [<ffffffff816100af>] sync_request+0x5af/0xbf0
<4>[38795.430904]  [<ffffffff810a0a4e>] ? try_to_del_timer_sync+0x4e/0x60
<4>[38795.430906]  [<ffffffff810a0a9d>] ? del_timer_sync+0x3d/0x50
<4>[38795.430907]  [<ffffffff818938a5>] ? schedule_timeout+0xf5/0x160
<4>[38795.430908]  [<ffffffff810a0ab0>] ? del_timer_sync+0x50/0x50
<4>[38795.430909]  [<ffffffff8161be39>] md_do_sync+0x9c9/0xf00
<4>[38795.430911]  [<ffffffff810856c0>] ? woken_wake_function+0x10/0x10
<4>[38795.430912]  [<ffffffff81890fe0>] ? __schedule+0x320/0x860
<4>[38795.430914]  [<ffffffff81075d9d>] ? try_to_wake_up+0xed/0x290
<4>[38795.430915]  [<ffffffff81619175>] md_thread+0x75/0x120
<4>[38795.430916]  [<ffffffff81619100>] ? errors_store+0x70/0x70
<4>[38795.430918]  [<ffffffff81619100>] ? errors_store+0x70/0x70
<4>[38795.430919]  [<ffffffff8106d87e>] kthread+0xde/0xf0
<4>[38795.430920]  [<ffffffff8106d7a0>] ? kthreadd+0x150/0x150
<4>[38795.430921]  [<ffffffff818946c8>] ret_from_fork+0x58/0x90
<4>[38795.430922]  [<ffffffff8106d7a0>] ? kthreadd+0x150/0x150
<4>[38795.430923] ---[ end trace 9d400a29547fb474 ]---
