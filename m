From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH v2 02/11] async_tx: kill ASYNC_TX_DEP_ACK flag
Date: Fri, 29 May 2009 14:41:39 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6B@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005936.4104.58597.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250320w74897dabo6576b4b48bd19c0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f12847240905250320w74897dabo6576b4b48bd19c0c@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "maan@systemlinux.org" <maan@systemlinux.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
List-Id: linux-raid.ids

Dan Williams wrote:
> In support of inter-channel chaining async_tx utilizes an ack flag to
> gate whether a dependent operation can be chained to another. =A0Whil=
e the
> flag is not set the chain can be considered open for appending. =A0Se=
tting
> the ack flag closes the chain and flags the descriptor for garbage
> collection. =A0The ASYNC_TX_DEP_ACK flag essentially means "close the
> chain after adding this dependency". =A0Since each operation can only=
 have
> one child the api now implicitly sets the ack flag at dependency
> submission time. =A0This removes an unnecessary management burden fro=
m
> clients of the api.
>=20
> [ Impact: clean up and enforce one dependency per operation ]
>=20
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0crypto/async_tx/async_memcpy.c | =A0 =A02 +-
> =A0crypto/async_tx/async_memset.c | =A0 =A02 +-
> =A0crypto/async_tx/async_tx.c =A0 =A0 | =A0 =A04 ++--
> =A0crypto/async_tx/async_xor.c =A0 =A0| =A0 =A06 ++----
> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 25 +++++++++++---=
-----------
> =A0include/linux/async_tx.h =A0 =A0 =A0 | =A0 =A04 +---
> =A06 files changed, 18 insertions(+), 25 deletions(-)

Async-tx-api.txt documentation should be also updated
(it still describes ASYNC_TX_DEP_ACK usage).

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
