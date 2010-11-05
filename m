From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 03/17] extension of IncrementalRemove to store location
 (path-id) of removed device
Date: Thu, 04 Nov 2010 22:39:48 -0700
Message-ID: <4CD398A4.5070304@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FB9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FB9@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 10/29/2010 7:15 AM, Czarnowska, Anna wrote:
>  From 39e3e87204d4381007f5d798545a220e5c532516 Mon Sep 17 00:00:00 2001
> From: Przemyslaw Czarnowski<przemyslaw.hawrylewicz.czarnowski@intel.com>
> Date: Wed, 27 Oct 2010 16:35:48 +0200
> Subject: [PATCH 03/17] extension of IncrementalRemove to store location (path-id) of removed device
>
> If the disk is taken out from its port this port information is lost. Only
> udev rule can provide us with this information, and then we have to store
> it somehow. This patch adds writing 'cookie' file in
> /dev/.mdadm/failed-slots directory in form of file named with value
> of<path-id>  containing the UUID's of arrays holding this device before
> it was removed. FAILED_SLOTS_DIR constant has been added to hold the
> location of cookie files.
>
> Signed-off-by: Przemyslaw Czarnowski<przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>   Incremental.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   Makefile      |    3 ++
>   mdadm.h       |    9 ++++++
>   util.c        |    5 +++
>   4 files changed, 99 insertions(+), 1 deletions(-)
>
> diff --git a/Incremental.c b/Incremental.c
> index de1003e..bda90bc 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1297,7 +1297,11 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
>   	int mdfd;
>   	int rv;
>   	struct mdstat_ent *ent;
> +	struct map_ent *map, *me;
>   	struct mddev_dev_s devlist;
> +	char path[PATH_MAX];
> +	FILE *id_fd;
> +
>   	if (!id_path) {
>   		dprintf(Name ": incremental removal without --path<id_path>  "
>   			"lacks the possibility to re-add new device in this "
> @@ -1315,15 +1319,92 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
>   			"of any array\n", devname);
>   		return 1;
>   	}
> +
> +	if (id_path) {
> +		if (mkdir(FAILED_SLOTS_DIR, S_IRWXU)<  0&&  errno != EEXIST) {
> +			fprintf(stderr, Name ": can't create file to save path "
> +				"to old disk\n");
> +			id_path = NULL;
> +		} else {
> +			snprintf(path, PATH_MAX, FAILED_SLOTS_DIR "/%s", id_path);
> +
> +			id_fd = fopen(path, "w");
> +			if (!id_fd) {
> +				fprintf(stderr, Name ": can't create file to"
> +						     " save path to old disk\n");
> +				id_path = NULL;
> +			}
> +		}
> +	}
> +
>   	mdfd = open_dev(ent->devnum);
>   	if (mdfd<  0) {
>   		fprintf(stderr, Name ": Cannot open array %s!!\n", ent->dev);
>   		return 1;
>   	}
> +
>   	memset(&devlist, 0, sizeof(devlist));
>   	devlist.devname = devname;
>   	devlist.disposition = 'f';
> -	Manage_subdevs(ent->dev, mdfd,&devlist, verbose, 0);
> +
> +	map_read(&map);
> +	if (!map) {
> +		fprintf(stderr, Name ": Cannot open/read map file\n");
> +		return 1;
> +	}
> +
> +	/* slightly different behavior for native and external */
> +	if (!is_external(ent->metadata_version)) {
> +		me = map_by_devnum(&map, ent->devnum);
> +		/* just write array device */
> +		if (id_path&&  fprintf(id_fd, "%08x:%08x:%08x:%08x\n",
> +				       me->uuid[0],
> +				       me->uuid[1],
> +				       me->uuid[2],
> +				       me->uuid[3])<  0) {
> +			fprintf(stderr, Name ": Failed to write to<id_path>  "
> +				"cookie\n");
> +			fclose(id_fd);
> +			unlink(path);
> +		}
> +		Manage_subdevs(ent->dev, mdfd,&devlist, verbose, 0);
> +	} else {
> +		int subfd;
> +		/* write device for all array members */
> +		for (me = map; me; me = me->next) {
> +			if (!is_subarray(me->metadata) ||
> +			    devname2devnum(me->metadata + 1) != ent->devnum)
> +				continue;
> +			/* found member, so */
> +			/* create file with names of arrays containing old disk */
> +			if (id_path&&  fprintf(id_fd, "%08x:%08x:%08x:%08x\n",
> +						me->uuid[0],
> +						me->uuid[1],
> +						me->uuid[2],
> +						me->uuid[3])<  0) {
> +				fprintf(stderr,	Name ": Failed to write to "
> +					"<id_path>  cookie\n");
> +				fclose(id_fd);
> +				unlink(path);
> +			}

Two comments from our review at LPC:

1/ General cleanup: these "if (id_path && fprintf(...))" blocks are 
duplicated and should probably be a helper function, but comment two 
makes this moot...

2/ We don't really need to record all the subarray ids at removal.  imsm 
can get by with just the container uuid.  Marcin I seem to recall you 
said this was added in case ddf might need it.  If that turns out to be 
true we can always add that functionality.  For now just do the simple 
thing and record the container uuid.  This also allow these paths to be 
unified between external / !external...

...actually Neil mentioned we should kill the idea that "external" 
always implies a container with subarray.  Consider if we added a new 
native-md metadata type handled externally, but still had the same 
1-array per set of disks constraint as 0.90 and 1.[012] metadata.

--
Dan
