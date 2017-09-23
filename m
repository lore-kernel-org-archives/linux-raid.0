From: Phil Turmel <philip@turmel.org>
Subject: Re: possible HighPoint RocketRAID 2720SGL failure
Date: Sat, 23 Sep 2017 10:49:58 -0400
Message-ID: <fb8f1bc9-ef8a-96c7-b152-b12f07ba3243@turmel.org>
References: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
 <20170921172019.2067e49b@natsu>
 <CAAMCDefoZFzP2yLu4+_cs90KpqHvwXZKZpAs-xBvJ_s-0Gy4pg@mail.gmail.com>
 <a0d2e5e4-f5eb-6a73-3e91-250aead0aa3a@eyal.emu.id.au>
 <bcb8a0a8-9e3e-f953-577e-42abe9cb0968@turmel.org>
 <6c99402d-506c-32de-9673-22f5179df8d7@eyal.emu.id.au>
 <b86d07f2-c306-398a-fb6a-e75df5f94311@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b86d07f2-c306-398a-fb6a-e75df5f94311@eyal.emu.id.au>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/23/2017 05:29 AM, Eyal Lebedinsky wrote:
> On 23/09/17 08:52, Eyal Lebedinsky wrote:

>> Thanks Phil,
>>
>> Interesting. I checked the card and it still looks "as new", no dust.
>> It does not have a fan and the heatsink is glued firmly to the processor.
>> Does not look like there is anything I can do here.
>>
>> I added a fan firing external air directly at the card and will test
>> again
>> later. I really need to understand the source of the problem. If this
>> fixes
>> it then I will get a replacement controller (the fan is just a hack).
>>
>>> Phil
> 
> The 'check' completed, something it was not able to do before, so it
> seems that
> it was an overheating problem. Now that I know, I searched for the
> relevant terms
> and did find some notes suggesting this card is known to have such an
> issue.
> 
> But, why now? I could only guess that the heatsink tape (the only thing
> connecting the processor to the heatsink) has aged enough to a low level of
> performance. I am not sure that I can fix it, or even remove the
> heatsink safely.

Chips get old.  Primarily due to thermal cycling producing expansion
cracking.  Silicon and the various deposited metals expand/contract with
different coefficients, so temperature changes stress the mating points
between semiconductors and interconnect.  (Sounds like your problem, as
extra cooling helps.)

If thermal stress doesn't kill them, then dopant diffusion within the
semiconductors eventually will.  This occurs even when turned off, but
proceeds much faster at elevated temperatures.  Dopant concentrations
are engineered to not suffer from diffusion effects well beyond the
expected life of the components (at rated operating temps), but that
doesn't mean there aren't marginal production runs.  Which can be hard
to discover before parts start failing years later.  If that happens
after the warranty period, the manufacturer has dodged a big bullet.
With a bit of tarnish on their name, of course.

> [OT: the following documents how I handled the 'check' results]

> Thanks, I feel much better now.

I like happy endings.  (-:

But it's too bad you have to replace it.

Phil
