From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 03/11] async_tx: structify submission arguments, add
	scribble
Date: Wed, 3 Jun 2009 12:05:33 -0700
Message-ID: <e9c3a7c20906031205qf7cd8aaqaba46a2d9a35a379@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
	 <f12847240905250321v774c4e8dscd7a466cd2e61168@mail.gmail.com>
	 <129600E5E5FB004392DDC3FB599660D7ACC13C6D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7ACC13C6D@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/5/29 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
> Dan Williams wrote:
>> Prepare the api for the arrival of a new parameter, 'scribble'. =A0T=
his
>> will allow callers to identify scratchpad memory for dma address or =
page
>> address conversions. =A0As this adds yet another parameter, take thi=
s
>> opportunity to convert the common submission parameters (flags,
>> dependency, callback, and callback argument) into an object that is
>> passed by reference.
>>
>> [ Impact: moves api pass-by-value parameters to a pass-by-reference =
struct ]
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0crypto/async_tx/async_memcpy.c | =A0 21 ++++-----
>> =A0crypto/async_tx/async_memset.c | =A0 23 ++++------
>> =A0crypto/async_tx/async_tx.c =A0 =A0 | =A0 34 +++++++--------
>> =A0crypto/async_tx/async_xor.c =A0 =A0| =A0 93 +++++++++++++++++----=
-------------------
>> =A0drivers/md/raid5.c =A0 =A0 =A0 =A0 =A0 =A0 | =A0 59 +++++++++++++=
++----------
>> =A0include/linux/async_tx.h =A0 =A0 =A0 | =A0 84 +++++++++++++++++++=
++++-------------
>> =A06 files changed, 161 insertions(+), 153 deletions(-)
>
> (...)
>
>> @@ -811,13 +818,11 @@ ops_run_postxor(struct stripe_head *sh, struct
>> dma_async_tx_descriptor *tx)
>>
>> =A0 =A0 =A0 =A0atomic_inc(&sh->count);
>>
>> - =A0 =A0 =A0 if (unlikely(count =3D=3D 1)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags &=3D ~(ASYNC_TX_XOR_DROP_DST | A=
SYNC_TX_XOR_ZERO_DST);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_memcpy(xor_dest, xor_srcs=
[0], 0, 0, STRIPE_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags, tx, ops_complet=
e_postxor, sh);
>> - =A0 =A0 =A0 } else
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_xor(xor_dest, xor_srcs, 0=
, count, STRIPE_SIZE,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags, tx, ops_complet=
e_postxor, sh);
>> + =A0 =A0 =A0 init_async_submit(&submit, flags, tx, ops_complete_pos=
txor, sh, NULL);
>> + =A0 =A0 =A0 if (unlikely(count =3D=3D 1))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_memcpy(xor_dest, xor_srcs=
[0], 0, 0, STRIPE_SIZE, &submit);
>> + =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D async_xor(xor_dest, xor_srcs, 0=
, count, STRIPE_SIZE, &submit);
>> =A0}
>
> What about ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST flags clea=
ring before async_memcpy?
>

Not necessary.  The routines ignore the flags that are not relevant.
However, the relevant flags for each routine used to be documented in
the kerneldoc description, but those lines got removed when the submit
parameter was added.  I'll go back and add notes to each routine about
which flags are honored and fix up compliance with the kerneldoc
format.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
