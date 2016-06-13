From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid1/raid10: slow down resync if there is non-resync
 activity pending
Date: Mon, 13 Jun 2016 11:48:07 -0700
Message-ID: <20160613184807.GB20136@kernel.org>
References: <1465825879-2059-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465825879-2059-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 13, 2016 at 03:51:19PM +0200, Tomasz Majchrzak wrote:
> A performance drop of mkfs has been observed on RAID10 during resync
> since commit 09314799e4f0 ("md: remove 'go_faster' option from
> ->sync_request()"). Resync sends so many IOs it slows down non-resync
> IOs significantly (few times). Add a short delay to a resync. The
> previous long sleep (1s) has proven unnecessary, even very short delay
> brings performance right.
> 
> The change also applied to raid1. The problem has not been observed on
> raid1, however it shares barriers code with raid10 so it might be an
> issue for some setup too.

Applied, thanks!
