From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 34/53] Compute backup blocks in function.
Date: Tue, 30 Nov 2010 13:32:31 +1100
Message-ID: <20101130133231.693939b2@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080816.5221.1108.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080816.5221.1108.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:08:16 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> number of backup blocks evaluation is put in to function for code reuse.

Applied, thanks.

NeilBrown


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  Grow.c  |   44 +++++++++++++++++++++++++++-----------------
>  mdadm.h |    4 +++-
>  2 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 8cba82b..8cc17d5 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -929,6 +929,31 @@ release:
>  	return d;
>  }
>  
> +unsigned long compute_backup_blocks(int nchunk, int ochunk,
> +				    unsigned int ndata, unsigned int odata)
> +{
> +	unsigned long a, b, blocks;
> +	/* So how much do we need to backup.
> +	 * We need an amount of data which is both a whole number of
> +	 * old stripes and a whole number of new stripes.
> +	 * So LCM for (chunksize*datadisks).
> +	 */
> +	a = (ochunk/512) * odata;
> +	b = (nchunk/512) * ndata;
> +	/* Find GCD */
> +	while (a != b) {
> +		if (a < b)
> +			b -= a;
> +		if (b < a)
> +			a -= b;
> +	}
> +	/* LCM == product / GCD */
> +	blocks = (ochunk/512) * (nchunk/512) * odata * ndata / a;
> +
> +	return blocks;
> +}
> +
> +
>  int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  		 long long size,
>  		 int level, char *layout_str, int chunksize, int raid_disks)
> @@ -967,7 +992,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  	int nrdisks;
>  	int err;
>  	int frozen;
> -	unsigned long a,b, blocks, stripes;
> +	unsigned long blocks, stripes;
>  	unsigned long cache;
>  	unsigned long long array_size;
>  	int changed = 0;
> @@ -1587,22 +1612,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  			break;
>  		}
>  
> -		/* So how much do we need to backup.
> -		 * We need an amount of data which is both a whole number of
> -		 * old stripes and a whole number of new stripes.
> -		 * So LCM for (chunksize*datadisks).
> -		 */
> -		a = (ochunk/512) * odata;
> -		b = (nchunk/512) * ndata;
> -		/* Find GCD */
> -		while (a != b) {
> -			if (a < b)
> -				b -= a;
> -			if (b < a)
> -				a -= b;
> -		}
> -		/* LCM == product / GCD */
> -		blocks = (ochunk/512) * (nchunk/512) * odata * ndata / a;
> +		blocks = compute_backup_blocks(nchunk, ochunk, ndata, odata);
>  
>  		sysfs_free(sra);
>  		sra = sysfs_read(fd, 0,
> diff --git a/mdadm.h b/mdadm.h
> index 698f1bf..06195c8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -459,7 +459,8 @@ extern int reshape_prepare_fdlist(char *devname,
>  extern void reshape_free_fdlist(int **fdlist_in,
>  				unsigned long long **offsets_in,
>  				int size);
> -
> +extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
> +					   unsigned int ndata, unsigned int odata);
>  
>  extern int save_stripes(int *source, unsigned long long *offsets,
>  			int raid_disks, int chunk_size, int level, int layout,
> @@ -471,6 +472,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
>  			   int source, unsigned long long read_offset,
>  			   unsigned long long start, unsigned long long length);
>  
> +
>  #ifndef Sendmail
>  #define Sendmail "/usr/lib/sendmail -t"
>  #endif

