From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Warn the user about too small array size
Date: Mon, 14 Mar 2011 18:23:05 +1100
Message-ID: <20110314182305.3cfcab82@notabene.brown>
References: <20110228050043.23112.65994.stgit@gklab-128-111.igk.intel.com>
	<BE2BFE91933D1B4089447C64486040806AB7C11F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040806AB7C11F@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 10 Mar 2011 09:40:33 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Neil,
> 
> Could you include also this patch, please.

Applied.  Thanks for the reminder.

NeilBrown


> 
> Regards
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Krzysztof Wojcik
> > Sent: Monday, February 28, 2011 6:01 AM
> > To: neilb@suse.de
> > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> > Williams, Dan J; Ciechanowski, Ed
> > Subject: [PATCH] Warn the user about too small array size
> > 
> > If single-disk RAID0 or RAID1 array is created, user may preserve data
> > on
> > disk. If array given size covers all partitions on disk, all data will
> > be
> > available on created array. If array size is too small (not covers
> > all partitions), data will be not accessible.
> > This patch introduces warning message during array creation if given
> > size
> > is too small. User may interrupt creation process to avoid data loss.
> > 
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> >  Create.c |    7 +++----
> >  mdadm.h  |    2 +-
> >  util.c   |    9 ++++++++-
> >  3 files changed, 12 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Create.c b/Create.c
> > index bbd25e5..ff18ff8 100644
> > --- a/Create.c
> > +++ b/Create.c
> > @@ -121,7 +121,6 @@ int Create(struct supertype *st, char *mddev,
> >  	unsigned long long newsize;
> > 
> >  	int major_num = BITMAP_MAJOR_HI;
> > -
> >  	memset(&info, 0, sizeof(info));
> >  	if (level == UnSet && st && st->ss->default_geometry)
> >  		st->ss->default_geometry(st, &level, NULL, NULL);
> > @@ -380,14 +379,14 @@ int Create(struct supertype *st, char *mddev,
> >  			if (strcmp(st->ss->name, "1.x") == 0 &&
> >  			    st->minor_version >= 1)
> >  				/* metadata at front */
> > -				warn |= check_partitions(fd, dname, 0);
> > +				warn |= check_partitions(fd, dname, 0, 0);
> >  			else if (level == 1 || level == LEVEL_CONTAINER
> >  				    || (level == 0 && raiddisks == 1))
> >  				/* partitions could be meaningful */
> > -				warn |= check_partitions(fd, dname,
> > freesize*2);
> > +				warn |= check_partitions(fd, dname, freesize*2,
> > size*2);
> >  			else
> >  				/* partitions cannot be meaningful */
> > -				warn |= check_partitions(fd, dname, 0);
> > +				warn |= check_partitions(fd, dname, 0, 0);
> >  			if (strcmp(st->ss->name, "1.x") == 0 &&
> >  			    st->minor_version >= 1 &&
> >  			    did_default &&
> > diff --git a/mdadm.h b/mdadm.h
> > index a1be856..476a2be 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -1078,7 +1078,7 @@ extern int parse_layout_faulty(char *layout);
> >  extern int check_ext2(int fd, char *name);
> >  extern int check_reiser(int fd, char *name);
> >  extern int check_raid(int fd, char *name);
> > -extern int check_partitions(int fd, char *dname, unsigned long long
> > freesize);
> > +extern int check_partitions(int fd, char *dname, unsigned long long
> > freesize, unsigned long long size);
> > 
> >  extern int get_mdp_major(void);
> >  extern int dev_open(char *dev, int flags);
> > diff --git a/util.c b/util.c
> > index 87c23dc..0f72b0e 100644
> > --- a/util.c
> > +++ b/util.c
> > @@ -1370,7 +1370,8 @@ static int get_last_partition_end(int fd,
> > unsigned long long *endofpart)
> >  	return retval;
> >  }
> > 
> > -int check_partitions(int fd, char *dname, unsigned long long freesize)
> > +int check_partitions(int fd, char *dname, unsigned long long freesize,
> > +			unsigned long long size)
> >  {
> >  	/*
> >  	 * Check where the last partition ends
> > @@ -1393,6 +1394,12 @@ int check_partitions(int fd, char *dname,
> > unsigned long long freesize)
> >  				Name ": metadata will over-write last partition
> > on %s.\n",
> >  				dname);
> >  			return 1;
> > +		} else if (size && endofpart > size) {
> > +			/* partitions will be truncated in new device */
> > +			fprintf(stderr,
> > +				Name ": array size is too small to cover all
> > partitions on %s.\n",
> > +				dname);
> > +			return 1;
> >  		}
> >  	}
> >  	return 0;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

