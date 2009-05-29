From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 10/11] dmatest: add pq support
Date: Fri, 29 May 2009 14:42:20 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C74@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010017.4104.85634.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250324t1a55b757hc8cd06d6b9663efe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250324t1a55b757hc8cd06d6b9663efe@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> Test raid6 p+q operations with a simple "always multiply by 1" q
> calculation to fit into dmatest's current destination verification
> scheme.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0drivers/dma/dmatest.c | =A0 26 ++++++++++++++++++++++++++
> =A01 files changed, 26 insertions(+), 0 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
