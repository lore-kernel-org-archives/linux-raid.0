From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 1/6] Limit no-restriping operations only for raid5
Date: Wed, 26 Jan 2011 11:56:35 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066FF05B6@irsmsx503.ger.corp.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
	<20110119162308.8738.44079.stgit@gklab-128-111.igk.intel.com>
 <20110126110132.1ef42d13@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126110132.1ef42d13@nbeee.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, January 26, 2011 2:02 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 1/6] Limit no-restriping operations only for raid5
> 
> On Wed, 19 Jan 2011 17:23:08 +0100
> Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:
> 
> > If no-restriping needed, we might need to impose some more
> > changes: layout, raid_disks, chunk_size but only for raid5 arrays.
> > Move this part of code before operations connected with restriping.
> 
> I haven't applied this.
> It is not clear to me that the code is in the wrong place.
> Maybe you introduced some code before this that should have gone after?
> or something....
> 
> Don't know ...  maybe if you try again it will make more sense next
> time.
> 
> NeilBrown

Hi,

This patch is just cleanup- code connected with non-restriping operations has been moved just after level change and monitor running, before the code used by restriping operations.
The patch is not necessary.

Krzysztof Wojcik

> 
> 
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> >  Grow.c |   81
> > ++++++++++++++++++++++++++++++++++------------------------------ 1
> > files changed, 43 insertions(+), 38 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index e1ec01c..0ce7c17 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -1656,6 +1656,49 @@ static int reshape_array(char *container, int
> > cfd, int fd, char *devname, }
> >  	ping_monitor(container);
> >
> > +	if (reshape.backup_blocks == 0) {
> > +		/* No restriping needed, but we might need to impose
> > +		 * some more changes: layout, raid_disks, chunk_size
> > +		 */
> > +		/* Changes possible only for raid5 arrays */
> > +		if (info->array.level != 5) {
> > +			unfreeze(st);
> > +			return rv;
> > +		}
> > +		if (info->new_layout != UnSet &&
> > +		    info->new_layout != info->array.layout) {
> > +			info->array.layout = info->new_layout;
> > +			if (ioctl(fd, SET_ARRAY_INFO,
> > &info->array) != 0) {
> > +				fprintf(stderr, Name ": failed to
> > set new layout\n");
> > +				rv = 1;
> > +			} else if (!quiet)
> > +				printf("layout for %s set to %d\n",
> > +				       devname, info->array.layout);
> > +		}
> > +		if (info->delta_disks != UnSet &&
> > +		    info->delta_disks != 0) {
> > +			info->array.raid_disks += info->delta_disks;
> > +			if (ioctl(fd, SET_ARRAY_INFO,
> > &info->array) != 0) {
> > +				fprintf(stderr, Name ": failed to
> > set raid disks\n");
> > +				rv = 1;
> > +			} else if (!quiet)
> > +				printf("raid_disks for %s set to
> > %d\n",
> > +				       devname,
> > info->array.raid_disks);
> > +		}
> > +		if (info->new_chunk != 0 &&
> > +		    info->new_chunk != info->array.chunk_size) {
> > +			if (sysfs_set_num(info, NULL,
> > +					  "chunk_size",
> > info->new_chunk) != 0) {
> > +				fprintf(stderr, Name ": failed to
> > set chunk size\n");
> > +				rv = 1;
> > +			} else if (!quiet)
> > +				printf("chunk size for %s set to
> > %d\n",
> > +				       devname,
> > info->array.chunk_size);
> > +		}
> > +		unfreeze(st);
> > +		return rv;
> > +	}
> > +
> >  	/* reload metadat as it is possible to change made by monitor
> >  	 */
> >  	if ((cfd >= 0) &&
> > @@ -1718,44 +1761,6 @@ static int reshape_array(char *container, int
> > cfd, int fd, char *devname, }
> >  	}
> >
> > -	if (reshape.backup_blocks == 0) {
> > -		/* No restriping needed, but we might need to impose
> > -		 * some more changes: layout, raid_disks, chunk_size
> > -		 */
> > -		if (info->new_layout != UnSet &&
> > -		    info->new_layout != info->array.layout) {
> > -			info->array.layout = info->new_layout;
> > -			if (ioctl(fd, SET_ARRAY_INFO,
> > &info->array) != 0) {
> > -				fprintf(stderr, Name ": failed to
> > set new layout\n");
> > -				rv = 1;
> > -			} else if (!quiet)
> > -				printf("layout for %s set to %d\n",
> > -				       devname, info->array.layout);
> > -		}
> > -		if (info->delta_disks != UnSet &&
> > -		    info->delta_disks != 0) {
> > -			info->array.raid_disks += info->delta_disks;
> > -			if (ioctl(fd, SET_ARRAY_INFO,
> > &info->array) != 0) {
> > -				fprintf(stderr, Name ": failed to
> > set raid disks\n");
> > -				rv = 1;
> > -			} else if (!quiet)
> > -				printf("raid_disks for %s set to
> > %d\n",
> > -				       devname,
> > info->array.raid_disks);
> > -		}
> > -		if (info->new_chunk != 0 &&
> > -		    info->new_chunk != info->array.chunk_size) {
> > -			if (sysfs_set_num(info, NULL,
> > -					  "chunk_size",
> > info->new_chunk) != 0) {
> > -				fprintf(stderr, Name ": failed to
> > set chunk size\n");
> > -				rv = 1;
> > -			} else if (!quiet)
> > -				printf("chunk size for %s set to
> > %d\n",
> > -				       devname,
> > info->array.chunk_size);
> > -		}
> > -		unfreeze(st);
> > -		return rv;
> > -	}
> > -
> >  	/*
> >  	 * There are three possibilities.
> >  	 * 1/ The array will shrink.

