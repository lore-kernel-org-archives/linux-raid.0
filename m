From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 06/11] async_tx: add sum check flags
Date: Fri, 29 May 2009 14:41:55 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C70@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005956.4104.27783.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905200111p54382735v6941b52825cf4d7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905200111p54382735v6941b52825cf4d7e@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> Replace the flat zero_sum_result with a collection of flags to contai=
n
> the P (xor) zero-sum result, and the soon to be utilized Q (raid6 ree=
d
> solomon syndrome) zero-sum result. =A0Use the SUM_CHECK_ namespace in=
stead
> of DMA_ since these flags will be used on non-dma-zero-sum enabled
> platforms.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0arch/arm/include/asm/hardware/iop3xx-adma.h | =A0 =A05 +++--
> =A0arch/arm/mach-iop13xx/include/mach/adma.h =A0 | =A0 12 +++++++----=
-
> =A0crypto/async_tx/async_xor.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =
=A04 ++--
> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A02 +-
> =A0drivers/md/raid5.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0 =A05 +++--
> =A0include/linux/async_tx.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =
=A0 =A02 +-
> =A0include/linux/dmaengine.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0=
 21 ++++++++++++++++++++-
> =A07 files changed, 37 insertions(+), 14 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
