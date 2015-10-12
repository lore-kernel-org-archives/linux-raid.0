From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] md: workqueue: Remove WQ_CPU_INTENSIVE from unbound
 workqueue allocations
Date: Mon, 12 Oct 2015 12:21:53 -0400
Message-ID: <20151012162153.GC23399@mtj.duckdns.org>
References: <1444361135-22624-1-git-send-email-xlpang@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1444361135-22624-1-git-send-email-xlpang@126.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.com>, Xunlei Pang <pang.xunlei@linaro.org>
List-Id: linux-raid.ids

On Fri, Oct 09, 2015 at 11:25:35AM +0800, Xunlei Pang wrote:
> From: Xunlei Pang <pang.xunlei@linaro.org>
> 
> WQ_CPU_INTENSIVE is meaningless for the unbound workqueue, so remove it.
> 
> Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
