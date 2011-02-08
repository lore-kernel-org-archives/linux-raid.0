From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] FIX: Process hangs at wait_barrier
Date: Tue, 8 Feb 2011 11:50:30 +1100
Message-ID: <20110208115030.3cc6b2f0@notabene.brown>
References: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 04 Feb 2011 14:18:18 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Patches resolve problem with process crash at wait_barrier()
> after raid0->raid10 takeover.
> First patch resolve this particular problem.
> Solution is similar to RAID1 barrier implementation.
> Second is proposal for general protection against barrier
> become negative.
> 
> ---
> 
> Krzysztof Wojcik (2):
>       FIX: md: process hangs at wait_barrier after 0->10 takeover

Applied, thanks.


>       FIX: md: Prevent barrier become negative

If we ever trying to make 'barrier' negative, that is a bug somewhere.
So I would prefer:

   BUG_ON(conf->barrier <= 0);
   conf->barrier--;

NeilBrown


> 
> 
>  drivers/md/raid1.c  |    3 ++-
>  drivers/md/raid10.c |    9 ++++++---
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 

