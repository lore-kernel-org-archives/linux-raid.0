From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 03/27] imsm: Prepare reshape_update in mdadm
Date: Wed, 8 Dec 2010 14:18:52 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17676EAED@irsmsx503.ger.corp.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
	<20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
 <20101208141016.437dfd2d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101208141016.437dfd2d@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

I didn't describe those functions, because I've realized that it has to be changed after your email.
I've planned to do this before I send patches, but unfortunately this "thread" was missed before sending ;).
Here is current state.

Functions: 
	- path2devnum() (Translates path (or symbolic link) to md device given by user to device number.)
	- find_array_minor() (returns device minor for given array name, it uses maps to find names with additions (i.e. "_0") from assebbly)
	- find_array_minor2() (as find_array_minor() but works for frozen arrays also)

Will be removed and replaced by:

int find_array_minor_by_subdev(int subdev, int container, int *minor) {
	char text_version[PATH_MAX];
	char path[PATH_MAX];
	int i;
	struct stat s;

	sprintf(text_version, "md%i/%i", container, subdev);
	for (i = 127; i >= 0; i--) {
		char buf[PATH_MAX];

		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
		if (stat(path, &s) != -1) {
			char *version;

			strcat(path, "metadata_version");
			if (load_sys(path, buf))
				continue;
			version = strchr(buf, ':');
			/* compare without first letter
			 * it could be marked as frozen with '-'
			 */
			if (!version || strcmp(version + 2, text_version))
				continue;
			*minor = i;
			return 0;
		}
	}

	return -1;
}

This is a little part of find_array_minor() with changed input.

This function searches given container for subdev and returns it minor id.
i.e.: for input parameters 0 and 127 it creates search string i.e. "md127/0" and for such device returns minor (~126).
For success 0 is returned, and -1 for failure (and passed minor variable remains untouched). 
It searches all devices from 127 to 0. 
I think it is simpler now (as you raised this issue), and mdadm doesn't make decisions based on array name/string/ now.

Please let me know how do you find this change. 

I've replaced open() with open_dev() in this patch (and in a few next one: 0003, 0007, 0012, 0019, 0021)

If it is ok, please let me know if you want fresh series or you'll apply current one and I'll send patches for above changes then.
In future patches, I'll address problem with lines longer than 80 characters also.

Please note also that implementation of searching spare devices for reshape is not final. 
It requires better integration with auto-rebuild searching spares mechanism.
This task is in my nearest plans (I'm hoping to post fixes instead of whole series again ;))


BR
Adam

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, December 08, 2010 4:10 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 03/27] imsm: Prepare reshape_update in mdadm
> 
> On Mon, 06 Dec 2010 14:21:08 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> >
> > +int path2devnum(char *pth)
> > +{
> > +	char *ep;
> > +	int fd = -1;
> > +	char *dev_pth = NULL;
> > +	char *dev_str;
> > +	int dev_num = -1;
> > +
> > +	fd = open(pth, O_RDONLY);
> > +	if (fd < 0)
> > +		return dev_num;
> > +	close(fd);
> > +	dev_pth = canonicalize_file_name(pth);
> > +	if (dev_pth == NULL)
> > +		return dev_num;
> > +	dev_str = strrchr(dev_pth, '/');
> > +	if (dev_str) {
> > +		while (!isdigit(dev_str[0]))
> > +			dev_str++;
> > +		dev_num = strtoul(dev_str, &ep, 10);
> > +		if (*ep != '\0')
> > +			dev_num = -1;
> > +	}
> > +
> > +	if (dev_pth)
> > +		free(dev_pth);
> > +
> > +	return dev_num;
> > +}
> 
> 
> I have repeatedly asked you to explain and document these functions.
> They
> look way to complex for whatever it that they might be trying to do.
> 
> I do not feel at all included to spend time reviewing your patches if
> you
> don't respond to the review comments.
> 
> So I'm ignoring the rest of this series until you explain this and we
> come to
> an agreement on what it does and how it should work.
> 
> BTW there are two places in this patch where you should be using
> open_dev,
> and several where you have lines longer than 80 characters.
> 
> NeilBrown
> 
> 
> > +
> > +extern void map_read(struct map_ent **map);
> > +extern void map_free(struct map_ent *map);
> > +int find_array_minor(char *text_version, int external, int
> container, int *minor)
> > +{
> > +	int i;
> > +	char path[PATH_MAX];
> > +	struct stat s;
> > +
> > +	if (minor == NULL)
> > +		return -2;
> > +
> > +	snprintf(path, PATH_MAX, "/dev/md/%s", text_version);
> > +	i = path2devnum(path);
> > +	if (i > -1) {
> > +		*minor = i;
> > +		return 0;
> > +	}
> > +
> > +	i = path2devnum(text_version);
> > +	if (i > -1) {
> > +		*minor = i;
> > +		return 0;
> > +	}
> > +
> > +	if (container > 0) {
> > +		struct map_ent *map = NULL;
> > +		struct map_ent *m;
> > +		char cont[PATH_MAX];
> > +
> > +		snprintf(cont, PATH_MAX, "/md%i/", container);
> > +		map_read(&map);
> > +		for (m = map; m; m = m->next) {
> > +			int index;
> > +			unsigned int len = 0;
> > +			char buf[PATH_MAX];
> > +
> > +			/* array have belongs to proper container
> > +			*/
> > +			if (strncmp(cont, m->metadata, 6) != 0)
> > +				continue;
> > +			/* begin of array name in map have to be the same
> > +			 * as array name in metadata
> > +			 */
> > +			if (strncmp(m->path, path, strlen(path)) != 0)
> > +				continue;
> > +			/* array name has to be followed by '_' char
> > +			 */
> > +			len = strlen(path);
> > +			if (*(m->path + len) != '_')
> > +				continue;
> > +			/* then we have to have  valid index
> > +			 */
> > +			len++;
> > +			if (strlen(m->path + len) <= 0)
> > +			    continue;
> > +			/* index has to be las position in array name
> > +			 */
> > +			index = atoi(m->path + strlen(path) + 1);
> > +			snprintf(buf, PATH_MAX, "%i", index);
> > +			len += strlen(buf);
> > +			if (len != strlen(m->path))
> > +				continue;
> > +			dprintf("Found %s device based on mdadm maps\n", m-
> >path);
> > +			*minor = m->devnum;
> > +			map_free(map);
> > +			return 0;
> > +		}
> > +		map_free(map);
> > +	}
> > +
> > +	for (i = 127; i >= 0; i--) {
> > +		char buf[PATH_MAX];
> > +
> > +		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
> > +		if (stat(path, &s) != -1) {
> > +			strcat(path, "metadata_version");
> > +			if (load_sys(path, buf))
> > +				continue;
> > +			if (external) {
> > +				char *version = strchr(buf, ':');
> > +				if (version && strcmp(version + 1,
> > +						      text_version))
> > +					continue;
> > +			} else {
> > +				if (strcmp(buf, text_version))
> > +					continue;
> > +			}
> > +			*minor = i;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	return -1;
> > +}
> > +
> > +/* find_array_minor2 looks for frozen devices also
> > + */
> > +int find_array_minor2(char *text_version, int external, int
> container, int *minor)
> > +{
> > +	int result;
> > +	char buf[PATH_MAX];
> > +
> > +	strcpy(buf, text_version);
> > +	result = find_array_minor(text_version, external, container,
> minor);
> > +	if (result < 0) {
> > +		/* try to find frozen array also
> > +		 */
> > +		char buf[PATH_MAX];
> > +
> > +		strcpy(buf, text_version);
> > +
> > +		*buf = '-';
> > +		result = find_array_minor(buf, external, container, minor);
> > +	}
> > +	return result;
> > +}
> > +
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

