From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 04/11] async_xor: permit callers to pass in a
 'dma/page scribble' region
Date: Fri, 29 May 2009 14:41:50 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6F@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250320w523fc657w3bca47f23442f46e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250320w523fc657w3bca47f23442f46e@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> async_xor() needs space to perform dma and page address conversions. =
=A0In
> most cases the code can simply reuse the struct page * array because =
the
> size of the native pointer matches the size of a dma/page address. =A0=
In
> order to support archs where sizeof(dma_addr_t) is larger than
> sizeof(struct page *), or to preserve the input parameters, we utiliz=
e a
> memory region passed in by the caller.
>=20
> Since the code is now prepared to handle the case where it cannot
> perform address conversions on the stack, we no longer need the
> !HIGHMEM64G dependency in drivers/dma/Kconfig.
>=20
> [ Impact: don't clobber input buffers for address conversions ]
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/async_xor.c | =A0 59 ++++++++++++++++++++---------=
--------------
> =A0drivers/dma/Kconfig =A0 =A0 =A0 =A0 | =A0 =A02 +
> =A02 files changed, 29 insertions(+), 32 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
