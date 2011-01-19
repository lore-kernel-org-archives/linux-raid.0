From: Cory Coager <ccoager@gmail.com>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 10:52:11 -0500
Message-ID: <20110119155211.GA31671@erebus.underworld.local>
References: <4D365551.7090207@gmail.com>
 <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
 <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
 <4D365BE2.9020300@gmail.com>
 <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 19, 2011 at 01:19:18PM -0200, Roberto Spadim wrote:
> ok,
> but if you don?t sync file system (remove from memory and put in disk
> controller)
> you will lost information with or without a batery
> 
> how to don?t lose information?
> don?t power down you memory,cpu, disk controller (sata controler, raid
> controller, or anyother) and disks (does it have a batery? a super
> capacitor?)
> if you power down, be sure that all memory was send to disk controller
> and that disk controller have energy (batery or capacitor) to send
> information to disks (they need batery or capacitor too)
> 
> right?
> so, a ups can power cpu, memory, disk controller and disks with only
> one batery (not a batery for each device cpu,memory,disk,disk
> controller)
> the best world could be a non volatile memory (250mb/s flash 4kb
> block) with the speed of volatile memory (10000mb/s ddr3 i don?t know
> the block size)

It would have to work the same as a hardware RAID controller.
Information is first written to the cache then synced to the
disk.  If the data is in the cache but not on the disk, the
machine loses power, next boot up the software raid would need a
way to flush the data from the ram disk to the disk.  Of course
this would require the battery be in working condition, as with
any hardware.

Hopefully I've explained that well enough.  Perhaps it will be
better to see the hardware I'm talking about:
http://techreport.com/articles.x/16255
