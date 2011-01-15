From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH] Update CONFIG_MD_RAID6_PQ to CONFIG_RAID6_PQ in drivers/dma/iop-adma.c
Date: Fri, 14 Jan 2011 17:47:36 -0800
Message-ID: <AANLkTi=viRaYBA5cZN7D2HoG0oqwnhBurGvcpHGeg=EB@mail.gmail.com>
References: <AANLkTimdi-V1kNGwWdUQVmUEXXCrVZGwGS7nFJ=piwDc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimdi-V1kNGwWdUQVmUEXXCrVZGwGS7nFJ=piwDc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongquan <weiyqlq@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 29, 2010 at 4:30 AM, Wei Yongquan <weiyqlq@gmail.com> wrote=
:
> Commit f5e70d0fe3ea990cfb3fc8d7f76a719adcb1e0b5 renamed MD_RAID6_PQ t=
o RAID6_PQ,
> but iop-adma.c didn't update synchronously.
>
> Signed-off-by: Wei Yongquan <weiyqlq@gmail.com>
> ---
> =A0drivers/dma/iop-adma.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
> index 161c452..c6b01f5 100644
> --- a/drivers/dma/iop-adma.c
> +++ b/drivers/dma/iop-adma.c
> @@ -1261,7 +1261,7 @@ out:
> =A0 =A0 =A0 =A0return err;
> =A0}
>
> -#ifdef CONFIG_MD_RAID6_PQ
> +#ifdef CONFIG_RAID6_PQ
> =A0static int __devinit
> =A0iop_adma_pq_zero_sum_self_test(struct iop_adma_device *device)
> =A0{
> @@ -1584,7 +1584,7 @@ static int __devinit iop_adma_probe(struct
> platform_device *pdev)

Thanks.  I needed to fix up this line wrapping damage, but I have
applied this to the dmaengine tree.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
