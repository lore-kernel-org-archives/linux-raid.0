From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 23 Jan 2014 14:38:52 -0700
Message-ID: <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E16536.2070608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 23, 2014, at 11:53 AM, Phil Turmel <philip@turmel.org> wrote:

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

Yes I understand this, but 2a and 2b occurring at the same time also seems very improbable with enterprise drives and regularly scheduled scrubs. That's the context I'm coming from.

What are the odds of a latent sector error resulting in a read failure, within ~14 days from the most recent scrub? And with enterprise drives that by design have the proper SCT ERC value? And at the same time as a single disk failure? It seems like a rather low probability. I'd sooner expect to see a 2nd disk failure before the rebuild completes.

> 
> It is no accident that raid5 is becoming much less popular.

Sure and I don't mean to indicate raid6 isn't orders of magnitude safer. I'm suggesting that massive safety margin is being used to paper over common improper configurations of raid5 arrays.  e.g. using drives with the wrong SCT ERC timeout for either controller or SCSI block layer, and also not performing any sort of raid or SMART scrubbing enabling latent sector errors to develop. 

The accumulation of latent sector errors makes raid5 collapse only somewhat less likely than the probability of a single drive failure. So raid5 is particularly sensitive to failure in the case of bad setups, whereas dual parity can in-effect mitigate the consequences of bad setups. But that's not really what it's designed for. If we're talking about exactly correctly configured setups, the comparison is overwhelmingly about (multiple) drive failure probability.


Chris Murphy