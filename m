From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 07/18] ioat3: split ioat3 support to its own file, add
 memset
Date: Tue, 15 Sep 2009 17:07:40 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548793@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064510.7141.80671.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064510.7141.80671.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Up until this point the driver for Intel(R) QuickData Technology
> engines, specification versions 2 and 3, were mostly identical save for
> a few quirks.  Version 3.2 hardware adds many new capabilities (like
> raid offload support) requiring some infrastructure that is not relevant
> for v2.  For better code organization of the new funcionality move v3
> and v3.2 support to its own file dma_v3.c, and export some routines from
> the base files (dma.c and dma_v2.c) that can be reused directly.
> 
> The first new capability included in this code reorganization is support
> for v3.2 memset operations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>