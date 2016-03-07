From: Phil Turmel <philip@turmel.org>
Subject: Re: When do you replace old hard drives in a raid6?
Date: Mon, 7 Mar 2016 00:18:10 -0500
Message-ID: <56DD0F12.2060104@turmel.org>
References: <56DB465E.9010703@gmail.com> <56DCCB55.1060906@turmel.org>
 <56DCD0E9.8040506@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56DCD0E9.8040506@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2016 07:52 PM, Ram Ramesh wrote:
> On 03/06/2016 06:29 PM, Phil Turmel wrote:
>> On 03/05/2016 03:49 PM, Ram Ramesh wrote:
>>> I am curious if people actually replace hard drives periodically because
>>> they are old or out of warranty. My 5 device raid6 has several older
>>> drives (3/5 are 3+ years old and out of warranty) They seem fine with
>>> SMART and raid scrubs. However, it makes me wonder when they will die.
>>> What is the best policy in such situations? More importantly, do people
>>> wait for disks to die and then replace or have some ad hoc schedule of
>>> replacing (like every 6mo replace oldest) to keep things safe?
>> I replace drives when their relocation count hits double digits.  In my
>> limited sample, that's typically after 40,000 hours.
>>
>> Phil
> 
> Thanks for the data point. 40K hours means roughly 4.5 years with 24/7.
> That is very good. You use enterprise drives? Mine are desktop (and may
> be one HGST NAS)

I moved from desktop drives to NAS drives about 4 years ago.  So the
40k+ hours were on desktop drives.  (A couple started dying in the mid
30,000's, but I suspect I overheated those two.)  The oldest NAS drives
I have now are approaching 40k, and are all still @ zero relocations.
WD Reds, fwiw.

> My SMART is perfect except for power on hours. I am going to take it
> easy for now as I have a spare (not part of a RAID) just in case
> something bad happens.

Yes, sounds reasonable.

Phil

