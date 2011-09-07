From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix: Sometimes mdmon throws core dump during reshape
Date: Wed, 7 Sep 2011 14:07:59 +1000
Message-ID: <20110907140759.6ed12d4d@notabene.brown>
References: <20110905103955.4372.52448.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110905103955.4372.52448.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Mon, 05 Sep 2011 12:39:55 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Problem was found during reshaping 2 volumes /raid0 and raid5/ in container.
> Sometimes mdmon throws core dump due to NULL pointer exception.
> 
> Problem occurs in scenario:
> - managemon: is about spare activation (degraded raid4 volume == raid0 under takeover)
> - managemon: detect level change and signals monitor (manage_member() calls replace_array())
> - monitor: detects transition raid4/5->raid0 and sets a->container to NULL
>            to indicate array deactivation
> - managemon : continues his work and tries to activate spare (a->check_degraded is set).
>               NULL pointer is passed to metadata handler activate_spare()
>               Core dump is generated.
> 
> To resolve this situation managemon (after monitor kick) checks again
> a->container pointer to learn if current array is not to be deactivated.

This looks like it might be the same bug as is fixed by
     Lukasz Dorau <lukasz.dorau@intel.com>
in
  Subject: [PATCH] FIX: Mdmon crashes after changing RAID level from 1 to 0

Does that look likely?

Thanks,
NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  managemon.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/managemon.c b/managemon.c
> index d020f82..3540dac 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -475,6 +475,12 @@ static void manage_member(struct mdstat_ent *mdstat,
>  		}
>  	}
>  
> +	/* we are after monitor kick,
> +	 * so container field can be cleared - check it again
> +	 */
> +	if (a->container == NULL)
> +		return;
> +
>  	/* We don't check the array while any update is pending, as it
>  	 * might container a change (such as a spare assignment) which
>  	 * could affect our decisions.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

