From: "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: RE: [PATCH 2.6.23-rc7 1/3] async_tx: usage documentation and developernotes
Date: Fri, 21 Sep 2007 08:25:12 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03157788@orsmsx418.amr.corp.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com> <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20070921012740.17157.49639.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com
List-Id: linux-raid.ids

>From: Williams, Dan J 
>Sent: Thursday, September 20, 2007 6:28 PM
>To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org; 
>neilb@suse.de
>Cc: akpm@linux-foundation.org; yur@emcraft.com; 
>saeed.bishara@gmail.com; Nelson, Shannon
>Subject: [PATCH 2.6.23-rc7 1/3] async_tx: usage documentation 
>and developernotes
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> Documentation/crypto/async-tx-api.txt |  217 
>+++++++++++++++++++++++++++++++++
> 1 files changed, 217 insertions(+), 0 deletions(-)

Thanks, Dan.  In addition to Randy's most excellent nit-picking, here
are a couple more minor nits.

[...]
>+4.2 "My application needs finer control of hardware channels"
>+This requirement seems to arise from cases where a DMA engine 
>driver is
[...]
>+dma_async_client_chan_request triggers dmaeninge to notify 
>the client of

s/dmaeninge/dmaengine/

[...]
>+5 SOURCE
>+drivers/dma/dmaengine.c: offload engine channel management routines
>+drivers/dma/: location for offload engine drivers
>+crypto/async_tx/async_tx.c: async_tx interface to dmaengine 
>and common code
>+crypto/async_tx/async_memcpy.c: copy offload
>+crypto/async_tx/async_memset.c: memory fill offload
>+crypto/async_tx/async_xor.c: xor offload

Also include/linux/dmaengine.h


sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
