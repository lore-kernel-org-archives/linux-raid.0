From: Dominik Kubla <dominik@kubla.de>
Subject: Re: People using RAID-6?
Date: Fri, 13 Feb 2004 08:15:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040213071519.GC1555@intern.kubla.de>
References: <c0hqc8$fvv$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c0hqc8$fvv$1@terminus.zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 13, 2004 at 06:20:56AM +0000, H. Peter Anvin wrote:
> People, if you actually use RAID-6, please do let me know.  I'd like
> to gauge the size of the user commnunity; it's going to matter a lot
> for how stable it can be assumed to be.
> 
> Please include the # of disks as well as if you have had any
> recoveries.
> 
> 	-hpa

What is your own estimation? Is it useable for production systems?
What is the recommended code basis? Our customers are _VERY_ conservative
(read: bankers), so they are mostly going with mirrors or striped mirrors.

Is there any performance data for different work loads? Eg. how does it
work for file service with different file sizes, read/write patterns.

Since most of our customers need database storage RAID1 still seems to be
the best appoach.

Regards,
  Dominik Kubla
-- 
You'd best be snoozin', 'cause you don't be gettin' no work done at 5 a.m.
anyway.
		-- From the wall of the Wurster Hall stairwell
