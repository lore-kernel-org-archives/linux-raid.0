From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: Linux RAID metadata format docs?
Date: Fri, 14 Nov 2003 23:48:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031114214837.GW9681@hvs.envisage.co.za>
References: <20031114185013.GA11930@gtf.org> <20031114193114.GB1080@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20031114193114.GB1080@mea-ext.zmailer.org>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 14, 2003 at 09:31:14PM +0200, Matti Aarnio wrote:
> Nevertheless I would love to be able to boot from _any_ of disks
> in a bootable RAID1 diskset.  I have just experimented with Highpoint's
> RocketRaid 1520, which almost can do that.  It fails if the primary
<snip> 
> After all, Sun has been able to do that for a very long time,
> it should be possible in PC hardware, too.

Nope, Sun's booting is achieved in the OBP (Open Boot Prom)
which is arguably more advanced than the current PC BIOSes.

> (In Suns we have to define a set of boot devices into prom level,

Which is specified based on the PCI/SBUS slot the controller is
attached to. One Day(TM) we'll be able to see the PeeCee world 
drop it's ISA slot independence but IRQ/IOport uniqueness, not to
mention it's real mode DOS compatible 0x80, 0x81 harddisk ordering... :(

>  and there all devices are different, and retain their identity
>  forever independent of plugging new interface cards into system,
>  but that is another story...)

That's only a function of the order of entries in /etc/path_to_inst, which is
achievable (to an extend) in linux with modules.conf trickery.

Hendrik
