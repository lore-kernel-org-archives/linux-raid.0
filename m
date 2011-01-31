From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Monitor: do not move partitions to external
 container
Date: Tue, 1 Feb 2011 10:39:02 +1100
Message-ID: <20110201103902.2e49d648@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EBB6C0F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010EBB6C0F@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 31 Jan 2011 16:31:24 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 862768811140f5f8a039d3d2ba6726e2cfcc71fb Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Fri, 3 Dec 2010 15:23:41 +0100
> Subject: [PATCH 1/2] Monitor: do not move partitions to external container
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> Arrays on partitions are not supported for external metadata
> so do not take such spare from native array.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>

I've applied both of these, thanks.

NeilBrown


> ---
>  Monitor.c |    4 ++++
>  mdadm.h   |    1 +
>  util.c    |   13 +++++++++++++
>  3 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index acc82ac..01006ac 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -764,6 +764,10 @@ static dev_t choose_spare(struct state *from, struct state *to,
>  		    from->devstate[d] == 0) {
>  			struct dev_policy *pol;
>  			unsigned long long dev_size;
> +			
> +			if (to->metadata->ss->external &&
> +			    test_partition_from_id(from->devid[d]))
> +				continue;
>  
>  			if (min_size &&
>  			    dev_size_from_id(from->devid[d], &dev_size) &&
> diff --git a/mdadm.h b/mdadm.h
> index 369118c..8fa3af4 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1120,6 +1120,7 @@ extern int ask(char *mesg);
>  extern unsigned long long get_component_size(int fd);
>  extern void remove_partitions(int fd);
>  extern int test_partition(int fd);
> +extern int test_partition_from_id(dev_t id);
>  extern unsigned long long calc_array_size(int level, int raid_disks, int layout,
>  				   int chunksize, unsigned long long devsize);
>  extern int flush_metadata_updates(struct supertype *st);
> diff --git a/util.c b/util.c
> index b806a97..38750b2 100644
> --- a/util.c
> +++ b/util.c
> @@ -295,6 +295,19 @@ int test_partition(int fd)
>  	return 1;
>  }
>  
> +int test_partition_from_id(dev_t id)
> +{
> +	char buf[20];
> +	int fd, rv;
> +
> +	sprintf(buf, "%d:%d", major(id), minor(id));
> +	fd = dev_open(buf, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	rv = test_partition(fd);
> +	close(fd);
> +	return rv;
> +}
>  
>  int enough(int level, int raid_disks, int layout, int clean,
>  	   char *avail, int avail_disks)

