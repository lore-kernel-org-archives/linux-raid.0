From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Fri, 18 Jan 2013 10:18:32 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
 <50F90857.3010305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F90857.3010305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Jan 2013, Stan Hoeppner wrote:

> The probability of a URE during rebuild increases with the number and
> size of the source drives being read to rebuild the failed drive.  Thus
> the probability of encountering a URE in the 1:1 drive scenario is
> extremely low, close to zero if you believe manufacturer specs.

For a 2TB drive and BER 10^-14 (common for non-enterprise drives), the 
probability is 1/6 of a single URE for a read of the entire drive.

> So, no, the "URE scare" being propagated these days doesn't affect 
> RAID1/10.  If/when individual drive capacities exceed 10TB in the 
> future, and if at that time the URE rates per drive do not improve, 
> -then- this phenomenon will affect RAID1/10.  But it does not currently 
> with today's drives.

Let's agree to disagree.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
