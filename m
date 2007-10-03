From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] [mdadm] Add klibc support to mdadm.h
Date: Tue, 02 Oct 2007 18:50:07 -0700
Message-ID: <4702F54F.1070504@zytor.com>
References: <11903959391007-git-send-email-max@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11903959391007-git-send-email-max@stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

maximilian attems wrote:
> klibc still misses a lot functionality to let mdadm link against,
> this small step helps to get to the real trouble.. :)
> 
> Signed-off-by: maximilian attems <max@stro.at>
> ---
>  mdadm.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/mdadm.h b/mdadm.h
> index ac7d4b4..dba09f0 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -29,7 +29,7 @@
>  
>  #define	_GNU_SOURCE
>  #include	<unistd.h>
> -#ifndef __dietlibc__
> +#if !defined(__dietlibc__) && !defined(__KLIBC__)
>  extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>  #else

Wouldn't it be better to just compile with -D_FILE_OFFSET_BITS=64 on all 
libraries instead of using the LFS cruft?

	-hpa
