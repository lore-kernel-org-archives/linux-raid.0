From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Triple parity and beyond
Date: Sun, 01 Dec 2013 09:37:03 -0600
Message-ID: <529B579F.6090806@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F17FB.60909@hardwarefreak.com> <528F5AF4.60803@hesbynett.no> <5296EDBD.8030905@hardwarefreak.com> <l7c4ae$17r$2@ger.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l7c4ae$17r$2@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/30/2013 1:32 AM, Alex Elsayed wrote:
> Stan Hoeppner wrote:
> 
>> Late reply.  This one got lost in the flurry of activity...
>>
> <snip>
>>
>> We must follow different definitions of "redundancy".  I view redundancy
>> as the number of drives that can fail without taking down the array.  In
>> the case of the above 20 drive RAID15 that maximum is clearly 11
>> drives-- one of every mirror and both of one mirror can fail.  The 12th
>> drive failure kills the array.
> 
> IMHO, 'redundancy' is not the important thing here, and may conflate two 
> things - 'how much storage is spent on things other than my data (mirrors, 
> parity)' [storage efficiency] and 'if the universe is trying to screw me 
> over, how many disk losses can I survive?' [failure resilience]
> 
> Your 11 disks number is best-case, 

This is not -my- number.  It is simply the best case RAID15 number.
Just as the worst case is 3.  Both numbers are part of the decision
making equation.  In my response to David, in which you cut the context,
I was simply stating his numbers were different than mine, and likely
wrong, which they were.  I was not making the argument, as you seem to
suggest here, that one should look at the best case 11 disk redundancy
as a magical number on which to make a decision.

> but quicksort has taught me to always 
> look at average-case and worst-case as well. What you describe has very good 
> best-case failure resilience, but its worst-case resilience is poorer. It 
> has better best-case, average-case, *and* worst-case performance, but has 
> considerably worse storage efficiency.

This has already been stated many times in the thread, more than once by
me.

> All of those need to be weighed in deciding which to use; raid 15 being 
> 'just better' isn't something that can be claimed. It depends on the 
> workload.

Again, already stated multiple times.

> <snip>
>> Knowing this is often critical from an architectural standpoint David.
>> It is quite common to create the mirrors of a RAID10 across two HBAs and
>> two JBOD chassis.  Some call this "duplexing".  With RAID10 you know you
>> can lose one HBA, one cable, one JBOD (PSU, expander, etc) and not skip
>> a beat.  "RAID15" would work the same in this scenario.
>>
>> This architecture is impossible with RAID5/6.  Any of the mentioned
>> failures will kill the array.
> 
> And again, these address different issues. 

"And again"?  This is the first time this has been discussed in this
thread.  And this isn't a "different issue".  It is part of the storage
architecture equation, and for some critically important.

> For one, there's multipath - with 
> dual-ported drives, multipath, etc. you can tolerate HBA failure; that 
> renders part of the issue something of a canard.

Except for one critical factor:  Only select few SAS drive models offer
dual ports, and they are very pricey, typically only offered in "Big 5"
vendor integrated storage products, usually SAN arrays, which include
RAID capability.  You don't often find dual-ported SAS drives available
in anyone's JBOD chassis.  ZERO SATA drives are dual ported.  The vast
majority of people using md/RAID are using SATA disks, not SAS.

To make such an argument displays some serious ignorance.  To call my
statement of fact a canard displays even more...

> Adding a second JBOD is really not an apples-to-apples comparison, either - 
> it's not likely to be a useful configuration in the same situations as lend 
> themselves to parity

Introducing a straw man?  Either that's intentional or you didn't read
my reply to David in context.  Please go back and read the exchange
again.  And for that matter, re-read the entire thread.  I've clearly
state once, if not twice, that RAID15 is something that only current
RAID10 users would be interested in, and that current parity RAID users
would shun it.  Just as you are here.

> Certainly, no-one is advocating that support for 
> RAID 10 be removed, and 

Where are you coming up with such nonsense?  Of course no one has
suggested this.  Why did you make this statement?

> mdadm is certainly capable of handling a manually-
> created RAID 15 today.

No, it is certainly not capable today.  Somehow you have missed all of
the posts explaining and discussing the key feature requirements of the
proposed RAID15 personality.

Considering the quantity of factual errors you've made in this post
Alex, I suggest you get your ducks in a row before your next reply, or
simply stay out of this thread entirely.  To date you've posted 3
replies, and not a one has added anything of value to the discussion.

I should have started a separate thread for the RAID15 idea, instead
dropping it into the triple parity thread.  That would have kept the
BTRFS users out of the discussion, as there would have been no reason to
CC that list, as was done in this case...

Speaking of which, no need to reply-all to BTRFS as this discussion has
nothing to do with it, thus removed.

-- 
Stan

