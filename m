From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Show DELAYED, PENDING status of resync process in
 "--detail"
Date: Thu, 23 Jun 2011 12:07:45 +1000
Message-ID: <20110623120745.19756ad7@notabene.brown>
References: <20110618141035.14426.58645.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110618141035.14426.58645.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Sat, 18 Jun 2011 16:10:35 +0200 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Initialy there is no proper translation mdstat's DEYALED/PENDING processes
> to "--detail" output.
> For example, if we have revover=DELAYED in mdstat, "--detail"
> shows "State: recovering" and "Rebuild Status = 0%".
> It was incorrect in case of process waiting on checkpoint different
> than 0%. In fact rebuild status is differnt than 0% and user is misled.
> 
> The patch fix the problem. Current "--detail" command shows
> in the exampe: "State: recovering (DELAYED)" and no information
> about precentage.

Looks good. 

Applied, thanks.
NeilBrown


> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Detail.c |   18 +++++++++---------
>  mdadm.h  |    2 ++
>  mdstat.c |    8 ++++----
>  3 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 375189d..e9f71d8 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -372,11 +372,13 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  			else
>  				st = ", degraded";
>  
> -			printf("          State : %s%s%s%s\n",
> -			       (array.state&(1<<MD_SB_CLEAN))?"clean":"active",
> -			       st,
> -			       (!e || e->percent < 0) ? "" : sync_action[e->resync],
> -			       larray_size ? "": ", Not Started");
> +			printf("          State : %s%s%s%s%s%s \n",
> +			       (array.state&(1<<MD_SB_CLEAN))?"clean":"active", st,
> +			       (!e || (e->percent < 0 && e->percent != PROCESS_PENDING &&
> +			       e->percent != PROCESS_DELAYED)) ? "" : sync_action[e->resync],
> +			       larray_size ? "": ", Not Started",
> +			       e->percent == PROCESS_DELAYED ? " (DELAYED)": "",
> +			       e->percent == PROCESS_PENDING ? " (PENDING)": "");
>  		}
>  		if (array.raid_disks)
>  			printf(" Active Devices : %d\n", array.active_disks);
> @@ -416,10 +418,8 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
>  		}
>  
>  		if (e && e->percent >= 0) {
> -			printf(" Re%s Status : %d%% complete\n",
> -			       (st && st->sb && info->reshape_active)?
> -			          "shape":"build",
> -			       e->percent);
> +			static char *sync_action[] = {"Rebuild", "Resync", "Reshape", "Check"};
> +			printf(" %s Status : %d%% complete\n", sync_action[e->resync], e->percent);
>  			is_rebuilding = 1;
>  		}
>  		free_mdstat(ms);
> diff --git a/mdadm.h b/mdadm.h
> index e075dd2..8bd0077 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1345,3 +1345,5 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
>  #define PATH_MAX	4096
>  #endif
>  
> +#define PROCESS_DELAYED -2
> +#define PROCESS_PENDING -3
> diff --git a/mdstat.c b/mdstat.c
> index 3d2edad..abf6bf9 100644
> --- a/mdstat.c
> +++ b/mdstat.c
> @@ -257,10 +257,10 @@ struct mdstat_ent *mdstat_read(int hold, int start)
>  				if (strncmp(w, "check", 5)==0)
>  					ent->resync = 3;
>  
> -				if (l > 8 && strcmp(w+l-8, "=DELAYED"))
> -					ent->percent = 0;
> -				if (l > 8 && strcmp(w+l-8, "=PENDING"))
> -					ent->percent = 0;
> +				if (l > 8 && strcmp(w+l-8, "=DELAYED") == 0)
> +					ent->percent = PROCESS_DELAYED;
> +				if (l > 8 && strcmp(w+l-8, "=PENDING") == 0)
> +					ent->percent = PROCESS_PENDING;
>  			} else if (ent->percent == -1 &&
>  				   w[0] >= '0' &&
>  				   w[0] <= '9' &&

