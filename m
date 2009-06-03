From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 08/11] async_tx: add support for asynchronous GF
	multiplication
Date: Wed, 3 Jun 2009 15:16:17 -0700
Message-ID: <e9c3a7c20906031516t783dcca7yf10df0054c525ad0@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010006.4104.70181.stgit@dwillia2-linux.ch.intel.com>
	 <f12847240905200111q37457b29lb9e30879e251888@mail.gmail.com>
	 <129600E5E5FB004392DDC3FB599660D7ACC13C72@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7ACC13C72@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

2009/5/29 Sosnowski, Maciej <maciej.sosnowski@intel.com>:
> Dan Williams wrote:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Since we have clobbered the src_lis=
t we are committed
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to doing this asynchronously. =A0=
Drivers force forward
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* progress in case they can not pro=
vide a descriptor
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (;;) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tx =3D dma->device_pre=
p_dma_pq(chan, dma_dest,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&dma_src[src_off],
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pq_src_cnt,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&coefs[src_off], len,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dma_flags);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(tx))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 async_tx_quiesce(&subm=
it->depend_tx);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_async_issue_pendin=
g(chan);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> How about adding a timeout to the loop in case we do not get a descri=
ptor at all for some reason?
>

There is an embedded timeout in async_tx_quiesce().  However, now that
we have the ->scribble pointer a future patch could make it a
requirement of the api.  With that in place we would always be able to
fall back to the synchronous at any point because the input parameters
would be preserved.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
