From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: Thu, 22 Mar 2007 17:31:14 -0700
Message-ID: <e9c3a7c20703221731p2eeb727eo44eb12ec9287d2c0@mail.gmail.com>
References: <20070322184155.GY19922@kernel.dk>
	 <20070322185413.13929.qmail@science.horizon.com>
	 <20070322190052.GA19922@kernel.dk>
	 <17923.6258.855467.589548@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17923.6258.855467.589548@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux@horizon.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@dale.us, cebbert@redhat.com
List-Id: linux-raid.ids

On 3/22/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday March 22, jens.axboe@oracle.com wrote:
> > On Thu, Mar 22 2007, linux@horizon.com wrote:
> > > > 3 (I think) seperate instances of this, each involving raid5. Is your
> > > > array degraded or fully operational?
> > >
> > > Ding! A drive fell out the other day, which is why the problems only
> > > appeared recently.
> > >
> > > md5 : active raid5 sdf4[5] sdd4[3] sdc4[2] sdb4[1] sda4[0]
> > >       1719155200 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUU_U]
> > >       bitmap: 149/164 pages [596KB], 1024KB chunk
> > >
> > > H'm... this means that my alarm scripts aren't working.  Well, that's
> > > good to know.  The drive is being re-integrated now.
> >
> > Heh, at least something good came out of this bug then :-)
> > But that's reaffirming. Neil, are you following this? It smells somewhat
> > fishy wrt raid5.
>
> Yes, I've been trying to pay attention....
>
> The evidence does seem to point to raid5 and degraded arrays being
> implicated.  However I'm having trouble finding how the fact that an array
> is degraded would be visible down in the elevator except for having a
> slightly different distribution of reads and writes.
>
> One possible way is that if an array is degraded, then some read
> requests will go through the stripe cache rather than direct to the
> device.  However I would more expect the direct-to-device path to have
> problems as it is much newer code.  Going through the cache for reads
> is very well tested code - and reads come from the cache for most
> writes anyway, so the elevator will still see lots of single-page.
> reads.  It only ever sees single-page write.
>
> There might be more pressure on the stripe cache when running
> degraded, so we might call the ->unplug_fn a little more often, but I
> doubt that would be noticeable.
>
> As you seem to suggest by the patch, it does look like some sort of
> unlocked access to the cfq_queue structure.  However apart from the
> comment before cfq_exit_single_io_context being in the wrong place
> (should be before __cfq_exit_single_io_context) I cannot see anything
> obviously wrong with the locking around that structure.
>
> So I'm afraid I'm stumped too.
>
> NeilBrown

Not a cfq failure, but I have been able to reproduce a different oops
at array stop time while i/o's were pending.  I have not dug into it
enough to suggest a patch, but I wonder if it is somehow related to
the cfq failure since it involves congestion and drives going away:

md: md0: recovery done.
Unable to handle kernel NULL pointer dereference at virtual address 000000bc
pgd = 40004000
[000000bc] *pgd=00000000
Internal error: Oops: 17 [#1]
Modules linked in:
CPU: 0
PC is at raid5_congested+0x14/0x5c
LR is at sync_sb_inodes+0x278/0x2ec
pc : [<402801cc>]    lr : [<400a39e8>]    Not tainted
sp : 8a3e3ec4  ip : 8a3e3ed4  fp : 8a3e3ed0
r10: 40474878  r9 : 40474870  r8 : 40439710
r7 : 8a3e3f30  r6 : bfa76b78  r5 : 4161dc08  r4 : 40474800
r3 : 402801b8  r2 : 00000004  r1 : 00000001  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 400397F
Table: 7B7D4018  DAC: 00000035
Process pdflush (pid: 1371, stack limit = 0x8a3e2250)
Stack: (0x8a3e3ec4 to 0x8a3e4000)
3ec0:          8a3e3f04 8a3e3ed4 400a39e8 402801c4 8a3e3f24 000129f9 40474800
3ee0: 4047483c 40439a44 8a3e3f30 40439710 40438a48 4045ae68 8a3e3f24 8a3e3f08
3f00: 400a3ca0 400a377c 8a3e3f30 00001162 00012bed 40438a48 8a3e3f78 8a3e3f28
3f20: 40069b58 400a3bfc 00011e41 8a3e3f38 00000000 00000000 8a3e3f28 00000400
3f40: 00000000 00000000 00000000 00000000 00000000 00000025 8a3e3f80 8a3e3f8c
3f60: 40439750 8a3e2000 40438a48 8a3e3fc0 8a3e3f7c 4006ab68 40069a8c 00000001
3f80: bfae2ac0 40069a80 00000000 8a3e3f8c 8a3e3f8c 00012805 00000000 8a3e2000
3fa0: 9e7e1f1c 4006aa40 00000001 00000000 fffffffc 8a3e3ff4 8a3e3fc4 4005461c
3fc0: 4006aa4c 00000001 ffffffff ffffffff 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 8a3e3ff8 40042320 40054520 00000000 00000000
Backtrace:
[<402801b8>] (raid5_congested+0x0/0x5c) from [<400a39e8>]
(sync_sb_inodes+0x278/0x2ec)
[<400a3770>] (sync_sb_inodes+0x0/0x2ec) from [<400a3ca0>]
(writeback_inodes+0xb0/0xb8)
[<400a3bf0>] (writeback_inodes+0x0/0xb8) from [<40069b58>]
(wb_kupdate+0xd8/0x160)
 r7 = 40438A48  r6 = 00012BED  r5 = 00001162  r4 = 8A3E3F30
[<40069a80>] (wb_kupdate+0x0/0x160) from [<4006ab68>] (pdflush+0x128/0x204)
 r8 = 40438A48  r7 = 8A3E2000  r6 = 40439750  r5 = 8A3E3F8C
 r4 = 8A3E3F80
[<4006aa40>] (pdflush+0x0/0x204) from [<4005461c>] (kthread+0x108/0x134)
[<40054514>] (kthread+0x0/0x134) from [<40042320>] (do_exit+0x0/0x844)
Code: e92dd800 e24cb004 e5900000 e3a01001 (e59030bc)
md: md0 stopped.
md: unbind<sda>
md: export_rdev(sda)
md: unbind<sdd>
md: export_rdev(sdd)
md: unbind<sdc>
md: export_rdev(sdc)
md: unbind<sdb>
md: export_rdev(sdb)

2.6.20-rc3-iop1 on an iop348 platform.  SATA controller is sata_vsc.

--
Dan
