From: Cory Coager <ccoager@gmail.com>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 12:02:52 -0500
Message-ID: <20110119170252.GA891@erebus.underworld.local>
References: <4D365551.7090207@gmail.com>
 <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
 <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
 <4D365BE2.9020300@gmail.com>
 <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
 <20110119155211.GA31671@erebus.underworld.local>
 <AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
 <20110119162941.GA32537@erebus.underworld.local>
 <AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 19, 2011 at 02:44:31PM -0200, Roberto Spadim wrote:
> yes, a jornaling but using ssd first and sata after
> it?s not raid feature...
> it?s per disk filesystem feature...
> we could implement jornaling in raid too...
> but?s more inteligent (easy) at application level (filesystem)
> you could write first at network (if it?s faster than sata) and after
> at sata (if it?s slower than network)
> 
> it?s not a raid feature... it?s a per device feature got it?
> maybe a device (not raid..) for a cache division on devices
> for example
> 
> 
> /dev/sda (sata 1terabyte 100mb/s)
> /dev/sdb (ssd 1gigabyte 1000mb/s)
> 
> /dev/cache_a (a mix of sata and ssd with sata size 1terabyte, and
> mixed speed (memory, ssd, sata))
> 
> cache_a device should know that
> early reads/write should be writen to sdb
> time in time it should sync at sda
> 
> the same happens with memory (ram memory) but it?s volatille (diferent
> than ssd that?s not volatille)
> 
> /dev/sdb should be sync
> /dev/sda should be async (since /dev/sdb make it safe to use async)
> 
> 
> that?s you intention? i don?t know if linux have it, anyone know?
I would use a physical ramdisk over a ssd but thats besides the point.
They are still disk drives to the OS.

Yes, I guess it would be similar to journaling but done in RAID
itself.  I don't believe it exists yet, thats why I'm asking if
we could add support for this?
