From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 02/11] async_tx: kill ASYNC_TX_DEP_ACK flag
Date: Wed, 3 Jun 2009 11:42:58 -0700
Message-ID: <e9c3a7c20906031142o31ff6acfh62764a9967abd980@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005936.4104.58597.stgit@dwillia2-linux.ch.intel.com>
	 <f12847240905250320w74897dabo6576b4b48bd19c0c@mail.gmail.com>
	 <129600E5E5FB004392DDC3FB599660D7ACC13C6B@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7ACC13C6B@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/5/29 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
> Dan Williams wrote:
>> In support of inter-channel chaining async_tx utilizes an ack flag t=
o
>> gate whether a dependent operation can be chained to another. =A0Whi=
le the
>> flag is not set the chain can be considered open for appending. =A0S=
etting
>> the ack flag closes the chain and flags the descriptor for garbage
>> collection. =A0The ASYNC_TX_DEP_ACK flag essentially means "close th=
e
>> chain after adding this dependency". =A0Since each operation can onl=
y have
>> one child the api now implicitly sets the ack flag at dependency
>> submission time. =A0This removes an unnecessary management burden fr=
om
>> clients of the api.
>>
>> [ Impact: clean up and enforce one dependency per operation ]
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0crypto/async_tx/async_memcpy.c | =A0 =A02 +-
>> =A0crypto/async_tx/async_memset.c | =A0 =A02 +-
>> =A0crypto/async_tx/async_tx.c =A0 =A0 | =A0 =A04 ++--
>> =A0crypto/async_tx/async_xor.c =A0 =A0| =A0 =A06 ++----
>> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 25 +++++++++++--=
------------
>> =A0include/linux/async_tx.h =A0 =A0 =A0 | =A0 =A04 +---
>> =A06 files changed, 18 insertions(+), 25 deletions(-)
>
> Async-tx-api.txt documentation should be also updated
> (it still describes ASYNC_TX_DEP_ACK usage).
>

Done, thanks... and I also need to update the document for the
async_submit_ctl structure.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
