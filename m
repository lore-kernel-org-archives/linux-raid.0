From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Date: Tue, 26 Feb 2013 17:27:45 -0800
Message-ID: <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130223074001.GA5199@www.outflux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Alasdair G Kergon <agk@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-raid.ids

On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> ---
>  drivers/md/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 7cdf359..0cc3a3d 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
>         depends on MD_RAID456
>         depends on SMP
> -       depends on EXPERIMENTAL

In this case MULTICORE_RAID456 and the related code should go as
well... now that there are patches to supersede this implementation in
md-next.

--
Dan
