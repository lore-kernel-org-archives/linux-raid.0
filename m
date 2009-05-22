From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 09/11] async_tx: add support for asynchronous RAID6
	recovery operations
Date: Fri, 22 May 2009 11:39:06 -0700
Message-ID: <e9c3a7c20905221139q7af824e7k6b3a8205ae73ac09@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010012.4104.50825.stgit@dwillia2-linux.ch.intel.com>
	 <20090522082908.GN11504@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090522082908.GN11504@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 22, 2009 at 1:29 AM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On Mon, May 18, 2009 at 06:00:12PM -0700, Dan Williams wrote:
>> +/**
>> + * async_raid6_2data_recov - asynchronously calculate two missing d=
ata blocks
>> + * @disks: number of disks in the RAID-6 array
>> + * @bytes: block size
>> + * @faila: first failed drive index
>> + * @failb: second failed drive index
>> + * @blocks: array of source pointers where the last two entries are=
 p and q
>> + * @submit: submission/completion modifiers
>> + */
>> +struct dma_async_tx_descriptor *
>> +async_raid6_2data_recov(int disks, size_t bytes, int faila, int fai=
lb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page **blocks, stru=
ct async_submit_ctl *submit)
>> +{
>
> [...]
>
>> + =A0 =A0 /* Dx =3D A*(P+Pxy) + B*(Q+Qxy) */
>> + =A0 =A0 srcs[0] =3D dp;
>> + =A0 =A0 srcs[1] =3D dq;
>> + =A0 =A0 coef[0] =3D raid6_gfexi[failb-faila];
>
> Here it's essential that faila < failb. This should either be clearly
> documented and checked for, or (better) the function should swap
> faila and failb if they are in the wrong order.

Yes, it would be safer if we did not trust the caller to get this right=
=2E

>
>> + =A0 =A0 p =3D blocks[disks-2];
>> + =A0 =A0 q =3D blocks[disks-1];
>> +
>> + =A0 =A0 /* Compute syndrome with zero for the missing data page
>> + =A0 =A0 =A0 =A0Use the dead data page as temporary storage for del=
ta q */
>> + =A0 =A0 dq =3D blocks[faila];
>> + =A0 =A0 blocks[faila] =3D (void *)raid6_empty_zero_page;
>> + =A0 =A0 blocks[disks-1] =3D dq;
>> +
>> + =A0 =A0 submit->flags &=3D ~ASYNC_TX_ACK;
>> + =A0 =A0 submit->cb_fn =3D NULL;
>> + =A0 =A0 submit->cb_param =3D NULL;
>> + =A0 =A0 tx =3D async_gen_syndrome(blocks, 0, disks, bytes, submit)=
;
>> + =A0 =A0 submit->depend_tx =3D tx;
>> +
>> + =A0 =A0 /* Restore pointer table */
>> + =A0 =A0 blocks[faila] =A0 =3D dq;
>> + =A0 =A0 blocks[disks-1] =3D q;
>> +
>> + =A0 =A0 /* Now, pick the proper data tables */
>> + =A0 =A0 coef =3D raid6_gfinv[raid6_gfexp[faila]];
>
> Pick data tables? The formula for recovering the data block is
>
> =A0 =A0 =A0 =A0(q + dq) / g^faila
>
> (with g being the generator). What this line actually does is computi=
ng
> g^{-faila}.

Yeah, that is a leftover comment from the original implementation,
I'll change it to be more informative.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
