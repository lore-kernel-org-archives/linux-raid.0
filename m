From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Wed, 01 Apr 2009 07:56:36 -0700
Message-ID: <1238597796.4604.6.camel@cichlid.com>
References: <439371.59188.qm@web51306.mail.re2.yahoo.com>
	 <87myb1ieoq.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87myb1ieoq.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> >> > Hey guys, How do you know if your machine can handle
> >> adding some more drives to it? How can you check that there
> >> is enough BUS IO to handle extra sata cards and also that
> >> the machine is powerful enough to support say an 8 drive
> >> raid 5...

Look at it from the viewpoint of raid performance rather than disk
performance. How can the throughput be less with more disks?

So what if your bus bandwidth is saturated now? Then it will be
saturated with more disks too, but the raid bandwidth should not change,
it's still the saturation bandwidth.

And if it's not saturated now then the raid throughput will increase
assuming you can get more disks operating in parallel.

I'm sure there are corner cases we can nitpick but isn't this correct in
general?

