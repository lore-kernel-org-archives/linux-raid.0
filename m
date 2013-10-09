From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Wed, 09 Oct 2013 21:08:19 +0200
Message-ID: <5255A9A3.3040205@hesbynett.no>
References: <20131009123135.GT1779@bitfolk.com> <l33q8a$da4$1@ger.gmane.org> <5255827B.8090309@hesbynett.no> <l3440m$85s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l3440m$85s$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/10/13 19:33, Ian Pilcher wrote:
> On 10/09/2013 11:21 AM, David Brown wrote:
>> Do you have any references for these claims?
> 
> If you mean real data, then no.  I am simply reasoning (hopefully
> rationally) from the nature of the different device types, along with
> anecdotes from people that have experienced SSD failures.

OK.  Anecdotal evidence is not to be ignored - you wouldn't have posted
if you didn't think it was realistic.  But it gets harder to credit for
each step away from personal experience.

> 
>> I would believe that /if/ an SSD was going to die, it is likely to do so
>> without warning - it is likely to be the controller that has died.  But
>> I can think of no reason why the controller on an SSD is more likely to
>> die than the controller on an HD - and HD's have so many more ways to
>> die (often slowly and noisily).
> 
> Agreed.  The interesting thing is that a bunch of less reliable devices
> that die slowly and noisily may be collectively more reliable over the
> long term than a bunch of more reliable devices that die completely at
> the same time.  I.e. does the additional variability in failures created
> by the mechanical components of HDDs reduce the correlation of the
> failures enough to make the entire array more reliable over some period
> of time?
> 
> (I would expect this effect to be most pronounced when populating an
> array with similar SSDs/HDDs.)

I agree with that, but it does not take into account the general greater
reliability and expected lifetime of SSD's compared to HD's.  In some
cases, you might consider "slow and noisy death" as being almost as good
as "working fine" - if you have enough redundancy (raid6), hot spares,
and replacement drives on hand then a "slow and noisy dying" disk does
not noticeably reduce the reliability of the whole array.  Then it comes
down to the likelihood of sudden and complete failure of the disks.  I
have not seen evidence that SSD's are more prone to that the HD's.

<http://www.tomshardware.com/reviews/ssd-reliability-failure-rate,2923.html>

This is two years old - we can expect that for serious SSD's, the
failure rate will have gone down since then as the technology matures
(we are not discussing the low-end, where price has higher priority than
reliability).  Hard disks are already a mature product - there has been
little change in the reliability figures in past years.

The only conclusion the study shows is that reliability figures from SSD
vendors are no more realistic than those from HD vendors, and that there
is not enough data to give concrete results.  My reading of the figures
is that SSD's look more reliable, but the trend can't be proven without
longer-term studies.

One thing that is clear from other studies is that SSDs can suffer
catastrophic failures with unexpected power faults, in a way that HD's
do not.  A good UPS, and perhaps redundant power supplies, is a good idea.



> 
>> That leaves firmware bugs as a possible explanation for such worries -
>> and that also applies to HD's.
> 
> Agreed, but see my reasoning above.
> 
>> But with that aside, having different manufacturers and models for the
>> two halves of a raid1 pair is not a bad idea regardless of whether you
>> have SSD's or HD's - it avoids the risk of a double failure due to a bad
>> production batch.
> 
> Is it potentially even more important when using SSDs, though?  I
> believe that the answer is yes.
> 

I think I agree there.

> I guess we just have to wait for Google to migrate their entire
> infrastructure for SSDs and publish a new study ...
> 

Even then it will be difficult to know for sure, as the SSD devices are
still changing too rapidly.  Wait another 5 years or so, then get Google
to migrate to SSDs and collect 5 years of data.  Then we will have
something we can rely on!

