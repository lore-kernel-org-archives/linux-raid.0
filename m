From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Monitor: pass statelist reference when adding new
 arrays
Date: Wed, 1 Dec 2010 22:25:55 +1100
Message-ID: <20101201222555.469c0d7c@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C102412@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C102412@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Wed, 1 Dec 2010 10:37:22 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From af217d38a81223408fc53ef485d7c5bd43b9d841 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Tue, 30 Nov 2010 14:44:45 +0100
> Subject: [PATCH] Monitor: pass statelist reference when adding new arrays
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> Otherwise it will not get updated.

Yes, of course.

Thanks a lot!

Applied and pushed out.

NeilBrown


> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  Monitor.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index d5514e9..e7f6d03 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -70,7 +70,7 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info);
>  static int check_array(struct state *st, struct mdstat_ent *mdstat,
>  		       int test, struct alert_info *info,
>  		       int increments);
> -static int add_new_arrays(struct mdstat_ent *mdstat, struct state *statelist,
> +static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>  			  int test, struct alert_info *info);
>  static void try_spare_migration(struct state *statelist, struct alert_info *info);
>  static void link_containers_with_subarrays(struct state *list);
> @@ -223,7 +223,7 @@ int Monitor(struct mddev_dev *devlist,
>  		
>  		/* now check if there are any new devices found in mdstat */
>  		if (scan)
> -			new_found = add_new_arrays(mdstat, statelist, test,
> +			new_found = add_new_arrays(mdstat, &statelist, test,
>  						   &info);
>  
>  		/* If an array has active < raid && spare == 0 && spare_group != NULL
> @@ -642,7 +642,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>  	return 0;
>  }
>  
> -static int add_new_arrays(struct mdstat_ent *mdstat, struct state *statelist,
> +static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>  			  int test, struct alert_info *info)
>  {
>  	struct mdstat_ent *mse;
> @@ -674,7 +674,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state *statelist,
>  				continue;
>  			}
>  			close(fd);
> -			st->next = statelist;
> +			st->next = *statelist;
>  			st->err = 1;
>  			st->devnum = mse->devnum;
>  			st->percent = -2;
> @@ -685,7 +685,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state *statelist,
>  					devname2devnum(mse->metadata_version+10);
>  			else
>  				st->parent_dev = NoMdDev;
> -			statelist = st;
> +			*statelist = st;
>  			if (test)
>  				alert("TestMessage", st->devname, NULL, info);
>  			alert("NewArray", st->devname, NULL, info);

