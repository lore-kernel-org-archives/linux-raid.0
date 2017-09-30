From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 0/2] Two fixes for PPL recovery
Date: Fri, 29 Sep 2017 23:05:26 -0700
Message-ID: <20170930060526.kpbjk6na6lmegkxh@kernel.org>
References: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 29, 2017 at 10:54:17PM +0200, Artur Paszkiewicz wrote:
> These patches fix some issues that can occur when array rebuild starts after
> ppl recovery.
> 
> Artur Paszkiewicz (2):
>   raid5-ppl: don't resync after rebuild
>   raid5-ppl: check recovery_offset when performing ppl recovery

applied, thanks! 
>  drivers/md/raid5-ppl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
