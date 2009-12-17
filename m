From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID5 / 6 Growth
Date: Thu, 17 Dec 2009 09:27:54 +0000
Message-ID: <4B29F99A.2000709@anonymous.org.uk>
References: <1C.0E.01567.69E892B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1C.0E.01567.69E892B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/12/2009 01:51, Leslie Rhorer wrote:
[...]
>> As to your initial question: Being able to keep the filesystem mounted
>> and used is the whole point of having online growing of the raid
>> system. If that weren't save then there would be no point to it as you
>> could just as well stop the raid if you already umounted it and grow
>> it offline.
> 
> 	I know that is the point of the utility.  My question boils down to,
> "How safe is it to avail one's self of the capability if it is not essential
> to have the array mounted for the duration?"  I don't particularly like
> having the array unavailable (especially not for nearly 5 days), but I
> prefer that to risking data loss, or especially risking irretrievably losing
> the entire array.  The question is particularly pertinent given the fact the
> growth is going to take nearly 5 days (a lot can happen in 5 days), and the
> fact the system was having the rather squirrelly issue a few days back which
> seems - emphasis on SEEMS - to have been resolved by disabling NCQ.  What
> happens if the system kicks a couple of drives, especially if one drive gets
> kicked, a bunch of data gets written and then a few minutes later another
> drive gets kicked?  In particular, what if neither of the two drives that
> get kicked are the new drive?

Well, what happens if two drives get kicked in normal use over the 
course of 5 days? I think you're being overly cautious, and I'll try to 
explain why.

The reshape only reduces redundancy during the "critical section". After 
that, you're as redundant as usual and can tolerate a drive failure. On 
RAID-6, 2 drive failures. A reshape should be considerably safer than 
doing a resync to a replacement drive, because in the reshape case if 
you get bad sectors md can regenerate the data from the parity info.

Do you regularly run a check on your array? Or have you done one 
recently? And does the SMART info on all your drives look OK? These 
should be the case before attempting any reshape anyway, so I'd say just 
keep the partition mounted.

Cheers,

John.
