From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 5/6] Remove code for non re-striping operations.
Date: Thu, 20 Jan 2011 10:59:04 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066F49A61@irsmsx503.ger.corp.intel.com>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160132.18013.92612.stgit@gklab-128-111.igk.intel.com>
	<20110113135134.584c1264@notabene.brown>
	<BE2BFE91933D1B4089447C644860408066EF065D@irsmsx503.ger.corp.intel.com>
 <20110120075244.0ef3352a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120075244.0ef3352a@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, January 19, 2011 9:53 PM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam
> Subject: Re: [PATCH 5/6] Remove code for non re-striping operations.
> 
> On Mon, 17 Jan 2011 15:49:25 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
> 
> > Hi Neil,
> >
> > So maybe it will be good to limit this part of code execution only
> for raid5?
> > (reshape.backup_blocks == 0) {
> > 	If (info->array.level != 5)
> > 		return rv;
> > ...
> >
> > Do you agree?
> 
> No.  Why would you want do to that?
> 
> The code is relevant in other cases too (I hadn't thought it through
> last
> time I commented).  There are other cases where re-striping isn't
> needed such
> as when adding an extra device to a RAID1.
> 
> Why do you think this code needs any change at all??  Is it causing you
> some
> sort of problem?

Yes. Problem is when I execute raid10<->raid0 takeover operation, I have delta_disks set to -2 so condition in this code (delta_disks != UnSet) is true and ioctl is executed. It is not succeeded,  Mdadm returns error:
Mdadm: failed to set disks
I don't know why ioctl returns error. Maybe because more than one parameters is changed (raid_disks and level) or it cannot overwrite raid_disks and level previously set to proper state.

I propose solutions:
1. Set delta_disks to UnSet for raid10->raid0 takeover or
2. Add new flag to reshape structure to indicate to skip raid_disk, chunksize, layout changes


> 
> NeilBrown
> 
> 
> >
> > Regards- Krzysztof
> >
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Thursday, January 13, 2011 3:52 AM
> > > To: Wojcik, Krzysztof
> > > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> > > Williams, Dan J; Ciechanowski, Ed
> > > Subject: Re: [PATCH 5/6] Remove code for non re-striping
> operations.
> > >
> > > On Wed, 12 Jan 2011 17:01:32 +0100 Krzysztof Wojcik
> > > <krzysztof.wojcik@intel.com> wrote:
> > >
> > > > Neil,
> > > > How was your intention when you add this part of code?
> > > > I can't find the case when it will be necessary.
> > > > Moreover it breaks flow for takeover operations because
> > > > ioctl not succeeded when more than one parameter is changed.
> > > > I've remove this code temporally to be able test takeover
> > > > operations.
> > > > We can restore this code after we decide what it should do.
> > >
> > > Asking what the purpose of some code is is perfectly OK.  Asking by
> > > sending a
> > > patch which removes the code seems ... odd.
> > >
> > > If the number of data devices is 1, then a RAID5 can have
> > > layout/chunksize
> > > changed without any restriping.
> > > This code handles that case.
> > >
> > > NeilBrown
> > >
> > >
> > > >
> > > > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > > > ---
> > > >  Grow.c |   43 +++++--------------------------------------
> > > >  1 files changed, 5 insertions(+), 38 deletions(-)
> > > >
> > > > diff --git a/Grow.c b/Grow.c
> > > > index 253f289..6835f34 100644
> > > > --- a/Grow.c
> > > > +++ b/Grow.c
> > > > @@ -1666,6 +1666,11 @@ static int reshape_array(char *container,
> int
> > > fd, char *devname,
> > > >  		ping_monitor(container);
> > > >  	}
> > > >
> > > > +	if (reshape.backup_blocks == 0) {
> > > > +		/* If operation not not reuire re-striping we can
> finish */
> > > > +		return rv;
> > > > +	}
> > > > +
> > > >  	/* ->reshape_super might have chosen some spares from the
> > > >  	 * container that it wants to be part of the new array.
> > > >  	 * We can collect them with ->container_content and give
> > > > @@ -1692,44 +1697,6 @@ static int reshape_array(char *container,
> int
> > > fd, char *devname,
> > > >  		}
> > > >  	}
> > > >
> > > > -	if (reshape.backup_blocks == 0) {
> > > > -		/* No restriping needed, but we might need to impose
> > > > -		 * some more changes: layout, raid_disks, chunk_size
> > > > -		 */
> > > > -		if (info->new_layout != UnSet &&
> > > > -		    info->new_layout != info->array.layout) {
> > > > -			info->array.layout = info->new_layout;
> > > > -			if (ioctl(fd, SET_ARRAY_INFO, &info->array) !=
> 0) {
> > > > -				fprintf(stderr, Name ": failed to set new
> > > layout\n");
> > > > -				rv = 1;
> > > > -			} else if (!quiet)
> > > > -				printf("layout for %s set to %d\n",
> > > > -				       devname, info->array.layout);
> > > > -		}
> > > > -		if (info->delta_disks != UnSet &&
> > > > -		    info->delta_disks != 0) {
> > > > -			info->array.raid_disks += info->delta_disks;
> > > > -			if (ioctl(fd, SET_ARRAY_INFO, &info->array) !=
> 0) {
> > > > -				fprintf(stderr, Name ": failed to set
> raid
> > > disks\n");
> > > > -				rv = 1;
> > > > -			} else if (!quiet)
> > > > -				printf("raid_disks for %s set to %d\n",
> > > > -				       devname, info->array.raid_disks);
> > > > -		}
> > > > -		if (info->new_chunk != 0 &&
> > > > -		    info->new_chunk != info->array.chunk_size) {
> > > > -			if (sysfs_set_num(info, NULL,
> > > > -					  "chunk_size", info->new_chunk) !=
> 0) {
> > > > -				fprintf(stderr, Name ": failed to set
> chunk
> > > size\n");
> > > > -				rv = 1;
> > > > -			} else if (!quiet)
> > > > -				printf("chunk size for %s set to %d\n",
> > > > -				       devname, info->array.chunk_size);
> > > > -		}
> > > > -
> > > > -		return rv;
> > > > -	}
> > > > -
> > > >  	/*
> > > >  	 * There are three possibilities.
> > > >  	 * 1/ The array will shrink.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

