From: Neil Brown <neilb@suse.de>
Subject: Re: How do I find endian-conversion function on Redhar/Fedora
Date: Mon, 6 Feb 2006 11:18:25 +1100
Message-ID: <17382.38353.505917.198557@cse.unsw.edu.au>
References: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com>
	<17382.30814.778053.416244@cse.unsw.edu.au>
	<43E68646.4000209@fooplanet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gil on Sunday February 5
Sender: linux-raid-owner@vger.kernel.org
To: Gil <gil@fooplanet.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 5, gil@fooplanet.com wrote:
> Neil Brown wrote:
> > So my plea for help:  Could someone with a Redhat installation
> > please see if there is any way to get functions that convert
> > between little endian and host endian, or if there is some name I
> > can #define to disable the 'private kernel header' warning..
> 
> I have an FC4 machine that I tried this out on.  I have no idea if
> this is the right way to use these headers in /usr/include/linux,
> but it made the compile problem go away at least.

Ok,.... that's interesting. 
I would in one sense just be moving the problem and maybe Redhat would
try to declare linux/byteorder/* off limits, but I guess I could
simply include them in the mdadm distrib if they did that.

Thanks.  If nothing better surfaces I'll probably include this in
mdadm 2.4.

NeilBrown

> 
> --Gil
> diff -r -u mdadm-2.3/bitmap.c mdadm-2.3-patched/bitmap.c
> --- mdadm-2.3/bitmap.c	2005-12-15 17:41:31.000000000 -0800
> +++ mdadm-2.3-patched/bitmap.c	2006-02-05 15:09:32.000000000 -0800
> @@ -21,7 +21,16 @@
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include "mdadm.h"
> -#include <asm/byteorder.h>
> +#include <endian.h>
> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> +#  include <linux/byteorder/little_endian.h>
> +#elif __BYTE_ORDER == __BIG_ENDIAN
> +#  include <linux/byteorder/big_endian.h>
> +#elif __BYTE_ORDER == __PDP_ENDIAN
> +#  include <linux/byteorder/pdp_endian.h>
> +#else
> +#  error "unknown endianness."
> +#endif
