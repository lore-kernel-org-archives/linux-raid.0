From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 10:51:42 +1100
Message-ID: <17358.54414.410350.594083@cse.unsw.edu.au>
References: <20060117174531.27739.patches@notabene>
	<43CCA80B.4020603@tls.msk.ru>
	<20060117095019.GA27262@localhost.localdomain>
	<43CCD453.9070900@tls.msk.ru>
	<20060117160829.GA16606@lug.udel.edu>
	<43CD3388.9050107@tls.msk.ru>
	<20060118081407.GC18945@localhost.localdomain>
	<43CE3898.7090207@xs4all.nl>
	<Pine.LNX.4.56.0601181248460.19220@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gordon Henderson on Wednesday January 18
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 18, gordon@drogon.net wrote:
> On Wed, 18 Jan 2006, John Hendrikx wrote:
> 
> > I agree with the original poster though, I'd really love to see Linux
> > Raid take special action on sector read failures.  It happens about 5-6
> > times a year here that a disk gets kicked out of the array for a simple
> > read failure.  A rebuild of the array will fix it without a trace, but a
> > rebuild takes about 3 hours :)
> 
> One thing that's well worth doing before simply fail/remove/add the drive
> with the bad sector, is to do a read-only test on the other
> drives/paritions in the rest of the set. That way you won't find out
> half-way through the resync that other drives have failures, and then lose
> the lot. It adds time to the whole operation, but it's worth it IMO.

But what do you do if the read-only test fails... I guess you try to
reconstruct using the nearly-failed drive...

What might be good and practical is to not remove a failed drive
completely, but to hold on to it and only read from it in desperation
while reconstructing a spare.  That might be worth the effort...

NeilBrown
