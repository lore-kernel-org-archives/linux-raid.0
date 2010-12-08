From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 03/27] imsm: Prepare reshape_update in mdadm
Date: Wed, 8 Dec 2010 14:10:16 +1100
Message-ID: <20101208141016.437dfd2d@notabene.brown>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
	<20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, 06 Dec 2010 14:21:08 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

>  
> +int path2devnum(char *pth)
> +{
> +	char *ep;
> +	int fd = -1;
> +	char *dev_pth = NULL;
> +	char *dev_str;
> +	int dev_num = -1;
> +
> +	fd = open(pth, O_RDONLY);
> +	if (fd < 0)
> +		return dev_num;
> +	close(fd);
> +	dev_pth = canonicalize_file_name(pth);
> +	if (dev_pth == NULL)
> +		return dev_num;
> +	dev_str = strrchr(dev_pth, '/');
> +	if (dev_str) {
> +		while (!isdigit(dev_str[0]))
> +			dev_str++;
> +		dev_num = strtoul(dev_str, &ep, 10);
> +		if (*ep != '\0')
> +			dev_num = -1;
> +	}
> +
> +	if (dev_pth)
> +		free(dev_pth);
> +
> +	return dev_num;
> +}


I have repeatedly asked you to explain and document these functions.  They
look way to complex for whatever it that they might be trying to do.

I do not feel at all included to spend time reviewing your patches if you
don't respond to the review comments.

So I'm ignoring the rest of this series until you explain this and we come to
an agreement on what it does and how it should work.

BTW there are two places in this patch where you should be using open_dev,
and several where you have lines longer than 80 characters.

NeilBrown


> +
> +extern void map_read(struct map_ent **map);
> +extern void map_free(struct map_ent *map);
> +int find_array_minor(char *text_version, int external, int container, int *minor)
> +{
> +	int i;
> +	char path[PATH_MAX];
> +	struct stat s;
> +
> +	if (minor == NULL)
> +		return -2;
> +
> +	snprintf(path, PATH_MAX, "/dev/md/%s", text_version);
> +	i = path2devnum(path);
> +	if (i > -1) {
> +		*minor = i;
> +		return 0;
> +	}
> +
> +	i = path2devnum(text_version);
> +	if (i > -1) {
> +		*minor = i;
> +		return 0;
> +	}
> +
> +	if (container > 0) {
> +		struct map_ent *map = NULL;
> +		struct map_ent *m;
> +		char cont[PATH_MAX];
> +
> +		snprintf(cont, PATH_MAX, "/md%i/", container);
> +		map_read(&map);
> +		for (m = map; m; m = m->next) {
> +			int index;
> +			unsigned int len = 0;
> +			char buf[PATH_MAX];
> +
> +			/* array have belongs to proper container
> +			*/
> +			if (strncmp(cont, m->metadata, 6) != 0)
> +				continue;
> +			/* begin of array name in map have to be the same
> +			 * as array name in metadata
> +			 */
> +			if (strncmp(m->path, path, strlen(path)) != 0)
> +				continue;
> +			/* array name has to be followed by '_' char
> +			 */
> +			len = strlen(path);
> +			if (*(m->path + len) != '_')
> +				continue;
> +			/* then we have to have  valid index
> +			 */
> +			len++;
> +			if (strlen(m->path + len) <= 0)
> +			    continue;
> +			/* index has to be las position in array name
> +			 */
> +			index = atoi(m->path + strlen(path) + 1);
> +			snprintf(buf, PATH_MAX, "%i", index);
> +			len += strlen(buf);
> +			if (len != strlen(m->path))
> +				continue;
> +			dprintf("Found %s device based on mdadm maps\n", m->path);
> +			*minor = m->devnum;
> +			map_free(map);
> +			return 0;
> +		}
> +		map_free(map);
> +	}
> +
> +	for (i = 127; i >= 0; i--) {
> +		char buf[PATH_MAX];
> +
> +		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
> +		if (stat(path, &s) != -1) {
> +			strcat(path, "metadata_version");
> +			if (load_sys(path, buf))
> +				continue;
> +			if (external) {
> +				char *version = strchr(buf, ':');
> +				if (version && strcmp(version + 1,
> +						      text_version))
> +					continue;
> +			} else {
> +				if (strcmp(buf, text_version))
> +					continue;
> +			}
> +			*minor = i;
> +			return 0;
> +		}
> +	}
> +
> +	return -1;
> +}
> +
> +/* find_array_minor2 looks for frozen devices also
> + */
> +int find_array_minor2(char *text_version, int external, int container, int *minor)
> +{
> +	int result;
> +	char buf[PATH_MAX];
> +
> +	strcpy(buf, text_version);
> +	result = find_array_minor(text_version, external, container, minor);
> +	if (result < 0) {
> +		/* try to find frozen array also
> +		 */
> +		char buf[PATH_MAX];
> +
> +		strcpy(buf, text_version);
> +
> +		*buf = '-';
> +		result = find_array_minor(buf, external, container, minor);
> +	}
> +	return result;
> +}
> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

