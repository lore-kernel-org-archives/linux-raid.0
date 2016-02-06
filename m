From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 3/3][mdadm] Monitor.c: fix compiler error with x32
 toolchain
Date: Fri, 5 Feb 2016 20:17:55 -0500 (EST)
Message-ID: <1290371608.15164091.1454721475169.JavaMail.zimbra@redhat.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com> <1454711298-32524-3-git-send-email-maxin.john@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454711298-32524-3-git-send-email-maxin.john@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Maxin B. John" <maxin.john@gmail.com>
> To: linux-raid@vger.kernel.org
> Cc: "Maxin B. John" <maxin.john@intel.com>
> Sent: Saturday, February 6, 2016 6:28:18 AM
> Subject: [PATCH 3/3][mdadm] Monitor.c: fix compiler error with x32 toolchain
> 
> From: "Maxin B. John" <maxin.john@intel.com>
> 
> With x32 toolchain, this code caused the below listed error:
> 
> | Monitor.c: In function 'check_array':
> | Monitor.c:545:16: error: comparison between signed and unsigned
> integer expressions [-Werror=sign-compare]
> |   if (st->utime == array.utime &&
> 
> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> ---
>  Monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index f19c2e5..748d61b 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -542,7 +542,7 @@ static int check_array(struct state *st, struct
> mdstat_ent *mdstat,
>  		alert("NewArray", st->devname, NULL, ainfo);
>  	}
>  
> -	if (st->utime == array.utime &&
> +	if ((unsigned long)st->utime == array.utime &&
>  	    st->failed == array.failed_disks &&
>  	    st->working == array.working_disks &&
>  	    st->spare == array.spare_disks &&

Hi Maxin

I sent the patch some days ago and I think it's not what Jes wanted. You can
see the mails in the list. I'll send the patch again.

Best Regards
Xiao
