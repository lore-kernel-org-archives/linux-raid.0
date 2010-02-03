From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Why does one get mismatches?
Date: Wed, 03 Feb 2010 12:17:26 +0100
Message-ID: <874olywou1.fsf@frosties.localdomain>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B684087.50001@tmr.com> (Bill Davidsen's message of "Tue, 02 Feb
	2010 10:11:03 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen <davidsen@tmr.com> writes:

> Neil Brown wrote:
>> On Mon, 01 Feb 2010 16:18:23 -0500
>> Bill Davidsen <davidsen@tmr.com> wrote:
>>
>>
>>> Comment: when there is a three way RAID-1, why doesn't repair
>>> *vote* on the correct value instead of just making a guess?
>>>
>>>
>>
>> Because truth is not democratic.
>>
>> (and I defy you to define "correct" in any general way in this context).
>>
>
> If you are willing to accept that the reconstructed data from
> RAID-[56] is "correct" then the data from RAID-1 majority opinion is
> "correct." If you say that such recovered data is the "most likely to
> match what was written," then data consistent on (N+1)/2 drives of a
> RAID-1 should be viewed in the same light. Call it "most likely to be
> correct" if you prefer, but picking a value from a drive at random is
> less likely.
>
> This whole discussion simply shows that for RAID-1 software RAID is
> less reliable than hardware RAID (no, I don't mean fake-RAID), because
> it doesn't pin the data buffer until all copies are written.

Lets ignore the fact that software raid seems to write bad data
supposedly only to unused blocks for now. If the block is really unused
it doesn't mater what is done. And if it is used then software raid has
a big bug that needs to be fixed and not repaired after the fact.

So lets assume there actualy is a true mismatch because one of the
drives returns false data on read. Then in raid1/10 with >2 copies and
raid6 you have a way to detect the correct data, correct as in most
likely to be what was written originally. For raid6 that means detecting
the drive so that the rest still give a correct parity and for raid1/10
that means finding the majority. Say you have a 10 way raid1 with 9
blocks having the same data and one differs. Picking a random block is
wrong 10% of the time. Do you realy think that in 10% of the cases 9
disks will be corrupt in exactly the same way?

MfG
        Goswin
