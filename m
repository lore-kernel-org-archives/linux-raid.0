From: Phil Turmel <philip@turmel.org>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 15:16:23 -0400
Message-ID: <1f354d53-9eeb-7e00-d2c0-f2fa571cf8c8@turmel.org>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
 <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tm65kyx.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, David Brown <david.brown@hesbynett.no>
Cc: Anthony Youngman <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/09/2017 07:27 AM, Nix wrote:
> On 9 May 2017, David Brown uttered the following:
> 
>> On 09/05/17 11:53, Nix wrote:
>>> This turns out not to be the case. See this ten-year-old paper:
>>> <https://indico.cern.ch/event/13797/contributions/1362288/attachments/115080/163419/Data_integrity_v3.pdf>.
>>> Five weeks of doing 2GiB writes on 3000 nodes once every two hours
>>> found, they estimated, 50 errors possibly attributable to disk problems
>>> (sector- or page-size regions of corrupted data) on 1/30th of their
>>> nodes. This is *not* rare and it is hard to imagine that 1/30th of disks
>>> used by CERN deserve discarding. It is better to assume that drives
>>> misdirect writes now and then, and to provide a means of recovering from
>>> them that does not take days of panic. RAID-6 gives you that means: md
>>> should use it.
>>
>> RAID-6 does not help here.  You have to understand the types of errors
>> that can occur, the reasons for them, the possibilities for detection,
>> the possibilities for recovery, and what the different layers in the
>> system can do about them.
>>
>> RAID (1/5/6) will let you recover from one or more known failed reads,
>> on the assumption that the driver firmware is correct, memories have no
>> errors, buses have no errors, block writes are atomic, write ordering
>> matches the flush commands, block reads are either correct or marked as
>> failed, etc.
> 
> I think you're being too pedantic. Many of these things are known not to
> be true on real hardware, and at least one of them cannot possibly be
> true without a journal (atomic block writes). Nonetheless, the md layer
> is quite happy to rebuild after a failed disk even though the write hole
> might have torn garbage into your data, on the grounds that it
> *probably* did not. If your argument was used everywhere, md would never
> have been started because 100% reliability was not guaranteed.
> 
> The same, it seems to me, is true of cases in which one drive in a
> RAID-6 reports a few mismatched blocks. It is true that you don't know
> the cause of the mismatches, but you *do* know which bit of the mismatch
> is wrong and what data should be there, subject only to the assumption
> that sufficiently few drives have made simultaneous mistakes that
> redundancy is preserved. And that's the same assumption RAID >0 makes
> all the time anyway!

You are completely ignoring the fact that reconstruction from P,Q is
mathematically correct only if the entire stripe is written together.
Any software or hardware problem that interrupts a complete stripe write
or a short-circuited P,Q update can and therefore often will deliver a
*wrong* assessment of what device is corrupted.  In particular, you
can't even tell which devices got new data and which got old data.  Even
worse, cable and controller problems have been known to create patterns
of corruption to the way to one or more drives.  You desperately need to
know if this happens to your array.  It is not only possible, but
*likely* in systems without ECC ram.

The bottom line is that any kernel that implements the auto-correct you
seem to think is a slam dunk will be shunned by any system administrator
who actually cares about their data.  Your obtuseness notwithstanding.

All:  Please drop me from future CCs on this thread.

Phil

