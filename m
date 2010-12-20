From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Fixes for Incremental()
Date: Tue, 21 Dec 2010 09:12:20 +1100
Message-ID: <20101221091220.36751131@notabene.brown>
References: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101217141641.4219.88151.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 17 Dec 2010 15:16:58 +0100 Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> The following series consists of two fixes for problems revealed during the tests 
> of autorebuild. First one is quite important, as recovery process do not start
> if bare disk is added to degraded array via incremental. Second one is just
> a change in return value of array_try_spare().
> 
> ---
> 
> Przemyslaw Czarnowski (2):
>       fix: adding spare via incremental do not trigger recovery
>       fix: incremental for bare disks return invalid value

Both applied,
Thanks,

NeilBrown

> 
> 
>  Incremental.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 

