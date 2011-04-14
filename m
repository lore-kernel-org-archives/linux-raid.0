From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone fix component list parsing
Date: Thu, 14 Apr 2011 17:29:46 +1000
Message-ID: <20110414172946.287e36ee@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
	<20110322095905.737fb1d5@notabene.brown>
	<20110404175242.GA3411@lazy.lzy>
	<20110405091242.3427e0b1@notabene.brown>
	<20110406180202.GA3267@lazy.lzy>
	<20110413204825.GA15496@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413204825.GA15496@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 22:48:25 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> maybe you missed the other email, anyway please
> find attached the patch to fix the parsing of
> the component list, i.e. skipping the "spare" one.
> 
> I also added a check in case the array is degraded.
> 
> Thanks,
> 

Thanks for the reminded.  I've applied this now.

NeilBrown


> pg
> 
> --- cut here ---
> 
> 
> diff -uNr a/raid6check.c b/raid6check.c
> --- a/raid6check.c	2011-04-05 01:29:45.000000000 +0200
> +++ b/raid6check.c	2011-04-05 22:51:32.587032612 +0200
> @@ -207,6 +207,7 @@
>  	char **disk_name = NULL;
>  	unsigned long long *offsets = NULL;
>  	int raid_disks = 0;
> +	int active_disks = 0;
>  	int chunk_size = 0;
>  	int layout = -1;
>  	int level = 6;
> @@ -242,6 +243,7 @@
>  			  GET_LEVEL|
>  			  GET_LAYOUT|
>  			  GET_DISKS|
> +			  GET_DEGRADED |
>  			  GET_COMPONENT|
>  			  GET_CHUNK|
>  			  GET_DEVS|
> @@ -254,6 +256,12 @@
>  		goto exitHere;
>  	}
>  
> +	if(info->array.failed_disks > 0) {
> +		fprintf(stderr, "%s: %s degraded array\n", prg, argv[1]);
> +		exit_err = 8;
> +		goto exitHere;
> +	}
> +
>  	printf("layout: %d\n", info->array.layout);
>  	printf("disks: %d\n", info->array.raid_disks);
>  	printf("component size: %llu\n", info->component_size * 512);
> @@ -262,12 +270,13 @@
>  	printf("\n");
>  
>  	comp = info->devs;
> -	for(i = 0; i < info->array.raid_disks; i++) {
> +	for(i = 0, active_disks = 0; active_disks < info->array.raid_disks; i++) {
>  		printf("disk: %d - offset: %llu - size: %llu - name: %s - slot: %d\n",
>  			i, comp->data_offset * 512, comp->component_size * 512,
>  			map_dev(comp->disk.major, comp->disk.minor, 0),
>  			comp->disk.raid_disk);
> -
> +		if(comp->disk.raid_disk >= 0)
> +			active_disks++;
>  		comp = comp->next;
>  	}
>  	printf("\n");
> @@ -317,18 +326,20 @@
>  	close_flag = 1;
>  
>  	comp = info->devs;
> -	for (i=0; i<raid_disks; i++) {
> +	for (i=0, active_disks=0; active_disks<raid_disks; i++) {
>  		int disk_slot = comp->disk.raid_disk;
> -		disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
> -		offsets[disk_slot] = comp->data_offset * 512;
> -		fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
> -		if (fds[disk_slot] < 0) {
> -			perror(disk_name[disk_slot]);
> -			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
> -			exit_err = 6;
> -			goto exitHere;
> +		if(disk_slot >= 0) {
> +			disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
> +			offsets[disk_slot] = comp->data_offset * 512;
> +			fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
> +			if (fds[disk_slot] < 0) {
> +				perror(disk_name[disk_slot]);
> +				fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
> +				exit_err = 6;
> +				goto exitHere;
> +			}
> +			active_disks++;
>  		}
> -
>  		comp = comp->next;
>  	}
>  
> --- cut here ---
> 
> bye,
> 

