From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] Fix regression during add devices
Date: Wed, 09 Mar 2016 13:30:49 -0500
Message-ID: <wrfjio0v4i7a.fsf@redhat.com>
References: <1457500818-1586-1-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457500818-1586-1-git-send-email-colyli@suse.de> (Coly Li's
	message of "Wed, 9 Mar 2016 13:20:18 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.com>
List-Id: linux-raid.ids

Coly Li <colyli@suse.de> writes:
> From: Hannes Reinecke <hare@suse.de>
>
> Commit d180d2aa2a17 ("Manage: fix test for 'is array failed'.")
> introduced a regression which would not allow to re-add new
> drivers to a failed array.
>
> The patch is written by Hannes Reinecke, Neil Brown points out
> the buggy commit ID is d180d2aa2a17. Coly helps to submit the
> patch to mdadm upstream.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Coly Li <colyli@suse.de>
> Cc: Neil Brown <neilb@suse.com>
> ---
>  Manage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Coly,

Thanks for the fix - please use "Fixes: " to indicate which patch
introduced the bug, and the story of pushing the patch really belongs in
a comment below the --- line, so it doesn't go into git.

I modified it to look like this - please let me know if you are OK with
this.

Thanks,
Jes


commit 227bd322d3ed80bee0f1a0ae44a293908890851c
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Mar 9 13:20:18 2016 +0800

    Fix regression during add devices
    
    Commit d180d2aa2a17 ("Manage: fix test for 'is array failed'.")
    introduced a regression which would not allow to re-add new
    drivers to a failed array.
    
    Fixes: d180d2aa2a17 ("Manage: fix test for 'is array failed'.")
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Cc: Coly Li <colyli@suse.de>
    Cc: Neil Brown <neilb@suse.com>
    Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>


> diff --git a/Manage.c b/Manage.c
> index 7e1b94b..073ddb9 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -879,10 +879,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  					continue;
>  				if (disc.major == 0 && disc.minor == 0)
>  					continue;
> -				found++;
>  				if (!(disc.state & (1<<MD_DISK_SYNC)))
>  					continue;
>  				avail[disc.raid_disk] = 1;
> +				found++;
>  			}
>  			array_failed = !enough(array->level, array->raid_disks,
>  					       array->layout, 1, avail);
