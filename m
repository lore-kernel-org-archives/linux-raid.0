From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 6/9] imsm: FIX: container content gathering is not
 needed for size set
Date: Wed, 12 Jan 2011 15:30:50 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1AD80@irsmsx503.ger.corp.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140435.13862.5816.stgit@gklab-128-013.igk.intel.com>
 <20110112165239.720cb9e4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112165239.720cb9e4@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, January 12, 2011 6:53 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 6/9] imsm: FIX: container content gathering is not
> needed for size set
> 
> On Tue, 11 Jan 2011 15:04:35 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Size information is loaded already and there is no need to load it
> again,
> > when metadata is not reloaded.
> 
> Why do you say that?  It seems wrong.
> 
> When growing an array, the size will not change until the reshape
> completes.
> When it does complete, it will be mdmon which updates the metadata and
> records in it the desired size of the array.
> 
> The only way mdadm can find this number out is by loading the metadata.
> 
> Where am I wrong?
> 
> NeilBrown

Size is set in metadata, before reshape start in reshape_super() and remains unchanged during whole reshape.
After reshape this value doesn't change in metadata also.
It is possible that this behavior is imsm specific, and for general case reload is required as you describes.

BR
Adam



> 
> 
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Grow.c |   58 +++++++++++++++++++++++++-----------------------------
> ----
> >  1 files changed, 25 insertions(+), 33 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 2ca9835..6238eb3 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -2019,44 +2019,36 @@ static int reshape_array(char *container, int
> fd, char *devname,
> >  		if (reshape.before.data_disks !=
> >  		    reshape.after.data_disks &&
> >  		    info->custom_array_size) {
> > -			struct mdinfo *info2;
> > -			char *subarray = strchr(info->text_version+1, '/')+1;
> > +			unsigned long long current_size = 0;
> > +			unsigned long long new_size = info-
> >custom_array_size/2;
> > +			unsigned long long suspend_value;
> >
> >  			wait_reshape(sra);
> >  			ping_monitor(container);
> >
> > -			info2 = st->ss->container_content(st, subarray);
> > -			if (info2) {
> > -				unsigned long long current_size = 0;
> > -				unsigned long long new_size =
> > -					info2->custom_array_size/2;
> > -				unsigned long long suspend_value;
> > -
> > -				if (sysfs_get_ll(sra,
> > -						 NULL,
> > -						 "array_size",
> > -						 &current_size) == 0 &&
> > -				    new_size > current_size) {
> > -					if (sysfs_set_num(sra, NULL,
> > -							  "array_size", new_size)
> > -					    < 0)
> > -						dprintf("Error: Cannot"
> > -							" set array size");
> > -					else
> > -						dprintf("Array size "
> > -							"changed");
> > -					dprintf(" from %llu to %llu.\n",
> > -						current_size, new_size);
> > -				}
> > -				/* manage suspend_* entries
> > -				 * set suspend_lo to suspend_hi value
> > -				 * to unblock array
> > -				 */
> > -				sysfs_get_ll(sra, NULL, "suspend_hi",
> &suspend_value);
> > -				sysfs_set_num(sra, NULL, "suspend_lo",
> suspend_value);
> > -
> > -				sysfs_free(info2);
> > +
> > +			if (sysfs_get_ll(sra,
> > +					 NULL,
> > +					 "array_size",
> > +					 &current_size) == 0 &&
> > +			    new_size > current_size) {
> > +				if (sysfs_set_num(sra, NULL,
> > +						  "array_size", new_size)
> > +				    < 0)
> > +					dprintf("Error: Cannot"
> > +						" set array size");
> > +				else
> > +					dprintf("Array size "
> > +						"changed");
> > +				dprintf(" from %llu to %llu.\n",
> > +					current_size, new_size);
> >  			}
> > +			/* manage suspend_* entries
> > +			 * set suspend_lo to suspend_hi value
> > +			 * to unblock array
> > +			 */
> > +			sysfs_get_ll(sra, NULL, "suspend_hi",
> &suspend_value);
> > +			sysfs_set_num(sra, NULL, "suspend_lo",
> suspend_value);
> >  		}
> >
> >  		if (info->new_level != reshape.level) {

