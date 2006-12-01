From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH 02/12] dmaengine: add the async_tx api
Date: Thu, 30 Nov 2006 18:19:40 -0700
Message-ID: <e9c3a7c20611301719y63f64b04m9f748f91766c7ff@mail.gmail.com>
References: <e9c3a7c20611301155p4069c642j276d7705b0f81447@mail.gmail.com>
	 <20061130201010.21313.53627.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061130201010.21313.53627.stgit@dwillia2-linux.ch.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, jeff@garzik.org, christopher.leech@intel.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, olof@lixom.net
List-Id: linux-raid.ids

> +static inline void
> +do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
> +       unsigned int src_cnt, size_t len, enum async_tx_flags flags,
> +       struct dma_async_tx_descriptor *depend_tx,
> +       dma_async_tx_callback callback, void *callback_param)
> +{
> +       void *_dest;
> +       int start_idx, i;
> +
> +       printk("%s: len: %u\n", __FUNCTION__, len);
Sorry, this should be PRINTK.

Dan
