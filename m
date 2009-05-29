From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 08/11] async_tx: add support for asynchronous GF
 multiplication
Date: Fri, 29 May 2009 14:42:11 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C72@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200111q37457b29lb9e30879e251888@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905200111q37457b29lb9e30879e251888@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> [ Based on an original patch by Yuri Tikhonov ]
>=20
> This adds support for doing asynchronous GF multiplication by adding
> two additional functions to the async_tx API:
>=20
> =A0async_gen_syndrome() does simultaneous XOR and Galois field
> =A0 =A0multiplication of sources.
>=20
> =A0async_syndrome_val() validates the given source buffers against kn=
own P
> =A0 =A0and Q values.
>=20
> When a request is made to run async_pq against more than the hardware
> maximum number of supported sources we need to reuse the previous
> generated P and Q values as sources into the next operation. =A0Care =
must
> be taken to remove Q from P' and P from Q'. =A0For example to perform=
 a 5
> source pq op with hardware that only supports 4 sources at a time the
> following approach is taken:
>=20
> p, q =3D PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08}))
> p', q' =3D PQ(p, q, q, src4, COEF({00}, {01}, {00}, {10}))
>=20
> p' =3D p + q + q + src4 =3D p + src4
> q' =3D {00}*p + {01}*q + {00}*q + {10}*src4 =3D q + {10}*src4
>=20
> Note: 4 is the minimum acceptable maxpq otherwise we punt to
> synchronous-software path.
>=20
> The DMA_PREP_CONTINUE flag indicates to the driver to reuse p and q a=
s
> sources (in the above manner) and fill the remaining slots up to maxp=
q
> with the new sources/coefficients.
>=20
> Note: Some devices have native support for P+Q continuation and can s=
kip
> this extra work. =A0Devices with this capability can advertise it wit=
h
> dma_set_maxpq. =A0It is up to each driver how the DMA_PREP_CONTINUE f=
lag
> is honored.
>=20
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0arch/arm/mach-iop13xx/setup.c | =A0 =A02
> =A0crypto/async_tx/Kconfig =A0 =A0 =A0 | =A0 =A04
> =A0crypto/async_tx/Makefile =A0 =A0 =A0| =A0 =A01
> =A0crypto/async_tx/async_pq.c =A0 =A0| =A0399 +++++++++++++++++++++++=
++++++++++++++++++
> =A0crypto/async_tx/async_xor.c =A0 | =A0 =A02
> =A0drivers/dma/dmaengine.c =A0 =A0 =A0 | =A0 =A04
> =A0drivers/dma/iop-adma.c =A0 =A0 =A0 =A0| =A0 =A02
> =A0include/linux/async_tx.h =A0 =A0 =A0| =A0 =A09 +
> =A0include/linux/dmaengine.h =A0 =A0 | =A0 58 +++++-
> =A09 files changed, 472 insertions(+), 9 deletions(-)
> =A0create mode 100644 crypto/async_tx/async_pq.c

(...)

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Since we have clobbered the src_list=
 we are committed
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to doing this asynchronously. =A0D=
rivers force forward
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* progress in case they can not prov=
ide a descriptor
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (;;) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D dma->device_prep=
_dma_pq(chan, dma_dest,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&dma_src[src_off],
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pq_src_cnt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&coefs[src_off], len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(tx))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 async_tx_quiesce(&submi=
t->depend_tx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_async_issue_pending=
(chan);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

How about adding a timeout to the loop in case we do not get a descript=
or at all for some reason?

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (;;) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D device->device_p=
rep_dma_pq_val(chan, pq, dma_src,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 disks - 2,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 raid6_gfexp,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len, pqres,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(tx))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 async_tx_quiesce(&submi=
t->depend_tx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_async_issue_pending=
(chan);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

Same as above...

Thanks,
Maciej--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
