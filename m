From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Wed, 15 Apr 2020 13:48:14 +0200
Message-ID: <20200415114814.GJ4629@dhcp22.suse.cz>
References: <20200402081312.32709-1-colyli@suse.de>
 <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
 <5f27365b-768f-eb69-36ec-f4ed0c292c60@suse.de>
 <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <204e9fd0-3712-4864-2bf5-38913511e658@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Coly Li <colyli@suse.de>, songliubraving@fb.com, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

On Thu 09-04-20 23:38:13, Guoqing Jiang wrote:
[...]
> Not know memalloc_noio_{save,restore} well, but I guess it is better
> to use them to mark a small scope, just my two cents.

This would go against the intentio of the api. It is really meant to
define reclaim recursion problematic scope. If there is a clear entry
point where any further allocation recursing to FS/IO could deadlock
then it should be used at that level. This might be a lock which is
taken from the reclaim or like this case a device is suspended and no IO
is processed so anything that would wait for an IO or rely on IO making
progress in the reclaim path would deadlock.

Please have a look at Documentation/core-api/gfp_mask-from-fs-io.rst
and let me know is something could be made more clear or explicit.
I am more than happy to improve the documentation.
-- 
Michal Hocko
SUSE Labs
