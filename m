From: Neil Brown <neilb@suse.de>
Subject: Re: hardware raid 5 and software raid 0 stripe broke.
Date: Fri, 12 May 2006 12:28:41 +1000
Message-ID: <17507.62169.927233.886775@cse.unsw.edu.au>
References: <4463ECBD.8040506@4dcsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ken on Thursday May 11
Sender: linux-raid-owner@vger.kernel.org
To: Ken <Ken@4dcsi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 11, Ken@4dcsi.com wrote:
> We have a Linux box running redhat 7.2   We have two hardware 
> controllers in it with about 500gig's each.   They're raid 5.   We were 
> using a software raid to combine them all together.   1 hard drive went 
> down so we replaced it and now the system won't boot.   We have used a 
> Knoppix boot cd to get into a linux system.   We can see /dev/sda1 and 
> /dev/sdb1.   However, /dev/md0 cannot be accessed.   Is there a safe way 
> to create the software raid from the cd to see if maybe mdadm on the 
> original system got corrupt?   any help would be greatly appreciated.

What booted off knoppix, what does

 mdadm -E /dev/sda1
 mdadm -E /dev/sdb1

produce?

How about
  mdadm -A /dev/md0 /dev/sda1 /dev/sdb1

NeilBrown
