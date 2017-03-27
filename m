From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm:checking --level once mode has been set
Date: Mon, 27 Mar 2017 17:59:46 -0400
Message-ID: <wrfjshlyidnx.fsf@gmail.com>
References: <1489987046-22496-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489987046-22496-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Mon, 20 Mar 2017 13:17:26 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> mdadm: it would be better to check --level ealier,
> because it would fall to different prompt if user
> forgets to specify the --level. such as:
> ./mdadm --build /dev/md0 -n2 /dev/loop[0-1]
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Create.c | 4 ----
>  mdadm.c  | 6 ++++++
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/Create.c b/Create.c
> index 2721884..50ec85e 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -125,10 +125,6 @@ int Create(struct supertype *st, char *mddev,
>  	memset(&info, 0, sizeof(info));
>  	if (s->level == UnSet && st && st->ss->default_geometry)
>  		st->ss->default_geometry(st, &s->level, NULL, NULL);
> -	if (s->level == UnSet) {
> -		pr_err("a RAID level is needed to create an array.\n");
> -		return 1;
> -	}
>  	if (s->raiddisks < 4 && s->level == 6) {
>  		pr_err("at least 4 raid-devices needed for level 6\n");
>  		return 1;
> diff --git a/mdadm.c b/mdadm.c
> index d6ad8dc..fcb33d1 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -349,6 +349,12 @@ int main(int argc, char *argv[])
>  				pr_err("Must give -a/--add for devices to add: %s\n", optarg);
>  				exit(2);
>  			}
> +			if (devs_found > 0 && s.level == UnSet && !devmode) {
> +				if (mode == CREATE || mode == BUILD) {
> +					pr_err("a RAID level is needed to create or build an array.\n");
> +					exit(2);
> +				}
> +			}
>  			dv = xmalloc(sizeof(*dv));
>  			dv->devname = optarg;
>  			dv->disposition = devmode;

So I am not sure I like this solution. I don't like the attempted catch
all global error handling, where we hope we catch all the cases in the
calling function. I would really prefer to move towards a model where
errors are caught in the function and we instead do better handling of
error return values as we return.

Second your patch changes the failure return code for Create() from
exit(1) to exit(2).

Jes
