From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 16/17] IMSM: Fix problem in mdmon monitor of using removed
 disk from in imsm container.
Date: Thu, 04 Nov 2010 23:17:22 -0700
Message-ID: <4CD3A172.5090905@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD7@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD7@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 10/29/2010 7:27 AM, Czarnowska, Anna wrote:
>  From 30aa06f20497fadf58990685ecc0554ffce21f25 Mon Sep 17 00:00:00 2001
> From: Marcin Labun<marcin.labun@intel.com>
> Date: Thu, 30 Sep 2010 05:00:57 +0200
> Subject: [PATCH 16/17] IMSM: Fix problem in mdmon monitor of using removed disk from in imsm container.
>
> Manager thread shall pass the information to monitor thread (mdmon)
> that some devices are removed from container. Otherwise, monitor (mdmon)
> might use such devices (spares) to rebuild the array that has gone degraded.
>
> This problem happens for imsm containers, since a list of the container disks
> is maintained in intel_super structure. When array goes degraded, the list is
> searched to find a spare disks to start rebuild.
> Without this fix the rebuild could be stared on the spare device that was
> a member of the container, but has been removed from it.

Yes, definitely a bug.

>
> New super type function handler has been introduced to prepare metadata
> format specific information about removed devices.
> int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
>                           int fd);
> The message prepared in remove_from_super is later processed
> by proceess_update handler in monitor thread.
>
> Signed-off-by: Marcin Labun<marcin.labun@intel.com>
> ---
>   managemon.c   |   38 ++++++++++++++
>   mdadm.h       |    7 ++-
>   super-intel.c |  159 ++++++++++++++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 173 insertions(+), 31 deletions(-)
>
> diff --git a/managemon.c b/managemon.c
> index bab0397..8ab2746 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -297,6 +297,43 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
>   	st->update_tail = NULL;
>   }
>
> +/*
> + * Create and queue update structure about the removed disks.
> + * The update is prepared by super type handler and passed to the monitor
> + * thread.
> + */
> +static void remove_disk_from_container(struct supertype *st, struct mdinfo *sd)
> +{
> +	int dfd;
> +	char nm[20];
> +	struct metadata_update *update = NULL;
> +	mdu_disk_info_t dk = {
> +		.number = -1,
> +		.major = sd->disk.major,
> +		.minor = sd->disk.minor,
> +		.raid_disk = -1,
> +		.state = 0,
> +	};
> +	/* nothing to do if super type handler does not support
> +	 * remove disk primitive
> +	 */
> +	if (!st->ss->remove_from_super)
> +		return;
> +	dprintf("%s: remove %d:%d to container\n",
> +		__func__, sd->disk.major, sd->disk.minor);
> +
> +	sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
> +	dfd = dev_open(nm, O_RDWR);
> +	if (dfd<  0)
> +		return;
> +
> +	st->update_tail =&update;
> +	st->ss->remove_from_super(st,&dk, dfd);
> +	st->ss->write_init_super(st);
> +	queue_metadata_update(update);

Since we do not update the metadata can we just lazily queue an modified 
imsm_delete() update the next time we call activate_spare() and find the 
spare removed?  That way it is just garbage collection without this new 
infrastructure that gives the appearance we are writing metadata when 
removing a spare.

