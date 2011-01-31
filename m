From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] patches addresses problem with memory corruption
Date: Tue, 1 Feb 2011 10:38:02 +1100
Message-ID: <20110201103802.6513b66a@notabene.brown>
References: <20110131151657.13213.16328.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131151657.13213.16328.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 16:25:08 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When for raid0 metadata is updated outside mdmon it can happen that
> memory corruption occurs due to too amount of memory is allocated 
> for imsm device structure.
> 
> 1. imsm: FIX: mdmon crash during 2 raid0 arrays expansion
>   this patch is almost the same to sent earlier except 2 changes:
>    a) compilation problem
>    b) size should affect anchor size also
>       (added calculation changes extends space_needed variable also
>        this variable is used for anchor allocation)
>   so it replaces previous one.
> 2.  imsm: FIX: sizeof_imsm_dev() can return too small value
> 	size returned by sizeof_imsm_dev() describes minimum size of device
>         This is correct when both device maps has the same length
>         When device expands or shrinks we should return size that allows
>         for storing larger device information to avoid memory corruption.
> 

Both applied (replacing the previous one)..

Thanks.

NeilBrown


> BR
> Adam
> 
> ---
> 
> Adam Kwolek (2):
>       imsm: FIX: sizeof_imsm_dev() can return too small value
>       imsm: FIX: mdmon crash during 2 raid0 arrays expansion
> 
> 
>  super-intel.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 

