From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 01/11] async_tx: rename zero_sum to val
Date: Fri, 29 May 2009 14:41:31 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C69@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005931.4104.81475.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200110x63b22601idbbdf3369984fa9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905200110x63b22601idbbdf3369984fa9a@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> 'zero_sum' does not properly describe the operation of generating par=
ity
> and checking that it validates against an existing buffer. =A0Change =
the
> name of the operation to 'val' (for 'validate'). =A0This is in
> anticipation of the p+q case where it is a requirement to identify th=
e
> target parity buffers separately from the source buffers, because the
> target parity buffers will not have corresponding pq coefficients.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0arch/arm/mach-iop13xx/setup.c | =A0 =A08 ++++----
> =A0arch/arm/plat-iop/adma.c =A0 =A0 =A0| =A0 =A02 +-
> =A0crypto/async_tx/async_xor.c =A0 | =A0 16 ++++++++--------
> =A0drivers/dma/dmaengine.c =A0 =A0 =A0 | =A0 =A04 ++--
> =A0drivers/dma/iop-adma.c =A0 =A0 =A0 =A0| =A0 38 +++++++++++++++++++=
-------------------
> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
> =A0include/linux/async_tx.h =A0 =A0 =A0| =A0 =A02 +-
> =A0include/linux/dmaengine.h =A0 =A0 | =A0 =A08 ++++----
> =A08 files changed, 40 insertions(+), 40 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

with following comments:

> @@ -1072,10 +1072,10 @@ iop_adma_xor_zero_sum_self_test(struct
> iop_adma_device *device)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_srcs[i] =3D dma_map_page(dma_chan-=
>device->dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 zero_sum_srcs[i], 0, PAGE_SIZE,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 DMA_TO_DEVICE);
> - =A0 =A0 =A0 tx =3D iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &zero_sum_result,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> + =A0 =A0 =A0 tx =3D iop_adma_prep_dma_xor_val(dma_chan, dma_srcs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&zero_sum_result,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0DMA_PREP_INTERRUPT | DMA_CTRL_ACK);

What about zero_sum_srcs and zero_sum_result? Shouldn't they be renamed=
 too?

> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -854,7 +854,7 @@ static void ops_run_check(struct stripe_head *sh)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xor_srcs[count++] =3D =
dev->page;
> =A0 =A0 =A0 =A0}
>=20
> - =A0 =A0 =A0 tx =3D async_xor_zero_sum(xor_dest, xor_srcs, 0, count,=
 STRIPE_SIZE,
> + =A0 =A0 =A0 tx =3D async_xor_val(xor_dest, xor_srcs, 0, count, STRI=
PE_SIZE,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&sh->ops.zero_sum_result, 0, NULL, NUL=
L, NULL);

And the same here...

Regards,
Maciej--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
