From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Software RAID when it works and when it doesn't
Date: Wed, 17 Oct 2007 11:29:52 +1300
Message-ID: <47153B60.5010008@sauce.co.nz>
References: <14526.1192571833@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14526.1192571833@mdt.ecitele.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta wrote:

> is at the mercy of the low level disk driver.  We've observed abysmal
> RAID1 recovery times on failing SATA disks because all the time is
> being spent in the driver retrying operations which will never succeed.
> Also, read errors don't tend to fail the array so when the bad disk is
> again accessed for some subsequent read the whole hopeless retry process
> begins anew.

This is one issue I believe the Western Digital RE/RE2 drives address. 
The "TLER (time-limited error recovery)" feature limits retrys to try to 
prevent this. I have the figure of 5 seconds in my head, but could be wrong.

Not sure if the Seagate nearline range offers the same sort of thing.

Regards,

Richard
