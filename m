From: NeilBrown <neilb@suse.de>
Subject: Re: high throughput storage server?
Date: Wed, 16 Feb 2011 08:41:36 +1100
Message-ID: <20110216084136.1c7efa28@notabene.brown>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
	<AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
	<20110215044434.GA9186@septictank.raw-sewage.fake>
	<4D5A98BF.3030704@gmail.com>
	<20110216073756.4c0291eb@notabene.brown>
	<4D5AE669.10107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5AE669.10107@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Doug Dumitru <doug@easyco.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 15 Feb 2011 15:47:37 -0500 Joe Landman <joe.landman@gmail.com> wrote:

> On 02/15/2011 03:37 PM, NeilBrown wrote:
> > On Tue, 15 Feb 2011 10:16:15 -0500 Joe Landman<joe.landman@gmail.com>  wrote:
> >
> >> As a tie in to the Linux RAID list, we use md raid for our OS drives
> >> (SSD pairs), and other utility functions within the unit, as well as
> >> striping over our hardware accelerated RAIDs.  We would like to use
> >> non-power of two chunk sizes, but haven't delved into the code as much
> >> as we'd like to see if we can make this work.
> >>
> >
> > md/raid0 (striping) currently supports non-power-of-two chunk sizes, though
> > it is a relatively recent addition.
> > (raid4/5/6 doesn't).
> 
> Cool!  We need to start playing with this ...
> 
> Which kernels have the support?

It was enabled by commit fbb704efb784e2c8418e34dc3013af76bdd58101
so 

$ git name-rev fbb704efb784e2c8418e34dc3013af76bdd58101
fbb704efb784e2c8418e34dc3013af76bdd58101 tags/v2.6.31-rc1~143^2~18


2.6.31 has this support.

However I note that mdadm still checks that the chunk size is a power of two:
       if (chunk < 8 || ((chunk-1)&chunk)) {

I should fix that...

NeilBrown


> 
> --
> Joe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

