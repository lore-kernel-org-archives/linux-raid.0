From: NeilBrown <neilb@suse.de>
Subject: Re: async_tx and RAID HW xor engine
Date: Tue, 1 May 2012 10:49:14 +1000
Message-ID: <20120501104914.4066a38c@notabene.brown>
References: <CAGA5_H55asVEekOd1ae2OjkK07W5Okf1iTCg10oRSX4+M7FLEA@mail.gmail.com>
	<CAA9_cmc0eEW-vjAuoj-ZnbX3vOrpswjVXU-NDw_rSSxqwvpU_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/endU5IhPkGR94pXBVRnWybh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmc0eEW-vjAuoj-ZnbX3vOrpswjVXU-NDw_rSSxqwvpU_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Rajasekhar Pulluru <pullururajasekhar@gmail.com>, linux-raid@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
List-Id: linux-raid.ids

--Sig_/endU5IhPkGR94pXBVRnWybh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 13:31:41 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> [ adding Russell and Neil for comment about the proposed change to async_=
tx ]

I've managed to avoid learning much about the internal details of async_tx
and adma but I thought I'd have a quick look.

Doesn't this Kconfig change simply disable ASYNC_TX_DMA on any device that
selects ASNC_TX_ENABLE_CHANNEL_SWITCH.  i.e.
  INTEL_IOP_ADMA
  FSL_DMA
  MX_XOR
  AMCC_PPC440_SPA_ADMA
Is that what you want to do?  Disable all of those?
I guess if they don't work then that is the right thing to do....

NeilBrown




>=20
> On Mon, Apr 30, 2012 at 3:05 AM, Rajasekhar Pulluru
> <pullururajasekhar@gmail.com> wrote:
> > Hi,
> >
> > I am trying to understand how are hardware xor engine's utilized by
> > async_tx module. I don't get the exact link that connects async_tx and
> > hardware xor engine.
> > Could someone help me understand it.
> >
> > Registration of a RAID HW XOR engine happens in
> > drivers/dma/<soc-xor.c> using dma_async_device_register(). Does this
> > registration function connect the async_tx api's
> > to use the HW XOR engine?
>=20
> Yes, the channel registers its capabilities with dmaengine, and then
> async_tx asks dmaengine (via dma_find_channel) for a resource to carry
> out the operation(s).
>=20
> > Or is there anything we need to support to
> > make async_tx api's to take advantage of the hardware XOR engine?
>=20
> Registration with dma engine should be all that is needed, but a word
> of caution that the channel switching mechanism has been found to be
> incompatible with the dma mapping api.  So, unless your dma channel
> supports all the operations needed for raid, do not rely on async_tx's
> channel switching capabilities.
>=20
> An architecture where this is known to be a problem is ARM, but I
> wonder if we should take the following global step until this is fixed
> properly?
>=20
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index cf9da36..b812b6b 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -280,6 +280,7 @@ config NET_DMA
>  config ASYNC_TX_DMA
>         bool "Async_tx: Offload support for the async_tx api"
>         depends on DMA_ENGINE
> +       depends on !ASYNC_TX_ENABLE_CHANNEL_SWITCH
>         help
>           This allows the async_tx api to take advantage of offload engin=
es for
>           memcpy, memset, xor, and raid6 p+q operations.  If your platfor=
m has


--Sig_/endU5IhPkGR94pXBVRnWybh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT58zCjnsnt1WYoG5AQKSgw//Tb3vsmkoXTDRDCA6kLIR7DfDL/3HzhU+
vJujTJUt+OAJ07P8j8SxsmXMmrem/U4z6o1RZaEX6Xd0IIWN5vLOvVbr+68Mrxe4
1Qfr8oCL71QYDfTuOwk92a9H+vXRMINfoYQZ9oRwet/A73dj6Ozuk4wgqBcD/cf1
6NoOEeXOy0AT4CpZ4SDCUIfpVd9QKluHrVZWnO1+Mk5Tuo1DQ40UYcvXoxFc7YFL
PRjoSxVVY77crLHattZ2xV4O8HPRqNgQDPgJKiL/ZEPCzC7co+ic8/qv4fvl0KQR
XjT1d6mYr0MW4QSWqeyXpjmjLrCBEkt0NkypAMuTMkcuYLROEPGWdS5dxyCW+Y1m
ES3qZxK7SnT5+Tnb4fUaxwEFBXaADMOR5cdYDr0ehNiGx1rcEwq3SGYZzIayQrob
f1DWOcDII1s+kZ2xb43+0cLw64HvI19FMZEFLMxXQWOQ5a4wXN0qBaOMJ//HUhKD
g48Mf2ymaeyObF2clHGKXF0sKUWyzWUlE9dlX930nHtnjrpedssPZ3yYotcWOkFi
NMbURhVLpqzGekptR3Go1xM0weubKA3d9f405b5bsVbYFGgoOI3hJtwlVOl+TMce
1ki5+0qokTs9/vI4ivQZBX+QjQf6eaoIYtiPZ6cu4Is9KIKqtzIszaHTMH1A5uXP
wtwjP8eT/A4=
=VnS7
-----END PGP SIGNATURE-----

--Sig_/endU5IhPkGR94pXBVRnWybh--
