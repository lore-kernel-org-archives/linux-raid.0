From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Software raid - controller options
Date: Wed, 07 Nov 2007 10:49:00 +0100
Message-ID: <877ikujshf.fsf@informatik.uni-tuebingen.de>
References: <1194315635.17361.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194315635.17361.20.camel@localhost.localdomain> (Lyle
	Schlueter's message of "Tue, 06 Nov 2007 05:20:35 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: Lyle Schlueter <lyle@xkubed.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lyle Schlueter <lyle@xkubed.com> writes:

> Hello,
>
> I just started looking into software raid with linux a few weeks ago. I
> am outgrowing the commercial NAS product that I bought a while back.
> I've been learning as much as I can, suscribing to this mailing list,
> reading man pages, experimenting with loopback devices setting up and
> expanding test arrays. 
>
> I have a few questions now that I'm sure someone here will be able to
> enlighten me about.
> First, I want to run a 12 drive raid 6, honestly, would I be better of
> going with true hardware raid like the areca ARC-1231ML vs software
> raid? I would prefer software raid just for the sheer cost savings. But
> what kind of processing power would it take to match or exceed a mid to
> high-level hardware controller?

We are setting up a lustre storage cluster at the moment.

- 60 external dual channel scsi raid boxes
- 16 750G SATA disks per box.
- Total raw capacity 720 TiB
- 20 8 core server with 3 dual channel scsi controlers each

We run raid6 on the hardware raid and export it to both channels. Each
scsi channel give 150-200MiB/s per raid box.

We partitioned each raid box into 6 luns. As each raid box is
connected to 2 servers there are 3 luns for each. Then each server
runs a 3 raid6 over the 6 raid boxes (one raid6 per lun). [This has 2
reasons: 1) we need <8TiB per filesystem, 2) we need multiple raids so
multiple cores are used in parallel for raid]

Now accessing the 3 raid6s on each server in parallel we get ~500MiB/s
writing and ~800MiB reading. On writes the raid boxes are not fully
utilized. The ram throughput and/or cpu speed is the limit
there. Meaning that 3 cores will be 100% busy just for the raid.


In conclusion: Software raid can compete just fine and outperform
pretty much any hardware raid but you pay for it with cpu time.

But this is raid6, which is rather expensive. A raid0 or raid1 costs
hardly any cpu at all. Just bandwidth to the controler. I also tested
an external 16 box SATA JBOD box [meaning real cheap] with a 4 lane
SAS connector [also quite cheap] with software raid0 and measured
980MiB/s throughput on some test system we had lying around. That is
about the limit of the PCIe (or was it PCI-X?) slot the controler
used.

^^^ JBOD - Just a Bunch Of Disks

> I haven't seen much, if any, discussion of this, but how many drives are
> people putting into software arrays? And how are you going about it?

The MTBF (mean time between failures) goes down eponentially with the
number of disks in an raid. So at some point the chance of 3 disks
failing in your raid6 (and data loss) becomes bigger than a (specific)
single disk failing. I've never actually done the math, just gut
feeling, but I wouldn't do a raid5 over >8 disks and no raid6 over >16
disks. But then again I never had 24 disks in a system yet so I was
never tempted.

But the risk is the same for software and hardware raid. Would you run
a 24 disks hardware raid6?

> Motherboards seem to max out around 6-8 SATA ports. Do you just add SATA
> controllers? Looking around on newegg (and some googling) 2-port SATA
> controllers are pretty easy to find, but once you get to 4 ports the
> cards all seem to include some sort of built in *raid* functionality.
> Are there any 4+ port PCI-e SATA controllers cards? 

Pretty much all the cheap SATA cards include raid support
nowadays. But that is all software raid done via the bios and not
actual hardware raid. Under linux you will just see 2/4/8 disks. All
of them you can run in JBOD mode and you want that. Don't use the
pseudo raid from the cheap cards but use Linux software raid. Just
ignore all the raid stuff in the bios.

> Are there any specific chipsets/brands of motherboards or controller
> cards that you software raid veterans prefer?

I like my promise TX4 at home (pci) and at work I prefer the marvell
chips. We also have a lot of sil chips but they have some bug with
seagate disks (mod 15 bug it is called). Some chip and disk
combinations have to switch to turtle mode (wow, see how fast that
turtle runs :) to avoid data corruption. So do some research before
buying a sil chip.

> Thank you for your time and any info you are able to give me!
>
> Lyle

MfG
        Goswin
