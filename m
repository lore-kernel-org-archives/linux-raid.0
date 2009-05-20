From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 03/11] async_tx: structify submission arguments, add
	scribble
Date: Wed, 20 May 2009 11:19:56 -0700
Message-ID: <e9c3a7c20905201119i5c01f959lec38a54e460b1901@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005941.4104.24363.stgit@dwillia2-linux.ch.intel.com>
	 <20090520080654.GS6403@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090520080654.GS6403@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 20, 2009 at 1:06 AM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On Mon, May 18, 2009 at 05:59:41PM -0700, Dan Williams wrote:
>
>> diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_=
memcpy.c
>> index 7117ec6..c9342ae 100644
>> --- a/crypto/async_tx/async_memcpy.c
>> +++ b/crypto/async_tx/async_memcpy.c
>> @@ -35,26 +35,23 @@
>> =A0 * @src: src page
>> =A0 * @offset: offset in pages to start transaction
>> =A0 * @len: length in bytes
>> - * @flags: ASYNC_TX_ACK
>> - * @depend_tx: memcpy depends on the result of this transaction
>> - * @cb_fn: function to call when the memcpy completes
>> - * @cb_param: parameter to pass to the callback routine
>> + * @submit: submission / completion modifiers
>> =A0 */
>> =A0struct dma_async_tx_descriptor *
>> =A0async_memcpy(struct page *dest, struct page *src, unsigned int de=
st_offset,
>> - =A0 =A0 unsigned int src_offset, size_t len, enum async_tx_flags f=
lags,
>> - =A0 =A0 struct dma_async_tx_descriptor *depend_tx,
>> - =A0 =A0 dma_async_tx_callback cb_fn, void *cb_param)
>> + =A0 =A0 =A0 =A0 =A0unsigned int src_offset, size_t len,
>> + =A0 =A0 =A0 =A0 =A0struct async_submit_ctl *submit)
>> =A0{
>
> The third parameter is called "dest_offset", but the comment refers t=
o
> "@offset".

=2E..and I was missing a comment for src_offset.  fixed.

>
>> +struct async_submit_ctl {
>> + =A0 =A0 enum async_tx_flags flags;
>> + =A0 =A0 struct dma_async_tx_descriptor *depend_tx;
>> + =A0 =A0 dma_async_tx_callback cb_fn;
>> + =A0 =A0 void *cb_param;
>> + =A0 =A0 void *scribble;
>> +};
>
> Can't scribble be of type addr_conv_t *?

It could, but that would require casting it when it is used.  I really
only added the addr_conv_t type to get a compiler warning if someone
inadvertently swaps the cb_param and scribble arguments to
init_async_submit().  There is no benefit for type safety once we go
to use it, and this will allow me to drop that unnecessary cast from
void * that you identified in [PATCH 04/11].

> Apart from these two minor issues the patch looks really nice. Thanks
> for taking the time to combine the common submission parameters to
> the new structure. This improves readability of the code and makes
> adaptation to future needs easier.
>
> Signed-off-by: Andre Noll <maan@systemlinux.org>

Thanks!

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
