From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sat, 19 Jan 2013 08:43:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F9D32F.7090606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Jan 2013, Stan Hoeppner wrote:

> If my math is correct, with a URE rate of 10E14, that's one URE for 
> every ~12.5TB read.  So theoretically one would have to read the entire 
> 2TB drive more than 6 times before hitting the first URE.  So it seems 
> unlikely that one would hit a URE during a mirror rebuild with such a 
> 2TB drive.

Unlikely yes, but it also means one in 6 rebuilds (statistically) will 
fail with URE. I'm not willing to take that chance, thus I use RAID6.

Usually, with scrubbing etc I'd imagine that the probability is better 
than 1 in 6, but it's still a substantial risk.

> This is math so there is no room for disagreement--there is one right 
> answer.  Either mine is correct or yours is.  If my math is incorrect 
> I'd certainly appreciate it if you, or anyone else, would explain where 
> I'm in error, so I don't disseminate incorrect information in the 
> future.  But given that the articles I've read on this subject agree 
> with my math, I don't believe I'm in error.

With a BER of 10^-14 you have a 16% risk of getting URE when reading an 
entire 2TB drive. We both agree on that. You called the risk in comparison 
with "getting hit by lightning" which I strongly disagree with.

> I made the point in a previous post that I use the smallest drives I can 
> get away with for a given array/workload/capacity, as performance is 
> generally better and rebuild times much lower.  Potential URE issues 
> provide yet another reason to use a higher count of smaller drives, 
> though again, this doesn't tend to affect most RAID1/10 users, yet.

It's important that people make informed decsision. With enterprise drives 
(better BER) that are smaller (let's say 300 GB), the risk is greatly 
reduced.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
