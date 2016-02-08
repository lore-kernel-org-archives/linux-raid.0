From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Makefile: make the CC definition conditional
Date: Mon, 08 Feb 2016 10:55:05 -0500
Message-ID: <wrfjy4avfb8m.fsf@redhat.com>
References: <1454925569-6840-1-git-send-email-maxin.john@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454925569-6840-1-git-send-email-maxin.john@gmail.com> (Maxin
	B. John's message of "Mon, 8 Feb 2016 11:59:29 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: linux-raid@vger.kernel.org, "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

"Maxin B. John" <maxin.john@gmail.com> writes:
> From: "Maxin B. John" <maxin.john@intel.com>
>
> By hardcoding CC's definition in the Makefile, all the external gcc
> parameters set by tune settings are lost. This causes compile failure
> with x32 toolchain
>
> Signed-off-by: Maxin B. John <maxin.john@intel.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied!

Thanks,
Jes

> diff --git a/Makefile b/Makefile
> index fd79cfb..5fd7f16 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -41,7 +41,7 @@ KLIBC=/home/src/klibc/klibc-0.77
>  
>  KLIBC_GCC = gcc -nostdinc -iwithprefix include
> -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include
> -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
>  
> -CC = $(CROSS_COMPILE)gcc
> +CC ?= $(CROSS_COMPILE)gcc
>  CXFLAGS ?= -ggdb
>  CWFLAGS = -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>  ifdef WARN_UNUSED
