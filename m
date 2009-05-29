From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 09/11] async_tx: add support for asynchronous RAID6
 recovery operations
Date: Fri, 29 May 2009 14:42:15 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C73@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010012.4104.50825.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250323q2e14efd6q69022a62cc7fd01f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250323q2e14efd6q69022a62cc7fd01f@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> =A0async_raid6_2data_recov() recovers two data disk failures
>=20
> =A0async_raid6_datap_recov() recovers a data disk and the P disk
>=20
> These routines are a port of the synchronous versions found in
> drivers/md/raid6recov.c. =A0The primary difference is breaking out th=
e xor
> operations into separate calls to async_xor. =A0Two helper routines a=
re
> introduced to perform scalar multiplication where needed.
> async_sum_product() multiplies two sources by scalar coefficients and
> then sums (xor) the result. =A0async_mult() simply multiplies a singl=
e
> source by a scalar.
>=20
> [ Impact: asynchronous raid6 recovery routines for 2data and datap ca=
ses ]
>=20
> Cc: Yuri Tikhonov <yur@emcraft.com>
> Cc: Ilya Yanok <yanok@emcraft.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A05 +
> =A0crypto/async_tx/Makefile =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01
> =A0crypto/async_tx/async_raid6_recov.c | =A0292 +++++++++++++++++++++=
++++++++++++++
> =A0include/linux/async_tx.h =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A08 +
> =A04 files changed, 306 insertions(+), 0 deletions(-)
> =A0create mode 100644 crypto/async_tx/async_raid6_recov.c

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
=20
With a minor comment:

> +static struct dma_async_tx_descriptor *
> +async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
> + =A0 =A0 =A0 =A0 =A0struct async_submit_ctl *submit)
> +{
> + =A0 =A0 =A0 struct dma_chan *chan =3D async_tx_find_channel(submit,=
 DMA_PQ,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &dest, 1, srcs, 2, len);
> + =A0 =A0 =A0 struct dma_device *dma =3D chan ? chan->device : NULL;
> + =A0 =A0 =A0 const u8 *qmul; /* Q multiplier table */
> + =A0 =A0 =A0 u8 *d, *s;
> +
> + =A0 =A0 =A0 if (dma) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_addr_t dma_dest[2];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_addr_t dma_src[1];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct device *dev =3D dma->dev;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dma_async_tx_descriptor *tx;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum dma_ctrl_flags dma_flags =3D DMA_P=
REP_PQ_DISABLE_P;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_dest[1] =3D dma_map_page(dev, dest,=
 0, len,
> DMA_BIDIRECTIONAL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_src[0] =3D dma_map_page(dev, src, 0=
, len, DMA_TO_DEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D dma->device_prep_dma_pq(chan, dm=
a_dest, dma_src, 1, &coef,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0len, dma_flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tx) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 async_tx_submit(chan, t=
x, submit);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tx;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }

How about adding "run the operation synchronously" comment at this poin=
t, just like it is in async_sum_product?

Maciej--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
