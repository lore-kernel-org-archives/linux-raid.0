From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: Which raid card to buy for Sarge
Date: Thu, 1 Apr 2004 09:49:21 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401074921.GA27234@bluff>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au> <406BAC2F.8090407@pobox.com> <406BAF18.8010005@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <406BAF18.8010005@wasp.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 01, 2004 at 09:56:40AM +0400, Brad Campbell wrote:
> Jeff Garzik wrote:
> 
> > >it out and insert the new drive in the array. The array starts 
> > >rebuilding - no effect on the uptime and only a slight loss in 
> > >throughput. Plus it's seamless.
> >
> >Yeah, md+mdadm can do all this right now, provided the hardware and 
> >driver support is there...
> >
> 
> Yes, my point however is for low budget stuff with software raid the driver 
> support is not yet there in a vanilla kernel.
> I can't just whack a sata drive off one of my promise SATA150-TX4 
> controllers, pop another one in and have the kernel rescan the partition 
> table and realise a new drive was present. (YET!)

I'm sort of confused... which are the combinations that allow me to hotswap a
disk w/ software raid. I don't mind doing some mdadm operations, I'm just
interested in how I can avoid rebooting. 

I thought I couldn't, now I learn you can "provided the hardware and driver
support is there"... can you detail a little more?

thanks
sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
