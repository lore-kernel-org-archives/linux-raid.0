From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Fri, 18 Jan 2013 16:56:47 -0600
Message-ID: <50F9D32F.7090606@hardwarefreak.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/18/2013 3:18 AM, Mikael Abrahamsson wrote:
> On Fri, 18 Jan 2013, Stan Hoeppner wrote:
> 
>> The probability of a URE during rebuild increases with the number and
>> size of the source drives being read to rebuild the failed drive.  Thus
>> the probability of encountering a URE in the 1:1 drive scenario is
>> extremely low, close to zero if you believe manufacturer specs.
> 
> For a 2TB drive and BER 10^-14 (common for non-enterprise drives), the
> probability is 1/6 of a single URE for a read of the entire drive.

If my math is correct, with a URE rate of 10E14, that's one URE for
every ~12.5TB read.  So theoretically one would have to read the entire
2TB drive more than 6 times before hitting the first URE.  So it seems
unlikely that one would hit a URE during a mirror rebuild with such a
2TB drive.

>> So, no, the "URE scare" being propagated these days doesn't affect
>> RAID1/10.  If/when individual drive capacities exceed 10TB in the
>> future, and if at that time the URE rates per drive do not improve,
>> -then- this phenomenon will affect RAID1/10.  But it does not
>> currently with today's drives.
> 
> Let's agree to disagree.

This is math so there is no room for disagreement--there is one right
answer.  Either mine is correct or yours is.  If my math is incorrect
I'd certainly appreciate it if you, or anyone else, would explain where
I'm in error, so I don't disseminate incorrect information in the
future.  But given that the articles I've read on this subject agree
with my math, I don't believe I'm in error.

I made the point in a previous post that I use the smallest drives I can
get away with for a given array/workload/capacity, as performance is
generally better and rebuild times much lower.  Potential URE issues
provide yet another reason to use a higher count of smaller drives,
though again, this doesn't tend to affect most RAID1/10 users, yet.

-- 
Stan

