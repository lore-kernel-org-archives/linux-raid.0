From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 03/11] async_tx: structify submission arguments, add
 scribble
Date: Fri, 29 May 2009 14:41:46 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6D@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250321v774c4e8dscd7a466cd2e61168@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250321v774c4e8dscd7a466cd2e61168@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> Prepare the api for the arrival of a new parameter, 'scribble'. =A0Th=
is
> will allow callers to identify scratchpad memory for dma address or p=
age
> address conversions. =A0As this adds yet another parameter, take this
> opportunity to convert the common submission parameters (flags,
> dependency, callback, and callback argument) into an object that is
> passed by reference.
>=20
> [ Impact: moves api pass-by-value parameters to a pass-by-reference s=
truct ]
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/async_memcpy.c | =A0 21 ++++-----
> =A0crypto/async_tx/async_memset.c | =A0 23 ++++------
> =A0crypto/async_tx/async_tx.c =A0 =A0 | =A0 34 +++++++--------
> =A0crypto/async_tx/async_xor.c =A0 =A0| =A0 93 +++++++++++++++++-----=
------------------
> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 59 ++++++++++++++=
+----------
> =A0include/linux/async_tx.h =A0 =A0 =A0 | =A0 84 ++++++++++++++++++++=
+++-------------
> =A06 files changed, 161 insertions(+), 153 deletions(-)

(...)

> @@ -811,13 +818,11 @@ ops_run_postxor(struct stripe_head *sh, struct
> dma_async_tx_descriptor *tx)
>=20
> =A0 =A0 =A0 =A0atomic_inc(&sh->count);
>=20
> - =A0 =A0 =A0 if (unlikely(count =3D=3D 1)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags &=3D ~(ASYNC_TX_XOR_DROP_DST | AS=
YNC_TX_XOR_ZERO_DST);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_memcpy(xor_dest, xor_srcs[=
0], 0, 0, STRIPE_SIZE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags, tx, ops_complete=
_postxor, sh);
> - =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_xor(xor_dest, xor_srcs, 0,=
 count, STRIPE_SIZE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags, tx, ops_complete=
_postxor, sh);
> + =A0 =A0 =A0 init_async_submit(&submit, flags, tx, ops_complete_post=
xor, sh, NULL);
> + =A0 =A0 =A0 if (unlikely(count =3D=3D 1))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_memcpy(xor_dest, xor_srcs[=
0], 0, 0, STRIPE_SIZE, &submit);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_xor(xor_dest, xor_srcs, 0,=
 count, STRIPE_SIZE, &submit);
> =A0}

What about ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST flags cleari=
ng before async_memcpy?

Maciej--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
