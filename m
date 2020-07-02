From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md: raid0/linear: fix dereference before null check on
 pointer mddev
Date: Thu, 2 Jul 2020 11:36:48 -0700
Message-ID: <CAPhsuW4r5vLo2Py6Fwd6Oe4Pzr6hfjvXHuEwOc7-X86zhnsi1Q@mail.gmail.com>
References: <20200702113502.37408-1-colin.king@canonical.com> <CAHD1Q_yy2gbBkd31oOJiJk2TU3K4wTV3gVtjLiQo1FW+e=5ivg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHD1Q_yy2gbBkd31oOJiJk2TU3K4wTV3gVtjLiQo1FW+e=5ivg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Guilherme Piccoli <gpiccoli@canonical.com>
Cc: Colin King <colin.king@canonical.com>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 7:41 AM Guilherme Piccoli <gpiccoli@canonical.com> wrote:
>
> Great catch Colin, thanks!
> Feel free to add my:
>
> Reviewed-by: Guilherme G. Piccoli <gpiccoli@canonical.com>

Thanks Colin and Guilherme! Applied to md-next.

>
>
> P.S.  Not sure if it's only me, but the diff is soo much easier to
> read when git is set to use patience diff algorithm:
> https://termbin.com/f8ig

Agreed. Patience is cleaner.
