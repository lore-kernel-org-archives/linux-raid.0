From: Guilherme Piccoli <gpiccoli@canonical.com>
Subject: Re: [PATCH] md: raid0/linear: fix dereference before null check on
 pointer mddev
Date: Thu, 2 Jul 2020 11:40:51 -0300
Message-ID: <CAHD1Q_yy2gbBkd31oOJiJk2TU3K4wTV3gVtjLiQo1FW+e=5ivg@mail.gmail.com>
References: <20200702113502.37408-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20200702113502.37408-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Song Liu <song@kernel.org>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Great catch Colin, thanks!
Feel free to add my:

Reviewed-by: Guilherme G. Piccoli <gpiccoli@canonical.com>


P.S.  Not sure if it's only me, but the diff is soo much easier to
read when git is set to use patience diff algorithm:
https://termbin.com/f8ig
