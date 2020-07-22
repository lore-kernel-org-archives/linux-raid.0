From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] raid: md_p.h: drop duplicated word in a comment
Date: Tue, 21 Jul 2020 22:08:38 -0700
Message-ID: <CAPhsuW7Mg-oKrSrtTUsDq1FGKTQJ30UVKV5en5SCJLrmKBcf2A@mail.gmail.com>
References: <d01bc32e-3b17-bd4d-faf6-29b4b931c9f6@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d01bc32e-3b17-bd4d-faf6-29b4b931c9f6@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jul 17, 2020 at 4:37 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Drop the doubled word "the" in a comment.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org

Applied to md-next. Thanks!

> ---
>  include/uapi/linux/raid/md_p.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-next-20200714.orig/include/uapi/linux/raid/md_p.h
> +++ linux-next-20200714/include/uapi/linux/raid/md_p.h
> @@ -123,7 +123,7 @@ typedef struct mdp_device_descriptor_s {
>
>  /*
>   * Notes:
> - * - if an array is being reshaped (restriped) in order to change the
> + * - if an array is being reshaped (restriped) in order to change
>   *   the number of active devices in the array, 'raid_disks' will be
>   *   the larger of the old and new numbers.  'delta_disks' will
>   *   be the "new - old".  So if +ve, raid_disks is the new value, and
>
