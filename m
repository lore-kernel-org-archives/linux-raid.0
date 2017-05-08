From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Mon, 8 May 2017 21:27:13 +0100
Message-ID: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vapb6s9h.fsf@esperi.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Phil Turmel <philip@turmel.org>
Cc: "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/05/17 20:52, Nix wrote:
> On 8 May 2017, Phil Turmel verbalised:
> 
>> On 05/08/2017 10:50 AM, Nix wrote:
>>
>>> I wonder... scrubbing is not very useful with md, particularly with RAID
>>> 6, because it does no writes unless something mismatches,
>>
>> This is wrong.  The purpose of scrubbing is to expose any sectors that
>> have degraded (as Wol describes) to the point of generating a read
>> error.  A "check" scrub only writes back to the sectors that report a
>> URE, giving the drive firmware a chance to fix or relocate the sector.
>>
>> A check scrub will NOT write on mismatch, just increment the mismatch
>> counter.  This is the recommended regular scrubbing operation.  You want
>> to know when mismatches occur.
> 
> And... then what do you do? On RAID-6, it appears the answer is "live
> with a high probability of inevitable corruption". That's not very good.
> (AIUI, if a check scrub finds a URE, it'll rewrite it, and when in the
> common case the drive spares it out and the write succeeds, this will
> not be reported as a mismatch: is this right?)

I think you're misunderstanding RAID here. IF the drive says "I can't 
read this block", the RAID reconstructs the block, and rewrites it. No 
corruption.

If the scrub finds a mismatch, then the drives are reporting 
"everything's fine here". Something's gone wrong, but the question is 
what? If you've got a four-drive raid that reports a mismatch, how do 
you know which of the four drives is corrupt? Doing an auto-correct here 
risks doing even more damage. (I think a raid-6 could recover, but 
raid-5 is toast ...)

And seeing as drives are pretty much guaranteed (unless something's gone 
BADLY wrong) to either (a) accurately return the data written, or (b) 
return a read error, that means a data mismatch indicates something is 
seriously wrong that is NOTHING to do with the drives.

<snip>
> 
> If a sector weakens purely because of neighbouring writes or temperature
> or a vibrating housing or something (i.e. not because of actual damage),
> so that a rewrite will strengthen it and relocation was never necessary,
> surely you've just saved a pointless bit of sector sparing? (I don't
> know: I'm not sure what the relative frequency of these things is. Read
> and write errors in general are so rare that it's quite possible I'm
> worrying about nothing at all. I do know I forgot to scrub my old
> hardware RAID array for about three years and nothing bad happened...)
> 
Yes you have saved a sector sparing. Note that a consumer 3TB drive can 
return, on average, one error every time it's read from end to end 3 
times, and still be considered "within spec" ie "not faulty" by the 
manufacturer. And that's a *brand* *new* drive. That's why building a 
large array using consumer drives is a stupid idea - 4 x 3TB drives and 
a *within* *spec* array must expect to handle at least one error every 
scrub.

Okay - most drives are actually way over spec, and could probably be 
read end-to-end many times without a single error, but you'd be a fool 
to gamble on it.

Cheers,
Wol
