From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: [PATCH] Version 1 super block
Date: Fri, 21 Jan 2005 09:59:55 -0600
Message-ID: <1106323194.8425.4.camel@dyn95390186.austin.ibm.com>
References: <41E9D66E.9080100@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E9D66E.9080100@us.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@cse.unsw.edu.au
Cc: akpm@osdl.org, linux-raid@vger.kernel.org, kevcorry@us.ibm.com
List-Id: linux-raid.ids

Hello Neil,

I've been wondering if you had a chance to look at this patch.  Please
let me know.

--
Thanks,
Mike T.

On Sat, 2005-01-15 at 20:50, Mike Tran wrote:
> Hello Neil,
> 
> I found 2 problems in the kernel MD driver:
> 1) if disk index 0 is used, counting of max_dev is wrong
> 2) missing checksum calculation
> 
> Please consider the attached patch for 2.6.10 kernel.
> --
> Thanks,
> Mike T.
> 
> 
> ______________________________________________________________________
> --- a/linux-2.6.10/drivers/md/md.c	2005-01-15 07:52:14.000000000 -0600
> +++ b/linux-2.6.10/drivers/md/md.c	2005-01-15 07:52:14.000000000 -0600
> @@ -939,9 +939,13 @@
>  		sb->resync_offset = cpu_to_le64(0);
>  
>  	max_dev = 0;
> -	ITERATE_RDEV(mddev,rdev2,tmp)
> +	i = 0;
> +	ITERATE_RDEV(mddev,rdev2,tmp) {
> +		i++;
>  		if (rdev2->desc_nr > max_dev)
>  			max_dev = rdev2->desc_nr;
> +	}
> +	max_dev = max(max_dev, i);
>  	
>  	sb->max_dev = cpu_to_le32(max_dev);
>  	for (i=0; i<max_dev;i++)
> @@ -958,6 +962,7 @@
>  	}
>  
>  	sb->recovery_offset = cpu_to_le64(0); /* not supported yet */
> +	sb->sb_csum = calc_sb_1_csum(sb);
>  }
>  
> 

