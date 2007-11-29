From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: raid6 check/repair
Date: Fri, 30 Nov 2007 10:17:20 +1100
Message-ID: <474F4880.8080300@eyal.emu.id.au>
References: <474431BF.30103@ph.tum.de>	<18244.64972.172685.796502@notabene.brown>	<4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18254.21949.441607.134763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 22, thiemo.nagel@ph.tum.de wrote:
>> Dear Neil,
>>
>> thank you very much for your detailed answer.
>>
>> Neil Brown wrote:
>>> While it is possible to use the RAID6 P+Q information to deduce which
>>> data block is wrong if it is known that either 0 or 1 datablocks is 
>>> wrong, it is *not* possible to deduce which block or blocks are wrong
>>> if it is possible that more than 1 data block is wrong.
>> If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
>> it *is* possible, to distinguish three cases:
>> a) exactly zero bad blocks
>> b) exactly one bad block
>> c) more than one bad block
>>
>> Of course, it is only possible to recover from b), but one *can* tell,
>> whether the situation is a) or b) or c) and act accordingly.
> 
> It would seem that either you or Peter Anvin is mistaken.
> 
> On page 9 of 
>   http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
> at the end of section 4 it says:
> 
>       Finally, as a word of caution it should be noted that RAID-6 by
>       itself cannot even detect, never mind recover from, dual-disk
>       corruption. If two disks are corrupt in the same byte positions,
>       the above algorithm will in general introduce additional data
>       corruption by corrupting a third drive.

The above a/b/c cases are not correct for raid6. While we can detect
0, 1 or 2 errors, any higher number of errors will be misidentified as
one of these.

The cases we will always see are:
	a) no  errors - nothing to do
	b) one error - correct it
	c) two errors -report? take the raid down? recalc syndromes?
and any other case will always appear as *one* of these (not as [c]).

Case [c] is where different users will want to do different things. If my data
is highly critical (would I really use raid6 here and not a higher redundancy
level?) I could consider doing some investigation. e.g. pick each pair of disks
in turn as the faulty ones, correct them and check that my data looks good
(fsck? inspect the data visually?) until one pair choice gives good data.

<may be OT>

The quote, saying two errors may not be detected, is not how I understand
ECC schemes to work. Does anyone have other papers that point this?

Also, is it the case that the raid6 alg detects a failed disk (strip)
or is it actually detecting failed bits and as such the correction is
done to the whole stripe? In other words, values in all failed locations
are fixed (when only 1-error cases are present) and not in just one
strip. This means that we do not necessarily identify the bad disk, and
neither do we need to.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
