From: jes.sorensen@gmail.com
Subject: Re: [MDADM PATCH 1/2] Add Wimplicit-fallthrough=0 in Makefile
Date: Mon, 06 Mar 2017 15:30:43 -0500
Message-ID: <wrfjh936m9l8.fsf@gmail.com>
References: <1488348766-31087-1-git-send-email-xni@redhat.com>
        <1488348766-31087-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488348766-31087-2-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Wed, 1 Mar 2017 14:12:45 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> There are many errors like 'error: this statement may fall through'. 
> But the logic is right. So add the flag Wimplicit-fallthrough=0 
> to disable the error messages. The method I use is from 
> https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
> #index-Wimplicit-fallthrough-375
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index a6f464c..b9f52e0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -43,7 +43,7 @@ KLIBC_GCC = gcc -nostdinc -iwithprefix include
> -I$(KLIBC)/klibc/include -I$(KLIB
>  
>  CC ?= $(CROSS_COMPILE)gcc
>  CXFLAGS ?= -ggdb
> -CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> +CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wimplicit-fallthrough=0

Hi Xiao,

I am not sure how long -Wimplicit-fallthrough has existed. I want to
make sure we allow for this to compile with older compilers as well.

Could you please make it a check so this flag is only set if the version
of gcc supports it?

Thanks,
Jes


