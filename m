From: Gi-Oh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH] md: bitmap: use mddev_suspend/resume instead of ->quiesce()
Date: Tue, 18 Sep 2018 10:34:50 +0200
Message-ID: <CAJX1YtapSbc3OZM+S3eqvOJRO6h1NG1tfxD-We8R81BLoLk7nw@mail.gmail.com>
References: <1536852930-18926-1-git-send-email-jinpuwang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536852930-18926-1-git-send-email-jinpuwang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: shli@kernel.org, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

On Thu, Sep 13, 2018 at 5:35 PM, Jack Wang <xjtuwjp@gmail.com> wrote:
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

Reviewed-by: Gioh Kim <gi-oh.kim@profitbricks.com>





--=20
GIOH KIM
Linux Kernel Entwickler

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 176 2697 8962
Fax:      +49 30 577 008 299
Email:    gi-oh.kim@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
