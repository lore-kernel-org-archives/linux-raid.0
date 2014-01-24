From: Phil Turmel <philip@turmel.org>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Fri, 24 Jan 2014 08:22:38 -0500
Message-ID: <52E2691E.4050701@turmel.org>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Chris,

[BTW, reply-to-all is proper etiquette on kernel.org lists.  You keep
dropping CCs.]

On 01/23/2014 04:38 PM, Chris Murphy wrote:
> 
> On Jan 23, 2014, at 11:53 AM, Phil Turmel <philip@turmel.org> wrote:
> 

>> 2a) Experience hardware failure on one drive followed by 2b) an 
>> unrecoverable read error in another drive.  You can expect a
>> hardware failure rate of a few percent per year.  Then, when
>> rebuilding on the replacement drive, the odds skyrocket.  On large
>> arrays, the odds of data loss are little different from the odds of
>> a hardware failure in the first place.
> 
> Yes I understand this, but 2a and 2b occurring at the same time also
> seems very improbable with enterprise drives and regularly scheduled
> scrubs. That's the context I'm coming from.

No, they aren't improbable.  That's my point.  For consumer drives, you
can expect a new URE every 12T or so read, on average.  (Based on
claimed URE rates.)  So big arrays (tens of terabytes) are likely find a
*new* URE on *every* scrub, even if they are back-to-back.  And on
rebuild after a hardware failure, which also reads the entire array.

> What are the odds of a latent sector error resulting in a read
> failure, within ~14 days from the most recent scrub? And with
> enterprise drives that by design have the proper SCT ERC value? And
> at the same time as a single disk failure? It seems like a rather low
> probability. I'd sooner expect to see a 2nd disk failure before the
> rebuild completes.

It's not even close.  The URE on rebuild is near *certain* on very large
arrays.

Enterprise drives push the URE rate down another factor of ten, so the
problem is most apparent on arrays of high tens of T or hundreds of T.
But enterprise customers are even more concerned with data loss, moving
the threshold right back.  And if you are a data center with thousands
of drives, the hardware failure rate is noticeable.

Also, all of my analysis presumes proper error-recovery configuration.
Without it, you're toast.

>> It is no accident that raid5 is becoming much less popular.
> 
> Sure and I don't mean to indicate raid6 isn't orders of magnitude
> safer. I'm suggesting that massive safety margin is being used to
> paper over common improper configurations of raid5 arrays.  e.g.
> using drives with the wrong SCT ERC timeout for either controller or
> SCSI block layer, and also not performing any sort of raid or SMART
> scrubbing enabling latent sector errors to develop.

No, the problem is much more serious than that.  Improper ERC just
causes a dramatic array collapse that confuses the hobbyist.  That's why
it gets a lot of attention on linux-raid.

> The accumulation of latent sector errors makes raid5 collapse only
> somewhat less likely than the probability of a single drive failure.
> So raid5 is particularly sensitive to failure in the case of bad
> setups, whereas dual parity can in-effect mitigate the consequences
> of bad setups. But that's not really what it's designed for. If we're
> talking about exactly correctly configured setups, the comparison is
> overwhelmingly about (multiple) drive failure probability.

No, improper ERC setup will take out a raid6 almost as fast as raid5,
since any URE kicks the drive out.  It happens to mostly to hobbyists
who haven't scheduled scrubs, since anyone doing scrubs finds this out
relatively quickly.  (Because they are afflicted with a rash of drive
"failures" that aren't.)

Your comments suggest you've completely discounted the fact that
published URE rates are now close to, or within, drive capacities.

Spend some time with the math and you will be very concerned.

Phil
