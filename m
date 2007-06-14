From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: raid1 with nbd member hangs MD on SLES10 and RHEL5
Date: Thu, 14 Jun 2007 17:57:01 -0400
Message-ID: <170fa0d20706141457y86d7c8p1289e02a8ffce3ad@mail.gmail.com>
References: <170fa0d20706121930g3b89ddeex8b31c8923d2a0ff6@mail.gmail.com>
	 <18031.22930.243723.550238@notabene.brown>
	 <170fa0d20706121959w480213bcvaba1b6881710379f@mail.gmail.com>
	 <170fa0d20706122009h5e3db54ek7487be4940a3d780@mail.gmail.com>
	 <18031.25581.353761.802283@notabene.brown>
	 <170fa0d20706122130q2c77d365tbe9261bab1a5b1b@mail.gmail.com>
	 <170fa0d20706131123q17e4fb9ehe6be25a07462cc30@mail.gmail.com>
	 <170fa0d20706131630p6cd29aa5i8f51856780a9c691@mail.gmail.com>
	 <4671AD7C.4010109@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754511AbXFNV5V@vger.kernel.org>
In-Reply-To: <4671AD7C.4010109@tmr.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, nbd-general@lists.sourceforge.net, Herbert Xu <herbert@gondor.apana.org.au>, Paul Clements <Paul.Clements@steeleye.com>
List-Id: linux-raid.ids

On 6/14/07, Bill Davidsen <davidsen@tmr.com> wrote:
> Mike Snitzer wrote:
> > On 6/13/07, Mike Snitzer <snitzer@gmail.com> wrote:
> >> On 6/13/07, Mike Snitzer <snitzer@gmail.com> wrote:
> >> > On 6/12/07, Neil Brown <neilb@suse.de> wrote:
> >> ...
> >> > > > > On 6/12/07, Neil Brown <neilb@suse.de> wrote:
> >> > > > > > On Tuesday June 12, snitzer@gmail.com wrote:
> >> > > > > > >
> >> > > > > > > I can provided more detailed information; please just ask.
> >> > > > > > >
> >> > > > > >
> >> > > > > > A complete sysrq trace (all processes) might help.
> >>
> >> Bringing this back to a wider audience.  I provided the full sysrq
> >> trace of the RHEL5 kernel to Neil; in it we saw that md0_raid1 had the
> >> following trace:
> >>
> >> md0_raid1     D ffff810026183ce0  5368 31663     11          3822
> >> 29488 (L-TLB)
> >>  ffff810026183ce0 ffff810031e9b5f8 0000000000000008 000000000000000a
> >>  ffff810037eef040 ffff810037e17100 00043e64d2983c1f 0000000000004c7f
> >>  ffff810037eef210 0000000100000001 000000081c506640 00000000ffffffff
> >> Call Trace:
> >>  [<ffffffff8003e371>] keventd_create_kthread+0x0/0x61
> >>  [<ffffffff801b9364>] md_super_wait+0xa8/0xbc
> >>  [<ffffffff8003e711>] autoremove_wake_function+0x0/0x2e
> >>  [<ffffffff801b9adb>] md_update_sb+0x1dd/0x23a
> >>  [<ffffffff801bed2a>] md_check_recovery+0x15f/0x449
> >>  [<ffffffff882a1af3>] :raid1:raid1d+0x27/0xc1e
> >>  [<ffffffff80233209>] thread_return+0x0/0xde
> >>  [<ffffffff8023279c>] __sched_text_start+0xc/0xa79
> >>  [<ffffffff8003e371>] keventd_create_kthread+0x0/0x61
> >>  [<ffffffff80233a9f>] schedule_timeout+0x1e/0xad
> >>  [<ffffffff8003e371>] keventd_create_kthread+0x0/0x61
> >>  [<ffffffff801bd06c>] md_thread+0xf8/0x10e
> >>  [<ffffffff8003e711>] autoremove_wake_function+0x0/0x2e
> >>  [<ffffffff801bcf74>] md_thread+0x0/0x10e
> >>  [<ffffffff8003e5e7>] kthread+0xd4/0x109
> >>  [<ffffffff8000a505>] child_rip+0xa/0x11
> >>  [<ffffffff8003e371>] keventd_create_kthread+0x0/0x61
> >>  [<ffffffff8003e513>] kthread+0x0/0x109
> >>  [<ffffffff8000a4fb>] child_rip+0x0/0x11
> >>
> >> To which Neil had the following to say:
> >>
> >> > > md0_raid1 is holding the lock on the array and trying to write
> >> out the
> >> > > superblocks for some reason, and the write isn't completing.
> >> > > As it is holding the locks, mdadm and /proc/mdstat are hanging.
> > ...
> >
> >> > We're using MD+NBD for disaster recovery (one local scsi device, one
> >> > remote via nbd).  The nbd-server is not contributing to md0.  The
> >> > nbd-server is connected to a remote machine that is running a raid1
> >> > remotely
> >>
> >> To take this further I've now collected a full sysrq trace of this
> >> hang on a SLES10 SP1 RC5 2.6.16.46-0.12-smp kernel, the relevant
> >> md0_raid1 trace is comparable to the RHEL5 trace from above:
> >>
> >> md0_raid1     D ffff810001089780     0  8583     51          8952
> >> 8260 (L-TLB)
> >> ffff810812393ca8 0000000000000046 ffff8107b7fbac00 000000000000000a
> >>        ffff81081f3c6a18 ffff81081f3c67d0 ffff8104ffe8f100
> >> 000044819ddcd5e2
> >>        000000000000eb8b 00000007028009c7
> >> Call Trace: <ffffffff801e1f94>{generic_make_request+501}
> >>        <ffffffff8026946c>{md_super_wait+168}
> >> <ffffffff80145aa2>{autoremove_wake_function+0}
> >>        <ffffffff8026f056>{write_page+128}
> >> <ffffffff80269ac7>{md_update_sb+220}
> >>        <ffffffff8026bda5>{md_check_recovery+361}
> >> <ffffffff883a97f5>{:raid1:raid1d+38}
> >>        <ffffffff8013ad8f>{lock_timer_base+27}
> >> <ffffffff8013ae01>{try_to_del_timer_sync+81}
> >>        <ffffffff8013ae16>{del_timer_sync+12}
> >> <ffffffff802d9adf>{schedule_timeout+146}
> >>        <ffffffff801456a9>{keventd_create_kthread+0}
> >> <ffffffff8026d5d8>{md_thread+248}
> >>        <ffffffff80145aa2>{autoremove_wake_function+0}
> >> <ffffffff8026d4e0>{md_thread+0}
> >>        <ffffffff80145965>{kthread+236} <ffffffff8010bdce>{child_rip+8}
> >>        <ffffffff801456a9>{keventd_create_kthread+0}
> >> <ffffffff80145879>{kthread+0}
> >>        <ffffffff8010bdc6>{child_rip+0}
> >>
> >> Taking a step back, here is what was done to reproduce on SLES10:
> >> 1) establish a raid1 mirror (md0) using one local member (sdc1) and
> >> one remote member (nbd0)
> >> 2) power off the remote machine, whereby severing nbd0's connection
> >> 3) perform IO to the filesystem that is on the md0 device to enduce
> >> the MD layer to mark the nbd device as "faulty"
> >> 4) cat /proc/mdstat hangs, sysrq trace was collected and showed the
> >> above md0_raid1 trace.
> >>
> >> To be clear, the MD superblock update hangs indefinitely on RHEL5.
> >> But with SLES10 it eventually succeeds (and MD marks the nbd0 member
> >> faulty); and the other tasks that were blocking waiting for the MD
> >> lock (e.g. 'cat /proc/mdstat') then complete immediately.
> >>
> >> It should be noted that this MD+NBD configuration has worked
> >> flawlessly using a stock kernel.org 2.6.15.7 kernel (ontop of a
> >> RHEL4U4 distro).  Steps have not been taken to try to reproduce  with
> >> 2.6.15.7 on SLES10; it may be useful to pursue but I'll defer to
> >> others to suggest I do so.
> >>
> >> 2.6.15.7 does not have the SMP race fixes that were made in 2.6.16;
> >> yet both SLES10 and RHEL5 kernels do:
> >> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4b2f0260c74324abca76ccaa42d426af163125e7
> >>
> >>
> >> If not this specific NBD change, something appears to have changed
> >> with how NBD behaves in the face of it's connection to the server
> >> being lost.  Almost like the MD superblock update that would be
> >> written to nbd0 is blocking within nbd or the network layer because of
> >> a network timeout issue?
> >
> > Just a quick update; it is really starting to look like there is
> > definitely an issue with the nbd kernel driver.  I booted the SLES10
> > 2.6.16.46-0.12-smp kernel with maxcpus=1 to test the theory that the
> > nbd SMP fix that went into 2.6.16 was in some way causing this MD/NBD
> > hang.  But it _still_ occurs with the 4-step process I outlined above.
> >
> First, running an smp kernel with maxcpus=1 is not the same as running a
> uni kernel, not is nosmp option. The code is different.

I tried nosmp and this dell 8-way I'm using wouldn't boot...

> Second, AFAIK nbd hasn't working in a while. I haven't tried it in ages,
> but was told it wouldn't work with smp and I kind of lost interest. If
> Neil thinks it should work in 2.6.21 or later I'll test it, since I have
> a machine which wants a fresh install soon, and is both backed up and
> available.

I'm fairly certain that this is an nbd issue and MD is hanging as a
side-effect of nbd getting wedged.  As far as nbd not working on SMP;
I thought Herbert Xu fixed it in 2.6.16?

Is that to say that his fix was incomplete and/or useless?

Who is the maintainer of the nbd code in the kernel?

regards,
Mike
