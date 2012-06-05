From: Krzysztof Adamski <k@adamski.org>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Tue, 05 Jun 2012 12:48:02 -0400
Message-ID: <1338914882.28212.365.camel@oxygen.netxsys.com>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
	 <20120604135619.402f4316@notabene.brown>
	 <1338815946.28212.307.camel@oxygen.netxsys.com>
	 <20120605133504.4a760a05@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120605133504.4a760a05@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2012-06-05 at 13:35 +1000, NeilBrown wrote:
> On Mon, 04 Jun 2012 09:19:06 -0400 Krzysztof Adamski <k@adamski.org> wrote:
> 
> > On Mon, 2012-06-04 at 13:56 +1000, NeilBrown wrote:
> > > On Sun, 03 Jun 2012 13:31:14 -0400 Krzysztof Adamski <k@adamski.org> wrote:
> > > 
> > > > The monthly data check found a bad drive in my raid6 array. This is what
> > > > started to show up in the log:
> > > > Jun  3 12:02:53 rogen kernel: [9908355.355940] sd 2:0:1:0: attempting task abort! scmd(ffff8801547c6a00)
> > > > Jun  3 12:02:53 rogen kernel: [9908355.355953] sd 2:0:1:0: [sdb] CDB: Read(10): 28 00 e4 5c ed 38 00 00 08 00
> > > > Jun  3 12:02:53 rogen kernel: [9908355.355983] scsi target2:0:1: handle(0x0009), sas_address(0x4433221100000000), phy(0)
> > > > Jun  3 12:02:53 rogen kernel: [9908355.355992] scsi target2:0:1: enclosure_logical_id(0x500605b003f7aa10), slot(3)
> > > > Jun  3 12:02:56 rogen kernel: [9908359.141194] sd 2:0:1:0: task abort: SUCCESS scmd(ffff8801547c6a00)
> > > > Jun  3 12:02:56 rogen kernel: [9908359.141206] sd 2:0:1:0: attempting task abort! scmd(ffff8803aea45400)
> > > > Jun  3 12:02:56 rogen kernel: [9908359.141216] sd 2:0:1:0: [sdb] CDB: Read(10): 28 00 e4 5c ed 40 00 00 08 00
> > > > 
> > > > But now it has changed to this:
> > > > Jun  3 12:04:44 rogen kernel: [9908466.716281] sd 2:0:1:0: [sdb] Unhandled error code
> > > > Jun  3 12:04:44 rogen kernel: [9908466.716287] sd 2:0:1:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> > > > Jun  3 12:04:44 rogen kernel: [9908466.716296] sd 2:0:1:0: [sdb] CDB: Read(10): 28 00 e4 5c ee 38 00 00 08 00
> > > > Jun  3 12:04:44 rogen kernel: [9908466.716319] end_request: I/O error, dev sdb, sector 3831295544
> > > > Jun  3 12:04:44 rogen kernel: [9908466.716616] sd 2:0:1:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> > > > Jun  3 12:04:44 rogen kernel: [9908466.717200] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221100000000)
> > > > Jun  3 12:04:44 rogen kernel: [9908466.917090] md/raid:md7: Disk failure on sdb2, disabling device.
> > > > Jun  3 12:04:44 rogen kernel: [9908466.917091] md/raid:md7: Operation continuing on 11 devices.
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882541] INFO: task md7_resync:28497 blocked for more than 120 seconds.
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882552] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882556] md7_resync      D ffff8800b508aa20     0 28497      2 0x00000000
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882560]  ffff8802ab877b80 0000000000000046 ffff8803ffbfa340 0000000000000046
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882564]  ffff8802ab876010 ffff8800b508a6a0 00000000001d29c0 ffff8802ab877fd8
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882566]  ffff8802ab877fd8 00000000001d29c0 ffff880070448000 ffff8800b508a6a0
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882569] Call Trace:
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882577]  [<ffffffff81339704>] schedule+0x55/0x57
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882599]  [<ffffffffa01da26b>] bitmap_cond_end_sync+0xbc/0x152 [md_mod]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882602]  [<ffffffff8106190d>] ? wake_up_bit+0x25/0x25
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882607]  [<ffffffffa022f7a7>] sync_request+0x22e/0x2ef [raid456]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882613]  [<ffffffffa01d1ebc>] ? is_mddev_idle+0x106/0x118 [md_mod]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882618]  [<ffffffffa01d2689>] md_do_sync+0x7bb/0xbce [md_mod]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882624]  [<ffffffffa01d2cbe>] md_thread+0xff/0x11d [md_mod]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882629]  [<ffffffffa01d2bbf>] ? md_rdev_init+0x8d/0x8d [md_mod]
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882631]  [<ffffffff81061499>] kthread+0x9b/0xa3
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882634]  [<ffffffff81342ca4>] kernel_thread_helper+0x4/0x10
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882637]  [<ffffffff810613fe>] ? __init_kthread_worker+0x56/0x56
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882639]  [<ffffffff81342ca0>] ? gs_change+0x13/0x13
> > > > Jun  3 12:07:41 rogen kernel: [9908643.882641] INFO: lockdep is turned off.
> > > > 
> > > > The cat /proc/mdstat is:
> > > > Personalities : [raid1] [raid6] [raid5] [raid4]
> > > > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> > > >       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [12/11] [UUU_UUUUUUUU]
> > > >       [=============>.......]  check = 65.3% (1913765076/2928312160) finish=44345.9min speed=381K/sec
> > > >       bitmap: 1/22 pages [4KB], 65536KB chunk
> > > > 
> > > > I don't really want to wait 30 days for this to finish, what is correct
> > > > thing to do before I replace the failed drive?
> > > >
> > > 
> > > If it is still hanging, then I suspect a reboot is your only way forward.
> > > This should not affect the data on the array.
> > 
> > Nothing more is being written to the log, but there is no progress:
> > 
> > Personalities : [raid1] [raid6] [raid5] [raid4]
> > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde2[7] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
> >       29283121600 blocks super 1.2 level 6, 32k chunk, algorithm 2 [12/11] [UUU_UUUUUUUU]
> >       [=============>.......]  check = 65.3% (1913765076/2928312160) finish=660982.5min speed=25K/sec
> >       bitmap: 4/22 pages [16KB], 65536KB chunk
> > 
> > 
> > > What kernel are you running?  I'll see if I can find the cause.
> > 
> > Self compiled:
> > # cat /proc/version 
> > Linux version 3.0.18-KAA (root@rogen) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Fri Jan 27 18:35:11 EST 2012
> > 
> > I can provide any other info that is needed.
> 
> Thanks.
> I have a theory about what might be causing it, but I cannot duplicated the
> problem.  I think you were quite "unlucky" to hit it.
> 
> If I'm right you might be able to kick the 'check' back into life by reading
> from the area of the array that is currently being synced. i.e. about 
> 19137650760K into the array.
> 
> dd skip=19137650000 bs=1024 count=2000 if=/dev/md7 of=/dev/null
> 
> might do it.
> 
> The thread that is doing the 'check' is blocked in bitmap_cond_sync_end,
> waiting for all pending check requests to complete.  It only does this every
> 5 seconds or so, so oncs in hundreds of requests.  (It doesn't really need to
> for 'check', only for 'sync', but it does anyway).
> 
> But for some reason one request isn't completing.  That should mean that
> STRIPE_INSYNC is not yet set on a 'struct stripe_head'.
> 
> I'm guessing that it has processed by handle_parity_checks6, noticed in the
> check_state_check_result  case that s->failed is non-zero, and so set 
> sh->check_state to check_state_compute_result, but then nothing caused
> the stripe to go around the loop again.  The code there should probably
> set STRIPE_HANDLE.. Maybe.
> 
> If the dead disk provides data to that stripe, rather than parity, then the
> read should set STRIPE_HANDLE and the handling of the stripe can progress.
> 
> It might not work, but it is worth a try.  What should happen is that the
> check will immediately abort.  If it doesn't you probably need to schedule a
> reboot ... if you haven't already.

I had to do a reboot already.

The drive was wedged for same reason, activity light solid, soft reboot
(shutdown -r now) didn't wake it up, the card bios didn't see it. I
pulled and reinserted it for it to be recognized by the LSI card.

I added it to the array and the rebuild took few minutes (thanks for the
bitmap). I forced a recheck and after 12 hours everything is good.

This was not the first time where I saw this kind of stop in the check
when one drive stops working in this machine, but with different adaptor
card and different drives. I will try what you suggested if it happens
again. 

Now I wonder if I should have just pulled/reinserted the drive to see
what would have happened.

K

