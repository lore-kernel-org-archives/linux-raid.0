From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] md/bitmap: use mddev_suspend/resume instead of ->quiesce()
Date: Mon, 15 Oct 2018 13:53:31 +0200
Message-ID: <CAMGffEkBzPEUPveXbJRVT8YsfBNgq1LJwj4Tc1RTqok23bUHjQ@mail.gmail.com>
References: <1539012243-7489-1-git-send-email-jinpuwang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539012243-7489-1-git-send-email-jinpuwang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wang Jinpu <xjtuwjp@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 8, 2018 at 5:24 PM Jack Wang <xjtuwjp@gmail.com> wrote:
>
> From: Jack Wang <jinpu.wang@profitbricks.com>
>
> After 9e1cc0a54556 ("md: use mddev_suspend/resume instead of ->quiesce()"=
)
> We still have similar left in bitmap functions.
>
> Replace quiesce() with mddev_suspend/resume.
>
> Also move md_bitmap_create out of mddev_suspend. and move mddev_resume
> after md_bitmap_destroy. as we did in set_bitmap_file.
>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>
>
> ---
> v3->v2: Drop the change in md_bitmap_resize, as Shaohua noticed
> mddev_suspend/resume is supposed to be called with reconfig_mutex hold, i=
t's not
> the case here.
> v2->v1: add reviewed-by.

ping?


--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
