From: AndyLiebman@aol.com
Subject: Re: ANNOUNCE: mdadm 1.8.0 - A tool for managing Soft RAID under Linux
Date: Wed, 3 Nov 2004 07:15:01 EST
Message-ID: <d9.18ba3ed3.2eba25c5@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> neilb@cse.unsw.edu.au writes:
>
> Hmmm... I might work with 1.6 if you --build that raid0 (rather than
> --create),  or if you are using a 64bit processor like alpha or ia64. 
> But mdadm 1.6 definitely have problems in i386 processors when you try
> to --create a raid0 with devices larger than 2 terabytes.

I have been using "mdadm -Cv /dev/md0 -n2 -l0 -c[256 or 512] /dev/sd{a,b}" 
without incident. But I'll switch over to 1.8. 

Was the previous problem only one of creating the arrays? Or could there be 
further problems down the line with my arrays that were created with 1.6? 

By the way, do you know anybody with enough understanding of the Linux kernel 
to be able to rationally and logically tune the following items, which all 
relate to one another and MUST have some optimum settings for low-latency/high 
throughput over a network. 

* chunk size/stripe size of Hardware and Software arrays
* blockdev --setra (for each Hardware array)
* blockdev --setra (for each Linux Software array on top of Hardware)
* tcp items in /proc/sys/net/core and /proc/sys/net/ipv4 like rmem_max, 
wmem_max and the like

Regards, 
Andy Liebman
