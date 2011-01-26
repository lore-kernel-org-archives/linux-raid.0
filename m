From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 6/6] FIX: Unblock disk in kernel only if it is blocked.
Date: Wed, 26 Jan 2011 11:06:26 +1000
Message-ID: <20110126110626.2d280ef0@nbeee.brown>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
	<20110119162349.8738.43217.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119162349.8738.43217.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 17:23:49 +0100
Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:

> Missing condition during setting next state for disk.

Yet again you completely fail to explain why you want to make this
change.
And again it looks wrong.

There is no harm is setting "-blocked" if the device is not actually
blocked is there?

PLEASE PLEASE PLEASE explain exactly the problem you are trying to
fix.  Don't waste my time and yours by making have to continually ask
for explanations.

NeilBrown


> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  monitor.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/monitor.c b/monitor.c
> index ed3ce49..4fba5fd 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -336,7 +336,9 @@ static int read_and_act(struct active_array *a)
>  			a->container->ss->set_disk(a,
> mdi->disk.raid_disk, mdi->curr_state);
>  			check_degraded = 1;
> -			mdi->next_state |= DS_UNBLOCK;
> +			/* if '-blocked' wasn't passed to kernel, do
> it now */
> +			if (mdi->curr_state == DS_BLOCKED)
> +				mdi->next_state |= DS_UNBLOCK;
>  			if (a->curr_state == read_auto) {
>  				a->container->ss->set_array_state(a,
> 0); a->next_state = active;

