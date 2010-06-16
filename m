From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 01/23] Add Online Capacity Expansion to mdadm for
 external metadata
Date: Wed, 16 Jun 2010 08:47:28 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F295BC5@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11EECE8B3@irsmsx503.ger.corp.intel.com>
 <20100616160424.3c40f877@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100616160424.3c40f877@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Neil,

Some of those loops has been introduced in slightly different design, so there was more justification for them.
During implementation due to other bugs (that are fixed now), I've found that md can be not ready for receive new raid_disks or report expected values when I've expected them.
Those loops can look a little strange but I've decided to leave them to make code more bug-proof. It can happen that someone will implement features for other metadata and those loops will work for him. As I've wrote those code not for IMSM only, but I'm understanding that this code is common for all external metadatas.
Of course for current implementation purposes, those loops are not necessary and they can be removed. I'll do this.

Regarding sleep2(), regular sleep() block process during waiting. My sleep2() bases on select() function, so single thread is in wait state only. This the way I want to wait, not everywhere (whole process), but in this very place/thread only. As I've used sleep2() in mdmon where threads are important, I've see no reason not to use it in mdadm also.

Goto usage is mainly to avoid many if/else and hard to read code due to many indents.
If you count those gotos, you'll see how big indent is required ;). It also looks better while checking code with check patch script (md/mdadm coding standard).

Thank you for your comments.

BR
Adam


> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, June 16, 2010 8:04 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 01/23] Add Online Capacity Expansion to mdadm for
> external metadata
> 
> 
> Hi Adam,
>  thanks for these patches.
> 
>  Much of this one makes sense:  adding a "struct supertype" to the
> *_grow
>  functions so that flush_metadata_updates can be called at the right
> time
>  looks right, as do the related ->load_super, ->update_super calls.
> 
>  However I don't understand why you need to two loops that repeatedly
> try
>  something, or what you need to introduce "sleep2".
> 
>  Also you have introduced some gotos and labels where a simple if/else
>  structure would reflect the need a lot better.
> 
>  Can you explain the loops please?
> 
> NeilBrown
> 
> 
> On Wed, 9 Jun 2010 15:25:15 +0100
> "Kwolek, Adam" <adam.kwolek@intel.com> wrote:
> 
> > (Online Capacity Expansion for IMSM)
> > So far there was no possibility to extend number of disks in array
> that uses external metadata.
> > To do this new disks number has to be set in raid_disks sysfs entry
> to configure md. New disks has to be added to md configuration, and
> reshape has to be run. To be in line with md configuration and reshape
> results, external metadata has to be updated by mdadm via mdmon.
> >
> > This patch introduces main part of Online Capacity Expansion to mdadm
> without:
> > - takeover usage
> > - size management
> > - metadata specific operations and md configuration
> >
> > For algorithm details look patch 00/23
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c  |  129
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  mdadm.h |    1
> >  util.c  |   11 +++++
> >  3 files changed, 128 insertions(+), 13 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 284d31d..29a6394 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -413,7 +413,8 @@ int bsb_csum(char *buf, int len)
> >  	return __cpu_to_le32(csum);
> >  }
> >
> > -static int child_grow(int afd, struct mdinfo *sra, unsigned long
> blocks,
> > +static int child_grow(struct supertype *st,
> > +		      int afd, struct mdinfo *sra, unsigned long blocks,
> >  		      int *fds, unsigned long long *offsets,
> >  		      int disks, int chunk, int level, int layout, int
> data,
> >  		      int dests, int *destfd, unsigned long long
> *destoffsets); @@ -471,6 +472,8 @@ void wait_reshape(struct mdinfo
> *sra)  }
> >
> >
> > +#define	EXTERNAL_META_STATUS_OK		1
> > +#define	EXTERNAL_META_STATUS_ERROR	2
> >  int Grow_reshape(char *devname, int fd, int quiet, char
> *backup_file,
> >  		 long long size,
> >  		 int level, char *layout_str, int chunksize, int
> raid_disks) @@ -1073,7 +1076,7 @@ int Grow_reshape(char *devname, int
> fd, int quiet, char *backup_file,
> >  		sysfs_free(sra);
> >  		sra = sysfs_read(fd, 0,
> >  				 GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|
> > -				 GET_CACHE);
> > +				 GET_CACHE|GET_VERSION);
> >
> >  		if (ndata == odata) {
> >  			/* Make 'blocks' bigger for better throughput, but @@
> -1209,7 +1212,92 @@ int Grow_reshape(char *devname, int fd, int quiet,
> char *backup_file,
> >  		 * sysfs.
> >  		 */
> >  		if (ochunk == nchunk && olayout == nlayout) {
> > +			int external_meta_status =
> EXTERNAL_META_STATUS_ERROR;
> > +			int prev_disks = array.raid_disks;
> > +			struct mdinfo info;
> > +			int delta_disks = 0;
> > +			int container_fd = -1;
> > +			int dn;
> > +			int counter = 20;
> > +			int result = -1;
> > +			struct mdu_array_info_s test_array;
> > +
> >  			array.raid_disks = ndisks;
> > +			/* check if we have external or native metadata
> > +			 */
> > +			if ((st == NULL) || (st->ss->external == 0))
> > +				goto native_array_setup;
> > +
> > +			/* update array for external meta via user space
> > +			 */
> > +			dn = devname2devnum(sra->text_version + 1);
> > +			container_fd = open_dev_excl(dn);
> > +			if (container_fd < 0)
> > +				goto ext_array_setup_exit;
> > +			st->ss->load_super(st, container_fd, NULL);
> > +			close(container_fd);
> > +			st->ss->getinfo_super(st, &info);
> > +
> > +			delta_disks = ndisks - prev_disks;
> > +			strcpy(info.sys_name, sra->sys_name);
> > +			/* loop has to be introduced for next volumes reshape
> > +			 * can occures tha array is not ready,
> > +			 * so we have wait a while
> > +			 */
> > +			while ((result != 0) || (counter > 0)) {
> > +				result = sysfs_set_num(&info, NULL,
> "raid_disks",
> > +							ndisks);
> > +				counter--;
> > +				if (result != 0)
> > +					sleep2(1, 0);
> > +			}
> > +			if (result != 0)
> > +				goto ext_array_setup_exit;
> > +
> > +			/* prepare meta update and add devices to mdmon
> > +			 */
> > +			info.delta_disks = delta_disks;
> > +			st->update_tail = &st->updates;
> > +			if (st->ss->update_super(st, &info,
> "update_grow_array",
> > +						 info.name, 0, 0, NULL) > 0)
> > +				goto ext_array_setup_exit;
> > +
> > +			/* look for md changes - md has to expose changes
> > +			 * to let know to mdmon about it
> > +			 * before flushing update
> > +			 */
> > +			counter = 10;
> > +			while (counter) {
> > +				sleep2(1, 0);
> > +				/* if communication error -> try again
> > +				 */
> > +				if (ioctl(fd, GET_ARRAY_INFO, &test_array) < 0)
> > +					counter--;
> > +				else if (test_array.working_disks == ndisks) {
> > +						counter = 0;
> > +						external_meta_status =
> EXTERNAL_META_STATUS_OK;
> > +					} else {
> > +						/* still wait for change
> > +						 */
> > +						counter--;
> > +					}
> > +			}
> > +
> > +			/* metadata update can be flushed after raid_disk
> change
> > +			 * will be visible to user space, so flush update
> after starting reshape
> > +			 */
> > +
> > +ext_array_setup_exit:
> > +			if (external_meta_status ==
> EXTERNAL_META_STATUS_ERROR) {
> > +				fprintf(stderr, Name ": Cannot set device
> shape"
> > +					" for %s: %s (external meta)\n",
> > +					devname, strerror(errno));
> > +				rv = 1;
> > +				goto release;
> > +			}
> > +
> > +			goto ext_array_configured;
> > +native_array_setup:
> >  			if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
> >  				int err = errno;
> >  				rv = 1;
> > @@ -1250,6 +1338,7 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file,
> >  			}
> >  		}
> >
> > +ext_array_configured:
> >  		if (ndisks == 2 && odisks == 2) {
> >  			/* No reshape is needed in this trivial case */
> >  			rv = 0;
> > @@ -1302,7 +1391,7 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file,
> >  			mlockall(MCL_FUTURE);
> >
> >  			if (odata < ndata)
> > -				done = child_grow(fd, sra, stripes,
> > +				done = child_grow(st, fd, sra, stripes,
> >  						  fdlist, offsets,
> >  						  odisks, ochunk, array.level,
> olayout, odata,
> >  						  d - odisks, fdlist+odisks,
> offsets+odisks); @@ -1495,7 +1584,8 @@ int grow_backup(struct mdinfo
> *sra,
> >   * every works.
> >   */
> >  /* FIXME return value is often ignored */ -int wait_backup(struct
> mdinfo *sra,
> > +int wait_backup(struct supertype *st,
> > +		struct mdinfo *sra,
> >  		unsigned long long offset, /* per device */
> >  		unsigned long long blocks, /* per device */
> >  		unsigned long long blocks2, /* per device - hack */ @@ -
> 1513,8 +1603,20 @@ int wait_backup(struct mdinfo *sra,
> >  	if (fd < 0)
> >  		return -1;
> >  	sysfs_set_num(sra, NULL, "sync_max", offset + blocks + blocks2);
> > -	if (offset == 0)
> > -		sysfs_set_str(sra, NULL, "sync_action", "reshape");
> > +	if (offset == 0) {
> > +		if (sysfs_set_str(sra, NULL, "sync_action", "reshape") >=
> 0) {
> > +
> > +			/* metadata update can be flushed after raid_disk
> change
> > +			 * will be visible to user space, so after starting
> reshape flush update
> > +			 */
> > +			if (st && st->ss->external == 1)
> > +				flush_metadata_updates(st);
> > +		} else {
> > +			dprintf("ERROR: Grow.c: cannot start reshape\n");
> > +			return -1;
> > +		}
> > +	}
> > +
> >  	do {
> >  		char action[20];
> >  		fd_set rfds;
> > @@ -1649,7 +1751,8 @@ static void validate(int afd, int bfd, unsigned
> long long offset)
> >  	}
> >  }
> >
> > -static int child_grow(int afd, struct mdinfo *sra, unsigned long
> stripes,
> > +static int child_grow(struct supertype *st,
> > +		      int afd, struct mdinfo *sra, unsigned long stripes,
> >  		      int *fds, unsigned long long *offsets,
> >  		      int disks, int chunk, int level, int layout, int
> data,
> >  		      int dests, int *destfd, unsigned long long
> *destoffsets) @@ -1667,7 +1770,7 @@ static int child_grow(int afd,
> struct mdinfo *sra, unsigned long stripes,
> >  		    dests, destfd, destoffsets,
> >  		    0, &degraded, buf);
> >  	validate(afd, destfd[0], destoffsets[0]);
> > -	wait_backup(sra, 0, stripes * chunk / 512, stripes * chunk / 512,
> > +	wait_backup(st, sra, 0, stripes * chunk / 512, stripes * chunk /
> 512,
> >  		    dests, destfd, destoffsets,
> >  		    0);
> >  	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) *
> data); @@ -1694,7 +1797,7 @@ static int child_shrink(int afd, struct
> mdinfo *sra, unsigned long stripes,
> >  	sysfs_set_str(sra, NULL, "sync_action", "reshape");
> >  	sysfs_set_num(sra, NULL, "suspend_lo", 0);
> >  	sysfs_set_num(sra, NULL, "suspend_hi", 0);
> > -	rv = wait_backup(sra, 0, start - stripes * chunk/512, stripes *
> chunk/512,
> > +	rv = wait_backup(NULL, sra, 0, start - stripes * chunk/512,
> stripes *
> > +chunk/512,
> >  			 dests, destfd, destoffsets, 0);
> >  	if (rv < 0)
> >  		return 0;
> > @@ -1704,7 +1807,7 @@ static int child_shrink(int afd, struct mdinfo
> *sra, unsigned long stripes,
> >  		    dests, destfd, destoffsets,
> >  		    0, &degraded, buf);
> >  	validate(afd, destfd[0], destoffsets[0]);
> > -	wait_backup(sra, start, stripes*chunk/512, 0,
> > +	wait_backup(NULL, sra, start, stripes*chunk/512, 0,
> >  		    dests, destfd, destoffsets, 0);
> >  	sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) *
> data);
> >  	free(buf);
> > @@ -1751,7 +1854,7 @@ static int child_same_size(int afd, struct
> mdinfo *sra, unsigned long stripes,
> >  	start += stripes * 2; /* where to read next */
> >  	size = sra->component_size / (chunk/512);
> >  	while (start < size) {
> > -		if (wait_backup(sra, (start-stripes*2)*chunk/512,
> > +		if (wait_backup(NULL, sra, (start-stripes*2)*chunk/512,
> >  				stripes*chunk/512, 0,
> >  				dests, destfd, destoffsets,
> >  				part) < 0)
> > @@ -1769,12 +1872,12 @@ static int child_same_size(int afd, struct
> mdinfo *sra, unsigned long stripes,
> >  		part = 1 - part;
> >  		validate(afd, destfd[0], destoffsets[0]);
> >  	}
> > -	if (wait_backup(sra, (start-stripes*2) * chunk/512, stripes *
> chunk/512, 0,
> > +	if (wait_backup(NULL, sra, (start-stripes*2) * chunk/512, stripes
> *
> > +chunk/512, 0,
> >  			dests, destfd, destoffsets,
> >  			part) < 0)
> >  		return 0;
> >  	sysfs_set_num(sra, NULL, "suspend_lo", ((start-
> stripes)*chunk/512) * data);
> > -	wait_backup(sra, (start-stripes) * chunk/512, tailstripes *
> chunk/512, 0,
> > +	wait_backup(NULL, sra, (start-stripes) * chunk/512, tailstripes *
> > +chunk/512, 0,
> >  		    dests, destfd, destoffsets,
> >  		    1-part);
> >  	sysfs_set_num(sra, NULL, "suspend_lo", (size*chunk/512) * data);
> diff --git a/mdadm.h b/mdadm.h index 68c15ab..84d5496 100644
> > --- a/mdadm.h
> > +++ b/mdadm.h
> > @@ -857,6 +857,7 @@ extern char *conf_word(FILE *file, int
> allow_key);  extern int conf_name_is_free(char *name);  extern int
> devname_matches(char *name, char *match);  extern struct mddev_ident_s
> *conf_match(struct mdinfo *info, struct supertype *st);
> > +extern void sleep2(unsigned int sec, unsigned int usec);
> >
> >  extern void free_line(char *line);
> >  extern int match_oneof(char *devices, char *devname); diff --git
> a/util.c b/util.c index d292a66..5779d52 100644
> > --- a/util.c
> > +++ b/util.c
> > @@ -1645,3 +1645,14 @@ void append_metadata_update(struct supertype
> *st, void *buf, int len)  unsigned int __invalid_size_argument_for_IOC
> = 0;  #endif
> >
> > +void sleep2(unsigned int sec, unsigned int usec) {
> > +	struct timeval tv;
> > +
> > +	if ((sec == 0) && (usec == 0))
> > +		return;
> > +
> > +	tv.tv_sec = sec;
> > +	tv.tv_usec = usec;
> > +	select(0, NULL, NULL, NULL, &tv);
> > +}
> >

