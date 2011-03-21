From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH] RAID-6 check standalone
Date: Mon, 21 Mar 2011 11:40:07 +0100
Message-ID: <20110321104007.GA15379@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110321140244.2314b4b4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Mon, Mar 21, 2011 at 02:02:44PM +1100, NeilBrown wrote:
> On Mon, 21 Feb 2011 21:45:51 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi Neil,
> > 
> > please find attached a patch, to mdadm-3.2 base, including
> > a standalone versione of the raid-6 check.
> > 
> > This is basically a re-working (and hopefully improvement)
> > of the already implemented check in "restripe.c".
> > 
> > I splitted the check function into "collect" and "stats",
> > so that the second one could be easily replaced.
> > The API is also simplified.
> > 
> > The command line option are reduced, since we only level
> > is raid-6, but the ":offset" option is included.
> > 
> > The output reports the block/stripe rotation, P/Q errors
> > and the possible HDD (or unknown).
> > 
> > BTW, the patch applies also to the already patched "restripe.c",
> > including the last ":offset" patch (which is not yet in git).
> > 
> 
> Sorry for not replying for a month!!  I manage to lose track of this then
> couldn't find it when I went looking, then got distracted, then....

don't worry, I know how easy is to loose track of
such items. That's why I kept (slowly) insisting.

> Thanks for your patience and persistence.
> 
> I have applied this patch to me git now - with some minor changes.

Thanks.

One question, I did not find the previous patch to "restripe.c",
which was adding the ":offset" capability. This was in order to
be able to cope with metadata 1.1 or 1.2 (offset to be determined).

> > Other item is that due to "sysfs.c" linking (see below) the
> > "Makefile" needed some changes, I hope this is not a problem.
> 
> I have reverted most of these changes and the linking with sysfs.c isn't
> needed yet.  When it is we can sort out how best to achieve it.
> 
> > 
> > Next steps (TODO list you like) would be:
> > 
> > 1) Add the "sysfs.c" code in order to retrieve the HDDs info
> > from the MD device. It is already linked, together with the
> > whole (mdadm) universe, since it seems it cannot leave alone.
> > I'll need some advice or hint on how to do use it. I checked
> > "sysfs.c", but before I dig deep into it maybe better to
> > have some advice (maybe just one function call will do it).
> 
> What exactly do you want to achieve?
> 
> I suspect you want to a open the md device, then
> 
>   info = sysfs_read(fd, -1,
>   GET_LEVEL|GET_LAYOUT_GET_DISKS|GET_CHUNK|GET_DEVS|GET_OFFSET);
> 
> (possibly with other flags) and then extract the info you want from the data
> structure returned - but I'm only guessing at what you might want.

I think this more or less correct.

I would like to pass, to "raid6check", the md device as only
parameter, maybe with some start/stop position, and derive all
the needed information from that.

That is, it should be: raid6check /dev/mdX start stop
Or, possibly: raid6check /dev/mdX start length
Or just: raid6check /dev/mdX

This means, the information that should be derived is:

1) level, in order to confirm it is 6
2) layout
3) disk components
4) offset for each component
5) chunk size

That should be all, I guess.

Your "sysfs_read" seems to do exactly this, please confirm.

> > 
> > 2) Add the suspend lo/hi control. Fellow John Robinson was
> > suggesting to look into "Grow.c", which I did, but I guess
> > the same story as 1) is valid: better to have some hint on
> > where to look before wasting time.
> 
> This would be:
> 
>   sysfs_set_num(info, NULL, "suspend_lo", offset*data_disks);
>   sysfs_set_num(info, NULL, "suspend_hi", (offset+chunksize)*data_disks);
> 
> to freeze one stripe.  Then work in there.
> The addresses are addresses in the array, hence the multiplication
> by data_disks (which is raid_disks - 2 for RAID6).
> 
> Don't hold the array suspended for too long or something might get
> upset.  And allocate any memory you need first, and call
>     	mlockall(MCL_CURRENT | MCL_FUTURE);
> 
> first to be even more safe.

Thanks for the explanation. How is, then, the "unfreeze"?
Just writing (0) to both hi and lo?

> > 
> > 3) Add a repair option (future). This should have different
> > levels, like "all", "disk", "stripe". That is, fix everything
> > (more or less like "repair"), fix only if a disk is clearly
> > having problems, fix each stripe which has clearly a problem
> > (but maybe different stripes may belong to different HDDs).
> > 
> > So, for the point 1) and 2) would be nice to have some more
> > detail on where to look what. Point 3) we will discuss later.
> 
> Agreed.
> Hopefully the info I have provided is sufficient to help you progress.

I'll ask, if I need more information.

> Thanks,
> NeilBrown

Thank you,

bye,

pg

> 
> > 
> > Thanks, please consider for inclusion,
> > 
> > bye,
> > 
> > pg
> 
> > 
> > 
> > diff -urN a/Makefile b/Makefile
> > --- a/Makefile	2011-02-01 05:31:07.000000000 +0100
> > +++ b/Makefile	2011-02-20 00:03:44.929998038 +0100
> > @@ -98,7 +98,7 @@
> >  MAN5DIR = $(MANDIR)/man5
> >  MAN8DIR = $(MANDIR)/man8
> >  
> > -OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
> > +OBJSX = config.o policy.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
> >  	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
> >  	Incremental.o \
> >  	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
> > @@ -106,6 +106,8 @@
> >  	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
> >  	platform-intel.o probe_roms.o
> >  
> > +OBJS = mdadm.o $(OBJSX)
> > +
> >  SRCS =  mdadm.c config.c policy.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
> >  	Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c Kill.c Query.c \
> >  	Incremental.c \
> > @@ -182,6 +184,9 @@
> >  test_stripe : restripe.c mdadm.h
> >  	$(CC) $(CXFLAGS) $(LDFLAGS) -o test_stripe -DMAIN restripe.c
> >  
> > +raid6check : raid6check.o mdadm.h $(OBJSX)
> > +	$(CC) $(CXFLAGS) $(LDFLAGS) -o raid6check raid6check.o $(OBJSX)
> > +
> >  mdassemble : $(ASSEMBLE_SRCS) $(INCL)
> >  	rm -f $(OBJS)
> >  	$(DIET_GCC) $(ASSEMBLE_FLAGS) -o mdassemble $(ASSEMBLE_SRCS)  $(STATICSRC)
> > @@ -265,7 +270,7 @@
> >  	mdadm.Os mdadm.O2 mdmon.O2 \
> >  	mdassemble mdassemble.static mdassemble.auto mdassemble.uclibc \
> >  	mdassemble.klibc swap_super \
> > -	init.cpio.gz mdadm.uclibc.static test_stripe mdmon \
> > +	init.cpio.gz mdadm.uclibc.static test_stripe raid6check raid6check.o mdmon \
> >  	mdadm.8
> >  
> >  dist : clean
> > diff -urN a/raid6check.c b/raid6check.c
> > --- a/raid6check.c	1970-01-01 01:00:00.000000000 +0100
> > +++ b/raid6check.c	2011-02-21 21:40:27.813656214 +0100
> > @@ -0,0 +1,263 @@
> > +/*
> > + * raid6check - extended consistency check for RAID-6
> > + *
> > + * Copyright (C) 2011 Piergiorgio Sartor
> > + *
> > + *
> > + *    This program is free software; you can redistribute it and/or modify
> > + *    it under the terms of the GNU General Public License as published by
> > + *    the Free Software Foundation; either version 2 of the License, or
> > + *    (at your option) any later version.
> > + *
> > + *    This program is distributed in the hope that it will be useful,
> > + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *    GNU General Public License for more details.
> > + *
> > + *    You should have received a copy of the GNU General Public License
> > + *    along with this program; if not, write to the Free Software
> > + *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> > + *
> > + *    Author: Piergiorgio Sartor
> > + *    Based on "restripe.c" from "mdadm" codebase
> > + */
> > +
> > +#include "mdadm.h"
> > +#include <stdint.h>
> > +
> > +int geo_map(int block, unsigned long long stripe, int raid_disks,
> > +	    int level, int layout);
> > +void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size);
> > +void make_tables(void);
> > +
> > +/* Collect per stripe consistency information */
> > +void raid6_collect(int chunk_size, uint8_t *p, uint8_t *q,
> > +		   char *chunkP, char *chunkQ, int *results)
> > +{
> > +	int i;
> > +	int data_id;
> > +	uint8_t Px, Qx;
> > +	extern uint8_t raid6_gflog[];
> > +
> > +	for(i = 0; i < chunk_size; i++) {
> > +		Px = (uint8_t)chunkP[i] ^ (uint8_t)p[i];
> > +		Qx = (uint8_t)chunkQ[i] ^ (uint8_t)q[i];
> > +
> > +		if((Px != 0) && (Qx == 0))
> > +			results[i] = -1;
> > +
> > +		if((Px == 0) && (Qx != 0))
> > +			results[i] = -2;
> > +
> > +		if((Px != 0) && (Qx != 0)) {
> > +			data_id = (raid6_gflog[Qx] - raid6_gflog[Px]);
> > +			if(data_id < 0) data_id += 255;
> > +			results[i] = data_id;
> > +		}
> > +
> > +		if((Px == 0) && (Qx == 0))
> > +			results[i] = -255;
> > +	}
> > +}
> > +
> > +/* Try to find out if a specific disk has problems */
> > +int raid6_stats(int *results, int raid_disks, int chunk_size)
> > +{
> > +	int i;
> > +	int curr_broken_disk = -255;
> > +	int prev_broken_disk = -255;
> > +	int broken_status = 0;
> > +	
> > +	for(i = 0; i < chunk_size; i++) {
> > +
> > +		if(results[i] != -255)
> > +			curr_broken_disk = results[i];
> > +
> > +		if(curr_broken_disk >= raid_disks)
> > +			broken_status = 2;
> > +
> > +		switch(broken_status) {
> > +		case 0:
> > +			if(curr_broken_disk != -255) {
> > +				prev_broken_disk = curr_broken_disk;
> > +				broken_status = 1;
> > +			}
> > +			break;
> > +
> > +		case 1:
> > +			if(curr_broken_disk != prev_broken_disk)
> > +				broken_status = 2;
> > +			break;
> > +
> > +		case 2:
> > +		default:
> > +			curr_broken_disk = prev_broken_disk = -65535;
> > +			break;
> > +		}
> > +	}
> > +
> > +	return curr_broken_disk;
> > +}
> > +
> > +int check_stripes(int *source, unsigned long long *offsets,
> > +		  int raid_disks, int chunk_size, int level, int layout,
> > +		  unsigned long long start, unsigned long long length, char *name[])
> > +{
> > +	/* read the data and p and q blocks, and check we got them right */
> > +	char *stripe_buf = malloc(raid_disks * chunk_size);
> > +	char **stripes = malloc(raid_disks * sizeof(char*));
> > +	char **blocks = malloc(raid_disks * sizeof(char*));
> > +	uint8_t *p = malloc(chunk_size);
> > +	uint8_t *q = malloc(chunk_size);
> > +	int *results = malloc(chunk_size * sizeof(int));
> > +
> > +	int i;
> > +	int diskP, diskQ;
> > +	int data_disks = raid_disks - 2;
> > +
> > +	extern int tables_ready;
> > +
> > +	if (!tables_ready)
> > +		make_tables();
> > +
> > +	for ( i = 0 ; i < raid_disks ; i++)
> > +		stripes[i] = stripe_buf + i * chunk_size;
> > +
> > +	while (length > 0) {
> > +		int disk;
> > +
> > +		for (i = 0 ; i < raid_disks ; i++) {
> > +			lseek64(source[i], offsets[i]+start, 0);
> > +			read(source[i], stripes[i], chunk_size);
> > +		}
> > +		for (i = 0 ; i < data_disks ; i++) {
> > +			int disk = geo_map(i, start/chunk_size, raid_disks,
> > +					   level, layout);
> > +			blocks[i] = stripes[disk];
> > +			printf("%d->%d\n", i, disk);
> > +		}
> > +
> > +		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
> > +		diskP = geo_map(-1, start/chunk_size, raid_disks,
> > +				level, layout);
> > +		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
> > +			printf("P(%d) wrong at %llu\n", diskP,
> > +			       start / chunk_size);
> > +		}
> > +		diskQ = geo_map(-2, start/chunk_size, raid_disks,
> > +				level, layout);
> > +		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
> > +			printf("Q(%d) wrong at %llu\n", diskQ,
> > +			       start / chunk_size);
> > +		}
> > +		raid6_collect(chunk_size, p, q,
> > +			      stripes[diskP], stripes[diskQ], results);
> > +		disk = raid6_stats(results, raid_disks, chunk_size);
> > +
> > +		if(disk >= -2) {
> > +			disk = geo_map(disk, start/chunk_size, raid_disks,
> > +				       level, layout);
> > +		}
> > +		if(disk >= 0) {
> > +			printf("Possible failed disk: %d --> %s\n", disk, name[disk]);
> > +		}
> > +		if(disk == -65535) {
> > +			printf("Failure detected, but disk unknown\n");
> > +		}
> > +
> > +		length -= chunk_size;
> > +		start += chunk_size;
> > +	}
> > +
> > +	free(stripe_buf);
> > +	free(stripes);
> > +	free(blocks);
> > +	free(p);
> > +	free(q);
> > +	free(results);
> > +
> > +	return 0;
> > +}
> > +
> > +unsigned long long getnum(char *str, char **err)
> > +{
> > +	char *e;
> > +	unsigned long long rv = strtoull(str, &e, 10);
> > +	if (e==str || *e) {
> > +		*err = str;
> > +		return 0;
> > +	}
> > +	return rv;
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	/* raid_disks chunk_size layout start length devices...
> > +	 */
> > +	int *fds;
> > +	char *buf;
> > +	unsigned long long *offsets;
> > +	int raid_disks, chunk_size, layout;
> > +	int level = 6;
> > +	unsigned long long start, length;
> > +	int i;
> > +
> > +	char *err = NULL;
> > +	if (argc < 8) {
> > +		fprintf(stderr, "Usage: raid6check raid_disks"
> > +			" chunk_size layout start length devices...\n");
> > +		exit(1);
> > +	}
> > +
> > +	raid_disks = getnum(argv[1], &err);
> > +	chunk_size = getnum(argv[2], &err);
> > +	layout = getnum(argv[3], &err);
> > +	start = getnum(argv[4], &err);
> > +	length = getnum(argv[5], &err);
> > +	if (err) {
> > +		fprintf(stderr, "test_stripe: Bad number: %s\n", err);
> > +		exit(2);
> > +	}
> > +	if (argc != raid_disks + 6) {
> > +		fprintf(stderr, "test_stripe: wrong number of devices: want %d found %d\n",
> > +			raid_disks, argc-6);
> > +		exit(2);
> > +	}
> > +	fds = malloc(raid_disks * sizeof(*fds));
> > +	offsets = malloc(raid_disks * sizeof(*offsets));
> > +	memset(offsets, 0, raid_disks * sizeof(*offsets));
> > +
> > +	for (i=0; i<raid_disks; i++) {
> > +		char *p;
> > +		p = strchr(argv[6+i], ':');
> > +
> > +		if(p != NULL) {
> > +			*p++ = '\0';
> > +			offsets[i] = atoll(p) * 512;
> > +		}
> > +		fds[i] = open(argv[6+i], O_RDWR);
> > +		if (fds[i] < 0) {
> > +			perror(argv[6+i]);
> > +			fprintf(stderr,"test_stripe: cannot open %s.\n", argv[6+i]);
> > +			exit(3);
> > +		}
> > +	}
> > +
> > +	buf = malloc(raid_disks * chunk_size);
> > +
> > +	int rv = check_stripes(fds, offsets,
> > +			       raid_disks, chunk_size, level, layout,
> > +			       start, length, &argv[6]);
> > +	if (rv != 0) {
> > +		fprintf(stderr,
> > +			"test_stripe: test_stripes returned %d\n", rv);
> > +		exit(1);
> > +	}
> > +
> > +	free(fds);
> > +	free(offsets);
> > +	free(buf);
> > +
> > +	exit(0);
> > +}
> > +
> > diff -urN a/restripe.c b/restripe.c
> > --- a/restripe.c	2011-02-19 22:36:29.707651642 +0100
> > +++ b/restripe.c	2011-02-19 18:13:14.468626986 +0100
> > @@ -33,7 +33,7 @@
> >   *
> >   */
> >  
> > -static int geo_map(int block, unsigned long long stripe, int raid_disks,
> > +int geo_map(int block, unsigned long long stripe, int raid_disks,
> >  		   int level, int layout)
> >  {
> >  	/* On the given stripe, find which disk in the array will have
> > @@ -223,7 +223,7 @@
> >  	}
> >  }
> >  
> > -static void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size)
> > +void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size)
> >  {
> >  	int d, z;
> >  	uint8_t wq0, wp0, wd0, w10, w20;
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
