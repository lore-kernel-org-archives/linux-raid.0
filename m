From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: total sector number in each disk
Date: Wed, 21 Jan 2004 14:37:13 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074713832.2523.43.camel@dyn251.ele.uri.edu>
References: <8003A8A6-4C3B-11D8-AA88-000A9576014E@cam.ac.uk>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8003A8A6-4C3B-11D8-AA88-000A9576014E@cam.ac.uk>
To: Bin Ren <br260@cam.ac.uk>
Cc: Raid Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Check how md, hd, sd driver handle the BLKGETSIZE or BLKGETSIZE64 ioctl
call. You will get that number. :)


ming

On Wed, 2004-01-21 at 12:59, Bin Ren wrote:
> Hi,
> 
> I'm reading the source codes of md and raid1. Could anyone tell me
> where to find out the total number of sectors of a particular disk in a
> raid set?
> 
> Thanks,
> -- Bin
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

