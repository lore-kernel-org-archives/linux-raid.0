From: "saeed bishara" <saeed.bishara@gmail.com>
Subject: Re: [md-accel PATCH 16/19] dmaengine: driver for the iop32x, iop33x, and iop13xx raid engines
Date: Thu, 30 Aug 2007 21:43:05 +0300
Message-ID: <c70ff3ad0708301143w55bf296p37b0991d7f099fd6@mail.gmail.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
	 <20070627015155.18962.88413.stgit@dwillia2-linux.ch.intel.com>
	 <c70ff3ad0708270611x5598fa9dlc3afa5f6fabd6563@mail.gmail.com>
	 <c70ff3ad0708270614t6f17b38nfbdf84ace69b8d78@mail.gmail.com>
	 <0C7297FA1D2D244A9C7F6959C0BF1E52025B10E4@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E52025B10E4@azsmsx413.amr.corp.intel.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, "Nelson, Shannon" <shannon.nelson@intel.com>
List-Id: linux-raid.ids

you are right, I've another question regarding the function
dma_wait_for_async_tx from async_tx.c, here is the body of the code:
       /* poll through the dependency chain, return when tx is complete */
1.        do {
2.                 iter = tx;
3.                 while (iter->cookie == -EBUSY)
4.                         iter = iter->parent;
5.
6.                 status = dma_sync_wait(iter->chan, iter->cookie);
7.         } while (status == DMA_IN_PROGRESS || (iter != tx));

assume that:
- The interrupt capability is not provided.
- Request A was sent to chan 0
- Request B that depends on A is sent to chan 1
- Request C that depends on B is send to chan 2.
- Also, assume that when C is handled by async_tx_submit(), B is still
not queued to the dmaengine (cookie equals to -EBUSY).

In this case, dma_wait_for_async_tx will be called for C, now, it
looks for me that the do while will loop forever, even when A gets
completed. this is because the iter will point to B after line 4, thus
the iter != tx (C) will always become true.

saeed
