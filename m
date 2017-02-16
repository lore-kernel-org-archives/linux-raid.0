From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] async_tx: deprecate broken support for channel switching
Date: Thu, 16 Feb 2017 10:09:24 +0530
Message-ID: <20170216043924.GQ2843@localhost>
References: <148721292971.19343.10618932473668163270.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148721292971.19343.10618932473668163270.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, Anup Patel <anup.patel@broadcom.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dmaengine@vger.kernel.org, Anatolij Gustschin <agust@denx.de>, Saeed Bishara <saeed.bishara@gmail.com>
List-Id: linux-raid.ids

On Wed, Feb 15, 2017 at 06:42:09PM -0800, Dan Williams wrote:
> Back in 2011, Russell pointed out that the "async_tx channel switch"
> capability was violating expectations of the dma mapping api [1]. At the
> time the existing uses were reviewed as still usable, but that longer
> term we needed a rework of the raid offload implementation. While some
> of the framework for a fixed implementation was introduced in 2012 [2],
> the wider rewrite never materialized.
> 
> There continues to be interest in raid offload with new dma/raid engine
> drivers being submitted. Those drivers must not build on top of the
> broken channel switching capability.
> 
> Prevent async_tx from using an offload engine if the channel switching
> capability is enabled. This still allows the engine to be used for other
> purposes, but the broken way async_tx uses these engines for raid will
> be disabled. For configurations where this causes a performance
> regression the only solution is to start the work of eliminating the
> async_tx api and moving channel management into the raid code directly
> where it can manage marshalling an operation stream between multiple dma
> channels.

Applied, thanks

-- 
~Vinod
