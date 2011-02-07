From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Re: User space RAID-6 access
Date: Tue, 8 Feb 2011 09:49:52 +1100
Message-ID: <20110208094952.49745c7b@notabene.brown>
References: <20110131202054.GA15712@lazy.lzy>
	<20110201075259.4beaf501@notabene.brown>
	<20110205173334.GA5952@lazy.lzy>
	<20110206075820.08fc19c9@notabene.brown>
	<20110207222459.GA25471@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110207222459.GA25471@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 7 Feb 2011 23:24:59 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> > test_stripe assumes that the data starts at the start of each device.
> > AS you are using 1.2 metadata (the default), data starts about 1M in to
> > the device (I think - you can check with --examine)
> > 
> > You could fix test_stripe to put the right value in the 'offsets' array,
> > or you could create the array with 1.0 or 0.90 metadata.
> 
> Hi Neil,
> 
> thanks for the info, maybe this should be a second patch.
> 
> In the meantime, please find attached a patch to restripe.c
> of mdadm 3.2 (latest, I hope).
> 
> This should add the functionality to detect, in RAID-6,
> which of the disks potentially has problems, in case of
> parity errors.
> 
> Some checks take place in order to avoid false positives,
> I hope these are correct and enough.
> 
> I'm not 100% happy of the interface (too much redundancy),
> but for the time being it could be OK.
> 
> Of course, any improvement is welcome.
> 
> Please consider to include these changes to the next mdadm
> whatever release.
> 

Thanks a lot!

I have applied some patch - with some formatting changes to make it consistent
with the rest of the code.

I don't really have time to look more deeply at it at the moment.
Maybe someone else will?...

Thanks,
NeilBrown


> bye,
> 
> --- restripe.c.org	2011-01-13 05:52:15.000000000 +0100
> +++ restripe.c	2011-02-07 22:51:01.539471472 +0100
> @@ -285,10 +285,13 @@
>  uint8_t raid6_gfexp[256];
>  uint8_t raid6_gfinv[256];
>  uint8_t raid6_gfexi[256];
> +uint8_t raid6_gflog[256];
> +uint8_t raid6_gfilog[256];
>  void make_tables(void)
>  {
>  	int i, j;
>  	uint8_t v;
> +	uint32_t b, log;
>  
>  	/* Compute multiplication table */
>  	for (i = 0; i < 256; i++)
> @@ -312,6 +315,19 @@
>  	for (i = 0; i < 256; i ++)
>  		raid6_gfexi[i] = raid6_gfinv[raid6_gfexp[i] ^ 1];
>  
> +	/* Compute log and inverse log */
> +	/* Modified code from: http://web.eecs.utk.edu/~plank/plank/papers/CS-96-332.html */
> +	b = 1;
> +	raid6_gflog[0] = 0;
> +	raid6_gfilog[255] = 0;
> +
> +	for (log = 0; log < 255; log++) {
> +	  raid6_gflog[b] = (uint8_t) log;
> +	  raid6_gfilog[log] = (uint8_t) b;
> +	  b = b << 1;
> +	  if (b & 256) b = b ^ 0435;
> +	}
> +
>  	tables_ready = 1;
>  }
>  
> @@ -387,6 +403,65 @@
>  	}
>  }
>  
> +/* Try to find out if a specific disk has a problem */
> +int raid6_check_disks(int data_disks, int start, int chunk_size, int level, int layout, int diskP, int diskQ, char *p, char *q, char **stripes)
> +{
> +  int i;
> +  int data_id, diskD;
> +  uint8_t Px, Qx;
> +  int curr_broken_disk = -1;
> +  int prev_broken_disk = -1;
> +  int broken_status = 0;
> +
> +  for(i = 0; i < chunk_size; i++) {
> +    Px = (uint8_t)stripes[diskP][i] ^ (uint8_t)p[i];
> +    Qx = (uint8_t)stripes[diskQ][i] ^ (uint8_t)q[i];
> +
> +    if((Px != 0) && (Qx == 0)) {
> +      curr_broken_disk = diskP;
> +    }
> +
> +    if((Px == 0) && (Qx != 0)) {
> +      curr_broken_disk = diskQ;
> +    }
> +
> +    if((Px != 0) && (Qx != 0)) {
> +      data_id = (raid6_gflog[Qx] - raid6_gflog[Px]) & 0xFF;
> +      diskD = geo_map(data_id, start/chunk_size, data_disks + 2, level, layout);
> +      curr_broken_disk = diskD;
> +    }
> +
> +    if((Px == 0) && (Qx == 0)) {
> +      curr_broken_disk = curr_broken_disk;
> +    }
> +
> +    switch(broken_status) {
> +    case 0:
> +      if(curr_broken_disk != -1) {
> +	prev_broken_disk = curr_broken_disk;
> +	broken_status = 1;
> +      }
> +      break;
> +
> +    case 1:
> +      if(curr_broken_disk != prev_broken_disk) {
> +	broken_status = 2;
> +      }
> +      if(curr_broken_disk >= data_disks + 2) {
> +	broken_status = 2;
> +      }
> +      break;
> +
> +    case 2:
> +    default:
> +      curr_broken_disk = prev_broken_disk = -2;
> +      break;
> +    }
> +  }
> +
> +  return curr_broken_disk;
> +}
> +
>  /* Save data:
>   * We are given:
>   *  A list of 'fds' of the active disks.  Some may be absent.
> @@ -673,7 +748,12 @@
>  	char *q = malloc(chunk_size);
>  
>  	int i;
> +	int diskP, diskQ;
>  	int data_disks = raid_disks - (level == 5 ? 1: 2);
> +
> +	if (!tables_ready)
> +		make_tables();
> +
>  	for ( i = 0 ; i < raid_disks ; i++)
>  		stripes[i] = stripe_buf + i * chunk_size;
>  
> @@ -693,18 +773,25 @@
>  		switch(level) {
>  		case 6:
>  			qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
> -			disk = geo_map(-1, start/chunk_size, raid_disks,
> +			diskP = geo_map(-1, start/chunk_size, raid_disks,
>  				       level, layout);
> -			if (memcmp(p, stripes[disk], chunk_size) != 0) {
> -				printf("P(%d) wrong at %llu\n", disk,
> +			if (memcmp(p, stripes[diskP], chunk_size) != 0) {
> +				printf("P(%d) wrong at %llu\n", diskP,
>  				       start / chunk_size);
>  			}
> -			disk = geo_map(-2, start/chunk_size, raid_disks,
> +			diskQ = geo_map(-2, start/chunk_size, raid_disks,
>  				       level, layout);
> -			if (memcmp(q, stripes[disk], chunk_size) != 0) {
> -				printf("Q(%d) wrong at %llu\n", disk,
> +			if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
> +				printf("Q(%d) wrong at %llu\n", diskQ,
>  				       start / chunk_size);
>  			}
> +			disk = raid6_check_disks(data_disks, start, chunk_size, level, layout, diskP, diskQ, p, q, stripes);
> +			if(disk >= 0) {
> +			  printf("Possible failed disk: %d\n", disk);
> +			}
> +			if(disk == -2) {
> +			  printf("Failure detected, but disk unknown\n");
> +			}
>  			break;
>  		}
>  		length -= chunk_size;
> 

