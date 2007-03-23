From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re: [PATCH 2.6.21-rc4 01/15] dmaengine: add base support for the async_tx api
Date: Fri, 23 Mar 2007 17:18:01 +0300
Message-ID: <200703231718.01770.yur@emcraft.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com> <20070323065142.15570.98231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070323065142.15570.98231.stgit@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi Dan,

 Functions dma_async_memcpy_buf_to_buf(), dma_async_memcpy_buf_to_pg() and 
dma_async_memcpy_pg_to_pg() are practically identical. Maybe it makes sense 
to extract the common part into a separate inline function? Somehow like 
this:

static inline dma_cookie_t dma_async_memcpy (
	struct dma_chan *chan, 
	dma_addr_t src,
	dma_addr_t dst,
	size_t len) 
{
	struct dma_device *dev = chan->device;
	struct dma_async_tx_descriptor *tx;
	dma_cookie_t cookie;
	int cpu;

	tx = dev->device_prep_dma_memcpy(chan, len, 0);
	if (!tx)
		return -ENOMEM;

	tx->ack = 1;
	tx->callback = NULL;
	dev->device_set_src(src, tx, 0);
	dev->device_set_dest(dst, tx, 0);
	cookie = dev->device_tx_submit(tx);

	cpu = get_cpu();
	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
	put_cpu();

	return cookie;
}

dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
        void *dest, void *src, size_t len)
{
	dma_addr_t dsrc, ddst;

	dsrc = dma_map_single(chan->device->dev, src, len, DMA_TO_DEVICE);
	ddst = dma_map_single(chan->device->dev, dest, len, DMA_FROM_DEVICE);

	return dma_async_memcpy(chan, dsrc, ddst, len);
}

dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
        struct page *page, unsigned int offset, void *kdata, size_t len)
{
	dma_addr_t dsrc, ddst;

	dsrc = dma_map_single(chan->device->dev, kdata, len, DMA_TO_DEVICE);
	ddst = dma_map_page(chan->device->dev, page, offset, len, DMA_FROM_DEVICE);

	return dma_async_memcpy(chan, dsrc, ddst, len);
}

dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
        struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
        unsigned int src_off, size_t len)
{
	dma_addr_t dsrc, ddst;

	dsrc = dma_map_page(chan->device->dev, src_pg, src_off, len, DMA_TO_DEVICE);
	ddst = dma_map_page(chan->device->dev,dest_pg,dest_off, len,DMA_FROM_DEVICE);

	return dma_async_memcpy(chan, dsrc, ddst, len);
}


 Regards, Yuri.

On Friday 23 March 2007 09:51, you wrote:
> The async_tx api provides methods for describing a chain of asynchronous
> ...
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 322ee29..2285f33 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> ...
> +/**
> + * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
> + * @chan: DMA channel to offload copy to
> + * @dest: destination address (virtual)
> + * @src: source address (virtual)
> + * @len: length
> + *
> + * Both @dest and @src must be mappable to a bus address according to the
> + * DMA mapping API rules for streaming mappings.
> + * Both @dest and @src must stay memory resident (kernel memory or locked
> + * user space pages).
> + */
> +dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
> +        void *dest, void *src, size_t len)
> +{
> +	struct dma_device *dev = chan->device;
> +	struct dma_async_tx_descriptor *tx;
> +	dma_addr_t addr;
> +	dma_cookie_t cookie;
> +	int cpu;
> +
> +	tx = dev->device_prep_dma_memcpy(chan, len, 0);
> +	if (!tx)
> +		return -ENOMEM;
> +
> +	tx->ack = 1;
> +	tx->callback = NULL;
> +	addr = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
> +	dev->device_set_src(addr, tx, 0);
> +	addr = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
> +	dev->device_set_dest(addr, tx, 0);
> +	cookie = dev->device_tx_submit(tx);
> +
> +	cpu = get_cpu();
> +	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> +	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> +	put_cpu();
> +
> +	return cookie;
> +}
> +EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
> +
> +/**
> + * dma_async_memcpy_buf_to_pg - offloaded copy from address to page
> + * @chan: DMA channel to offload copy to
> + * @page: destination page
> + * @offset: offset in page to copy to
> + * @kdata: source address (virtual)
> + * @len: length
> + *
> + * Both @page/@offset and @kdata must be mappable to a bus address
> according + * to the DMA mapping API rules for streaming mappings.
> + * Both @page/@offset and @kdata must stay memory resident (kernel memory
> or + * locked user space pages)
> + */
> +dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
> +        struct page *page, unsigned int offset, void *kdata, size_t len)
> +{
> +	struct dma_device *dev = chan->device;
> +	struct dma_async_tx_descriptor *tx;
> +	dma_addr_t addr;
> +	dma_cookie_t cookie;
> +	int cpu;
> +
> +	tx = dev->device_prep_dma_memcpy(chan, len, 0);
> +	if (!tx)
> +		return -ENOMEM;
> +
> +	tx->ack = 1;
> +	tx->callback = NULL;
> +	addr = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
> +	dev->device_set_src(addr, tx, 0);
> +	addr = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
> +	dev->device_set_dest(addr, tx, 0);
> +	cookie = dev->device_tx_submit(tx);
> +
> +	cpu = get_cpu();
> +	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> +	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> +	put_cpu();
> +
> +	return cookie;
> +}
> +EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
> +
> +/**
> + * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
> + * @chan: DMA channel to offload copy to
> + * @dest_pg: destination page
> + * @dest_off: offset in page to copy to
> + * @src_pg: source page
> + * @src_off: offset in page to copy from
> + * @len: length
> + *
> + * Both @dest_page/@dest_off and @src_page/@src_off must be mappable to a
> bus + * address according to the DMA mapping API rules for streaming
> mappings. + * Both @dest_page/@dest_off and @src_page/@src_off must stay
> memory resident + * (kernel memory or locked user space pages).
> + */
> +dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
> +        struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
> +        unsigned int src_off, size_t len)
> +{
> +	struct dma_device *dev = chan->device;
> +	struct dma_async_tx_descriptor *tx;
> +	dma_addr_t addr;
> +	dma_cookie_t cookie;
> +	int cpu;
> +
> +	tx = dev->device_prep_dma_memcpy(chan, len, 0);
> +	if (!tx)
> +		return -ENOMEM;
> +
> +	tx->ack = 1;
> +	tx->callback = NULL;
> +	addr = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
> +	dev->device_set_src(addr, tx, 0);
> +	addr = dma_map_page(dev->dev, dest_pg, dest_off, len, DMA_FROM_DEVICE);
> +	dev->device_set_dest(addr, tx, 0);
> +	cookie = dev->device_tx_submit(tx);
> +
> +	cpu = get_cpu();
> +	per_cpu_ptr(chan->local, cpu)->bytes_transferred += len;
> +	per_cpu_ptr(chan->local, cpu)->memcpy_count++;
> +	put_cpu();
> +
> +	return cookie;
> +}
> +EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
> ...
