From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] uapi: fix linux/raid/md_p.h userspace compilation error
Date: Thu, 20 Apr 2017 09:41:12 -0700
Message-ID: <20170420164112.vsi5j2qudqddxess@kernel.org>
References: <xr93wpak0xkb.fsf@gthelen.mtv.corp.google.com>
 <20170419084806.28405-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170419084806.28405-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org, gthelen@google.com, ncroxon@redhat.com
List-Id: linux-raid.ids

On Wed, Apr 19, 2017 at 10:48:06AM +0200, Artur Paszkiewicz wrote:
> Use __le32 and __le64 instead of u32 and u64.
> 
> This fixes klibc build error:
>   In file included from /klibc/usr/klibc/../include/sys/md.h:30:0,
>                    from /klibc/usr/kinit/do_mounts_md.c:19:
>   /linux-next/usr/include/linux/raid/md_p.h:414:51: error: 'u32' undeclared here (not in a function)
>     (PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))

applied, thanks!
 
> Reported-by: Greg Thelen <gthelen@google.com>
> Reported-by: Nigel Croxon <ncroxon@redhat.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  include/uapi/linux/raid/md_p.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index d9a1ead867b9..d500bd224979 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -411,7 +411,7 @@ struct ppl_header_entry {
>  #define PPL_HEADER_SIZE 4096
>  #define PPL_HDR_RESERVED 512
>  #define PPL_HDR_ENTRY_SPACE \
> -	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))
> +	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(__le32) - sizeof(__le64))
>  #define PPL_HDR_MAX_ENTRIES \
>  	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
