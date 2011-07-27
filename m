From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 13:44:24 +0100
Message-ID: <4E300828.3000601@anonymous.org.uk>
References: <20110727141652.7511fc51@notabene.brown> <j0p0d6$aj6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0p0d6$aj6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/07/2011 13:30, Lutz Vieweg wrote:
> On 07/27/2011 06:16 AM, NeilBrown wrote:
>> Then as errors occur they will cause the faulty block to be added to
>> the log rather
>> than the device to be remove from the array.
>
> Can you describe the criteria for MD considering a block as faulty?

I'll try to answer this having followed some of the discussion around 
it. It'll be the same circumstances where currently a drive is 
considered faulty, causing the the array to become degraded. With the 
bad block list, instead of the whole array becoming degraded, only the 
stripe with the bad block becomes degraded.

> In your blog, I read
> "... known to be bad. i.e. either a read or a write has recently failed..."
> but that definition may be problematic: I've experienced drives
> with intermittent read / write failures (due to controller or power
> stability
> problems), and I wonder whether such a situation could quickly fill up the
> "bad block list", doing more harm than good in the "intermittent error"-
> szenario.

It might quickly fill up the bad block list, but with no bad block list, 
the array would be taken offline much sooner. Once the controller or 
power issues are resolved, the bad block list can be administratively 
modified or cleared.

> Another szenario: The write succeeded, but a later reads of the same
> block return read errors. This would result in a "pending sector", and the
> harddisk may very well re-map the sector on the next write. Do you mark
> the block faulty on the MD level after the first read failed (even though
> subsequent reads/writes to the block would succeed), or do you first try
> to re-write the block, and call it faulty only if that fails?

MD already handles this and has done for years; if a read fails, 
reconstruction is performed and the data written back. It would be at 
this point that a failure would cause the block to be called faulty (or 
without the bad block list, the device would be called faulty).

> One more general thing: I guess that "marking bad blocks" is probably
> unsuitable for SSDs, which usually do not assign fixed physical
> storage location with a certain block number. Maybe mdadm could warn
> about better
> not enabling the feature if the device is known to be a SSD.

I don't think mdadm knows whether its constituent devices are SSDs.

Cheers,

John.

