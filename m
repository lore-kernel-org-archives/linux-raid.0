From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 07/13] async_tx: add support for asynchronous RAID6
 recovery	operations
Date: Mon, 30 Mar 2009 15:30:22 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8BF24@irsmsx504.ger.corp.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
 <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318192052.20375.68157.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> +ddr_sync:
> +	{
> +		void **sptrs = (void **)lptrs;
> +		/*
> +		 * Failed to compute asynchronously, do it in
> +		 * synchronous manner
> +		 */
> +
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +		if (flags & ASYNC_TX_DEP_ACK)
> +			async_tx_ack(depend_tx);
> +
> +		i = disks;
> +		while (i--)
> +			sptrs[i] = page_address(ptrs[i]);
> +		raid6_2data_recov(disks, bytes, faila, failb, sptrs);
> +
> +		async_tx_sync_epilog(cb, cb_param);
> +	}
(...)
> +dpr_sync:
> +	{
> +		void **sptrs = (void **) lptrs;
> +		/*
> +		 * Failed to compute asynchronously, do it in
> +		 * synchronous manner
> +		 */
> +
> +		/* wait for any prerequisite operations */
> +		async_tx_quiesce(&depend_tx);
> +		if (flags & ASYNC_TX_DEP_ACK)
> +			async_tx_ack(depend_tx);
> +
> +		i = disks;
> +		while (i--)
> +			sptrs[i] = page_address(ptrs[i]);
> +		raid6_datap_recov(disks, bytes, faila, (void *)sptrs);
> +
> +		async_tx_sync_epilog(cb, cb_param);
> +	}

These synchronous sections in async_r6_dd_recov() and async_r6_dp_recov()
look almost the same. What about placing the code in a common function?

Regards,
Maciej