From: Redeeman <redeeman@metanurb.dk>
Subject: Re: time limited error recovery and md raid
Date: Sat, 06 Dec 2008 15:33:00 +0100
Message-ID: <1228573980.16555.103.camel@localhost>
References: <1228510646.16555.73.camel@localhost>
	 <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>
	 <1228511266.16555.81.camel@localhost>
	 <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>
	 <1228511880.16555.87.camel@localhost>
	 <alpine.DEB.1.10.0812051618340.17806@p34.internal.lan>
	 <1228512684.16555.91.camel@localhost>
	 <alpine.DEB.1.10.0812051637360.17806@p34.internal.lan>
	 <1228514942.16555.95.camel@localhost>
	 <alpine.DEB.1.10.0812051852110.4906@p34.internal.lan>
	 <1228532361.16555.100.camel@localhost>
	 <alpine.DEB.1.10.0812060421340.3494@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812060421340.3494@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2008-12-06 at 04:23 -0500, Justin Piszcz wrote:
> 
> On Sat, 6 Dec 2008, Redeeman wrote:
> 
> > On Fri, 2008-12-05 at 18:52 -0500, Justin Piszcz wrote:
> >>
> >> On Fri, 5 Dec 2008, Redeeman wrote:
> >>
> >>> On Fri, 2008-12-05 at 16:42 -0500, Justin Piszcz wrote:
> >>>>
> >>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>
> >>>>> On Fri, 2008-12-05 at 16:21 -0500, Justin Piszcz wrote:
> >>>>>>
> >>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>>>
> >>>>>>> On Fri, 2008-12-05 at 16:12 -0500, Justin Piszcz wrote:
> >>>>>>>>
> >>>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>>>>>
> >>>>>>>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
> >>>>>>>>>>
> >>>>>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
> >>>>>>>>>>
> >>>>> Okay, you happen to have any knowledge to pass on about current 1tb
> >>>>> disks?
> >>>> I am still looking for some good 1TiB drives myself.  I know one user who
> >>>> has 12 of these, 11 in a RAID-5 array and 1 as a spare on a 12-port 3ware
> >>>> PCI-X card:
> >>>> SAMSUNG Spinpoint F1 HD103UJ 1TB 7200 RPM 32MB Cache SATA 3.0Gb/s Hard Drive
> >>> I guess those look pretty good.
> >>>
> >>> i personally am running WD RE2 and Seagate ES.2 in raids without issues
> >>> at all, raid1, but hmm..
> >>
> >> Can you show the smartctl -a output for each of the disks in your raids?
> > this is a raid1 with 1xwd re2 gp and 1x seagate es.2:
> 
> Just 1 re-allocated sector, curious btw is there a reason you do not do
> daily short smart tests and weekly long tests?  Nothing is worse than
> rebuilding a RAID array and then having another disk fail due to poor health.
> Check/repair/VERIFY also helps to rid disks of bad sectors (force-re-allocate)
> but still..

I actually thought i had that already on this, i guess i forgot that :)

> 
> Justin.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

