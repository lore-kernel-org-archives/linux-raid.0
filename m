From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 21/33] Monitor: link containers and volumes in statelist
Date: Tue, 6 Jul 2010 17:11:17 +1000
Message-ID: <20100706171117.6116b595@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C42@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C42@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 5 Jul 2010 10:35:26 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> To avoid repeated retrieving of parent container or volumes list.
> 
> Simplifies finding unused disk in a container.
> 
> Function check_disk_is_free will be used for spare sharing.
> 
> 
> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com<mailto:marcin.labun@intel.com>>
> 
> ---
> 
>  Monitor.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
> 
>  1 files changed, 102 insertions(+), 21 deletions(-)
> 
> 
> 
> diff --git a/Monitor.c b/Monitor.c
> 
> index 8e82797..e16af2d 100644
> 
> --- a/Monitor.c
> 
> +++ b/Monitor.c
> 
> @@ -38,6 +38,24 @@ static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mail
> 
>   * At least it isn't MD_SB_DISKS.
> 
>   */
> 
>  #define MaxDisks 384
> 
> +struct state {
> 
> +     char *devname;
> 
> +     int devnum; /* to sync with mdstat info */
> 
> +     long utime;
> 
> +     int err;
> 
> +     char *spare_group;
> 
> +     int active, working, failed, spare, raid, total;
> 
> +     int expected_spares;
> 
> +     int devstate[MaxDisks];
> 
> +     int devid[MaxDisks];
> 
> +     int percent;
> 
> +     char *metadata_version;
> 
> +     struct state *next;
> 
> +     struct state *volumes;
> 
> +     struct state *parent;
> 
> +     struct state *missing;

I'm having trouble figuring out what next/volumes/parent/missing are meant to
mean exactly, and there is a lack of any comments explaining it.
I suspect that is probably makes sense, but I need some help understanding
exactly what you are doing here....


> > @@ -281,11 +298,9 @@ int Monitor(mddev_dev_t devlist,
> 
>                       st->spare == array.spare_disks &&
> 
>                       (mse == NULL  || (
> 
>                             mse->percent == st->percent
> 
> -                           ))) {
> 
> -                       close(fd);
> 
> +                           )))
> 
>                         st->err = 0;
> 
> -                       continue;
> 
> -                 }
> 


That if statement no just sets st->err=0, which happens again a few lines
later, so it seems the if statement is now pointless....
But it was there for a reason - I think to short-circuit a collections of
tests that won't be needed if the 'if' succeeds.  Maybe you could explain
why you want to remove the 'if' now.



> 
> +                             if (missing_parent_list)
> 
> +                                   st->missing = missing_parent_list;
> 
> +                             else
> 
> +                                   st->missing = NULL;

This 'if' is exactly equivalent to
      st->missing = missing_parent_list;
!


>                   struct mdstat_ent *mse;
> 
>                   for (mse=mdstat; mse; mse=mse->next)
> 
>                         if (mse->devnum != INT_MAX &&
> 
> -                           mse->level &&
> 
> -                           (strcmp(mse->level, "raid0")!=0 &&
> 
> -                            strcmp(mse->level, "linear")!=0)
> 
> -                             ) {
> 
> +                       (!mse->level  || /* retrieve containers */
> 
> +                       (strcmp(mse->level, "raid0") != 0 &&
> 
> +                       strcmp(mse->level, "linear") != 0))) {

You are messing up the indenting rather badly.  Please preserve the
formatting style of the original code.

> 
> +                                   if (st->metadata_version)
> 
> +                                         free(st->metadata_version);


You don't need the test, as free(NULL) is defined to do noting.


> 
> 
> 
> +/* check if disk is used in donor array (native) or any volume in donor
> 
> +container (external)*/ int check_disk_is_free(struct state *donor, int
> 
> +disk_idx, int ext) {

Some how the comment and the function declaration got wrapped together.  Not
nice.


Thanks,
NeilBrown

