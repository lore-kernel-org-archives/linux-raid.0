From: Stephen Kent <smkent@smkent.net>
Subject: Re: mdadm named array (metadata 1.2) and udev when assembling an
 array in initramfs
Date: Sun, 2 Nov 2014 20:16:34 -0800
Message-ID: <CAC45b7=H2kFg2VdFq2xdaQ=z4MebV3QC-aA1X5TO0ra=749puA@mail.gmail.com>
References: <20141103125020.19308fd5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141103125020.19308fd5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 2, 2014 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
>
> Hi Stephen,
>  thanks for the bug report.
> This patch should fix it.
>
> NeilBrown
>
> From 628cdf19ea35daad22e409e51c0abc7ffb19d6aa Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 3 Nov 2014 12:49:05 +1100
> Subject: [PATCH] Rebuildmap: strip local host name from device name.
>
> When /run/mdadm/map is being rebuilt, e.g. by "mdadm -Ir",
> if the device doesn't exist in /dev, we have to choose
> a name.
> Currently we don't strip the hostname which is wrong if
> it is the local host.
>
> Reported-by: Stephen Kent <smkent@smkent.net>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/mapfile.c b/mapfile.c
> index 4e7f24214b8a..41599df05f97 100644
> --- a/mapfile.c
> +++ b/mapfile.c
> @@ -455,12 +455,19 @@ void RebuildMap(void)
>                                                         sep = "";
>                                                 }
>                                         }
> -                                       if (strchr(name, ':'))
> -                                               /* probably a uniquifying
> +                                       if (strchr(name, ':')) {
> +                                               /* Probably a uniquifying
>                                                  * hostname prefix.  Allow
> -                                                * without a suffix
> +                                                * without a suffix, and strip
> +                                                * hostname if it is us.
>                                                  */
> +                                               if (homehost && unum == -1 &&
> +                                                   strncmp(name, homehost,
> +                                                           strlen(homehost)) == 0 &&
> +                                                   name[strlen(homehost)] == ':')
> +                                                       name += strlen(homehost)+1;
>                                                 unum = -1;
> +                                       }
>
>                                         while (conflict) {
>                                                 if (unum >= 0)


Your patch works for me! Thanks so much for taking a look.

Stephen
