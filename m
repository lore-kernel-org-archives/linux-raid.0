From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Mdmon crashes after changing RAID level from 1 to
 0
Date: Wed, 7 Sep 2011 12:41:31 +1000
Message-ID: <20110907124131.0f38dd20@notabene.brown>
References: <20110901131033.3034.42088.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901131033.3034.42088.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 01 Sep 2011 15:10:34 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Description of the bug:
> Sometimes mdmon crashes after changing RAID level from 1 to 0 (takeover).
> 
> Cause of the bug:
> The managemon marks an active_array for removal from monitoring
> by assigning a->container to NULL value (in the "manage_member" function).
> Sometimes (during stress test) it happens right when the monitor
> is in the "read_and_act" function and a->container pointer is in use.
> This causes the monitor crashes.
> 
> Solution:
> The active array has to be marked for removal in another way
> than setting NULL pointer when it can be in use.
> A new field "to_remove" was added to the "active_array" structure.
> It is used in the managemon to mark a container to remove
> (instead of the old assigment: a->container = NULL)
> and monitor checks it to determine if the array should be removed.
> The field "to_remove" should be checked in some other places
> to avoid managing of the array which is going to be removed.
> 
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>

Thanks.

I have applied this - despite the ridiculous disclaimer at the bottom :-)

NeilBrown


> ---
>  managemon.c |    4 ++--
>  mdmon.h     |    1 +
>  monitor.c   |    8 ++++----
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/managemon.c b/managemon.c
> index d020f82..9e0a34d 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -461,7 +461,7 @@ static void manage_member(struct mdstat_ent *mdstat,
>  	if (mdstat->level) {
>  		int level = map_name(pers, mdstat->level);
>  		if (level == 0 || level == LEVEL_LINEAR) {
> -			a->container = NULL;
> +			a->to_remove = 1;
>  			wakeup_monitor();
>  			return;
>  		}
> @@ -739,7 +739,7 @@ void manage(struct mdstat_ent *mdstat, struct supertype *container)
>  		/* Looks like a member of this container */
>  		for (a = container->arrays; a; a = a->next) {
>  			if (mdstat->devnum == a->devnum) {
> -				if (a->container)
> +				if (a->container && a->to_remove == 0)
>  					manage_member(mdstat, a);
>  				break;
>  			}
> diff --git a/mdmon.h b/mdmon.h
> index 6d1776f..59e1b53 100644
> --- a/mdmon.h
> +++ b/mdmon.h
> @@ -28,6 +28,7 @@ struct active_array {
>  	struct mdinfo info;
>  	struct supertype *container;
>  	struct active_array *next, *replaces;
> +	int to_remove;
>  
>  	int action_fd;
>  	int resync_start_fd;
> diff --git a/monitor.c b/monitor.c
> index 7ac5907..b002e90 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -479,7 +479,7 @@ static void reconcile_failed(struct active_array *aa, struct mdinfo *failed)
>  	struct mdinfo *victim;
>  
>  	for (a = aa; a; a = a->next) {
> -		if (!a->container)
> +		if (!a->container || a->to_remove)
>  			continue;
>  		victim = find_device(a, failed->disk.major, failed->disk.minor);
>  		if (!victim)
> @@ -539,7 +539,7 @@ static int wait_and_act(struct supertype *container, int nowait)
>  		/* once an array has been deactivated we want to
>  		 * ask the manager to discard it.
>  		 */
> -		if (!a->container) {
> +		if (!a->container || a->to_remove) {
>  			if (discard_this) {
>  				ap = &(*ap)->next;
>  				continue;
> @@ -642,7 +642,7 @@ static int wait_and_act(struct supertype *container, int nowait)
>  			/* FIXME check if device->state_fd need to be cleared?*/
>  			signal_manager();
>  		}
> -		if (a->container) {
> +		if (a->container && !a->to_remove) {
>  			is_dirty = read_and_act(a);
>  			rv |= 1;
>  			dirty_arrays += is_dirty;
> @@ -657,7 +657,7 @@ static int wait_and_act(struct supertype *container, int nowait)
>  
>  	/* propagate failures across container members */
>  	for (a = *aap; a ; a = a->next) {
> -		if (!a->container)
> +		if (!a->container || a->to_remove)
>  			continue;
>  		for (mdi = a->info.devs ; mdi ; mdi = mdi->next)
>  			if (mdi->curr_state & DS_FAULTY)
> 
> ---------------------------------------------------------------------
> Intel Technology Poland sp. z o.o.
> z siedziba w Gdansku
> ul. Slowackiego 173
> 80-298 Gdansk
> 
> Sad Rejonowy Gdansk Polnoc w Gdansku, 
> VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
> numer KRS 101882
> 
> NIP 957-07-52-316
> Kapital zakladowy 200.000 zl
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

