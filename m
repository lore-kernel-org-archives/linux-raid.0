From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: new raid system for home use
Date: Tue, 20 Apr 2004 03:14:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404200314.04968.maarten@vbvb.nl>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 18 April 2004 20:49, Mark Hahn wrote:
> > three terabyte capacity.  My tentative plan is to use 8 of the new
> > Hitachi Deskstar 7K400 400 GB SATA drives in a RAID-5 configuration, and

My own home setup consists of 5+2 x 80GB IDE disks yielding an array of 400GB 
space. It uses 3 cheap promise ATA cards and uses raid5.  It is full to the 
brim now, so funds permitting I will build a new bigger array this somewhere 
this year...

> > additional drives in a RAID-1 configuration as the boot device and higher
> > priority data storage.
>
> I wouldn't bother, since raid5 is plenty fast.  it's nothing but marketing
> that the storage vendors push this concept of "near-line" disk storage.

I myself preferred to use a small old 8 GB bootdrive. It needn't be 
fault-tolerant; I can live with the OS dying one day: my data is not in 
danger.

> naturally, a lot of disks should make you very concerned for the
> size of your power supply.

Be that as it may, my system above (with eight disks!) runs happily off a 
high-quality 300 Watt PSU.  Ide disks don't draw such high currents anymore, 
look at the label.  Typically both rails are loaded well under 1 amp.
(Yes, I realize spin-up current can be a killer, but as I said, it works fine)
Moreover, I have them spinning down when idle for 4 hours, so if those startup 
currents were that severe, I would have killed my PSU years ago...)

> >   * open source drivers for all components if possible, or most if not
> >   * all things being equal, the quieter and cooler-running version
>
> big PSU's tend not to be quiet.  and even though modern non-SCSI disks
> are quiet, enough of them does make some noise.

Advice: definitely go for a PSU that's equipped with a 120mm fan. They're 
really very quiet, you'll be surprised. You can recognize them easily since 
the fan will be mounted at the bottom [intake], horizontally. 

> >   * endless oodles of CPU (I'd think 2x3GHz would be megaplenty)
>
> too much, I'd say.  a single p4/2.6 would be fine.  it's true though that
> if you have your heart set on high bandwidth, that necessitates PCI-X,
> and they're uncommonly found outside of dual xeon/opteron "server" boards.
> you can, of course, sensibly run such a board with 1 cpu.

If it is only for the raid5 calculations, don't bother.  I changed my server 
motherboards at one time, it had a lowly AMD K6 before, it has dual celerons 
now (SMP). There was no noticeable speed difference whatsoever.
And both those boards are dead _slow_ compared to current systems.

> big storage should be left in big chunks, unles there's some good reason
> for it.

I fully concur.

> 400W PS is not enough for 8-10 disks, and you probably want

I will agree on the "better be safe than sorry" aspect, but as I said above, a 
normal (but good quality!) PSU can, and does, handle 8 disks if need be.
(I'm not talking about scsi disks though!)

> note also that 5.25 bays are in some ways a disadvantage, since all
> disks are 3.5 (and you probably want a couple multi-bay hotswap
> converters that put, eg, 4 3.5's in 3 5.25's.)

I disagree.  Disks tend to die in a too hot environment. So I mounted all 
disks in 5.25" bays (thus leaving lots of air space) and ripped out the whole 
plastic front to mount two papst silent 120mm fans right in front of the 
disks.  These babies don't even know what 30 degrees celsius feels like ;-)) 

Good luck!
Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
