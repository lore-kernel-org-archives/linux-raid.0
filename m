From: "Maxin B. John" <maxin.john@gmail.com>
Subject: Re: [PATCH 2/3][mdadm] mdadm.h: bswap is already defined in uclibc
Date: Thu, 11 Feb 2016 13:26:52 +0200
Message-ID: <CAMhs6YyA61Mie1Ku1EpV0+z0Xe6Ft1xqFeNZix2gOLFA3rgXpA@mail.gmail.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
	<1454711298-32524-2-git-send-email-maxin.john@gmail.com>
	<wrfjsi13dweh.fsf@redhat.com>
	<CAMhs6YwxytaKNJ-v9J714whBxgDxz_cQ9t8qi-wSp5Ho--vjfQ@mail.gmail.com>
	<wrfjio1w74od.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjio1w74od.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

Hi Jes,

On Wed, Feb 10, 2016 at 9:20 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> "Maxin B. John" <maxin.john@gmail.com> writes:
>> Hi Jes,
>>
>> On Mon, Feb 8, 2016 at 6:00 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>>> "Maxin B. John" <maxin.john@gmail.com> writes:
>>>> From: "Maxin B. John" <maxin.john@intel.com>
>>>>
>>>> Fixes this build error:
>>>>
>>>> | In file included from mdadm.c:28:0:
>>>> | mdadm.h:142:0: error: "bswap_16" redefined [-Werror]
>>>> |  #define bswap_16(x) (((x) & 0x00ffU) << 8 | \
>>>> |  ^
>>>>
>>>> Signed-off-by: Maxin B. John <maxin.john@intel.com>
>>>> ---
>>>>  mdadm.h | 9 +++++++++
>>>>  1 file changed, 9 insertions(+)
>>>
>>> Hi Maxin,
>>>
>>> I am not opposed to this, but I would like to understand why you see
>>> these duplicate defines. What defines it in your build environment?
>>
>>
>> I get the below listed error message with uclibc builds:
>
<snip>
>
> Maxin,
>
> I think it's actually wrong for uClibc to expose those macros with such
> a common name, but rather than picking up outside macros randomly I
> prefer to rename the mdadm ones to be sure we know what we are getting.

That looks reasonable to me.

> Instead of your patch, I applied this one instead. I hope that is fine
> with you.

Yes, this fix looks much better. Thank you!

> Cheers,
> Jes

Best Regards,
Maxin

>
> From dd47b4e0c45fd72b94a9a7d0f0a5046ef9c8d97b Mon Sep 17 00:00:00 2001
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> Date: Wed, 10 Feb 2016 14:15:38 -0500
> Subject: [PATCH] mdadm.h: rename bswap macros to avoid clash with uClibc
>  definitions
>
> uClibc exposes it's own version of bswap_<X> macros. Rather than
> pulling in random macros by change, rename the mdadm ones to make sure
> we know what we are getting.
>
> Reported-by: "Maxin B. John" <maxin.john@gmail.com>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  mdadm.h | 52 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
>
> diff --git a/mdadm.h b/mdadm.h
> index dd02be7..72888e2 100755
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -139,20 +139,20 @@ struct dlm_lksb {
>   * and there is no standard conversion function so... */
>  /* And dietlibc doesn't think byteswap is ok, so.. */
>  /*  #include <byteswap.h> */
> -#define bswap_16(x) (((x) & 0x00ffU) << 8 | \
> -                    ((x) & 0xff00U) >> 8)
> -#define bswap_32(x) (((x) & 0x000000ffU) << 24 | \
> -                    ((x) & 0xff000000U) >> 24 | \
> -                    ((x) & 0x0000ff00U) << 8  | \
> -                    ((x) & 0x00ff0000U) >> 8)
> -#define bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
> -                    ((x) & 0xff00000000000000ULL) >> 56 | \
> -                    ((x) & 0x000000000000ff00ULL) << 40 | \
> -                    ((x) & 0x00ff000000000000ULL) >> 40 | \
> -                    ((x) & 0x0000000000ff0000ULL) << 24 | \
> -                    ((x) & 0x0000ff0000000000ULL) >> 24 | \
> -                    ((x) & 0x00000000ff000000ULL) << 8 | \
> -                    ((x) & 0x000000ff00000000ULL) >> 8)
> +#define __mdadm_bswap_16(x) (((x) & 0x00ffU) << 8 | \
> +                            ((x) & 0xff00U) >> 8)
> +#define __mdadm_bswap_32(x) (((x) & 0x000000ffU) << 24 | \
> +                            ((x) & 0xff000000U) >> 24 | \
> +                            ((x) & 0x0000ff00U) << 8  | \
> +                            ((x) & 0x00ff0000U) >> 8)
> +#define __mdadm_bswap_64(x) (((x) & 0x00000000000000ffULL) << 56 | \
> +                            ((x) & 0xff00000000000000ULL) >> 56 | \
> +                            ((x) & 0x000000000000ff00ULL) << 40 | \
> +                            ((x) & 0x00ff000000000000ULL) >> 40 | \
> +                            ((x) & 0x0000000000ff0000ULL) << 24 | \
> +                            ((x) & 0x0000ff0000000000ULL) >> 24 | \
> +                            ((x) & 0x00000000ff000000ULL) << 8 |  \
> +                            ((x) & 0x000000ff00000000ULL) >> 8)
>
>  #if !defined(__KLIBC__)
>  #if BYTE_ORDER == LITTLE_ENDIAN
> @@ -163,19 +163,19 @@ struct dlm_lksb {
>  #define __le32_to_cpu(_x) (unsigned int)(_x)
>  #define __le64_to_cpu(_x) (unsigned long long)(_x)
>
> -#define        __cpu_to_be16(_x) bswap_16(_x)
> -#define __cpu_to_be32(_x) bswap_32(_x)
> -#define __cpu_to_be64(_x) bswap_64(_x)
> -#define        __be16_to_cpu(_x) bswap_16(_x)
> -#define __be32_to_cpu(_x) bswap_32(_x)
> -#define __be64_to_cpu(_x) bswap_64(_x)
> +#define        __cpu_to_be16(_x) __mdadm_bswap_16(_x)
> +#define __cpu_to_be32(_x) __mdadm_bswap_32(_x)
> +#define __cpu_to_be64(_x) __mdadm_bswap_64(_x)
> +#define        __be16_to_cpu(_x) __mdadm_bswap_16(_x)
> +#define __be32_to_cpu(_x) __mdadm_bswap_32(_x)
> +#define __be64_to_cpu(_x) __mdadm_bswap_64(_x)
>  #elif BYTE_ORDER == BIG_ENDIAN
> -#define        __cpu_to_le16(_x) bswap_16(_x)
> -#define __cpu_to_le32(_x) bswap_32(_x)
> -#define __cpu_to_le64(_x) bswap_64(_x)
> -#define        __le16_to_cpu(_x) bswap_16(_x)
> -#define __le32_to_cpu(_x) bswap_32(_x)
> -#define __le64_to_cpu(_x) bswap_64(_x)
> +#define        __cpu_to_le16(_x) __mdadm_bswap_16(_x)
> +#define __cpu_to_le32(_x) __mdadm_bswap_32(_x)
> +#define __cpu_to_le64(_x) __mdadm_bswap_64(_x)
> +#define        __le16_to_cpu(_x) __mdadm_bswap_16(_x)
> +#define __le32_to_cpu(_x) __mdadm_bswap_32(_x)
> +#define __le64_to_cpu(_x) __mdadm_bswap_64(_x)
>
>  #define        __cpu_to_be16(_x) (unsigned int)(_x)
>  #define __cpu_to_be32(_x) (unsigned int)(_x)
> --
> 2.5.0
>
