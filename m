From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] Fix kernel module refcount handling
Date: Tue, 19 Jul 2016 11:21:18 -0700
Message-ID: <20160719182118.GB46288@kernel.org>
References: <1466676661-1564-1-git-send-email-aleksey.obitotskiy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466676661-1564-1-git-send-email-aleksey.obitotskiy@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexey Obitotskiy <aleksey.obitotskiy@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 23, 2016 at 12:11:01PM +0200, Alexey Obitotskiy wrote:
> md loads raidX modules and increments module refcount each time level
> has changed but does not decrement it. You are unable to unload raid0
> module after reshape because raid0 reshape changes level to raid4
> and back to raid0.
> 
> Signed-off-by: Aleksey Obitotskiy <aleksey.obitotskiy@intel.com>

Applied, thanks!
