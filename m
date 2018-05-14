From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] md/raid1: add error handling of read error from FailFast device
Date: Mon, 14 May 2018 10:24:11 +0200
Message-ID: <CAMGffEkW-bXTJ7RoYER9uu4nSYKEfopTsWy87V9GUSojjhJ6dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Gi-Oh Kim <gi-oh.kim@profitbricks.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 9, 2018 at 10:58 AM, Jack Wang <jack.wang.usish@gmail.com> wrot=
e:
> ---------- Forwarded message ----------
> From: Gioh Kim <gi-oh.kim@profitbricks.com>
> Date: 2018-05-02 13:08 GMT+02:00
> Subject: [PATCH] md/raid1: add error handling of read error from FailFast=
 device
> To: shli@kernel.org
> =E6=8A=84=E9=80=81=EF=BC=9A linux-raid@vger.kernel.org, linux-kernel@vger=
.kernel.org, Gioh Kim
> <gi-oh.kim@profitbricks.com>
>
>
> Current handle_read_error() function calls fix_read_error()
> only if md device is RW and rdev does not include FailFast flag.
> It does not handle a read error from a RW device including
> FailFast flag.
>
> I am not sure it is intended. But I found that write IO error
> sets rdev faulty. The md module should handle the read IO error and
> write IO error equally. So I think read IO error should set rdev faulty.
>
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  drivers/md/raid1.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index e9e3308cb0a7..4445179aa4c8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2474,6 +2474,8 @@ static void handle_read_error(struct r1conf
> *conf, struct r1bio *r1_bio)
>                 fix_read_error(conf, r1_bio->read_disk,
>                                r1_bio->sector, r1_bio->sectors);
>                 unfreeze_array(conf);
> +       } else if (mddev->ro =3D=3D 0 && test_bit(FailFast, &rdev->flags)=
) {
> +               md_error(mddev, rdev);
>         } else {
>                 r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>         }
> --
> 2.14.1

Patch looks good to me!
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
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
