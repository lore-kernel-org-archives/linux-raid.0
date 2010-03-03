From: Neil Brown <neilb@suse.de>
Subject: Re: Auto Checking Raid 6 crashes my system
Date: Wed, 3 Mar 2010 16:32:20 +1100
Message-ID: <20100303163220.70fbb646@notabene.brown>
References: <adf93d751002152104w52b329fdx9eb54719f1c8587a@mail.gmail.com>
	<73e903671002160537m571a48e1v6e652410554e8a49@mail.gmail.com>
	<adf93d751002160916r5414b3e9qf3e6e19e2e9b83a0@mail.gmail.com>
	<adf93d751002180028o401b5d8an4520aea1baa2b122@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002180028o401b5d8an4520aea1baa2b122@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: Kristleifur =?UTF-8?B?RGHDsGFzb24=?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Feb 2010 00:28:05 -0800
Dawning Sky <the.dawning.sky@gmail.com> wrote:

> I tried to reproduce the crash.  First I echoed "check" into
> /sys/block/md127/md/sync_action under the single mode and the array
> finished checking.  Then I booted into init 3 and repeated the same
> thing and got the following error on the screen and the computer hung=
=2E
>  I had to manually type the error since I had no way to copy/paste, s=
o
> there might be a few typos.

That is quite an effort typing all that in!!

I wish I could say it was really helpful and I can see exactly the prob=
lem
but unfortunately I cannot.
I have never seen any bugs in this part of the code and I cannot see ho=
w such
a BUG could be occurring, unless memory has become corrupted some how.

I think this is very likely to be caused by a hardware problem of some =
sort.
Maybe try running memcheck86 just in case.  Maybe try a different
controller card or something.

sorry I cannot be more helpful.

NeilBrown

>=20
>=20
> UG: unable to handle kernel paging request at 000000006a312c50
> IP: [<ffffffff810402a8>] task_rq_lock_0x3c/0x7e
> PGD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/block/md127/md/sync_speed
> CPU 1
> Modules linked: fuse ipt_MASQUERADE iptable_nat nf_nat bridge stp llc
> nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 hwmon_vid sunrpc
> cpufreq_ondemand powernow_k8 freq_table ipv6 nf_conntrack_netbios_ns
> ext2 kvm_amd kvm uinput snd_hda_codec_analog usblp snd_hda_intel
> snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd
> forcedeth amd64_edac_mod ppdev soundcore edac_core i2c_nforce2
> snd_page_alloc parport_pc k8temp serio_raw parport asusatk0110 raid45=
6
> raid6_pq async_xor async_tx xor dm_multipath ata_generic pata_jmicron
> firewire_ohci firewire_core crc_itu_t pata_amd pata_acpi sata_nv
> usb_storage nouveau ttm drm_kms_helper drm i2c_algo_bit i2c_core [las=
t
> unloaded: scsi_wait_scan]
> Pid: 523, comm: md127_raid5 Not tainted 2.6.31.12-174.2.3.fc12.x86_64
> #1 System Product Name
> RIP: 0010:[<ffffffff810402a8>] [<ffffffff810402a8>] task_rq_lock+0x3c=
/0x7e
> RSP: 0010:ffff8801155d5c10 EFLAGS: 00010046
> RAX: 000000001d1836b0 RBX: 0000000000015600 RCX: 0000000000000000
> RDX: 0000000000000046 RSI: ffff8801155d5c58 RDI: ffff8800dc4c2f00
> RBP: ffff8801155d5c30 R08: 0000000000000000 R09: 0000000000000001
> R10: ffff880115cb64e8 R11: 6db6db6db6db6db7 R12: ffff8801155d5c58
> R13: ffff8800dc4c2f00 R14: 0000000000015600 R15: 0000000000000000
> FS: 00007f66cc00c780(0000) GS: ffff88002803c000(0000) knlGS: 00000000=
00000000
> CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 000000006a312c50 CR3: 0000000001001000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process md127_raid5 (pid: 523, threadinfo ffff8801155d4000, task
> ffff880115daaf00)
> Stack:
>  ffff8800dc4c2f00 0000000000000000 0000000000000003 ffff8801155d5c58
> <0> ffff8801155d5c90 ffffffff8104ae7d
> [drm] nouveau 0000:07:00.0: GPU lockup - switching to software fbcon
>  ffff880115fc4c00 ffff880115a45400
> <0> ffff88011809e400 00000000000000046 ffff888115cb64e8 0000000000000=
001
> Call Trace:
>  [<ffffffff8104ae7d>] try_to_wake_up+0x9a/0x2de
>  [<ffffffff8104b0d3>] default_wake_function+0x12/0x14
>  [<ffffffff8103c237>] __wake_up_common+0x4e/0x84
>  [<ffffffff810400cd>] __wake_up+0x39/0x4d
>  [<ffffffffa017ce72>] __release_stripe+0x115/0x147 [raid456]
>  [<ffffffffa017ced9>] release_stripe+0x35/0x49 [raid456]
>  [<ffffffffa0182cd8>] raid5d+0x44e/0x563 [raid456]
>  [<ffffffff8141c285>] ? schedule_timeout+0xb3/0xe3
>  [<ffffffff8105c236>] ? process_timeout+0x0/0x10
>  [<ffffffff8133deef>] md_thread+0xf1/0x10f
>  [<ffffffff81067b37>] ? autoremove_wake_function+0x0/0x39
>  [<ffffffff8133ddfe>] ? md_thread+0x0/0x10f
>  [<ffffffff810677b5>] kthread+0x91/0x99
>  [<ffffffff81022daa>] child_rip+0xa/0x20
>  [<ffffffff81067724>] ? kthread+0x0/0x99
>  [<ffffffff81012da0>] ? child_rip+0x0/0x20
> Code: c7 c3 00 56 01 00 49 89 fd 49 89 f4 9c 58 66 66 90 66 90 48 89
> c2 fa 66 66 90 66 66 90 49 89 14 24 49 8b 45 08 49 89 de 8b 40 18 <4c=
>
> 03 34 c5 d0 76 6f 81 4c 89 f7 e8 ac d3 3d 00 49 8b 45 08 8b
> RIP [<ffffffff810402a8>] task_rq_lock+0x3c/0x7e
>  RSP <ffff8801155d5c10>
> CR2: 000000006a312c50
> ---[ end trace 6c5abd1701cc36a0 ]---
> BUG: unable to handle kernel
>=20
>=20
> On Tue, Feb 16, 2010 at 9:16 AM, Dawning Sky <the.dawning.sky@gmail.c=
om> wrote:
> > On Tue, Feb 16, 2010 at 5:37 AM, Kristleifur Da=C3=B0ason
> > <kristleifur@gmail.com> wrote:
> >> On Tue, Feb 16, 2010 at 5:04 AM, Dawning Sky <the.dawning.sky@gmai=
l.com> wrote:
> >>> Hi,
> >>>
> >>> I just build a brand new md raid-6 with 5 disks. =C2=A0And on Fed=
ora 12,
> >>> the auto checking of md devices via a weekly cron job is enabled =
by
> >>> default. =C2=A0It performs the checking by echo "check" into
> >>> /sys/block/mdX/md/sync_action. =C2=A0But after a while, the kerne=
l just
> >>> crashes, without finishing checking the raid device or leaving
> >>> anything in the messages file.
> >>>
> >>> For now, I've disable the raid-check cron job. =C2=A0The kernel v=
ersion I'm
> >>> running is 2.6.31.12-174.2.3.fc12.x86_64.
> >>>
> >>> Thanks,
> >>>
> >>> DS
> >>
> >>
> >> Hi,
> >>
> >> I encountered similar issues because of a faulty mvsas driver that
> >> flaked out under the load. What hardware do you have?
> >
> > I'm using the onboard sata chip, which I believe is nVidia, and the
> > driver is nv_sata.
> >
> >>
> >> -- Kristleifur
> >>
> >
> > DS
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
