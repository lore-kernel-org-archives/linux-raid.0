From: "David Lethe" <david@santools.com>
Subject: RE: Adding more drives/saturating the bandwidth
Date: Wed, 1 Apr 2009 10:17:29 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C0930174657B@34093-C4-EVS1.exchange.rackspace.com>
References: <439371.59188.qm@web51306.mail.re2.yahoo.com> <87myb1ieoq.fsf@frosties.localdomain> <1238597796.4604.6.camel@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1238597796.4604.6.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>, linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Andrew Burgess
> Sent: Wednesday, April 01, 2009 9:57 AM
> To: linux raid mailing list
> Subject: Re: Adding more drives/saturating the bandwidth
> 
> 
> > >> > Hey guys, How do you know if your machine can handle
> > >> adding some more drives to it? How can you check that there
> > >> is enough BUS IO to handle extra sata cards and also that
> > >> the machine is powerful enough to support say an 8 drive
> > >> raid 5...
> 
> Look at it from the viewpoint of raid performance rather than disk
> performance. How can the throughput be less with more disks?
> 
> So what if your bus bandwidth is saturated now? Then it will be
> saturated with more disks too, but the raid bandwidth should not
> change,
> it's still the saturation bandwidth.
> 
> And if it's not saturated now then the raid throughput will increase
> assuming you can get more disks operating in parallel.
> 
> I'm sure there are corner cases we can nitpick but isn't this correct
> in
> general?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
In grand sense of things, isn't this question rather irrelevant?  The
answer is one of perception.  Would you ask the same question about
whether or not you could add more programs to run and saturating a CPU?
Of course not, the answer is easy. 

If you need the extra disks, then you need more disks because the
applications running on that machine needs more disk space then you have
available.  Your choice is always to free up existing space, add more
disks, or lighten the overhead by moving applications elsewhere ..
assuming overall performance is "satisfactory" in the eyes of the people
who control your budget.

So isn't this all a moot point?  Set a baseline for appropriate
performance before you begin and create a plan in event the updated
hardware config doesn't meet it, then react accordingly.

David


