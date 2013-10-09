From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 09 Oct 2013 18:21:15 +0200
Message-ID: <5255827B.8090309@hesbynett.no>
References: <20131009123135.GT1779@bitfolk.com> <l33q8a$da4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l33q8a$da4$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/10/13 16:46, Ian Pilcher wrote:
> On 10/09/2013 07:31 AM, Andy Smith wrote:
>> Any insights appreciated.
> 
> Consider the probable failure mode of an SSD.  An SSD is more likely
> than an HDD to (1) die with absolutely no warning and (2) die due to
> the pattern of data written to it over its lifetime (and the way those
> writes interact with the SSD's controller/firmware).
> 
> #2 in particular means that there is potentially a much higher
> correlation between the failures of SSDs in an array than there is of
> HDDs.  (And #1 means that the consequences will be more catastrophic.)
> 
> I would recommend using SSDs with two different types on controllers.
> 

Do you have any references for these claims?

I would believe that /if/ an SSD was going to die, it is likely to do so
without warning - it is likely to be the controller that has died.  But
I can think of no reason why the controller on an SSD is more likely to
die than the controller on an HD - and HD's have so many more ways to
die (often slowly and noisily).

Modern SSDs are not going to suffer from wear in any realistic
environment.  You have to be intentionally abusive - a decent SSD will
be fine with /years/ of continuous high-speed writes.  Even then, you
will get write failures long before you have read failures.

That leaves firmware bugs as a possible explanation for such worries -
and that also applies to HD's.


But with that aside, having different manufacturers and models for the
two halves of a raid1 pair is not a bad idea regardless of whether you
have SSD's or HD's - it avoids the risk of a double failure due to a bad
production batch.

David

