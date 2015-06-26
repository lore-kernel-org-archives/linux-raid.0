From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: DM_CACHE_SMQ is experimental and enabled by default? (was: Re: dm
 cache: add stochastic-multi-queue (smq) policy)
Date: Fri, 26 Jun 2015 09:47:46 +0200
Message-ID: <CAMuHMdVfK8x8xXqaq=yX41qZA0L3VP-sezKfDureYMa-QqfM6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jun 26, 2015 at 2:13 AM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=66a636356647a9be8885c2ce2948de126577698a
> Commit:     66a636356647a9be8885c2ce2948de126577698a
> Parent:     40775257b97e27305cf5c2425be7acaa6edee4ea
> Refname:    refs/heads/master
> Author:     Joe Thornber <ejt@redhat.com>
> AuthorDate: Fri May 15 15:33:34 2015 +0100
> Committer:  Mike Snitzer <snitzer@redhat.com>
> CommitDate: Thu Jun 11 17:12:59 2015 -0400
>
>     dm cache: add stochastic-multi-queue (smq) policy

> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index edcf4ab..b597273 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -304,6 +304,18 @@ config DM_CACHE_MQ
>           This is meant to be a general purpose policy.  It prioritises
>           reads over writes.
>
> +config DM_CACHE_SMQ
> +       tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
> +       depends on DM_CACHE
> +       default y

A feature cannot be "EXPERIMENTAL", and be enabled by default.
Please drop (at least) one of them.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
