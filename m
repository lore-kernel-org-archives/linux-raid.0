From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 00:30:14 -0500
Message-ID: <4DD5FC66.5020209@hardwarefreak.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520020853.GC4759@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/19/2011 9:08 PM, Andy Smith wrote:
> Hi Ed,
> 
> On Thu, May 19, 2011 at 01:26:49PM +0100, Ed W wrote:
>> Ideally I would like a controller with writeback cache and BBU since
>> whilst this office machine is likely quite underused, for any sensible
>> amount of IO (some of the other machines we might upgrade) this seems to
>> give a 10-100x increase in IOPs?  For the moment it's just a nice to
>> have though
> 
> Are there actually any HBAs that have BBU without using their RAID
> features?

AFAIK the LSI real RAID cards allow this.  To get them into a JBOD mode
you have to create a single drive RAID 0 of each disk and export it.  By
doing so the RAID firmware is actually active, though not really doing
anything, so you get the cache and BBU benefit of the controller.  One
of the XFS developers, Dave Chinner, posted this to the XFS list quite
some time ago when we discussed hardware vs software RAID setups.

-- 
Stan
