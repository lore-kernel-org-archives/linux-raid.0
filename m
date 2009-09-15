From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/18] dmaengine, async_tx: add a "no channel switch"
 allocator
Date: Tue, 15 Sep 2009 10:28:46 -0700
Message-ID: <4AAFCECE.9070302@intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com> <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com> <129600E5E5FB004392DDC3FB599660D7B5548785@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7B5548785@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sosnowski, Maciej wrote:
> Williams, Dan J wrote:
>> Channel switching is problematic for some dmaengine drivers as the
>> architecture precludes separating the ->prep from ->submit.  In these
>> cases the driver can select ASYNC_TX_DISABLE_CHANNEL_SWITCH to modify
>> the async_tx allocator to only return channels that support all of the
>> required asynchronous operations.
>>
>> For example MD_RAID456=y selects support for asynchronous xor, xor
>> validate, pq, pq validate, and memcpy.  When
>> ASYNC_TX_DISABLE_CHANNEL_SWITCH=y any channel with all these
>> capabilities is marked DMA_ASYNC_TX allowing async_tx_find_channel() to
>> quickly locate compatible channels with the guarantee that dependency
>> chains will remain on one channel.  When
>> ASYNC_TX_DISABLE_CHANNEL_SWITCH=n async_tx_find_channel() may select
>> channels that lead to operation chains that need to cross channel
>> boundaries using the async_tx channel switch capability.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
> 
> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> 
> with one question:
> 
>> +	/* note: this only matters in the
>> +	 * CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y case
>> +	 */
>> +	if (device_has_all_tx_types(device))
>> +		dma_cap_set(DMA_ASYNC_TX, device->cap_mask);
> 
> Why not to put this part plus device_has_all_tx_types()
> into #ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH then?
> 

Because device_has_all_tx_types() already has the necessary ifdefs per 
operation type, and it does not rule out the possibility that code 
outside of async_tx can make use of DMA_ASYNC_TX capability.  We don't 
gain anything by eliminating this call... although we would save an 
entry in the dmaengine channel table by turning off DMA_ASYNC_TX in enum 
dma_transaction_type.  But we have already cleaned up 
dma_transaction_type in this patchset so the net change from 2.6.31 to 
2.6.32 is still positive in this area.

--
Dan
