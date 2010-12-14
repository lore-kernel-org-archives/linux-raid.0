From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 02/29] imsm: Prepare reshape_update in mdadm
Date: Tue, 14 Dec 2010 07:54:13 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176AAEF6C@irsmsx503.ger.corp.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
	<20101209151855.26876.17602.stgit@gklab-170-024.igk.intel.com>
 <20101214110751.5691de92@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101214110751.5691de92@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

As I wrote in cover email, spares management will/is be changed by Krzysztof.
Yesterday, he post patch and functions you pointed below as not correct or with bugs
are totally removed from code. 
I didn't update/develop those functions so far, due this reason.

BR
Adam

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Neil Brown
> Sent: Tuesday, December 14, 2010 1:08 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 02/29] imsm: Prepare reshape_update in mdadm
> 
> On Thu, 09 Dec 2010 16:18:56 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > During Online Capacity Expansion metadata has to be updated to show
> > array changes and allow for future assembly of array.
> > To do this mdadm prepares and sends reshape_update metadata update to
> mdmon.
> > Update is sent for one array in container. It contains updated device
> > and spares that have to be turned in to array members.
> > For spares we have 2 cases:
> > 1. For first array in container:
> >    reshape_delta_disks: shows how many disks will be added to array
> >    Spares are sent in update so variable spares_in_update in metadata
> update tells that mdmon has to turn spares in to array
> >    (IMSM's array meaning) members.
> > 2. For 2nd array in container:
> >    reshape_delta_disks: shows how many disks will be added to array -
> exactly as in first case
> >    Spares were turned in to array members (they are not a spares) so
> we have for this volume
> >    reuse those disks only.
> >
> > This update will change active array state to reshape_is_starting
> state.
> > This works in the following way:
> > 1. reshape_super() prepares metadata update and send it to mdmon
> > 2. managemon in prepare_update() allocates required memory for bigger
> device object
> > 3. monitor in process_update() updates (replaces) device object with
> information
> >    passed from mdadm (memory was allocated by managemon)
> > 4. process_update() function performs:
> >    - sets reshape_delta_disks variable to reshape_delta_disks value
> from update
> >    - sets array in to reshape_is_starting state.
> > 5. This signals managemon to add devices to md and start reshape for
> this array
> >    and put array in to reshape_in_progress.
> >    Managemon can request reshape_cancel_request state in error case.
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> I have applied this.
> I haven't reviewed the super-intel.c bits very closely.
> 
> I have improved find_array_by_subdev, renamed it to mdstat_by_subdev
> and
> moved it to mdstat.c where it belongs.
> I have also totally re-written sysfs_get_unused_spares which was:
>   - undocumented
>   - overly complex
>   - wrong in a few places. e.g.
> 
> 
> > +
> > +struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd)
> > +{
> > +	char fname[PATH_MAX];
> > +	char buf[PATH_MAX];
> > +	char *base;
> > +	char *dbase;
> > +	struct mdinfo *ret_val;
> > +	struct mdinfo *dev;
> > +	DIR *dir = NULL;
> > +	struct dirent *de;
> > +	int is_in;
> > +	char *to_check;
> > +
> > +	ret_val = malloc(sizeof(*ret_val));
> > +	if (ret_val == NULL)
> > +		goto abort;
> > +	memset(ret_val, 0, sizeof(*ret_val));
> > +	sysfs_init(ret_val, container_fd, -1);
> > +	if (ret_val->sys_name[0] == 0)
> > +		goto abort;
> > +
> > +	sprintf(fname, "/sys/block/%s/md/", ret_val->sys_name);
> > +	base = fname + strlen(fname);
> > +
> > +	strcpy(base, "raid_disks");
> > +	if (load_sys(fname, buf))
> > +		goto abort;
> > +	ret_val->array.raid_disks = strtoul(buf, NULL, 0);
> > +
> > +	/* Get all the devices as well */
> > +	*base = 0;
> > +	dir = opendir(fname);
> > +	if (!dir)
> > +		goto abort;
> > +	ret_val->array.spare_disks = 0;
> > +	while ((de = readdir(dir)) != NULL) {
> > +		char *ep;
> > +		if (de->d_ino == 0 ||
> > +		    strncmp(de->d_name, "dev-", 4) != 0)
> > +			continue;
> > +		strcpy(base, de->d_name);
> > +		dbase = base + strlen(base);
> > +		*dbase = '\0';
> > +
> > +		to_check = strstr(fname, "/md/");
> > +		is_in = sysfs_is_spare_device_belongs_to(fd, to_check);
> > +		if (is_in == -1) {
> > +			char *p;
> > +			struct stat stb;
> > +			char stb_name[PATH_MAX];
> > +
> > +			dev = malloc(sizeof(*dev));
> > +			if (!dev)
> > +				goto abort;
> > +			strncpy(dev->text_version, fname, 50);
> > +
> > +			*dbase++ = '/';
> > +
> > +			dev->disk.raid_disk = strtoul(buf, &ep, 10);
> > +			dev->disk.raid_disk = -1;
> > +
> > +			strcpy(dbase, "block/dev");
> > +			if (load_sys(fname, buf)) {
> > +				free(dev);
> > +				continue;
> > +			}
> > +			/* check first if we are working on block device
> > +			 * if not, we cannot check it
> > +			 */
> > +			p = strchr(dev->text_version, '-');
> > +			if (p)
> > +				p++;
> > +			sprintf(stb_name, "/dev/%s", p);
> > +			if (stat(stb_name, &stb) < 0) {
> 
> Taking a string out of /sys and looking it up in /dev is wrong.  Names
> in /dev tend to follow /sys by convention, but there is no guarantee.
> 
> 
> > +				dprintf(Name ": stat failed for %s: %s.\n",
> > +					stb_name, strerror(errno));
> > +				free(dev);
> > +				continue;
> > +			}
> > +			if (!S_ISBLK(stb.st_mode)) {
> 
> And everything that is a member of an array will be a block device, so
> checking that it is a block device is pointless.
> 
> 
> > +				dprintf(Name\
> > +					": %s is not a block device."\
> > +					" Skip checking.\n",
> > +					stb_name);
> > +				goto skip;
> > +			}
> > +			dprintf(Name": %s seams to a be block device\n",
> > +				stb_name);
> > +			sscanf(buf, "%d:%d",
> > +			       &dev->disk.major,
> > +			       &dev->disk.minor);
> > +			strcpy(dbase, "block/device/state");
> > +			if (load_sys(fname, buf) != 0) {
> > +				free(dev);
> > +				continue;
> > +			}
> > +			if (strncmp(buf, "offline", 7) == 0) {
> > +				free(dev);
> > +				continue;
> > +			}
> > +			if (strncmp(buf, "failed", 6) == 0) {
> > +				free(dev);
> > +				continue;
> > +			}
> 
> The string you want to check here is "faulty" not "failed".
> 
> NeilBrown
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
