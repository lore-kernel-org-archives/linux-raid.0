From: Iain Rauch <postmaster@email.iain.rauch.co.uk>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 11 Mar 2010 12:25:11 +0000
Message-ID: <C7BE91A7.10FF2%postmaster@email.iain.rauch.co.uk>
References: <4877c76c1003110406g7b09f6e6ya793321f76e6c3ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003110406g7b09f6e6ya793321f76e6c3ed@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Thu, Mar 11, 2010 at 3:51 AM, Iain Rauch
> <groups@email.iain.rauch.co.uk> wrote:
>> Smartd emailed me to say I have "1 Currently unreadable (pending) sectors".
>> This actually happened for two disks now.
>> 
>> I ran a check and then a repair on my array and they both gave mismatch_cnt
>> of 8.
>> 
>> I ran a long self-test on both and they completed without error with no
>> errors logged. Yet the 'Current_Pending_Sector' is still 1 on both, and one
>> disk also has a 'UDMA_CRC_Error_Count' of 1.
>> 
>> I ran 'hdrecover' on both and they are both telling me "Couldn't recover
>> sector 2930277168". It's asking if I want to overwrite it with zeros to fix
>> it, but I would assume this will damage my array?
>> 
>> The disk sizes are 1500301910016 bytes and I use 1500250M partition sizes
>> for the array components. Does that sector fall outside my partition, and
>> hence would it be safe to overwrite it with zeros?
>> 
>> Also, why did I have a mismatch_cnt? I haven't run another check since I did
>> the repair, as I wanted to fix the pending sector.
>> 
>> BTW, I have a 15 drive RAID6.
>> 
> 
> If you are running RAID6 and it can read from all but two drives then
> it should still be able to calculate whatever would match the
> remaining (presumed good) reads to fill the later two drives.  RECENT
> kernels will try to write over failed sectors automatically; and only
> kick the drive if the write fails.
> 
> Please provide more information.
> 
> Kernel version
> mdadm version
> 
> Information about how the source block devices are split up before
> mdadm sees them, and any related messages from the system-log.  The
> relevant section should be near the end of a dmesg output when you've
> just completed a check or repair.  Your syslog probably already
> captured the same data and stored it elsewhere.

I thought doing the repair was supposed to fix the issue, but it didn't seem
to touch it. I wonder if it is outside what md sees, but then how would it
have been noticed as unreadable? And is it coincidence that both drives have
the same unreadable sector?

root@Edna:/home/iain# uname -a
Linux Edna 2.6.28-16-server #57-Ubuntu SMP Wed Nov 11 10:34:04 UTC 2009
x86_64 GNU/Linux
root@Edna:/home/iain# mdadm -V
mdadm - v2.6.9 - 10th March 2009

I paste the end of messages below. There's loads of that all the way through
doing the repair so I'm not sure how to filter out the useful bits.


Iain


Mar 10 07:21:21 Edna -- MARK --
Mar 10 07:29:48 Edna kernel: [135073.510019] Modules linked in: appletalk
video output input_polldev nfsd auth_rpcgss exportfs nfs lockd nfs_acl
sunrpc xfs bonding lp ppdev psmouse pcspkr k8temp serio_raw i2c_piix4 r8168
snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc parport_pc
parport shpchp ohci1394 ieee1394 sata_mv raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear fbcon tileblit font
bitblit softcursor
Mar 10 07:29:48 Edna kernel: [135073.510019] CPU 0:
Mar 10 07:29:48 Edna kernel: [135073.510019] Modules linked in: appletalk
video output input_polldev nfsd auth_rpcgss exportfs nfs lockd nfs_acl
sunrpc xfs bonding lp ppdev psmouse pcspkr k8temp serio_raw i2c_piix4 r8168
snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc parport_pc
parport shpchp ohci1394 ieee1394 sata_mv raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear fbcon tileblit font
bitblit softcursor
Mar 10 07:29:48 Edna kernel: [135073.510019] Pid: 1005, comm: md1_raid5 Not
tainted 2.6.28-16-server #57-Ubuntu
Mar 10 07:29:48 Edna kernel: [135073.510019] RIP: 0010:[<ffffffffa007f7c9>]
[<ffffffffa007f7c9>] raid6_sse24_gen_syndrome+0x1e9/0x28a [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019] RSP: 0018:ffff88012bd0db58
EFLAGS: 00000297
Mar 10 07:29:48 Edna kernel: [135073.510019] RAX: ffff8800ac397000 RBX:
ffff88012bd0db90 RCX: ffff8800ac3978a0
Mar 10 07:29:48 Edna kernel: [135073.510019] RDX: ffff8800ac397880 RSI:
0000000000001000 RDI: 00000000ffffffff
Mar 10 07:29:48 Edna kernel: [135073.510019] RBP: ffff88012bd0db90 R08:
0000000000000880 R09: 00000000000008a0
Mar 10 07:29:48 Edna kernel: [135073.510019] R10: 00000000000008b0 R11:
0000000000000890 R12: ffff88012bd0db48
Mar 10 07:29:48 Edna kernel: [135073.510019] R13: ffff88012bd0db48 R14:
ffff88012bd0dae0 R15: ffff88012f214000
Mar 10 07:29:48 Edna kernel: [135073.510019] FS:  00007f05d81076f0(0000)
GS:ffffffff80a9b000(0000) knlGS:0000000000000000
Mar 10 07:29:48 Edna kernel: [135073.510019] CS:  0010 DS: 0018 ES: 0018
CR0: 0000000080050033
Mar 10 07:29:48 Edna kernel: [135073.510019] CR2: 00007fdd92599760 CR3:
0000000000201000 CR4: 00000000000006a0
Mar 10 07:29:48 Edna kernel: [135073.510019] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Mar 10 07:29:48 Edna kernel: [135073.510019] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Mar 10 07:29:48 Edna kernel: [135073.510019] Call Trace:
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa007f811>] ?
raid6_sse24_gen_syndrome+0x231/0x28a [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa0076d9a>]
compute_parity6+0x20a/0x380 [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa0078696>]
handle_parity_checks6+0x1d6/0x360 [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa007c507>]
handle_stripe6+0xb07/0xbd0 [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa007d395>]
handle_stripe+0x25/0x30 [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffffa007d9f7>]
raid5d+0x1f7/0x300 [raid456]
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff8056864c>]
md_thread+0x5c/0x140
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff80268a50>] ?
autoremove_wake_function+0x0/0x40
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff805685f0>] ?
md_thread+0x0/0x140
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff802685e9>]
kthread+0x49/0x90
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff80213979>]
child_rip+0xa/0x11
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff802685a0>] ?
kthread+0x0/0x90
Mar 10 07:29:48 Edna kernel: [135073.510019]  [<ffffffff8021396f>] ?
child_rip+0x0/0x11
Mar 10 07:33:03 Edna kernel: [135268.444637] md: md1: requested-resync done.


