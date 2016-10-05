From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] async_pq_val: fix DMA memory leak
Date: Wed, 5 Oct 2016 06:19:36 +0530
Message-ID: <20161005004936.GJ2467@localhost>
References: <20161004201758.13876-1-jmaggard@netgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161004201758.13876-1-jmaggard@netgear.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, dmaengine@vger.kernel.org, Justin Maggard <jmaggard@netgear.com>
List-Id: linux-raid.ids

On Tue, Oct 04, 2016 at 01:17:58PM -0700, Justin Maggard wrote:
> Add missing dmaengine_unmap_put(), so we don't OOM during RAID6 sync.

Applied, thanks

-- 
~Vinod
