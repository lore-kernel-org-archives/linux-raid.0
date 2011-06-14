From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] FIX: Cannot create volume
Date: Tue, 14 Jun 2011 12:35:30 +1000
Message-ID: <20110614123530.319da13a@notabene.brown>
References: <20110609162050.690.87261.stgit@gklab-128-013.igk.intel.com>
	<20110609162921.690.90444.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110609162921.690.90444.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 09 Jun 2011 18:29:21 +0200 Adam Kwolek <adam.kwolek@intel.com> wrote:

> getinfo_super() can clear entire 'inf' structure before filling with new
> information. Disk number required later is lost.
> 
> Restore disk number information after getinfo_super() call.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Create.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Create.c b/Create.c
> index 7b4d0fe..d01dea7 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -805,7 +805,6 @@ int Create(struct supertype *st, char *mddev,
>  			switch(pass) {
>  			case 1:
>  				*inf = info;
> -
>  				inf->disk.number = dnum;
>  				inf->disk.raid_disk = dnum;
>  				if (inf->disk.raid_disk < raiddisks)
> @@ -856,12 +855,13 @@ int Create(struct supertype *st, char *mddev,
>  					/* getinfo_super might have lost these ... */
>  					inf->disk.major = major(stb.st_rdev);
>  					inf->disk.minor = minor(stb.st_rdev);
> +					inf->disk.number = dnum;
> +					inf->disk.raid_disk = dnum;
>  				}
>  				break;
>  			case 2:
>  				inf->errors = 0;
>  				rv = 0;
> -
>  				rv = add_disk(mdfd, st, &info, inf);
>  
>  				if (rv) {

Unfortunately this is wrong too.

There should be no need to set disk.number and disk.raid_disk as the
->getinfo_super is supposed to have set them.

As the comment in mdadm.h says:

	/* Extract generic details from metadata.  This could be details about
	 * the container, or about an individual array within the container.
	 * The determination is made either by:
	 *   load_super being given a 'component' string.
	 *   validate_geometry determining what to create.
	 * The info includes both array information and device information.
	 * The particular device should be:
	 *   The last device added by add_to_super
	 *   The device the metadata was loaded from by load_super
	 * If 'map' is present, then it is an array raid_disks long
	 * (raid_disk must already be set and correct) and it is filled
	 * with 1 for slots that are thought to be active and 0 for slots which
	 * appear to be failed/missing.
	 * *info is zeroed out before data is added.
	 */

In this case, ->add_to_super was recently called so it should record state so
that getinfo_super can return the correct information.  That is what super0
and super1 does.

It seems that this has been wrong for a long time and my recent change to
zero the info structure showed it up.
So I'll let the patch through so as not to hold things up unnecessarily, but
I would really like you to see if you can fix add_to_super and getinfo_super
so that they follow the documented behaviour.

Thanks,
NeilBrown
