From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] fix read past end of array in md/linear.c
Date: Thu, 08 Mar 2007 21:37:46 -0500
Message-ID: <45F0C87A.9000400@tmr.com>
References: <20070308205204.GA12152@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070308205204.GA12152@hexapodia.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Isaacson wrote:
> When iterating through an array, one must be careful to test one's index
> variable rather than another similarly-named variable.  
>
> The loop will read off the end of conf->disks[] in the following
> (pathological) case:
>
> % dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
> % for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
> % ./vmlinux ubd0=root ubd1=d1 ubd2=d2 ubd3=d3 ubd4=d4
> # mdadm -C /dev/md0 --level=linear --raid-devices=4 /dev/ubd[1234]
>
> adding some printks, I saw this:
> [42949374.960000] hash_spacing = 821120
> [42949374.960000] cnt          = 4
> [42949374.960000] min_spacing  = 801
> [42949374.960000] j=0 size=820928 sz=820928
> [42949374.960000] i=0 sz=820928 hash_spacing=820928
> [42949374.960000] j=1 size=64 sz=64
> [42949374.960000] j=2 size=64 sz=128
> [42949374.960000] j=3 size=64 sz=192
> [42949374.960000] j=4 size=1515870810 sz=1515871002
>
> Index: linus/drivers/md/linear.c
> ===================================================================
> --- linus.orig/drivers/md/linear.c	2007-03-02 11:35:55.000000000 -0800
> +++ linus/drivers/md/linear.c	2007-03-07 13:10:30.000000000 -0800
> @@ -188,7 +188,7 @@
>  	for (i=0; i < cnt-1 ; i++) {
>  		sector_t sz = 0;
>  		int j;
> -		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
> +		for (j=i; j<cnt-1 && sz < min_spacing ; j++)
>  			sz += conf->disks[j].size;
>  		if (sz >= min_spacing && sz < conf->hash_spacing)
>  			conf->hash_spacing = sz;

After looking at that code, I have to wonder how this ever worked, or if 
in fact anyone ever took this path. I assume that the value of sz caused 
the loop exit in all cases, since this has been in the code at least 
since 2.6.15, oldest thing I have handy.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

