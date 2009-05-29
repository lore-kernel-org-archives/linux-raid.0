From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 07/11] async_tx: kill needless module_{init|exit}
Date: Fri, 29 May 2009 14:42:06 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C71@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010001.4104.24270.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250323o21113fb9xbc4c16eea07b215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250323o21113fb9xbc4c16eea07b215@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> If module_init and module_exit are nops then neither need to be defin=
ed.
>=20
> [ Impact: pure cleanup ]
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/async_memcpy.c | =A0 13 -------------
> =A0crypto/async_tx/async_memset.c | =A0 13 -------------
> =A0crypto/async_tx/async_tx.c =A0 =A0 | =A0 17 +++--------------
> =A03 files changed, 3 insertions(+), 40 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
