From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 13/17] Monitor: autorebuild functionality added
Date: Thu, 04 Nov 2010 22:58:22 -0700
Message-ID: <4CD39CFE.506@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FD0@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 10/29/2010 7:25 AM, Czarnowska, Anna wrote:
>  From 43c50f74689943e85913db343b33a0ff24812721 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska<anna.czarnowska@intel.com>
> Date: Thu, 28 Oct 2010 13:20:21 +0200
> Subject: [PATCH 13/17] Monitor: autorebuild functionality added
>
> After all information on arrays is updated we first move spares
> using spare-group information from config file, then link containers with
> subarrays and call spare_sharing. Arrays with defined spare-groups
> are not considered again. spare_sharing searches for suitable spares
> in other arrays and moves them using move_spare to the arrays
> that need them. move_spare removes spare from one array/container
> and adds to another. If add fails we add back to original container.
> Manage_subdevs function is used to perform the spare relocation.
>
> Signed-off-by: Anna Czarnowska<anna.czarnowska@intel.com>
> Signed-off-by: Marcin Labun<marcin.labun@intel.com>
> ---
>   Monitor.c |  299 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 294 insertions(+), 5 deletions(-)

Looks good, only a couple of future enhancements.

A ddf array may be able to fix up a degraded array with free space on 
another array member.  So we may need to ensure that mdmon has had a 
chance to perform the search before we grab a free spare from another 
container.

> +static struct supertype *get_super(struct state *st)
> +{
> +	struct supertype *super = NULL;
> +	char *metadata = NULL;
> +	int i;
> +
> +	if (is_external(st->metadata_version)) {
> +		st = st->parent;
> +		if (!st)
> +			return NULL;
> +		metadata = st->metadata_version + strlen("external:");
> +	} else {
> +		metadata = st->metadata_version;
> +	}
> +	for (i = 0; !super&&  superlist[i]; i++)
> +		super = superlist[i]->match_metadata_desc(metadata);

This looks like an open-coded version_to_superswitch()
