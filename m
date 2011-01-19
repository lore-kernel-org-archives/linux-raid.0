From: Cory Coager <ccoager@gmail.com>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 12:19:22 -0500
Message-ID: <20110119171922.GA1130@erebus.underworld.local>
References: <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
 <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
 <4D365BE2.9020300@gmail.com>
 <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
 <20110119155211.GA31671@erebus.underworld.local>
 <AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
 <20110119162941.GA32537@erebus.underworld.local>
 <AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
 <AANLkTikCUkESU8zNLRgmDpz_wdKfDFC3YTG0R4O+5eVi@mail.gmail.com>
 <AANLkTinhFAiYYV=cm7UuYHeOsDLwSP_yVsbMPTCwcNee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinhFAiYYV=cm7UuYHeOsDLwSP_yVsbMPTCwcNee@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 19, 2011 at 03:04:09PM -0200, Roberto Spadim wrote:
> check:
> Key Specifications
> 
>     * 500GB, 320GB and 250GB hard drive capacity options   (hard disk
> like, maybe 100mb/s with 7200rpm   - it?s you hd disk (/dev/sda in my
> example) )
>     * 7200-RPM spindle speed
>     * 4GB SLC NAND solid state memory   (SSD like, maybe 300mb/s   -
> it?s you ssd cache disk (/dev/sdb in my example) )
>     * 32MB of drive-level cache  (is it ddr3? ddr3 is 10000mb/s, maybe
> less, sata is 3gb/s    - it?s the linux/computer ram memory)
>     * SATA 3Gb/s with Native Command Queuing (3000mb/s)
> 
> what this disk do?
> 
> operational system write to (hd) and read from (hd)
> 
> hd:
> write/read in memory
> if not in memory, read from ssd
> if not in ssd, read from hd
> 
> write can be async
> when loser energy, save memory to ssd, 32mb is fast to write, with
> 300mb/s ssd speed you can use a super capacitor and have 1 second of
> life...
> after write to ssd, write to hd

Sounds about right.  Can we make it happen?
