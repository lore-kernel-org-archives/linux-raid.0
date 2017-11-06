From: Phil Turmel <philip@turmel.org>
Subject: Re: [sucess] upgrading LSI SAS9211-8i fw IR->IT
Date: Mon, 6 Nov 2017 16:48:16 -0500
Message-ID: <0eba8116-169e-4ca6-262a-dfcc3c8ed5f9@turmel.org>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
 <34e5cc74-2cb2-5059-0e11-8f26a8bee223@eyal.emu.id.au>
 <31706ffc-3a81-b844-261e-a84dd8c01deb@fnarfbargle.com>
 <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
 <20171106201556.C02DA120495@gemini.denx.de>
 <5006e53f-5df1-df17-732f-73a5a7d3349e@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5006e53f-5df1-df17-732f-73a5a7d3349e@eyal.emu.id.au>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
Cc: Wolfgang Denk <wd@denx.de>, Brad Campbell <lists2009@fnarfbargle.com>
List-Id: linux-raid.ids

On 11/06/2017 04:38 PM, Eyal Lebedinsky wrote:
> On 07/11/17 07:15, Wolfgang Denk wrote:
>> Dear Eyal,
>> 
>> In message <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
>> you wrote:
>>> 
>>> (I had many disk failures/replacements in the 4 years life of
>>> this array).
>> 
>> Reading this makes me wonder if you checked your environment for 
>> other influences.  there must be some reason for an exceptional
>> high number of failures.
>> 
>> I remeber we also had a nighmare of disk errors in the rack in the 
>> 2nd floor of our building - which disappeared after moving the
>> rack into the basement.  I can't prove it, but I blame it on
>> vibrations. We have a heavy traffic train line less than 50 meters
>> away, and disks (classic, magnetic ones) definitely do not like
>> vibrations - see [1].  Maybe you have other influences you did not
>> check for yet?
> 
> Interesting Wolfgang,
> 
> - This array is at  home, a relatively quiet place. - I monitor the
> disks temperatures and it is OK. - The machine runs off a UPS which
> can be a source of bad power (if the PS does not filter it out). -
> The HBA may be somehow bothering the disks?
> 
> The disks are under warranty until late next year so there is time to
> see if the disks do better with the LSI.
> 
> BTW, two of the RMAs were for disks that arrived DOA (as RMAs). I  do
> not have high regard for the WD blacks. The failures were spread
> across the last 4 years (so not infant mortality).
> 
> If nothing else, this experience made me comfortable with software 
> raid, and encouraged me to stick to my backup schedule.

That's a really bad failure rate.  But they're WD Blacks, which if I
recall correctly, do not support scterc.  Did you deal with your driver
timeouts?  If not, those drives probably weren't really dead.  Just not
raid-compatible out-of-the-box.

Phil
