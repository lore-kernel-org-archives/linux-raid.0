From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: apparent but not real raid1 failure. what happened? still confused. Gurus Please help...
Date: Mon, 2 May 2005 20:20:45 +0200
Message-ID: <tk7ik2-4f2.ln1@news.it.uc3m.es>
References: <200505021224.35396.mlaks@verizon.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks <mlaks@verizon.net> wrote:
> Initially, one raid failed:
> /dev/md0 between /dev/hda1 and
> /dev/hdg1 with the /dev/hdg1 on a highpoint rocket 133 controller.

> From reading the log files I see that initially /dev/hda1 died

Yes, but then so did hdg1.

Or at least they were slow replying, or perhaps spun down.


> Apr 21 07:36:01 A2 kernel: hda: dma_intr: status=0x51 { DriveReady
> SeekComplete Error }
> Apr 21 07:36:01 A2 kernel: hda: dma_intr: error=0x40 { UncorrectableError },
> LBAsect=209715335, high=12, low=8388743, sector=209
> 715335
> Apr 21 07:36:01 A2 kernel: end_request: I/O error, dev hda, sector 209715335

Well, this seems to be a bona fide error on hda.  It's about 100GB in.
Is that right? Looks like slow wakeup, or tracking problem.

Anyway, it might have been a read error. Those happen. I posted a patch
("robust raid") to stop the disk being faulted out of the array on
those errors, letting the other disk be tried instead.

> Apr 21 07:36:01 A2 kernel:  disk 1, wo:0, o:1, dev:hdg1
> Apr 21 07:36:01 A2 kernel: RAID1 conf printout:
> Apr 21 07:36:01 A2 kernel:  --- wd:1 rd:2
> Apr 21 07:36:01 A2 kernel:  disk 1, wo:0, o:1, dev:hdg1
> Apr 21 07:36:01 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
> another mirror

Oh, well after faulting out hda1, hdg1 got tried anyay.

> Apr 21 07:36:21 A2 kernel: hdg: dma_timer_expiry: dma status == 0x20
> Apr 21 07:36:21 A2 kernel: hdg: DMA timeout retry
> Apr 21 07:36:21 A2 kernel: hdg: timeout waiting for DMA
> Apr 21 07:36:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
> SeekComplete DataRequest }

But it was not ready either.  It looks like neither disk is especially
happy using that mode of dma.  I'd play with hdparm!

> Apr 21 07:36:21 A2 kernel: hdg: drive not ready for command
> Apr 21 07:36:21 A2 kernel: raid1: hdg1: rescheduling sector 209715272
> Apr 21 07:36:21 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
> another mirror

That's a silly (harmless) raid bug. There is no other mirror.

> and then /dev/hdg1 immediately began to spew forth error messages of the
> following sort 

> Apr 22 22:29:21 A2 kernel: hdg: status error: status=0x58 { DriveReady
> SeekComplete DataRequest }
> Apr 22 22:29:21 A2 kernel:
> Apr 22 22:29:21 A2 kernel: hdg: drive not ready for command
> Apr 22 22:29:21 A2 kernel: raid1: hdg1: rescheduling sector 209715272
> Apr 22 22:29:21 A2 kernel: raid1: hdg1: redirecting sector 209715272 to
> another
> mirror

Well, maybe not so harmless.  Same sector every time. It never learns.

> These errors continued nonstop all day/night until /
> var ran out of space and errors filled the 6GB /var partition.

Shrug. They were harmless otherwise.

> 2.6GB of         /var/log/kern.log and

You need to practice better log control!

> 2.6GB of        /var/log/syslog and
> 1GB of          /var/log/messages
> were filled by these errors.

Unfortunate, but not terribly harmful.


> I then pulled the two drives out of the system and 

There's nothing wrong with them as far as I can see!  Just let them cool
down or use another dma mode, or rewrite the god*mn bad sector and let
them go on their merry way.

> put a pair of new drives in for /dev/hda1 and /dev/hdg1 and

Nooooooo.

> and created /dev/md0 anew, and restored the data to my servers from backups.


It is not likely that both disks are kaput. It's not even likely that
one disk was. It's likely that your controller or disk was not happy
with the dma mode, or simply that you had the immense bad luck to get a
read error from the same sector on both. That's not disastrous. It
sounds like it's something in common about your machine, since errors
are really unlikely on the same sector in two independent drives!


> I then took the two drives /dev/hda1 and /dev/hdg1 to another machine
> and ran the Western Digital drive diagnostics on both of them and they 
> are both fine. No errors.

See!


> Has anyone else had this trouble? Could someone explain what happened?

Sure - you saw what happened. Read error. Leading to raid ejection.
Leading to admin panic.



> What should I have done when I found the errors when my system failed?

Nothing.  Nothing was very wrong.  Rewrite the failed sector with zeros,
at worst, and restart the raid array, and take the 512B loss like a man.

But I'd be looking hard at your dma settings! You can't leave the disks
in that setting - they error!

You might also be inspecting cables or anything else that occurs to you
to check. Heat?

But by all accounts (your report), nothing was really deeply wrong!

You needed to force the raid to restart.  I think a mkraid --force would
have done the trick.  I'm wondering whether to use
--dangerous-no-resync, because a rewrite would be nice in order to at
least warm up and fix one disk!  But would it read the bad sector?
Maybe.  Maybe not. That dma setting needs changing.

Perhaps you also want to check for disk settings (if you can get at
them) like "error on read error", or "replace bad sector on read".
You might have a SMART control that can do that.


> Is it safe for me to continue to use raid1?

Not if you continue to do that, unfortunately - most likely nothing was
wrong at all and the array merely needed restarting to correct its.
overzealous action in ejecting the disk after read error.  I think
that's going a bit far, and one should tell it not to do that and get on
with life.  But you rather paniced and took it all offline instead of
kicking its pants and telling it to calm down and be a good boy.

My "robost raid" patch purports to at least stop the disk being kicked
on a read error, but it's not clear that it would have helped here
because BOTH disks failed on that sector.  It looks as though your
motherboard was a bit hot to the touch at that moment ...

Peter

