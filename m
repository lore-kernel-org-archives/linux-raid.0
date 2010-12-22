From: saeed bishara <saeed.bishara@gmail.com>
Subject: Re: [PATCH] mv_xor: fix race in tasklet function
Date: Wed, 22 Dec 2010 13:21:43 +0200
Message-ID: <AANLkTi=KSPEurnOvh_kXPua1xR7-=dno14C8gRm2kJF=@mail.gmail.com>
References: <1292943219-26470-1-git-send-email-saeed@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1292943219-26470-1-git-send-email-saeed@marvell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Saeed Bishara <saeed@marvell.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan, can you please merge this patch?

On Tue, Dec 21, 2010 at 4:53 PM, Saeed Bishara <saeed@marvell.com> wrot=
e:
> use mv_xor_slot_cleanup() instead of __mv_xor_slot_cleanup() as the f=
ormer function
> aquires the spin lock that needed to protect the drivers data.
>
> Signed-off-by: Saeed Bishara <saeed@marvell.com>
> ---
> =C2=A0drivers/dma/mv_xor.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
> index 411d5bf..a25f5f6 100644
> --- a/drivers/dma/mv_xor.c
> +++ b/drivers/dma/mv_xor.c
> @@ -449,7 +449,7 @@ mv_xor_slot_cleanup(struct mv_xor_chan *mv_chan)
> =C2=A0static void mv_xor_tasklet(unsigned long data)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct mv_xor_chan *chan =3D (struct mv_xo=
r_chan *) data;
> - =C2=A0 =C2=A0 =C2=A0 __mv_xor_slot_cleanup(chan);
> + =C2=A0 =C2=A0 =C2=A0 mv_xor_slot_cleanup(chan);
> =C2=A0}
>
> =C2=A0static struct mv_xor_desc_slot *
> --
> 1.6.0.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
