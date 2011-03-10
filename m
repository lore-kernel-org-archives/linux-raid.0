From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/9] FIX: Cannot continue reshape if mdmon is not run
Date: Thu, 10 Mar 2011 11:37:39 +1100
Message-ID: <20110310113739.4643a5c4@notabene.brown>
References: <20110309134019.8939.15438.stgit@gklab-128-013.igk.intel.com>
	<20110309134618.8939.46747.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110309134618.8939.46747.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Wed, 09 Mar 2011 14:46:18 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Grow_continue() call was moved down in assemble_container_content()
> because it needs running mdmon. Mdmon is running at the end of this function.
> 
> Due to mdmon is required to run setting array_state was disabled for reshaped array.
> This causes that md will keep stable reshape in sync_action.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Assemble.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 0ffbbc9..3771ee1 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1544,7 +1544,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  	if (runstop > 0 ||
>  		 (working + preexist + expansion) >=
>  			content->array.working_disks) {
> -		int err;
> +		int err = 0;
>  
>  		if (content->reshape_active) {
>  			int spare = content->array.raid_disks + expansion;
> @@ -1577,18 +1577,19 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  						" to specify a --backup-file\n");
>  				return 1;
>  			}
> -
> -			err = Grow_continue(mdfd, st, content, backup_file);
> -		} else switch(content->array.level) {
> +		}
> +		switch (content->array.level) {
>  		case LEVEL_LINEAR:
>  		case LEVEL_MULTIPATH:
>  		case 0:
> -			err = sysfs_set_str(content, NULL, "array_state",
> -					    "active");
> +			if (!content->reshape_active)
> +				err = sysfs_set_str(content, NULL,
> +						    "array_state", "active");
>  			break;
>  		default:
> -			err = sysfs_set_str(content, NULL, "array_state",
> -				      "readonly");
> +			if (!content->reshape_active)
> +				err = sysfs_set_str(content, NULL,
> +						    "array_state", "readonly");
>  			/* start mdmon if needed. */
>  			if (!err) {
>  				if (!mdmon_running(st->container_dev))
> @@ -1615,8 +1616,12 @@ int assemble_container_content(struct supertype *st, int mdfd,
>  					expansion);
>  			fprintf(stderr, "\n");
>  		}
> -		if (!err)
> +		if (!err) {
>  			wait_for(chosen_name, mdfd);
> +			if (content->reshape_active)
> +				err = Grow_continue(mdfd, st, content,
> +						    backup_file);
> +		}
>  		return err;
>  		/* FIXME should have an O_EXCL and wait for read-auto */
>  	} else {
> 

This is needlessly complex.

I have applied the following instead.

Thanks,
NeilBrown

commit f362d22b5bc492c60fa1ea7e0f8346b7837dd7da
Author: NeilBrown <neilb@suse.de>
Date:   Thu Mar 10 11:36:47 2011 +1100

    Grow: make sure mdmon is running for Grow_continue arrays.
    
    when starting an array that is in the middle of a migration,
    we need to start mdmon, just as we do for arrays which are not
    in the middle of a migration.
    
    Repored-by: Adam Kwolek <adam.kwolek@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 5acd94d..734fa6d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3371,6 +3371,11 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
                container = buf;
                freeze(st);
 
+               if (!mdmon_running(st->container_dev))
+                       start_mdmon(st->container_dev);
+               ping_monitor(devnum2devname(st->container_dev));
+
+
                if (info->reshape_active == 2) {
                        int cfd = open_dev(st->container_dev);
                        if (cfd < 0)


