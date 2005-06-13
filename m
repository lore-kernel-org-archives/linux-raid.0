From: "Diego M. Vadell" <dvadell@lantech.com.ar>
Subject: Re: sata_nv and RAID1
Date: Mon, 13 Jun 2005 00:15:42 -0300
Message-ID: <200506130015.42981.dvadell@lantech.com.ar>
References: <200506111613.42962.dvadell@lantech.com.ar> <20050611192606.GA4055@pentafluge.infradead.org> <42AB49BC.50104@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AB49BC.50104@tls.msk.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 11 June 2005 17:29, Michael Tokarev wrote:
> Jeff Garzik wrote:
> > On Sat, Jun 11, 2005 at 04:13:42PM +0000, Diego M. Vadell wrote:
> >>Hi,
> >>   A new computer arrived at work with 4 160GB SATA disks. I made a
> >>couple of RAID 1 (mirror) with two disks each, and then joined them wih
> >>LVM. Now I have 320GB in my root volume.
> >>
> >>My boss asked me to test it, so we all gathered and unplugged the data
> >>cable of one of the disks. I was hoping to see linux making warnings for
> >
> > Hotplug is not supported yet.  Don't do that :)
>
> It isn't hotPLUG -- it's hotUNplug.  Happens when drive is dying for
> example, or when the cable is flaky, or due to millions of other
> reasons...  And.. I for one expect linux to react to such a situation
> *somehow* - after all, raid is used for this very stuff too, to be
> able to continue running a system if one of the drives failed...
>
> /mjt

So I thought... Who's fault is it? Is it something missing from sata_nv or 
from md? How hard could it be to implement (I dont know a thing, but maybe 
its just a matter of returning an error somewhere, as I dont want to retry or 
nothing but informing the md layer that it has to forget about that disk)? 
Has anybody started to do this?

Thanks a lot,
 -- Diego.
