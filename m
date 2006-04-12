From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm does not want to create partitions
Date: Wed, 12 Apr 2006 18:30:46 +1000
Message-ID: <17468.47798.66618.134174@cse.unsw.edu.au>
References: <200604112310.19991.casus@casus.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anton Petrusevich on Tuesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Anton Petrusevich <casus@casus.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 11, casus@casus.us wrote:
> but, I have:
> 
> # mdadm -A /dev/md1 --auto=part8
> mdadm: that --auto option not compatable with device named /dev/md1
> 

"/dev/md1" is traditionally a name for a non-partitioned md, and using
it for a partioned might cause confusion..

Use "/dev/md/d0" (preferred) or "/dev/mda"  or even
 /dev/my-big-storage

and mdadm won't complain.

NeilBrown


> It can be assembled only as non-partitioned, --auto=part or mdp do not work 
> also. I need my partitions back, but I don't understand what I can do. The 
> kernel is from RHEL-4 2.6.9-22.EL.roothugemem (custom build for RedHat 9). It 
> was working before the power failure. 
> -- 
> Anton Petrusevich
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
