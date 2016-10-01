From: Tejun Heo <htejun@fb.com>
Subject: Re: [PATCH] md: set rotational bit
Date: Sat, 1 Oct 2016 12:50:59 +0200
Message-ID: <20161001105058.GA12172@mtj.duckdns.org>
References: <475298bb0650722bf38a2bf0d260a20579ee14e3.1475253807.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <475298bb0650722bf38a2bf0d260a20579ee14e3.1475253807.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com
List-Id: linux-raid.ids

On Fri, Sep 30, 2016 at 09:45:40AM -0700, Shaohua Li wrote:
> if all disks in an array are non-rotational, set the array
> non-rotational.
> 
> This only works for array with all disks populated at startup. Support
> for disk hotadd/hotremove could be added later if necessary.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>

FWIW,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
