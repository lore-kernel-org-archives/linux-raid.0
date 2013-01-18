From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Suboptimal raid6 linear read speed
Date: Fri, 18 Jan 2013 02:31:19 -0600
Message-ID: <50F90857.3010305@hardwarefreak.com>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/17/2013 9:51 AM, Mikael Abrahamsson wrote:

> The probability of getting struck by lightning is a lot less than being
> struck by a read error when rebuilding from the only remaining mirror
> when one drive failed and you've replaced it.

The probability of a URE during rebuild increases with the number and
size of the source drives being read to rebuild the failed drive.  Thus
the probability of encountering a URE in the 1:1 drive scenario is
extremely low, close to zero if you believe manufacturer specs.

> <http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>
> is applicable to RAID1 and RAID10 as well as RAID5.

In Robin's example we're reading 12TB of sectors from 6 drives to
complete the rebuild of one failed drive, so the overall probably of a
URE is less than that of a single drive.  With RAID1/10 we're only
reading 2TB, well below the URE rates for single drives.

So, no, the "URE scare" being propagated these days doesn't affect
RAID1/10.  If/when individual drive capacities exceed 10TB in the
future, and if at that time the URE rates per drive do not improve,
-then- this phenomenon will affect RAID1/10.  But it does not currently
with today's drives.

-- 
Stan

