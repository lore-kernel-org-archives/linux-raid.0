From: Joey Liao <joeyliao@qnap.com>
Subject: [BUG] call trace in raid5 do_release_stripe() is triggered during I/O
 stress test in kernel 3.19-rc8
Date: Mon, 23 May 2016 12:12:46 +0800
Message-ID: <CAHvN=inrSMjyiwMxGyJ6xXEL+92SDPw_L864GWJiy6F-AV1phg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

We start to do the I/O stress test for raid5 in kernel 3.19.8. During
the stress test, the raid5 is clean (not
resyncing/rebuilding/reshaping) and it is not degraded as well.

However, we meet a machine reboot problem and we believe it hugely
related to the following call trace:

Ps.
1. The call trace shows suddenly and the previous messages were 1 hour ago.
2. It is not easy to reproduce but it has been taken place twice this week.

It is really a serious problem to us, would you please help to provide
us some suggestions to solve the problem or at least to figure out the
root cause? Thanks.

=== related source code ===

static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
     struct list_head *temp_inactive_list)
{
    BUG_ON(!list_empty(&sh->lru));
    ....
}

=== related call trace ===

 kernel BUG at drivers/md/raid5.c:299!
<4>[53230.958843] invalid opcode: 0000 [#1] SMP
<4>[53230.962991] Modules linked in: thunderbolt xt_mark
ipt_MASQUERADE iptable_nat nf_nat_masquerade_ipv4 nf_nat_ipv4 nf_nat
ppp_deflate bsd_comp ppp_mppe ppp_async ppp_generic slhc tun
iscsi_tcp(O) libiscsi_tcp(O) libiscsi(O) scsi_transport_iscsi(O)
iscsi_target_mod target_core_file target_core_iblock target_core_mod
fbdisk(O) bonding bridge stp ipv6 uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core snd_usb_caiaq snd_usb_audio
snd_usbmidi_lib snd_seq_midi snd_rawmidi fnotify(PO) udf isofs
iTCO_wdt psnap llc ufsd(PO) jnl(O) pl2303 usbserial intel_ips drbd(O)
flashcache(O) dm_thin_pool dm_bio_prison dm_persistent_data
hal_netlink(O) coretemp ixgbe mdio r8152 usbnet mii igb e1000e(O)
mpt3sas mpt2sas scsi_transport_sas raid_class uas usb_storage xhci_pci
xhci_hcd usblp uhci_hcd ehci_pci ehci_hcd
<4>[53231.035304] CPU: 2 PID: 4316 Comm: md1_raid5 Tainted: P     U
 O   3.19.8 #1
<4>[53231.042620] Hardware name: Default string Default string/SKYBAY,
BIOS QX80AT04 03/29/2016
<4>[53231.050818] task: ffff8802b383a0d0 ti: ffff88029e734000 task.ti:
ffff88029e734000
<4>[53231.058308] RIP: 0010:[]  [] do_release_stripe+0x190/0x1a0
<4>[53231.066953] RSP: 0000:ffff88029e737c48  EFLAGS: 00210006
<4>[53231.072283] RAX: 000000000000d201 RBX: ffff8802b05aec98 RCX:
0000000000000001
<4>[53231.079426] RDX: ffff8802aed74b48 RSI: ffff8802b05aec98 RDI:
ffff8802aed74800
<4>[53231.086571] RBP: ffff88029e737c68 R08: 0000000000000000 R09:
0000000000000000
<4>[53231.093714] R10: ffff88029e737b28 R11: 0000000000000002 R12:
ffff8802aed74800
<4>[53231.100858] R13: ffff8802b05aeca8 R14: ffff8802aed74b48 R15:
ffff88029e737d08
<4>[53231.108001] FS:  0000000000000000(0000)
GS:ffff8802bdd00000(0000) knlGS:0000000000000000
<4>[53231.116099] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[53231.121856] CR2: 00000000f76ade38 CR3: 0000000001c7d000 CR4:
00000000003407e0
<4>[53231.129017] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
<4>[53231.136161] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
<4>[53231.143304] Stack:
<4>[53231.145326]  ffff88029e737cd0 0000000000000001 ffff8802aed74800
0000000000000008
<4>[53231.152818]  ffff88029e737c78 ffffffff81698bbb ffff88029e737d38
ffffffff816a2318
<4>[53231.160312]  ffff8802aed74800 ffff8802a903ece8 0000000000000000
ffff88029e737e58
<4>[53231.167835] Call Trace:
<4>[53231.170295]  [] __release_stripe+0x1b/0x30
<4>[53231.175966]  [] handle_active_stripes+0x3d8/0x450
<4>[53231.182243]  [] raid5d+0x399/0x630
<4>[53231.187221]  [] md_thread+0x7d/0x130
<4>[53231.192369]  [] ? woken_wake_function+0x20/0x20
<4>[53231.198473]  [] ? errors_store+0x70/0x70
<4>[53231.203985]  [] kthread+0xe3/0xf0
<4>[53231.208874]  [] ? kthreadd+0x160/0x160
<4>[53231.214198]  [] ret_from_fork+0x58/0x90
<4>[53231.219608]  [] ? kthreadd+0x160/0x160
<4>[53231.224931] Code: b8 49 8b 44 24 18 48 8b b8 48 01 00 00 e8 89
fe 00 00 eb a5 48 89 df e8 0f fd ff ff e9 14 ff ff ff 0f 0b eb fe 66
0f 1f 44 00 00 <0f> 0b eb fe 0f 0b eb fe 0f 1f 84 00 00 00 00 00 55 48
89 e5 e8
<1>[53231.245381] RIP  [] do_release_stripe+0x190/0x1a0
<4>[53231.251681]  RSP
