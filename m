From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH] ANNOUNCE: mdadm 2.5.1 - A tool for managing Soft RAID
 under Linux
Date: Mon, 19 Jun 2006 15:02:09 -0400
Message-ID: <4496F4B1.9090604@steeleye.com>
References: <17554.895.666628.776527@cse.unsw.edu.au> <4492D26B.4070705@steeleye.com> <4492F066.7060709@tmr.com> <4496BE1A.8010502@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4496BE1A.8010502@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> --- super1.c	2006-06-19 05:17:36.000000000 -0400
> +++ /export/public/clemep/tmp/super1-ppc-compile-error.c	2006-06-19 00:40:26.000000000 -0400
> @@ -124,8 +124,11 @@ static unsigned int calc_sb_1_csum(struc
>  	disk_csum = sb->sb_csum;
>  	sb->sb_csum = 0;
>  	newcsum = 0;
> -	for (i=0; size>=4; size -= 4 )
> -		newcsum += __le32_to_cpu(*isuper++);
> +	for (i=0; size>=4; size -= 4 ) {
> +		unsigned int *x = isuper;
> +		newcsum += __le32_to_cpu(*x);
> +		x++;
> +	}

Should be more like:

for (i=0; size>=4; size -= 4 ) {
	newcsum += __le32_to_cpu(*isuper);
	isuper++;
}

Duh... :)

