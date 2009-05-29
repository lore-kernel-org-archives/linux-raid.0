From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 11/11] async_tx: raid6 recovery self test
Date: Fri, 29 May 2009 14:42:25 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C75@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250324k2b4a0c7as9ac9b084d3707ce5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250324k2b4a0c7as9ac9b084d3707ce5@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> Port drivers/md/raid6test/test.c to use the async raid6 recovery
> routines. =A0This is meant as a unit test for raid6 acceleration driv=
ers.
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/Makefile =A0 =A0| =A0 =A01
> =A0crypto/async_tx/raid6test.c | =A0212 +++++++++++++++++++++++++++++=
++++++++++++++
> =A0drivers/md/Kconfig =A0 =A0 =A0 =A0 =A0| =A0 13 +++
> =A03 files changed, 226 insertions(+), 0 deletions(-)
> =A0create mode 100644 crypto/async_tx/raid6test.c

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
