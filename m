From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 04:58:49 -0500
Message-ID: <4DDA2FD9.3020303@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD99FF2.2030609@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/22/2011 6:44 PM, Brad Campbell wrote:

> He used WD commodity drives on a "hardware" RAID enclosure that needed
> TLER. The RAID-5 kicked out 4 drives in a short period of time, so he
> power cycled it and re-initialised the array and it came up fine, but
> blank (as it would as he re-initialised it).

It was/is an Excel Meridian Data SecurStor Astra ES with 4 expansion
chassis.  Low end, many would call it junk (myself included).  Excel
Meridian Data, formerly known as Excel CD-ROM, has been re-badging cheap
Taiwanese, and now Chinese, junk since their inception in 1992.

Eli stated this gear was sold to UCSC as a packaged, warrantied, storage
system, by an unnamed local SoCal vendor.  I took the man at his word.
We can speculate that he lied about it and tossed it together himself
form a catalog, which seems plausible given EMD's business model, but
that makes no material difference in this discussion, which is that WD
Green drives are not appropriate for RAID arrays, regardless of who
selected the components and whose hands assembled the hardware.

> Sorry Stan, that's not a failure of the drives. He lost the data due to
> limitations in his RAID configuration and bad management.

On the contrary.  It *is* a failure of the drives.  They failed to
perform properly in the chosen application environment, because the
vendor/end user put them in an unsupported environment.  That's the
whole theme of this thread, and precisely why I encouraged people to
read about this fiasco and the potential costs of using these drives in
RAIDs.

Whether the spindles motors quit, the PCBs failed, or they were merely
kicked offline due to any of a half dozen reasons, these are all drive
failures.  When a drive goes offline doe you call it "success"?  No.
What's the opposite of success?  Failure.

The Astra ES is almost certainly running embedded Linux + md RAID due to
its price point.  I can't locate the EMD website nor the PDF for this
Astra unit because every Excel Meridian domain Google'ing returned is
currently squatted.  They may have gone belly up.

If indeed that box uses embedded Linux + md RAID, TLER wouldn't have
been the problem.  Multiple drives definitely went offline, but I doubt
it's due to a real RAID ASIC with custom firmware and a TLER issue.
More likely, given the price, it was a backplane signal quality problem,
for which cheap backplanes are notorious.  Either way, cheap
not-fit-for-RAID drives were stuffed into a cheap RAID box and disaster
was the result.  People buying these drives for array use aren't
dropping them into quality backplanes, but cheap ones.  The entire
ecosystem of components used to build a WD Green drive array are
typically of much lower quality than the drives themselves.  Cheap
backplane + cheap drives + cheap HBAs = high probability of disaster.

In summary, very few people are going to successfully build reliable
arrays from these drives.  I've seen too many horror stories, the UCSC
fiasco being the most severe.  I'm simply trying want to prevent others
from suffering similar disasters.  I think that's a worthy cause.  WDC
itself says not to use the Green drives in RAID arrays.  I'm supplying
examples of real world disasters to support WDC's disclaimer, and
prevent some heartache.

-- 
Stan
