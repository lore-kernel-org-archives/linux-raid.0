From: drtebi@drtebi.com
Subject: Re: RAID1 always resyncs at boot???
Date: Thu, 27 Nov 2003 20:57:44 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <hp1ps8.7u9xet@mail.drtebi.com>
References: <hp0nmt.3pm23q@mail.drtebi.com> <16326.34106.78894.57151@notabene.cse.unsw.edu.au> <hp1alh.rftuxt@mail.drtebi.com> <16326.36888.900928.183987@notabene.cse.unsw.edu.au> <hp1on7.90c5en@mail.drtebi.com> <16326.53667.624406.368072@notabene.cse.unsw.edu.au>
Reply-To: drtebi@drtebi.com
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16326.53667.624406.368072@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am rebuilding the array now, it will take about 2 hours.

The way to do it is to unmount /dev/md0, and then issue
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/hd[ac]1
correct?

Trying to mark the drive faulty and add it back in (as described in the man
page) does not work. But I suppose that couldn't, since it's already faulty.

You said it might be the power supply? I have a 350 Watt power supply in
there, kind of a cheap one I think. I thought too that connecting 4 drives to
it might be a bit much.

However, if I do the "unplugged concert" again, and the RAID fails to
reconstruct again, what do you suggest? Try another power supply? Give it up,
spend $200 more on SCSI drives? I am a bit clueless, I thought I would sleep
better when having a RAID1 for my data, so far it's the opposite :(

DrTebi


--- Neil Brown <neilb@cse.unsw.edu.au> wrote:

> On Thursday November 27, drtebi@drtebi.com wrote:
> > 
> > in my log:
> > Nov 28 04:41:44 [kernel] hda: dma_intr: status=0x51 { DriveReady
> SeekComplete
> > Error }
> > Nov 28 04:41:44 [kernel] md: (skipping faulty
> > ide/host0/bus0/target0/lun0/part1 )
> > Nov 28 04:41:45 [kernel] hda: dma_intr: status=0x51 { DriveReady
> SeekComplete
> > Error }
> >                 - Last output repeated 8 times -
> > Nov 28 04:41:56 [kernel] md: md_do_sync() got signal ... exiting
> > Nov 28 04:41:56 [kernel] raid1: mirror resync was not fully finished,
> > restarting next time.
> > 
> > Does this mean one of the drives is bad?
> 
> Well, it means one of your drives return an error, so it was kicked
> out of the array.
> Whether it is the drive that is bad, or the controller, or the
> power-supply, I cannot know.
> You could try removing it from the array and putting it back, and let
> it rebuild, and see if the problem happens again.
> 
> > 
> > -------------
> > bully@drtebi: mdadm --query /dev/md0
> > /dev/md0: 114.49GiB raid1 2 devices, 0 spares. Use mdadm --detail for more
> > detail.
> > /dev/md0: No md super block found, not an md component.
> > 
> > The last message is weird... no md super block?
> 
> That is proper.  /dev/md0 is not a component of another md, so it
> doesn't have a superblock on it (the individual drives have
> superblocks, not the array).
> 
> > 
> > Thanks,
> > DrTebi
> > 
> > P.S.: I don't really like IDE drives :(
> > 
> Me neither.
> 
> NeilBrown
> 



