From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Triple parity and beyond
Date: Fri, 29 Nov 2013 23:32:40 -0800
Message-ID: <l7c4ae$17r$2@ger.gmane.org>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com> <528AA1EB.3010909@zytor.com> <CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com> <528BCA2D.5010500@redhat.com> <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu> <528D61C5.70902@hardwarefreak.com> <528DCD36.1060808@hesbynett.no> <528F17FB.60909@hardwarefreak.com> <528F5AF4.60803@hesbynett.no> <5296EDBD.8030905@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner wrote:

> Late reply.  This one got lost in the flurry of activity...
> 
<snip>
> 
> We must follow different definitions of "redundancy".  I view redundancy
> as the number of drives that can fail without taking down the array.  In
> the case of the above 20 drive RAID15 that maximum is clearly 11
> drives-- one of every mirror and both of one mirror can fail.  The 12th
> drive failure kills the array.

IMHO, 'redundancy' is not the important thing here, and may conflate two 
things - 'how much storage is spent on things other than my data (mirrors, 
parity)' [storage efficiency] and 'if the universe is trying to screw me 
over, how many disk losses can I survive?' [failure resilience]

Your 11 disks number is best-case, but quicksort has taught me to always 
look at average-case and worst-case as well. What you describe has very good 
best-case failure resilience, but its worst-case resilience is poorer. It 
has better best-case, average-case, *and* worst-case performance, but has 
considerably worse storage efficiency.

All of those need to be weighed in deciding which to use; raid 15 being 
'just better' isn't something that can be claimed. It depends on the 
workload.

<snip>
> Knowing this is often critical from an architectural standpoint David.
> It is quite common to create the mirrors of a RAID10 across two HBAs and
> two JBOD chassis.  Some call this "duplexing".  With RAID10 you know you
> can lose one HBA, one cable, one JBOD (PSU, expander, etc) and not skip
> a beat.  "RAID15" would work the same in this scenario.
> 
> This architecture is impossible with RAID5/6.  Any of the mentioned
> failures will kill the array.

And again, these address different issues. For one, there's multipath - with 
dual-ported drives, multipath, etc. you can tolerate HBA failure; that 
renders part of the issue something of a canard.

Adding a second JBOD is really not an apples-to-apples comparison, either - 
it's not likely to be a useful configuration in the same situations as lend 
themselves to parity >> 2. Certainly, no-one is advocating that support for 
RAID 10 be removed, and mdadm is certainly capable of handling a manually-
created RAID 15 today.

