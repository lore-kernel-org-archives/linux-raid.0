From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 02/18] dmaengine, async_tx: add a "no channel switch"
 allocator
Date: Tue, 15 Sep 2009 17:05:28 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548785@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755081AbZIOQHJ@vger.kernel.org>
In-Reply-To: <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Channel switching is problematic for some dmaengine drivers as the
> architecture precludes separating the ->prep from ->submit.  In these
> cases the driver can select ASYNC_TX_DISABLE_CHANNEL_SWITCH to modify
> the async_tx allocator to only return channels that support all of the
> required asynchronous operations.
> 
> For example MD_RAID456=y selects support for asynchronous xor, xor
> validate, pq, pq validate, and memcpy.  When
> ASYNC_TX_DISABLE_CHANNEL_SWITCH=y any channel with all these
> capabilities is marked DMA_ASYNC_TX allowing async_tx_find_channel() to
> quickly locate compatible channels with the guarantee that dependency
> chains will remain on one channel.  When
> ASYNC_TX_DISABLE_CHANNEL_SWITCH=n async_tx_find_channel() may select
> channels that lead to operation chains that need to cross channel
> boundaries using the async_tx channel switch capability.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

with one question:

> +	/* note: this only matters in the
> +	 * CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y case
> +	 */
> +	if (device_has_all_tx_types(device))
> +		dma_cap_set(DMA_ASYNC_TX, device->cap_mask);

Why not to put this part plus device_has_all_tx_types()
into #ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH then?

Thanks,
Maciej