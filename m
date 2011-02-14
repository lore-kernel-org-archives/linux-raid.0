From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH] fix: detect container early in Create
Date: Mon, 14 Feb 2011 11:19:24 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0111762445@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F01114985F2@irsmsx504.ger.corp.intel.com>
 <20110214095235.0fce04e9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214095235.0fce04e9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,
I can't fully agree with you. 
Loading orom in validate_geometry_imsm is a good idea but
it will only work when -e imsm option is given.
When we have an imsm  container with sda and sdb and just call 
mdadm -CR v0 -l 0 -n 2 /dev/sd[ab]
then default geometry will not be called and chunk will still be set to 512.
We need to realize that /dev/sda is already in an imsm container to get the correct setting.
Regards
Anna

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Sunday, February 13, 2011 11:53 PM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH] fix: detect container early in Create
> 
> On Thu, 10 Feb 2011 09:14:40 +0000 "Czarnowska, Anna"
> <anna.czarnowska@intel.com> wrote:
> 
> > >From 082f13fb974059de27804e0f28d05f11e3c3eb3b Mon Sep 17 00:00:00
> 2001
> > From: Anna Czarnowska <anna.czarnowska@intel.com>
> > Date: Thu, 10 Feb 2011 09:52:42 +0100
> > Subject: [PATCH] fix: detect container early in Create
> > Cc: linux-raid@vger.kernel.org, Williams, Dan J
> <dan.j.williams@intel.com>, Ciechanowski, Ed
> <ed.ciechanowski@intel.com>
> >
> > When creating raid0 subarray in a container giving list of
> > devices on the command line Create always sets chunk=512
> > default_geometry will only return chunk!=0 for imsm
> > when we have superblock loaded.
> > When a list of disks is given instead of a container
> > we load superblock later, after wrong chunk size has been set.
> > This causes Create to fail for imsm.
> >
> > New function check_container is added to check if first
> > non "missing" device on given list is a container member.
> > If it is, we load container so we can get correct chunk.
> > At this stage we can abort creation if
> > - all given devices are "missing" or
> > - device can't be open for reading or
> > - metadata given on command line does not match container we found.
> >
> > As the container check was a part of validate geometry for ddf and
> imsm
> > metadata this part of code has been replaced by check_container.
> 
> I don't like this patch.
> 
> Choosing the correct default chunk size does not require loading
> the metadata.  It only requires finding the option rom which
> you can easily do in default_geometry_imsm just like it is done in
> validate_geometry_imsm_container.
> 
> There may be a case for factoring code out of both ddf and intel and
> putting it in util.c - I'm not sure.  But it should be a separate
> patch with a separate justification.
> 
> so: not applied.
> 
> Thanks,
> NeilBrown
> 
> 
> >
> > Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> > ---
> >  Create.c      |   21 +++++++++++++++
> >  mdadm.h       |    1 +
> >  super-ddf.c   |   78 ++++++-----------------------------------------
> ---------
> >  super-intel.c |   58 +----------------------------------------
> >  util.c        |   79
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 111 insertions(+), 126 deletions(-)
> >
> > diff --git a/Create.c b/Create.c
> > index a0669fe..8208b19 100644
> > --- a/Create.c
> > +++ b/Create.c
> > @@ -64,6 +64,21 @@ static int default_layout(struct supertype *st,
> int level, int verbose)
> >  	return layout;
> >  }
> >
> > +static int devices_in_container(struct mddev_dev *devlist, struct
> supertype **stp, int verbose)
> > +{
> > +	struct mddev_dev *dv;
> > +
> > +	for(dv = devlist; dv; dv = dv->next)
> > +		if (strcasecmp(dv->devname, "missing") == 0)
> > +			continue;
> > +		else
> > +			break;
> > +	if (!dv) {
> > +		fprintf(stderr, Name ": Cannot create this array on missing
> devices\n");
> > +		return -1;
> > +	}
> > +	return  check_container(dv->devname, stp, verbose);
> > +}
> >
> >  int Create(struct supertype *st, char *mddev,
> >  	   int chunk, int level, int layout, unsigned long long size,
> > @@ -230,6 +245,12 @@ int Create(struct supertype *st, char *mddev,
> >  	case 6:
> >  	case 0:
> >  		if (chunk == 0) {
> > +			/* check if listed devices are in a container
> > +			 * if so, load the container */
> > +			if ((!st || !st->sb) &&
> > +			   devices_in_container(devlist, &st, verbose) < 0)
> > +				/* error already printed */
> > +				return 1;
> >  			if (st && st->ss->default_geometry)
> >  				st->ss->default_geometry(st, NULL, NULL,
> &chunk);
> >  			chunk = chunk ? : 512;
> > diff --git a/mdadm.h b/mdadm.h
> > index 608095f..9be236f 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -1133,6 +1133,7 @@ extern struct mdinfo
> *container_choose_spares(struct supertype *st,
> >  					      struct domainlist *domlist,
> >  					      char *spare_group,
> >  					      const char *metadata, int get_one);
> > +extern int check_container(char *devname, struct supertype **stp,
> int verbose);
> >  extern int move_spare(char *from_devname, char *to_devname, dev_t
> devid);
> >  extern int add_disk(int mdfd, struct supertype *st,
> >  		    struct mdinfo *sra, struct mdinfo *info);
> > diff --git a/super-ddf.c b/super-ddf.c
> > index 287fa7f..611626f 100644
> > --- a/super-ddf.c
> > +++ b/super-ddf.c
> > @@ -2555,10 +2555,6 @@ static int validate_geometry_ddf(struct
> supertype *st,
> >  				 char *dev, unsigned long long *freesize,
> >  				 int verbose)
> >  {
> > -	int fd;
> > -	struct mdinfo *sra;
> > -	int cfd;
> > -
> >  	/* ddf potentially supports lots of things, but it depends on
> >  	 * what devices are offered (and maybe kernel version?)
> >  	 * If given unused devices, we will make a container.
> > @@ -2601,79 +2597,21 @@ static int validate_geometry_ddf(struct
> supertype *st,
> >  		return 1;
> >  	}
> >
> > -	if (st->sb) {
> > -		/* A container has already been opened, so we are
> > -		 * creating in there.  Maybe a BVD, maybe an SVD.
> > +	if (st->sb || check_container(dev, &st, verbose) == 1) {
> > +		/* A container has already been opened
> > +		 * or dev is a ddf container member, so we are
> > +		 * creating in there.
> > +		 * Maybe a BVD, maybe an SVD.
> >  		 * Should make a distinction one day.
> >  		 */
> >  		return validate_geometry_ddf_bvd(st, level, layout,
> raiddisks,
> >  						 chunk, size, dev, freesize,
> >  						 verbose);
> >  	}
> > -	/* This is the first device for the array.
> > -	 * If it is a container, we read it in and do automagic
> allocations,
> > -	 * no other devices should be given.
> > -	 * Otherwise it must be a member device of a container, and we
> > -	 * do manual allocation.
> > -	 * Later we should check for a BVD and make an SVD.
> > -	 */
> > -	fd = open(dev, O_RDONLY|O_EXCL, 0);
> > -	if (fd >= 0) {
> > -		sra = sysfs_read(fd, 0, GET_VERSION);
> > -		close(fd);
> > -		if (sra && sra->array.major_version == -1 &&
> > -		    strcmp(sra->text_version, "ddf") == 0) {
> > -
> > -			/* load super */
> > -			/* find space for 'n' devices. */
> > -			/* remember the devices */
> > -			/* Somehow return the fact that we have enough */
> > -		}
> > -
> > -		if (verbose)
> > -			fprintf(stderr,
> > -				Name ": ddf: Cannot create this array "
> > -				"on device %s - a container is required.\n",
> > -				dev);
> > -		return 0;
> > -	}
> > -	if (errno != EBUSY || (fd = open(dev, O_RDONLY, 0)) < 0) {
> > -		if (verbose)
> > -			fprintf(stderr, Name ": ddf: Cannot open %s: %s\n",
> > -				dev, strerror(errno));
> > -		return 0;
> > -	}
> > -	/* Well, it is in use by someone, maybe a 'ddf' container. */
> > -	cfd = open_container(fd);
> > -	if (cfd < 0) {
> > -		close(fd);
> > -		if (verbose)
> > -			fprintf(stderr, Name ": ddf: Cannot use %s: %s\n",
> > -				dev, strerror(EBUSY));
> > -		return 0;
> > -	}
> > -	sra = sysfs_read(cfd, 0, GET_VERSION);
> > -	close(fd);
> > -	if (sra && sra->array.major_version == -1 &&
> > -	    strcmp(sra->text_version, "ddf") == 0) {
> > -		/* This is a member of a ddf container.  Load the container
> > -		 * and try to create a bvd
> > -		 */
> > -		struct ddf_super *ddf;
> > -		if (load_super_ddf_all(st, cfd, (void **)&ddf, NULL) == 0)
> {
> > -			st->sb = ddf;
> > -			st->container_dev = fd2devnum(cfd);
> > -			close(cfd);
> > -			return validate_geometry_ddf_bvd(st, level, layout,
> > -							 raiddisks, chunk, size,
> > -							 dev, freesize,
> > -							 verbose);
> > -		}
> > -		close(cfd);
> > -	} else /* device may belong to a different container */
> > -		return 0;
> > +	if (verbose)
> > +		fprintf(stderr, Name ": ddf: failed container membership
> check\n");
> > +	return 0;
> >
> > -	return 1;
> >  }
> >
> >  static int
> > diff --git a/super-intel.c b/super-intel.c
> > index 29f8fc4..4d4ff89 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -4413,10 +4413,6 @@ static int validate_geometry_imsm(struct
> supertype *st, int level, int layout,
> >  				  char *dev, unsigned long long *freesize,
> >  				  int verbose)
> >  {
> > -	int fd, cfd;
> > -	struct mdinfo *sra;
> > -	int is_member = 0;
> > -
> >  	/* if given unused devices create a container
> >  	 * if given given devices in a container create a member volume
> >  	 */
> > @@ -4446,64 +4442,14 @@ static int validate_geometry_imsm(struct
> supertype *st, int level, int layout,
> >  		}
> >  		return 1;
> >  	}
> > -	if (st->sb) {
> > +	if (st->sb || check_container(dev, &st, verbose) == 1) {
> >  		/* creating in a given container */
> >  		return validate_geometry_imsm_volume(st, level, layout,
> >  						     raiddisks, chunk, size,
> >  						     dev, freesize, verbose);
> >  	}
> > -
> > -	/* This device needs to be a device in an 'imsm' container */
> > -	fd = open(dev, O_RDONLY|O_EXCL, 0);
> > -	if (fd >= 0) {
> > -		if (verbose)
> > -			fprintf(stderr,
> > -				Name ": Cannot create this array on device
> %s\n",
> > -				dev);
> > -		close(fd);
> > -		return 0;
> > -	}
> > -	if (errno != EBUSY || (fd = open(dev, O_RDONLY, 0)) < 0) {
> > -		if (verbose)
> > -			fprintf(stderr, Name ": Cannot open %s: %s\n",
> > -				dev, strerror(errno));
> > -		return 0;
> > -	}
> > -	/* Well, it is in use by someone, maybe an 'imsm' container. */
> > -	cfd = open_container(fd);
> > -	close(fd);
> > -	if (cfd < 0) {
> > -		if (verbose)
> > -			fprintf(stderr, Name ": Cannot use %s: It is busy\n",
> > -				dev);
> > -		return 0;
> > -	}
> > -	sra = sysfs_read(cfd, 0, GET_VERSION);
> > -	if (sra && sra->array.major_version == -1 &&
> > -	    strcmp(sra->text_version, "imsm") == 0)
> > -		is_member = 1;
> > -	sysfs_free(sra);
> > -	if (is_member) {
> > -		/* This is a member of a imsm container.  Load the
> container
> > -		 * and try to create a volume
> > -		 */
> > -		struct intel_super *super;
> > -
> > -		if (load_super_imsm_all(st, cfd, (void **) &super, NULL) ==
> 0) {
> > -			st->sb = super;
> > -			st->container_dev = fd2devnum(cfd);
> > -			close(cfd);
> > -			return validate_geometry_imsm_volume(st, level,
> layout,
> > -							     raiddisks, chunk,
> > -							     size, dev,
> > -							     freesize, verbose);
> > -		}
> > -	}
> > -
> >  	if (verbose)
> > -		fprintf(stderr, Name ": failed container membership
> check\n");
> > -
> > -	close(cfd);
> > +		fprintf(stderr, Name ": imsm: failed container membership
> check\n");
> >  	return 0;
> >  }
> >
> > diff --git a/util.c b/util.c
> > index 87c23dc..6aeb789 100644
> > --- a/util.c
> > +++ b/util.c
> > @@ -1976,3 +1976,82 @@ struct mdinfo *container_choose_spares(struct
> supertype *st,
> >  	}
> >  	return disks;
> >  }
> > +
> > +/* Returns
> > + *  1: if devname is a member of container with metadata type
> matching stp
> > + * -1: if device not suitable for creating array
> > + *  0: if not in container but device may be suitable for native
> array
> > + */
> > +int check_container(char *devname, struct supertype **stp, int
> verbose)
> > +{
> > +	int fd, cfd, is_member = 0;
> > +	struct mdinfo *sra;
> > +	struct supertype *st = NULL;
> > +	int container_expected = (*stp && (*stp)->ss->external);
> > +
> > +	fd = open(devname, O_RDONLY|O_EXCL, 0);
> > +	if (fd >= 0) {
> > +		/* not in container but don't stop create
> > +		 * when creating native array */
> > +		close(fd);
> > +		if (container_expected) {
> > +			fprintf(stderr, Name
> > +				": Cannot create this array on device %s "
> > +				"- a container is required.\n",
> > +				devname);
> > +			return -1;
> > +		}
> > +		return 0;
> > +	}
> > +	if (errno != EBUSY || (fd = open(devname, O_RDONLY, 0)) < 0) {
> > +		if (verbose)
> > +			fprintf(stderr, Name ": Cannot open %s: %s\n",
> > +				devname, strerror(errno));
> > +		/* we can't create anything on this disk */
> > +		return -1;
> > +	}
> > +	/* Well, it is in use by someone, maybe a container. */
> > +	cfd = open_container(fd);
> > +	close(fd);
> > +	if (cfd < 0) {
> > +		if (container_expected) {
> > +			fprintf(stderr, Name ": Cannot use %s: It is busy\n",
> > +				devname);
> > +			return -1;
> > +		}
> > +		return 0;
> > +	}
> > +	sra = sysfs_read(cfd, 0, GET_VERSION);
> > +	if (sra && sra->array.major_version == -1) {
> > +		int i;
> > +		for (i = 0; st == NULL && superlist[i] ; i++)
> > +			st = superlist[i]->match_metadata_desc(sra-
> >text_version);
> > +		if (st)
> > +			is_member = 1;
> > +	}
> > +	sysfs_free(sra);
> > +	if (is_member) {
> > +		/* This is a member of a container.
> > +		 * if *stp we expect some type of metadata
> > +		 * check if it matches with what we have found
> > +		 * then load the container */
> > +		if (*stp && st->ss != (*stp)->ss) {
> > +			fprintf(stderr, Name ": Cannot use %s: "
> > +				"member of %s container\n",
> > +				devname, st->ss->name);
> > +			close(cfd);
> > +			free(st);
> > +			return -1;
> > +		}
> > +		if (st->ss->load_container(st, cfd, NULL) == 0) {
> > +			free(*stp);
> > +			*stp = st;
> > +		} else /* still return ok status
> > +			* validate_geometry will fail anyway because !st->sb
> */
> > +			if (verbose)
> > +				fprintf(stderr, Name ": Failed to load
> container"
> > +					"information for %s\n", devname);
> > +	}
> > +	close(cfd);
> > +	return is_member;
> > +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
