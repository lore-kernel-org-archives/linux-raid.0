From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Do not count as backup devices, spare disks used
 for reshape
Date: Thu, 24 Mar 2011 10:24:23 +1100
Message-ID: <20110324102423.19387efa@notabene.brown>
References: <20110318105511.6462.93752.stgit@gklab-128-013.igk.intel.com>
	<20110320154111.23c9e350@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D191E0B158@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D191E0B158@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 23 Mar 2011 07:49:32 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Sunday, March 20, 2011 5:41 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH] FIX: Do not count as backup devices, spare disks
> > used for reshape
> > 
> > On Fri, 18 Mar 2011 11:55:12 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> > 
> > > Problem:
> > > Reshape is run without specified backup file when all spares are used
> > for expansion.
> > >
> > > When spare disks are used for reshape, they should not be counted as
> > backup devices.
> > > Md still thinks about them as about spares until reshape will not be
> > started.
> > > mdadm should have all it in mind.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >
> > >  Grow.c |    4 +++-
> > >  1 files changed, 3 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index b639585..17c22fc 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1660,6 +1660,7 @@ static int reshape_array(char *container, int
> > fd, char *devname,
> > >  	unsigned long long array_size;
> > >  	int done;
> > >  	struct mdinfo *sra = NULL;
> > > +	int used_spares = 0;
> > >
> > >  	/* when reshaping a RAID0, the component_size might be zero.
> > >  	 * So try to fix that up.
> > > @@ -1793,6 +1794,7 @@ static int reshape_array(char *container, int
> > fd, char *devname,
> > >  					 * be part of the array.
> > >  					 */
> > >  					add_disk(fd, st, info2, d);
> > > +					used_spares++;
> > >  				}
> > >  			}
> > >  			sysfs_free(info2);
> > > @@ -1956,7 +1958,7 @@ started:
> > >  				Name ": %s: Cannot grow - need backup-file\n",
> > >  				devname);
> > >  			goto release;
> > > -		} else if (sra->array.spare_disks == 0) {
> > > +		} else if (sra->array.spare_disks - used_spares == 0) {
> > >  			fprintf(stderr, Name ": %s: Cannot grow - need a spare
> > or "
> > >  				"backup-file to backup critical section\n",
> > >  				devname);
> > 
> > 
> > This change doesn't make sense to me.
> > 
> > The only time when we use a spare device as for storing the backup is
> > (or at
> > least should be) when increasing the number of devices in the array.
> > In that case we only need a backup at the very beginning.
> > So we use the end of a spare for the backup that happens at the every
> > beginning and it all works happily.
> > 
> > Why do you now want to count a spare used for backup as a spare to use
> > for
> > growth?
> > 
> 
> Because difference in user interface in start and restart reshape /IMHO/.
> For reshape start spare disk can be used for grow can be used as backup device also, so backup file doesn't have to be specified.
> For reshape restart spare is used by array already and it is not indicated as spare device, so user have to specified backup file
> (it is also possible that backup file will be not used during reshape restart).

If a spare can be used for backup, it will only be used at the very
beginning, for the first few stripes.  After that it won't be used any more.
So when restarting a reshape that used a spare device for the backup, the
backup is only of interest if we crashed during those first few stripes, and
mdadm will simply read the backup, write out the stripes, and then continue
with no further need for a backup.


> 
> The different behavior /requirement for backup-file command line parameter/ for reshape start and restart can be not obvious for user.

I agree that the situation might be confusing - but I don't think your change
would help.

> Possible we should not require backup file after critical section for OLCE.
> 

IMSM OLCE is a bit awkward.  As there might be multiple arrays in the
container, you need a backup file for the start of each array.
So when restarting the reshape of the first array in the container you don't
need a backup file for that array, but you will for the next array (if there
is one).


> If you think this is not a problem /or it is not important improvement only/ we can forget about this patch

There may be issue here that need to be addressed, but I don't think this
patch addresses them, so I will drop it.

Thanks,
NeilBrown

