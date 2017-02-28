From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 00/14] the latest changes for md-cluster
Date: Tue, 28 Feb 2017 11:27:21 -0800
Message-ID: <20170228192721.3jxfigqeqbhhmxca@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:10AM +0800, Guoqing Jiang wrote:
> Hi,
> 
> This patchset is based on md/for-next branch, which includes below parts:
> 
> 1. some code improvements (0001-0004).
> 2. changes for use sync way to handle METADATA_UPDATED msg (0005-0009).
> 3. add resize support for md-cluster (0010-0012 and 0014), and also
>    make some related changes inside md (0013).

Applied patch 2, 3, 13. Replied to other patches.

BTW, is it possible you can create a test suite people can verify the md-cluster stuff?

Thanks,
Shaohua
