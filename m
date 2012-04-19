From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH 07/14] FIX: Extend size of raid0 array
Date: Thu, 19 Apr 2012 15:09:45 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB185DF96A@IRSMSX101.ger.corp.intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
 <20120417125236.5debe352@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120417125236.5debe352@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

On Tuesday, April 17, 2012 4:53 AM NeilBrown wrote:
> 
> On Fri, 13 Apr 2012 16:52:01 +0200 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > For raid0, takeover operation is required for size change.
> > Add takeover to degraded raid4 before size change and back to raid0 after.
> > Array information has to be read again from md after takeover.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >  Grow.c |   35 +++++++++++++++++++++++++++++++++++
> >  1 files changed, 35 insertions(+), 0 deletions(-)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 8c7bafc..e8f6554 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -1626,6 +1626,7 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file,
> >  		long long orig_size = get_component_size(fd)/2;
> >  		long long min_csize;
> >  		struct mdinfo *mdi;
> > +		int raid0_takeover = 0;
> >
> >  		if (orig_size == 0)
> >  			orig_size = array.size;
> > @@ -1674,6 +1675,28 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file,
> >  				"2TB per device\n");
> >  			size = min_csize;
> >  		}
> > +		if (st->ss->external) {
> > +			if (sra->array.level == 0) {
> > +				rv = sysfs_set_str(sra, NULL, "level",
> > +						   "raid5");
> > +				if (!rv) {
> > +					raid0_takeover = 1;
> > +					/* get array parametes after takeover
> > +					 * to chane one parameter at time
> only
> > +					 */
> > +					rv = ioctl(fd, GET_ARRAY_INFO,
> &array);
> > +				}
> > +			}
> > +			/* make sure mdmon is
> > +			 * aware of the new level */
> > +			if (!mdmon_running(st->container_dev))
> > +				start_mdmon(st->container_dev);
> > +			ping_monitor(container);
> > +			if (mdmon_running(st->container_dev) &&
> > +					st->update_tail == NULL)
> > +				st->update_tail = &st->updates;
> > +		}
> > +
> >  		array.size = size;
> >  		if (array.size != size) {
> >  			/* got truncated to 32bit, write to
> > @@ -1686,12 +1709,24 @@ int Grow_reshape(char *devname, int fd, int
> quiet, char *backup_file,
> >  				rv = -1;
> >  		} else {
> >  			rv = ioctl(fd, SET_ARRAY_INFO, &array);
> > +
> >  			/* manage array size when it is managed externally
> >  			 */
> >  			if ((rv == 0) && st->ss->external)
> >  				rv = set_array_size(st, sra, sra->text_version);
> >  		}
> >
> > +		if (raid0_takeover) {
> > +			/* do not recync non-existing parity,
> > +			 * we will drop it anyway
> > +			 */
> > +			sysfs_set_str(sra, NULL, "sync_action", "idle");
> 
> This is probably ineffective.  If the array thinks it needs to resync, then
> just setting it to 'idle' will only stop in temporarily.  It will immediately
> start syncing again.
> 
> However given that it is a RAID5 array which is degraded, it shouldn't try to
> resync at all.
> 
> So:  does it still work if you remove this line?  If so, could you send a
> patch to remove it?
> If not - we should work out why.
> 

It doesn't work without this line.
The N-disks raid0 changes to degraded (N+1)-disks raid5 (N of N+1 disks) 
in /proc/mdstat after size extension, however the metadata on all disks is correct.

Regards,
Lukasz
 
> 
> > +			/* go back to raid0, drop parity disk
> > +			 */
> > +			sysfs_set_str(sra, NULL, "level", "raid0");
> > +			ioctl(fd, GET_ARRAY_INFO, &array);
> > +		}
> > +
> >  		if (rv != 0) {
> >  			int err = errno;
> >

