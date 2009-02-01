From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: Fix the used device size in mdadm -D output.
Date: Mon, 2 Feb 2009 10:04:45 +1100
Message-ID: <18822.10893.62071.901769@notabene.brown>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org>
	<497DD740.8080306@rabbit.us>
	<20090126160814.GD17185@skl-net.de>
	<497DF230.1080908@rabbit.us>
	<20090126183359.GG17185@skl-net.de>
	<20090127075253.GH17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Tuesday January 27
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday January 27, maan@systemlinux.org wrote:
> On 19:33, Andre Noll wrote:
> > This is twice as much as it should be due to a bug in mdadm which bites
> > only for version1 superblocks. The patch below should fix it. However,
> > this might not be the most elegant solution because the real bug
> > is IMHO that get_component_size() multiplies the value from sysfs
> > (which is always in 1K units) by two, so it returns 2K units which
> > looks a bit weird.
> 
> This was of course a braino: Multiplying a value in 1K units by two
> yields 512byte units rather than 2K units, which is exactly what the
> comment to get_component_size() says ;)
> 
> That being said, I think my patch is correct and dividing the result
> by two in Detail() seems the best way to deal with the situation.
> So here's the patch again, this time with proper log message.

Thanks Andre.
Your patch is good... but I really like to use "sectors" as often as
possible.
So I've changed it to leave 'dsize' as sectors, but device it by 2, or
shift by 9, as appropriate.

Thanks,
NeilBrown


> 
> Andre
> 
> commit 2e9fd78bd09bf332ac86f2d288a0e7c3c1c3df4f
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Tue Jan 27 08:49:15 2009 +0100
> 
>     Fix the used device size in mdadm -D output.
>     
>     As get_component_size() returns the number of used sectors of a
>     device while mdadm is supposed to print this size in kilobytes,
>     we have to divide the return value of get_component_size() by two.
>     
>     Signed-off-by: Andre Noll <maan@systemlinux.org>
> 
> diff --git a/Detail.c b/Detail.c
> index 3cee66f..cef1abb 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -195,7 +195,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  		if (array.level >= 1) {
>  			if (array.major_version != 0 &&
>  			    (larray_size >= 0xFFFFFFFFULL|| array.size == 0)) {
> -				unsigned long long dsize = get_component_size(fd);
> +				unsigned long long dsize = get_component_size(fd) / 2; /* KB */
>  				if (dsize > 0)
>  					printf("  Used Dev Size : %llu%s\n",
>  					       dsize,
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
