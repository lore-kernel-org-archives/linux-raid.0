From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 array ,  part id 'fd' not assembling at boot .
Date: Sat, 17 Mar 2007 16:36:23 +1100
Message-ID: <17915.32343.270875.583164@notabene.brown>
References: <Pine.LNX.4.64.0703161838110.11877@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Friday March 16
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday March 16, babydr@baby-dragons.com wrote:
>  	Hello All ,  I am having a dickens of a time with preparing this system 
> to replace my present one .
>  	I created a raid6 array over 6 147GB scsi drives .
>  	steps I followed were .
> 
>  	fdisk /dev/sd[c-h] ( one at a time of course )
>  	  created a partition starting at cyl 2 & -10 Cyls from the end of the drive .
>  	  typed the partion FD
>  	  w
>  	repeat until all six drives partitioned .
> 
>  	mdadm --create /dev/md3 --chunk=64 --metadata=1.2 --verbose --bitmap=internal --level=6 --raid-devices=6 --spare-devices=0 /dev/sd[cdefgh]1
>  	Built just fine .

In-kernel auto-assembly using partition type 0xFD only works for
metadata=0.90.  This is deliberate.

Don't use 0xFD partitions.  Use mdadm to assemble your array, either
via an initrd or (if it don't hold the root filesystem) via an init.d
script.

NeilBrown
