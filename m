From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 09:03:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com> <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se> <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 11 Oct 2013, Guillaume Betous wrote:

>> I would recommend setting this to 180 seconds.
>
> Yes, and that's what I've done ! Not 30 seconds, but 3 minutes, you're right.
> Sorry :)
>
>> RAID6, preferrably with a spare.
>
> I'm not comfortable with RAID 6 setup. What is the minimal number of
> hard drives for having a RAID 6 + spare ?

Well, I guess that would be 4, but that doesn't make much sense, then you 
could rather have just 3 drives in raid1.

But basically it's usually beneficial to have a RAID6 array over a 
RAID5+spare. I can't think of any "home use" usage patterns where RAID6 
would perform a lot worse than RAID5. You get the benefit of allowing two 
drives to fail or a single drive failure plus read errors to be handled 
without problems.

I have completely stopped using RAID5 it's just not worth it when using 
large non-enterprise drives with 10^-14 read error rates.

What is it about RAID6 that you are not comfortable with?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
