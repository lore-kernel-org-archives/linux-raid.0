From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/3][mdadm] mdadm.h: bswap is already defined in uclibc
Date: Mon, 08 Feb 2016 11:00:54 -0500
Message-ID: <wrfjsi13dweh.fsf@redhat.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
	<1454711298-32524-2-git-send-email-maxin.john@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454711298-32524-2-git-send-email-maxin.john@gmail.com> (Maxin
	B. John's message of "Sat, 6 Feb 2016 00:28:17 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

"Maxin B. John" <maxin.john@gmail.com> writes:
> From: "Maxin B. John" <maxin.john@intel.com>
>
> Fixes this build error:
>
> | In file included from mdadm.c:28:0:
> | mdadm.h:142:0: error: "bswap_16" redefined [-Werror]
> |  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
> |  ^
>
> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> ---
>  mdadm.h | 9 +++++++++
>  1 file changed, 9 insertions(+)

Hi Maxin,

I am not opposed to this, but I would like to understand why you see
these duplicate defines. What defines it in your build environment?

Cheers,
Jes

>
> diff --git a/mdadm.h b/mdadm.h
> index dd02be7..230e60f 100755
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -139,12 +139,20 @@ struct dlm_lksb {
>   * and there is no standard conversion function so... */
>  /* And dietlibc doesn't think byteswap is ok, so.. */
>  /*  #include <byteswap.h> */
> +
> +#ifndef bswap_16
>  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
>  		     ((x) & 0xff00U) >> 8)
> +#endif
> +
> +#ifndef bswap_32
>  #define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
>  		     ((x) & 0xff000000U) >> 24 | \
>  		     ((x) & 0x0000ff00U) << 8  | \
>  		     ((x) & 0x00ff0000U) >> 8)
> +#endif
> +
> +#ifndef bswap_64
>  #define bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
>  		     ((x) & 0xff00000000000000ULL) >> 56 | \
>  		     ((x) & 0x000000000000ff00ULL) << 40 | \
> @@ -153,6 +161,7 @@ struct dlm_lksb {
>  		     ((x) & 0x0000ff0000000000ULL) >> 24 | \
>  		     ((x) & 0x00000000ff000000ULL) << 8 | \
>  		     ((x) & 0x000000ff00000000ULL) >> 8)
> +#endif
>  
>  #if !defined(__KLIBC__)
>  #if BYTE_ORDER == LITTLE_ENDIAN
