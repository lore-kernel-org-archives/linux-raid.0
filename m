From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 28/29] dmaengine: kill tx_list
Date: Mon, 14 Sep 2009 16:01:58 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554819A@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023252.32667.51136.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090904023252.32667.51136.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> The tx_list attribute of struct dma_async_tx_descriptor is common to
> most, but not all dma driver implementations.  None of the upper level
> code (dmaengine/async_tx) uses it, so allow drivers to implement it
> locally if they need it.  This saves sizeof(struct list_head) bytes for
> drivers that do not manage descriptors with a linked list (e.g.: ioatdma
> v2,3).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>