From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Suboptimal raid6 linear read speed
Date: Thu, 17 Jan 2013 16:51:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F70DB7.6020104@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Jan 2013, Stan Hoeppner wrote:

> This isn't a legitimate argument.  The probability of you being struck 
> by lightning is greater than two drives in the same mirror in a 4 drive 
> RAID10 dying before a rebuild completes.

The probability of getting struck by lightning is a lot less than being 
struck by a read error when rebuilding from the only remaining mirror when 
one drive failed and you've replaced it.

> I challenge you to do an exhaustive search for anyone, at any time in 
> history, who was managing the array properly, suffering such a two drive 
> failure and losing a RAID10 array, 4 drives or greater.  Note that 
> controller failures with all drives on one controller don't count, as 
> that failure mode will take down any array of any RAID level.

<http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162> 
is applicable to RAID1 and RAID10 as well as RAID5.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
