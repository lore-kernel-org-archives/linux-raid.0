From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 33/53] Prepare and free fdlist in functions
Date: Tue, 30 Nov 2010 13:28:33 +1100
Message-ID: <20101130132833.0c063c80@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080808.5221.94530.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080808.5221.94530.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:08:08 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> fd handles table creation is put in to function for code reuse.
> 
> In manage_reshape(), child_grow() function from Grow.c will be reused.
> To prepare parameters for this function, code from Grow.c can be reused also.
> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

I've applied this, though I changed the "_in" parameters to simple
pass-by-value parameters, and removed all the NULL checks which are fairly
pointless - if those values are zero it would be wrong to continue, you
should just abort, which is what will now happen anyway.

NeilBrown



> ---
> 
>  Grow.c  |  136 ++++++++++++++++++++++++++++++++++++++++++++++++---------------
>  mdadm.h |   11 +++++
>  2 files changed, 115 insertions(+), 32 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 347f07b..8cba82b 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -832,6 +832,103 @@ int remove_disks_on_raid10_to_raid0_takeover(struct supertype *st,
>  	return 0;
>  }
>  
> +void reshape_free_fdlist(int **fdlist_in,
> +			 unsigned long long **offsets_in,
> +			 int size)
> +{
> +	int i;
> +	int *fdlist;
> +	unsigned long long *offsets;
> +	if ((offsets_in == NULL) || (offsets_in == NULL)) {
> +		dprintf(Name " Error: Parameters verification error #1.\n");
> +		return;
> +	}
> +
> +	fdlist = *fdlist_in;
> +	offsets = *offsets_in;
> +	if ((fdlist == NULL) || (offsets == NULL)) {
> +		dprintf(Name " Error: Parameters verification error #2.\n");
> +		return;
> +	}
> +
> +	for (i = 0; i < size; i++) {
> +		if (fdlist[i] > 0)
> +			close(fdlist[i]);
> +	}
> +
> +	free(fdlist);
> +	free(offsets);
> +	*fdlist_in = NULL;
> +	*offsets_in = NULL;
> +}
> +
> +int reshape_prepare_fdlist(char *devname,
> +			   struct mdinfo *sra,
> +			   int raid_disks,
> +			   int nrdisks,
> +			   unsigned long blocks,
> +			   char *backup_file,
> +			   int **fdlist_in,
> +			   unsigned long long **offsets_in)
> +{
> +	int d = 0;
> +	int *fdlist;
> +	unsigned long long *offsets;
> +	struct mdinfo *sd;
> +
> +	if ((devname == NULL) || (sra == NULL) ||
> +	    (fdlist_in == NULL) || (offsets_in == NULL)) {
> +		dprintf(Name " Error: Parameters verification error #1.\n");
> +		d = -1;
> +		goto release;
> +	}
> +
> +	fdlist = *fdlist_in;
> +	offsets = *offsets_in;
> +
> +	if ((fdlist == NULL) || (offsets == NULL)) {
> +		dprintf(Name " Error: Parameters verification error #2.\n");
> +		d = -1;
> +		goto release;
> +	}
> +
> +	for (d = 0; d <= nrdisks; d++)
> +		fdlist[d] = -1;
> +	d = raid_disks;
> +	for (sd = sra->devs; sd; sd = sd->next) {
> +		if (sd->disk.state & (1<<MD_DISK_FAULTY))
> +			continue;
> +		if (sd->disk.state & (1<<MD_DISK_SYNC)) {
> +			char *dn = map_dev(sd->disk.major,
> +					   sd->disk.minor, 1);
> +			fdlist[sd->disk.raid_disk]
> +				= dev_open(dn, O_RDONLY);
> +			offsets[sd->disk.raid_disk] = sd->data_offset*512;
> +			if (fdlist[sd->disk.raid_disk] < 0) {
> +				fprintf(stderr, Name ": %s: cannot open component %s\n",
> +					devname, dn ? dn : "-unknown-");
> +				d = -1;
> +				goto release;
> +			}
> +		} else if (backup_file == NULL) {
> +			/* spare */
> +			char *dn = map_dev(sd->disk.major,
> +					   sd->disk.minor, 1);
> +				fdlist[d] = dev_open(dn, O_RDWR);
> +				offsets[d] = (sd->data_offset + sra->component_size - blocks - 8)*512;
> +				if (fdlist[d] < 0) {
> +					fprintf(stderr, Name ": %s: cannot open component %s\n",
> +						devname, dn ? dn : "-unknown-");
> +					d = -1;
> +					goto release;
> +				}
> +				d++;
> +			}
> +		}
> +release:
> +	return d;
> +}
> +
>  int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  		 long long size,
>  		 int level, char *layout_str, int chunksize, int raid_disks)
> @@ -1547,38 +1644,13 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  			rv = 1;
>  			break;
>  		}
> -		for (d=0; d <= nrdisks; d++)
> -			fdlist[d] = -1;
> -		d = array.raid_disks;
> -		for (sd = sra->devs; sd; sd=sd->next) {
> -			if (sd->disk.state & (1<<MD_DISK_FAULTY))
> -				continue;
> -			if (sd->disk.state & (1<<MD_DISK_SYNC)) {
> -				char *dn = map_dev(sd->disk.major,
> -						   sd->disk.minor, 1);
> -				fdlist[sd->disk.raid_disk]
> -					= dev_open(dn, O_RDONLY);
> -				offsets[sd->disk.raid_disk] = sd->data_offset*512;
> -				if (fdlist[sd->disk.raid_disk] < 0) {
> -					fprintf(stderr, Name ": %s: cannot open component %s\n",
> -						devname, dn?dn:"-unknown-");
> -					rv = 1;
> -					goto release;
> -				}
> -			} else if (backup_file == NULL) {
> -				/* spare */
> -				char *dn = map_dev(sd->disk.major,
> -						   sd->disk.minor, 1);
> -				fdlist[d] = dev_open(dn, O_RDWR);
> -				offsets[d] = (sd->data_offset + sra->component_size - blocks - 8)*512;
> -				if (fdlist[d]<0) {
> -					fprintf(stderr, Name ": %s: cannot open component %s\n",
> -						devname, dn?dn:"-unknown");
> -					rv = 1;
> -					goto release;
> -				}
> -				d++;
> -			}
> +
> +		d = reshape_prepare_fdlist(devname, sra, array.raid_disks,
> +					nrdisks, blocks, backup_file,
> +					&fdlist, &offsets);
> +		if (d < 0) {
> +			rv = 1;
> +			goto release;
>  		}
>  		if (backup_file == NULL) {
>  			if (st->ss->external && !st->ss->manage_reshape) {
> diff --git a/mdadm.h b/mdadm.h
> index 750afcc..698f1bf 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -448,6 +448,17 @@ extern int sysfs_unique_holder(int devnum, long rdev);
>  extern int sysfs_freeze_array(struct mdinfo *sra);
>  extern int load_sys(char *path, char *buf);
>  extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
> +extern int reshape_prepare_fdlist(char *devname,
> +				  struct mdinfo *sra,
> +				  int raid_disks,
> +				  int nrdisks,
> +				  unsigned long blocks,
> +				  char *backup_file,
> +				  int **fdlist_in,
> +				  unsigned long long **offsets_in);
> +extern void reshape_free_fdlist(int **fdlist_in,
> +				unsigned long long **offsets_in,
> +				int size);
>  
>  
>  extern int save_stripes(int *source, unsigned long long *offsets,

