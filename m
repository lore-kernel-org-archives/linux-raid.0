From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH] FIX: sysfs_disk_to_scsi_id() adapted to current sysfs
 format
Date: Thu, 17 Feb 2011 12:35:46 +0000
Message-ID: <BE2BFE91933D1B4089447C6448604080690294D2@irsmsx503.ger.corp.intel.com>
References: <20110216124021.9092.83943.stgit@gklab-128-111.igk.intel.com>
 <20110217171751.264709cd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217171751.264709cd@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, February 17, 2011 7:18 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH] FIX: sysfs_disk_to_scsi_id() adapted to current
> sysfs format
> 
> On Wed, 16 Feb 2011 13:40:21 +0100 Krzysztof Wojcik
> <krzysztof.wojcik@intel.com> wrote:
> 
> > Problem: sysfs_disk_to_scsi_id() not returns correct scsi_id value.
> > Reason: sysfs format has been changed
> >
> > This patch adapt sysfs_disk_to_scsi_id() to new sysfs format.
> 
> If there has been a change in sysfs format, we want the code to work in
> both
> old and new cases.
> 
> Do you know if this new code works in the 'old' case?  Do you know when
> (which kernel version) the change happened, or at least can you name a
> kernel
> version when the 'old' style worked.
> 
> The patch looks OK, but I want to be sure all bases are covered.

I tested the patch with a few versions of kernels since 2.6.27. The patch works with all versions.
I haven't found kernel working properly with initial code.
I assume that scsi_id field was not filled properly for a long time.
It is not critical because scsi_id is not currently used by mdadm so bug hasn't been discovered earlier.
For today scsi_id is important from the viewpoint of IMSM metadata compatibility only.
I suggest to apply the patch.

> 
> Thanks,
> NeilBrown
> 
> 
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > ---
> >  sysfs.c |   14 ++++++--------
> >  1 files changed, 6 insertions(+), 8 deletions(-)
> >
> > diff --git a/sysfs.c b/sysfs.c
> > index f0773d4..883a834 100644
> > --- a/sysfs.c
> > +++ b/sysfs.c
> > @@ -705,7 +705,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
> >  	if (fstat(fd, &st))
> >  		return 1;
> >
> > -	snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/device",
> > +	snprintf(path, sizeof(path),
> "/sys/dev/block/%d:%d/device/scsi_device",
> >  		 major(st.st_rdev), minor(st.st_rdev));
> >
> >  	dir = opendir(path);
> > @@ -714,8 +714,7 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
> >
> >  	de = readdir(dir);
> >  	while (de) {
> > -		if (strncmp("scsi_disk:", de->d_name,
> > -			    strlen("scsi_disk:")) == 0)
> > +		if (strchr(de->d_name, ':'))
> >  			break;
> >  		de = readdir(dir);
> >  	}
> > @@ -724,21 +723,20 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
> >  	if (!de)
> >  		return 1;
> >
> > -	c1 = strchr(de->d_name, ':');
> > -	c1++;
> > +	c1 = de->d_name;
> >  	c2 = strchr(c1, ':');
> >  	*c2 = '\0';
> >  	*id = strtol(c1, NULL, 10) << 24; /* host */
> >  	c1 = c2 + 1;
> >  	c2 = strchr(c1, ':');
> >  	*c2 = '\0';
> > -	*id |= strtol(c1, NULL, 10) << 16; /* channel */
> > +	*id |= strtol(c1, NULL, 10) << 16; /* bus */
> >  	c1 = c2 + 1;
> >  	c2 = strchr(c1, ':');
> >  	*c2 = '\0';
> > -	*id |= strtol(c1, NULL, 10) << 8; /* lun */
> > +	*id |= strtol(c1, NULL, 10) << 8; /* target */
> >  	c1 = c2 + 1;
> > -	*id |= strtol(c1, NULL, 10); /* id */
> > +	*id |= strtol(c1, NULL, 10); /* lun */
> >
> >  	return 0;
> >  }

