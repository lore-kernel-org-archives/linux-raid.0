From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Re[2]: [PATCH 03/11][v3] async_tx: add support for asynchronous
	RAID6 recovery operations
Date: Fri, 16 Jan 2009 11:37:07 -0700
Message-ID: <e9c3a7c20901161037l6ab42609td327f6f33406e2d@mail.gmail.com>
References: <200901130343.14016.yur@emcraft.com>
	 <e9c3a7c20901141706v17215220s22d973f81369be72@mail.gmail.com>
	 <498243073.20090116145142@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <498243073.20090116145142@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Fri, Jan 16, 2009 at 4:51 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
>  The reason why I preferred to use async_pq() instead of async_xor()
> here is to maximize the chance that the whole D+D recovery operation
> will be handled in one ADMA device, i.e. without channels switch and
> the latency introduced because of that.
>

This should be a function of the async_tx_find_channel implementation.
 The default version tries to keep a chain of operations on one
channel.

struct dma_chan *
__async_tx_find_channel(struct dma_async_tx_descriptor *depend_tx,
        enum dma_transaction_type tx_type)
{
        /* see if we can keep the chain on one channel */
        if (depend_tx &&
            dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
                return depend_tx->chan;
        return dma_find_channel(tx_type);
}

--
Dan
