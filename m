From: Cory Coager <ccoager@gmail.com>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 11:29:41 -0500
Message-ID: <20110119162941.GA32537@erebus.underworld.local>
References: <4D365551.7090207@gmail.com>
 <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
 <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
 <4D365BE2.9020300@gmail.com>
 <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
 <20110119155211.GA31671@erebus.underworld.local>
 <AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 19, 2011 at 02:16:08PM -0200, Roberto Spadim wrote:
> ok, your hardware have:
> cpu, memory, disk controller, disks
> 
> and you computer have:
> cpu, memory, disk controler (your hardware)
> 
> if your computer cache don?t sync to your disk controller you will
> lose information....
> 
> check that *memory, is the volatille memory and *disk controller is
> the non volatille memory
> if you tell me that you will never have a *memory, and you have always
> a non volatille memory, no problem, you will never need a kernel
> load... just a boot loader that read previous memory information and
> start in that point... why don?t do this? non volatille memory is not
> as fast as volatille memory
> got the problem?

Sorry, we're still not on the same page.  I would use both a ramdisk
and sata disk.  The ramdisk would act as a persistent cache
(with the battery) for the sata disks.  Enabling write through
would write to the cache first then sync to the sata disks.

Understand what I'm getting at now?
