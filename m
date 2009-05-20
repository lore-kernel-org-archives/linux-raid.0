From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 04/11] async_xor: permit callers to pass in a 'dma/page
	scribble' region
Date: Wed, 20 May 2009 11:35:03 -0700
Message-ID: <e9c3a7c20905201135y46022829s9b68d7ee81a5d3dc@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
	 <20090520080818.GT6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090520080818.GT6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 20, 2009 at 1:08 AM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On Mon, May 18, 2009 at 05:59:46PM -0700, Dan Williams wrote:
>
>> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor=
=2Ec
>> @@ -125,9 +124,14 @@ do_sync_xor(struct page *dest, struct page **sr=
c_list, unsigned int offset,
>> =A0 =A0 =A0 int xor_src_cnt;
>> =A0 =A0 =A0 int src_off =3D 0;
>> =A0 =A0 =A0 void *dest_buf;
>> - =A0 =A0 void **srcs =3D (void **) src_list;
>> + =A0 =A0 void **srcs;
>>
>> - =A0 =A0 /* reuse the 'src_list' array to convert to buffer pointer=
s */
>> + =A0 =A0 if (submit->scribble)
>> + =A0 =A0 =A0 =A0 =A0 =A0 srcs =3D (void **) submit->scribble;
>
> Unnecessary cast as submit->scribble is void *.

fixed.

>
>> @@ -171,17 +175,26 @@ async_xor(struct page *dest, struct page **src=
_list, unsigned int offset,
>> =A0 =A0 =A0 struct dma_chan *chan =3D async_tx_find_channel(submit, =
DMA_XOR,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &dest, 1, src_list,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_cnt, len);
>> + =A0 =A0 dma_addr_t *dma_src =3D NULL;
>> +
>> =A0 =A0 =A0 BUG_ON(src_cnt <=3D 1);
>>
>> - =A0 =A0 if (chan) {
>> + =A0 =A0 if (submit->scribble)
>> + =A0 =A0 =A0 =A0 =A0 =A0 dma_src =3D submit->scribble;
>> + =A0 =A0 else if (sizeof(dma_addr_t) <=3D sizeof(struct page *))
>> + =A0 =A0 =A0 =A0 =A0 =A0 dma_src =3D (dma_addr_t *) src_list;
>> +
>> + =A0 =A0 if (dma_src && chan) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* run the xor asynchronously */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug("%s (async): len: %zu\n", __fun=
c__, len);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return do_async_xor(chan, dest, src_list=
, offset, src_cnt, len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 su=
bmit);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm=
a_src, submit);
>> =A0 =A0 =A0 } else {
>
> Don't we need to fall back to sync xor if src_cnt exceeds
> what the device can handle, i.e. if it is larger than
> chan->device->max_xor? async_xor_val() further down has a check for
> this condition.

No, we don't need this check for async_xor().  The asynchronous path
of async_xor_val() has the constraint that it must be able to validate
an xor block without writing to that block i.e. it is a read-only
operation.  The synchronous path recalculates the xor with the
destination as a source and then does a memcmp() to validate that the
new result is zero.

To support more than ->max_xor sources for async_xor_val() we would
need an engine that supported hardware continuation of validate
operations (i.e. an engine with an internal buffer for the
intermediate xor result) otherwise we will need to store an
intermediate xor result in system memory which is no better than the
synchronous path.

=46or async_xor() we are always allowed to write the destination, so we
can reuse it as a source to continue the calculation of the xor
result.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
