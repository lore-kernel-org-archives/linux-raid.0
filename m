From: David Brown <david.brown@hesbynett.no>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 23 Jan 2014 23:06:38 +0100
Message-ID: <52E1926E.30106@hesbynett.no>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E16536.2070608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/01/14 19:53, Phil Turmel wrote:
> Hi Chris,
>
> On 01/23/2014 12:28 PM, Chris Murphy wrote:
>> It's a fair point. I've recently run across some claims on a separate
>> forum with hardware raid5 arrays containing all enterprise drives,
>> with regularly scrubs, yet with such excessive implosions that some
>> integrators have moved to raid6 and completely discount the use of
>> raid5. The use case is video production. This sounds suspiciously
>> like microcode or raid firmware bugs to me. I just don't see how ~6-8
>> enterprise drives in a raid5 translates into significantly higher
>> array collapses that then essentially vanish when it's raid6.
>
> I just wanted to address this one point.  Raid6 is many orders of
> magnitude more robust than raid5 in the rebuild case.  Let me illustrate:
>
> How to lose data in a raid5:
>
> 1) Experience unrecoverable read errors on two of the N drives at the
> same *time* and same *sector offset* of the two drives.  Absurdly
> improbable.  On the order of 1x10^-36 for 1T consumer-grade drives.
>
> 2a) Experience hardware failure on one drive followed by 2b) an
> unrecoverable read error in another drive.  You can expect a hardware
> failure rate of a few percent per year.  Then, when rebuilding on the
> replacement drive, the odds skyrocket.  On large arrays, the odds of
> data loss are little different from the odds of a hardware failure in
> the first place.
>
> How to lose data in a raid6:
>
> 1) Experience unrecoverable read errors on *three* of the N drives at
> the same *time* and same *sector offset* of the drives.  Even more
> absurdly improbable.  On the order of 1x10^-58 for 1T consumer-grade drives.
>
> 2) Experience hardware failure on one drive followed by unrecoverable
> read errors on two of the remaining drives at the same *time* and same
> *sector offset* of the two drives.  Again, absurdly improbable.  Same as
> for the raid5 case "1".
>
> 3) Experience hardware failure on two drives followed by an
> unrecoverable read error in another drive.  As with raid5 on large
> arrays, you probably can't complete the rebuild error-free.  But the
> odds of this event are subject to management--quick reponse to case "2"
> greatly reduces the odds of case "3".
>
> It is no accident that raid5 is becoming much less popular.
>
> Phil

Don't forget the other possible cause of read errors - some muppet sees 
that one drive has a complete failure, and when going to replace it 
pulls out the wrong drive...  Raid 6 gives extra protection against that 
most unbounded of error sources - human error!

Anyway, the issue of checksums and the type of bitrot situation invented 
for the Ars Technica article is about /undetected/ errors - dealing with 
/detected/ unrecoverable read errors is easy.


