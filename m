From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Wed, 18 Jan 2006 12:51:01 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601181248460.19220@lion.drogon.net>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru>
 <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru>
 <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru>
 <20060118081407.GC18945@localhost.localdomain> <43CE3898.7090207@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43CE3898.7090207@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 Jan 2006, John Hendrikx wrote:

> I agree with the original poster though, I'd really love to see Linux
> Raid take special action on sector read failures.  It happens about 5-6
> times a year here that a disk gets kicked out of the array for a simple
> read failure.  A rebuild of the array will fix it without a trace, but a
> rebuild takes about 3 hours :)

One thing that's well worth doing before simply fail/remove/add the drive
with the bad sector, is to do a read-only test on the other
drives/paritions in the rest of the set. That way you won't find out
half-way through the resync that other drives have failures, and then lose
the lot. It adds time to the whole operation, but it's worth it IMO.

Gordon
