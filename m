From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 09 Oct 2013 12:33:19 -0500
Message-ID: <l3440m$85s$1@ger.gmane.org>
References: <20131009123135.GT1779@bitfolk.com> <l33q8a$da4$1@ger.gmane.org> <5255827B.8090309@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5255827B.8090309@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/09/2013 11:21 AM, David Brown wrote:
> Do you have any references for these claims?

If you mean real data, then no.  I am simply reasoning (hopefully
rationally) from the nature of the different device types, along with
anecdotes from people that have experienced SSD failures.

> I would believe that /if/ an SSD was going to die, it is likely to do so
> without warning - it is likely to be the controller that has died.  But
> I can think of no reason why the controller on an SSD is more likely to
> die than the controller on an HD - and HD's have so many more ways to
> die (often slowly and noisily).

Agreed.  The interesting thing is that a bunch of less reliable devices
that die slowly and noisily may be collectively more reliable over the
long term than a bunch of more reliable devices that die completely at
the same time.  I.e. does the additional variability in failures created
by the mechanical components of HDDs reduce the correlation of the
failures enough to make the entire array more reliable over some period
of time?

(I would expect this effect to be most pronounced when populating an
array with similar SSDs/HDDs.)

> That leaves firmware bugs as a possible explanation for such worries -
> and that also applies to HD's.

Agreed, but see my reasoning above.

> But with that aside, having different manufacturers and models for the
> two halves of a raid1 pair is not a bad idea regardless of whether you
> have SSD's or HD's - it avoids the risk of a double failure due to a bad
> production batch.

Is it potentially even more important when using SSDs, though?  I
believe that the answer is yes.

I guess we just have to wait for Google to migrate their entire
infrastructure for SSDs and publish a new study ...

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

