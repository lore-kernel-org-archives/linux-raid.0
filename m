From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sun, 2 Feb 2003 01:06:36 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302020102410.3772-100000@uplift.swm.pp.se>
References: <Pine.LNX.4.44.0302011449420.12785-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302011449420.12785-100000@redhat1.mmaero.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003 jlewis@lewis.org wrote:

> So can this trick (connecting 14 to 15) be used as a work-around for brain 
> damaged motherboards that won't power-on after power-loss to keep a system 
> always on?

I don't know, but I wouldnt suggest it and I wouldnt do it on a production 
system without extensive testing first. I haven't seen the behaviour you 
suggest above in motherboards since a PPRO200-board way back, all newer 
boards I have worked with have an option in Power Save-settings as to what 
to do after a power loss and the following power return (that is usually 
default to the desktop setting, ie do not power on after power return).
  
> We have a dual PIII server with 2 9gb and 8 36gb drives running on a 450W 
> supply (IIRC), but those are all SCSI drives with various spin-up delays.

I have 9 IDE drives all powering up at the same time (mostly IBM 7200 rpm 
units) without any problems on my 350W).
 
> On another system we were using to test a large RAID array, we just rigged 
> up an AT power supply to half of the disks.  That works fine on the bench, 
> but is a little sloppy if you're trying to build a production server.

I know people that have done this as well when they have lots of drives. 
It's wa cheaper than trying to find a power supply with twice the output 
of a regular power supply.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

