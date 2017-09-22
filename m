From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: possible HighPoint RocketRAID 2720SGL failure
Date: Sat, 23 Sep 2017 08:52:06 +1000
Message-ID: <6c99402d-506c-32de-9673-22f5179df8d7@eyal.emu.id.au>
References: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
 <20170921172019.2067e49b@natsu>
 <CAAMCDefoZFzP2yLu4+_cs90KpqHvwXZKZpAs-xBvJ_s-0Gy4pg@mail.gmail.com>
 <a0d2e5e4-f5eb-6a73-3e91-250aead0aa3a@eyal.emu.id.au>
 <bcb8a0a8-9e3e-f953-577e-42abe9cb0968@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bcb8a0a8-9e3e-f953-577e-42abe9cb0968@turmel.org>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/17 23:20, Phil Turmel wrote:
> On 09/22/2017 04:27 AM, Eyal Lebedinsky wrote:
>> On 22/09/17 11:08, Roger Heflin wrote:
>>> If it is the marvell issue I had before then quit doing smartctl
>>> commands (disable all smart queries of any sort) as that seemed to
>>> massively increase the reliablity.  It did not completely fix the
>>> issues, it just made them happen a lot less often.
>>
>> I now tried this and it did not help. I stopped all smart access, but
>> running
>> a md 'check' fails as before (all the disks disappear). Each test fails
>> at a
>> different address. This time the machine was mostly idle when the check was
>> running.
>>
>> I should note that this HighPoint card was running without any problem for
>> 4 years.
>>
>> Maybe a driver issue? I was running f19 until a few weeks ago, and the
>> failures
>> all happened after I upgraded to f22 (and now on f26).
> 
> Your issue sounds like an overheating controller chip.  Four years of
> dust accumulation and/or fan bearing wear.  It's failing when you load
> it down with a scrub.  Replace the controller card.

Thanks Phil,

Interesting. I checked the card and it still looks "as new", no dust.
It does not have a fan and the heatsink is glued firmly to the processor.
Does not look like there is anything I can do here.

I added a fan firing external air directly at the card and will test again
later. I really need to understand the source of the problem. If this fixes
it then I will get a replacement controller (the fan is just a hack).

> Phil

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
