From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] FIX: Remove error message during reshape restart
Date: Wed, 21 Sep 2011 08:03:18 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A03259F@IRSMSX101.ger.corp.intel.com>
References: <20110916135637.10460.87995.stgit@gklab-128-013.igk.intel.com>
	<20110921130935.563effd1@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A032491@IRSMSX101.ger.corp.intel.com>
 <20110921175856.195e94cb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921175856.195e94cb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Wednesday, September 21, 2011 9:59 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> Subject: Re: [PATCH] FIX: Remove error message during reshape restart
> 
> On Wed, 21 Sep 2011 07:20:33 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> >
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Wednesday, September 21, 2011 5:10 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> > > Subject: Re: [PATCH] FIX: Remove error message during reshape
> > > restart
> > >
> > > On Fri, 16 Sep 2011 15:56:38 +0200 Adam Kwolek
> > > <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > When reshape is restarted freeze() is called on blocked already array.
> > > > Meaningless error message is displayed and reshape is continued
> > > > without interruption.
> > >
> > > Maybe I'm just having a bad day, but again I cannot understand the
> > > situation that you are trying to fix.
> >
> > In assemble_container_content () one of the first command for reshape
> case is:
> > 	if (content->reshape_active)
> > 		block_subarray(content);
> >
> > This means that call block_monitor () will produce error message while
> array is frozen.
> >
> > I think, that in fact for reshape continue case block_monitor ()
> > should skip frozen arrays and freeze all other /not frozen yet/. I've got the
> following change in my sent Q (this will replace suppressing error message
> patch):
> >
> > instead:
> > if (sra->text_version[0] == '-')
> > 			break;
> >
> > I think should be:
> >
> > if (sra->text_version[0] == '-') {
> > 	if (restart)
> > 		continue;
> > 	else
> > 		break;
> > }
> 
> Why not just get rid of it completely - it doesn't seem to be necessary.
> 
> NeilBrown

If 2 degraded arrays in container is being assembled and one is during reshape inserting spare device can push second one in to resync.
This can lead to block reshape condition on second array during container operation.

Adam

> 
> 
> 
> >
> > This will freeze whole container during reshape continuation (just like for
> reshape start).
> >
> > A few more fixes for freezing are in my Q also. I'll send them soon.
> >
> >
> > >
> > > When we restart a reshape the array should not be frozen should it?
> > > Maybe it is after your new series of patches, in which case if you
> > > think this is still relevant, please add this to that series.
> > >
> > > If a reshaping array is started while in the 'initrd', then I think
> > > the only way that it should be frozen is that sync_max should be set
> > > to where the reshape is currently up to.
> >
> > This patch is independent to 'initrd' problem, but I think about it.
> >
> > BR
> > Adam
> >
> >
> >
> >
> > >
> > > NeilBrown
> > >
> > >
> > > >
> > > > Disable error message for reshape restart displayed by freeze()
> > > > function.
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > > ---
> > > >
> > > >  Grow.c |   17 +++++++++--------
> > > >  msg.c  |    7 ++++---
> > > >  msg.h  |    2 +-
> > > >  3 files changed, 14 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/Grow.c b/Grow.c
> > > > index 04e6679..15d4a65 100644
> > > > --- a/Grow.c
> > > > +++ b/Grow.c
> > > > @@ -478,7 +478,7 @@ static int check_idle(struct supertype *st)
> > > >  	return is_idle;
> > > >  }
> > > >
> > > > -static int freeze_container(struct supertype *st)
> > > > +static int freeze_container(struct supertype *st, int restart)
> > > >  {
> > > >  	int container_dev = (st->container_dev != NoMdDev
> > > >  			     ? st->container_dev : st->devnum); @@ -486,11
> > > +486,12 @@
> > > > static int freeze_container(struct supertype *st)
> > > >
> > > >  	if (!check_idle(st))
> > > >  		return -1;
> > > > -
> > > > +
> > > >  	fmt_devname(container, container_dev);
> > > >
> > > > -	if (block_monitor(container, 1)) {
> > > > -		fprintf(stderr, Name ": failed to freeze container\n");
> > > > +	if (block_monitor(container, 1, restart)) {
> > > > +		if (!restart)
> > > > +			fprintf(stderr, Name ": failed to freeze container\n");
> > > >  		return -2;
> > > >  	}
> > > >
> > > > @@ -508,7 +509,7 @@ static void unfreeze_container(struct
> > > > supertype
> > > *st)
> > > >  	unblock_monitor(container, 1);
> > > >  }
> > > >
> > > > -static int freeze(struct supertype *st)
> > > > +static int freeze(struct supertype *st, int restart)
> > > >  {
> > > >  	/* Try to freeze resync/rebuild on this array/container.
> > > >  	 * Return -1 if the array is busy, @@ -517,7 +518,7 @@ static
> > > > int freeze(struct supertype *st)
> > > >  	 * return 1 if it worked.
> > > >  	 */
> > > >  	if (st->ss->external)
> > > > -		return freeze_container(st);
> > > > +		return freeze_container(st, restart);
> > > >  	else {
> > > >  		struct mdinfo *sra = sysfs_read(-1, st->devnum,
> > > GET_VERSION);
> > > >  		int err;
> > > > @@ -1444,7 +1445,7 @@ int Grow_reshape(char *devname, int fd, int
> > > quiet, char *backup_file,
> > > >  			devname);
> > > >  		return 1;
> > > >  	}
> > > > -	frozen = freeze(st);
> > > > +	frozen = freeze(st, 0);
> > > >  	if (frozen < -1) {
> > > >  		/* freeze() already spewed the reason */
> > > >  		return 1;
> > > > @@ -3846,7 +3847,7 @@ int Grow_continue(int mdfd, struct supertype
> > > *st, struct mdinfo *info,
> > > >  	if (st->ss->external) {
> > > >  		fmt_devname(buf, st->container_dev);
> > > >  		container = buf;
> > > > -		freeze(st);
> > > > +		freeze(st, 1);
> > > >
> > > >  		if (!mdmon_running(st->container_dev))
> > > >  			start_mdmon(st->container_dev); diff --git a/msg.c
> b/msg.c
> > > > index a10c930..0cae6ba 100644
> > > > --- a/msg.c
> > > > +++ b/msg.c
> > > > @@ -300,7 +300,7 @@ int block_subarray(struct mdinfo *sra)
> > > >   * As older versions of mdmon (which might run from initrd) don't
> > > understand
> > > >   * this, we first check that the running mdmon is new enough.
> > > >   */
> > > > -int block_monitor(char *container, const int freeze)
> > > > +int block_monitor(char *container, const int freeze, const int
> > > > +restart)
> > > >  {
> > > >  	int devnum = devname2devnum(container);
> > > >  	struct mdstat_ent *ent, *e, *e2; @@ -388,8 +388,9 @@ int
> > > > block_monitor(char *container, const int freeze)
> > > >  	}
> > > >
> > > >  	if (e) {
> > > > -		fprintf(stderr, Name ": failed to freeze subarray%s\n",
> > > > -			to_subarray(e, container));
> > > > +		if (!restart)
> > > > +			fprintf(stderr, Name ": failed to freeze
> > > subarray%s\n",
> > > > +				to_subarray(e, container));
> > > >
> > > >  		/* thaw the partially frozen container */
> > > >  		for (e2 = ent; e2 && e2 != e; e2 = e2->next) { diff --git
> > > a/msg.h
> > > > b/msg.h index c6d037d..1c8565b 100644
> > > > --- a/msg.h
> > > > +++ b/msg.h
> > > > @@ -30,7 +30,7 @@ extern int ping_monitor(char *devname);  extern
> > > > int ping_monitor_by_id(int devnum);  extern int
> > > > block_subarray(struct mdinfo *sra);  extern int
> > > > unblock_subarray(struct mdinfo *sra, const int unfreeze); -extern
> > > > int block_monitor(char *container, const int freeze);
> > > > +extern int block_monitor(char *container, const int freeze, const
> > > > +int restart);
> > > >  extern void unblock_monitor(char *container, const int unfreeze);
> > > > extern int fping_monitor(int sock);  extern int ping_manager(char
> > > > *devname);

