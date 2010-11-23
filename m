From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 03/13] Manage: allow manual control of external raid0
 readonly flag
Date: Tue, 23 Nov 2010 15:08:22 +1100
Message-ID: <20101123150822.32e0322a@notabene.brown>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
	<20101118092145.29508.68627.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118092145.29508.68627.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 18 Nov 2010 10:21:45 +0100
Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:

> From: Dan Williams <dan.j.williams@intel.com>
> 
> mdadm --readwrite <subarray> will clear the external readonly flag ('-'
> to '/'), but only for redudant arrays.  Allow raid0 arrays as well so
> the user has a simple helper to control this flag.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Manage.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index 6e9d4a0..ac9415b 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -56,7 +56,6 @@ int Manage_ro(char *devname, int fd, int readonly)
>  	mdi = sysfs_read(fd, -1, GET_LEVEL|GET_VERSION);
>  	if (mdi &&
>  	    mdi->array.major_version == -1 &&
> -	    mdi->array.level > 0 &&
>  	    is_subarray(mdi->text_version)) {
>  		char vers[64];
>  		strcpy(vers, "external:");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I've added:
diff --git a/Manage.c b/Manage.c
index 919dc01..a203ec9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -87,6 +87,8 @@ int Manage_ro(char *devname, int fd, int readonly)
 			if (*cp)
 				*cp = 0;
 			ping_monitor(vers+10);
+			if (mdi->array.level <= 0)
+				sysfs_set_str(mdi, NULL, "array_state", "active");
 		}
 		return 0;
 	}


so that you can set raid0 to --readonly again.  Yell if you think that is
wrong.

NeilBrown
