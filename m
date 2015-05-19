From: "David F." <df7729@gmail.com>
Subject: Re: [PATCH v2] mdadm: monitor: fix nullptr dereference when
 get_md_name() returns NULL
Date: Mon, 18 May 2015 18:42:22 -0700
Message-ID: <CAGRSmLuzqwn=7LQZx_CA1VE4SsGTHMEWU-TJkuHUeeaa8XUQ1Q@mail.gmail.com>
References: <1531453.K804EMet0W@sergeyv_box>
	<1591364.ylu2LGHCpE@sergeyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1591364.ylu2LGHCpE@sergeyv>
Sender: linux-raid-owner@vger.kernel.org
To: Sergey Vidishev <sergeyv@yandex-team.ru>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

not sure if that causes a memory leak since st not freed ?

On Mon, May 18, 2015 at 4:33 PM, Sergey Vidishev <sergeyv@yandex-team.ru> wrote:
> From c1e59424bfabee349aa7b8b903833475a56cf145 Mon Sep 17 00:00:00 2001
> From: Sergey Vidishev <sergeyv@yandex-team.ru>
> Date: Wed, 8 Oct 2014 21:51:03 +0400
> Subject: [PATCH] mdadm: monitor: fix nullptr dereference when get_md_name()
>  returns NULL
>
> Function add_new_arrays() expects that function get_md_name() should
> return pointer to devname, but also get_md_name() may return NULL. So
> check the pointer before use it in add_new_arrays().
>
> Signed-off-by: Sergey Vidishev <sergeyv@yandex-team.ru>
> ---
>
> v1 -> v2: more verbose commit message
>
> This patch against fresh git://neil.brown.name/mdadm.
> I'm not subscribed to the list, please CC me in replies.
>
>  Monitor.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 1cd378b..1bbaf89 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -687,6 +687,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>  {
>         struct mdstat_ent *mse;
>         int new_found = 0;
> +       char *name;
>
>         for (mse=mdstat; mse; mse=mse->next)
>                 if (mse->devnm[0] &&
> @@ -697,7 +698,12 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>                         struct state *st = xcalloc(1, sizeof *st);
>                         mdu_array_info_t array;
>                         int fd;
> -                       st->devname = xstrdup(get_md_name(mse->devnm));
> +
> +                       name = get_md_name(mse->devnm);
> +                       if (!name)
> +                               return 0;
> +
> +                       st->devname = xstrdup(name);
>                         if ((fd = open(st->devname, O_RDONLY)) < 0 ||
>                             ioctl(fd, GET_ARRAY_INFO, &array)< 0) {
>                                 /* no such array */
> --
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
