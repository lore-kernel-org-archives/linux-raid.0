From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.8.0 - A tool for managing Soft RAID under Linux
Date: Fri, 5 Nov 2004 13:50:42 +1100
Message-ID: <16778.60034.295831.641999@cse.unsw.edu.au>
References: <d9.18ba3ed3.2eba25c5@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Wednesday November 3
Sender: linux-raid-owner@vger.kernel.org
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 3, AndyLiebman@aol.com wrote:
> > neilb@cse.unsw.edu.au writes:
> >
> > Hmmm... I might work with 1.6 if you --build that raid0 (rather than
> > --create),  or if you are using a 64bit processor like alpha or ia64. 
> > But mdadm 1.6 definitely have problems in i386 processors when you try
> > to --create a raid0 with devices larger than 2 terabytes.
> 
> I have been using "mdadm -Cv /dev/md0 -n2 -l0 -c[256 or 512] /dev/sd{a,b}" 
> without incident. But I'll switch over to 1.8. 

Very odd.  Is this on a 2.4 or a 2.6 linux kernel??

> 
> Was the previous problem only one of creating the arrays? Or could there be 
> further problems down the line with my arrays that were created with
> 1.6? 

If your arrays were successfully created and appear to be working,
they should be fine and should continue to work.

NeilBrown


> 
> By the way, do you know anybody with enough understanding of the Linux kernel 
> to be able to rationally and logically tune the following items, which all 
> relate to one another and MUST have some optimum settings for low-latency/high 
> throughput over a network. 
> 
> * chunk size/stripe size of Hardware and Software arrays
> * blockdev --setra (for each Hardware array)
> * blockdev --setra (for each Linux Software array on top of Hardware)
> * tcp items in /proc/sys/net/core and /proc/sys/net/ipv4 like rmem_max, 
> wmem_max and the like
> 
> Regards, 
> Andy Liebman
