From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 01/11] async_tx: rename zero_sum to val
Date: Wed, 3 Jun 2009 11:12:48 -0700
Message-ID: <e9c3a7c20906031112k52de5879uc97b269fbf1a2aac@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005931.4104.81475.stgit@dwillia2-linux.ch.intel.com>
	 <f12847240905200110x63b22601idbbdf3369984fa9a@mail.gmail.com>
	 <129600E5E5FB004392DDC3FB599660D7ACC13C69@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7ACC13C69@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/5/29 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
> Dan Williams wrote:
>> 'zero_sum' does not properly describe the operation of generating pa=
rity
>> and checking that it validates against an existing buffer. =A0Change=
 the
>> name of the operation to 'val' (for 'validate'). =A0This is in
>> anticipation of the p+q case where it is a requirement to identify t=
he
>> target parity buffers separately from the source buffers, because th=
e
>> target parity buffers will not have corresponding pq coefficients.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0arch/arm/mach-iop13xx/setup.c | =A0 =A08 ++++----
>> =A0arch/arm/plat-iop/adma.c =A0 =A0 =A0| =A0 =A02 +-
>> =A0crypto/async_tx/async_xor.c =A0 | =A0 16 ++++++++--------
>> =A0drivers/dma/dmaengine.c =A0 =A0 =A0 | =A0 =A04 ++--
>> =A0drivers/dma/iop-adma.c =A0 =A0 =A0 =A0| =A0 38 ++++++++++++++++++=
+-------------------
>> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02 +-
>> =A0include/linux/async_tx.h =A0 =A0 =A0| =A0 =A02 +-
>> =A0include/linux/dmaengine.h =A0 =A0 | =A0 =A08 ++++----
>> =A08 files changed, 40 insertions(+), 40 deletions(-)
>
> Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
>
> with following comments:
>
>> @@ -1072,10 +1072,10 @@ iop_adma_xor_zero_sum_self_test(struct
>> iop_adma_device *device)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_srcs[i] =3D dma_map_page(dma_chan=
->device->dev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 zero_sum_srcs[i], 0, PAGE_SIZE,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 DMA_TO_DEVICE);
>> - =A0 =A0 =A0 tx =3D iop_adma_prep_dma_zero_sum(dma_chan, dma_srcs,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &zero_sum_result,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>> + =A0 =A0 =A0 tx =3D iop_adma_prep_dma_xor_val(dma_chan, dma_srcs,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0IOP_ADMA_NUM_SRC_TEST + 1, PAGE_SIZE,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&zero_sum_result,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>
> What about zero_sum_srcs and zero_sum_result? Shouldn't they be renam=
ed too?

No, the hardware specification calls the operation "zero sum", so it
is fine that the kernel calls it one thing but the driver translates
it into something else.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
