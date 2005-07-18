From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: 2.6.13-rc3 (ide ?) kernel crash
Date: Tue, 19 Jul 2005 00:06:32 +0300
Message-ID: <96921040.20050719000632@netvision.net.il>
References: <1057870318.20050718195400@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <1057870318.20050718195400@netvision.net.il>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, this was for linux-kernel.

Thanks,

Maxim.

MK> Hi!
MK> Trying 2.6.13-rc3 for Supermicro dual Xeon x86_64 with maxcpus=1 (because of
MK> hyperthreading bug) I get an ide-related (?) kernel crash:
MK> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
MK> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
MK> hdb: HL-DT-STCD-RW/DVD DRIVE GCC-4240N, ATAPI CD/DVD-ROM drive
MK> ide1: I/O resource 0x170-0x177 not free.
MK> ide1: ports already in use, skipping probe
MK> Unable to handle kernel NULL pointer dereference at 0000000000000020 RIP:
MK> <ffffffff80297940>{init_irq+448}
MK> PGD 0
MK> Oops: 0000 [1] SMP
MK> CPU 0
MK> Modules linked in:
MK> Pid: 1, comm: swapper Not tainted 2.6.13-rc3
MK> RIP: 0010:[<ffffffff80297940>] <ffffffff80297940>{init_irq+448}
MK> RSP: 0018:ffff81007ff29e38  EFLAGS: 00010246
MK> RAX: 0000000000000000 RBX: 0000000000007580 RCX: 0000000000000000
MK> RDX: ffff810037e39500 RSI: 00000000000000d0 RDI: 0000000000000198
MK> RBP: ffffffff804f5200 R08: 0000000000000030 R09: 0000000000000002
MK> R10: 000000000000000e R11: 0000000000000000 R12: ffffffff804fc780
MK> R13: 00000000ffffffff R14: 0000ffffffff8010 R15: ffffffff8051bfb0
MK> FS:  0000000000000000(0000) GS:ffffffff8050f800(0000) knlGS:0000000000000000
MK> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
MK> CR2: 0000000000000020 CR3: 0000000000101000 CR4: 00000000000006e0
MK> Process swapper (pid: 1, threadinfo ffff81007ff28000, task ffff81007ff274d0)
MK> Stack: 0000000000000003 0000000000000246 0000000000000000 0000000000000000
MK>        0000000000000246 ffffffff804f5200 ffffffff804f5220 0000000000000001
MK>        0000000000000001 0000ffffffff8010
MK> Call Trace:<ffffffff80298138>{hwif_init+328}
MK> <ffffffff80298443>{ideprobe_init+131}
MK>        <ffffffff801be662>{create_proc_entry+146}
MK> <ffffffff8053a0a9>{ide_generic_init+9}
MK>        <ffffffff8010b249>{init+505}
MK> <ffffffff8010e93f>{child_rip+8}
MK>        <ffffffff8010b050>{init+0} <ffffffff8010e937>{child_rip+0}


MK> Code: 48 8b 40 20 48 0f b6 80 98 00 00 00 0f b6 90 c0 55 49 80 e8
MK> RIP <ffffffff80297940>{init_irq+448} RSP <ffff81007ff29e38>
MK> CR2: 0000000000000020
MK>  <0>Kernel panic - not syncing: Attempted to kill init!

MK> Please advise.

MK> Thanks,

MK> Maxim Kozover.


