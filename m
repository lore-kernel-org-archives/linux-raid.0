From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Sat, 30 Jun 2012 13:48:31 +0200
Message-ID: <20120630114831.GA3034@lazy.lzy>
References: <10900468.MPSjVn2C3J@peanut>
 <5100581.utCIcpy8f5@peanut>
 <20120621182326.GA2144@lazy.lzy>
 <1436304.MN64neqUEr@peanut>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436304.MN64neqUEr@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Buchholz <robert.buchholz@goodpoint.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Robert,

very good you provide these patches!

Please see the comments below.

On Fri, Jun 29, 2012 at 08:16:13PM +0200, Robert Buchholz wrote:
[...]
> I'll attach a set of patches that add a repair mode to raid6check. While 

I think, I'm not sure, Neil Brown should/will
apply the pathes to the main tree.
In any case I expect a comment from him.

> the tool currently can detect failure of a single slot, and it could 
> automatically repair that, I chose to make repair an explicit action.
> In fact, even the slice number and the two slots to repair are given via 
> the command line. 
> 
> So for example, given this output of raid6check (check mode):
> Error detected at 1: possible failed disk slot: 5 --> /dev/sda1
> Error detected at 2: possible failed disk slot: 3 --> /dev/sdb1
> Error detected at 3: disk slot unknown
> 
> To regenerate 1 and 2, run:
> raid6check /dev/md0 repair 1 5 3
> raid6check /dev/md0 repair 2 5 3
> (the repair arguments require you to always rebuild two blocks, one of 
> which should result in a noop in these cases)

Why always two blocks?
 
> Since for stripe 3, two slots must be wrong, the admin has to provide a 

Well, "unknown" means it is not possible to detect
which one(s).
It could be there are more than 2 corrupted.
The "unknown" case means that the only reasonable thing
would be to rebuild the parities, but nothing more can
be said about the status of the array.

Nevertheless, there is a possibility which I was thinking
about, but I never had time to implement (even if the
software has some already built-in infrastructure for it).
Specifically, a "vertical" statistic.
That is, if there are mismatches, and, for example, 90% of
them belong to /dev/sdX, and the rest 10% are "unknown",
then it could be possible to extrapolate that, for the
"unknown", /dev/sdX must be fixed anyway and then re-check
if the status is still "unknown" or some other disk shows
up. If one disk is reported, then it could be fixed.
Other cases, the parity must be adjusted, whatever this
means in terms of data recovery.

Of course, this is just a statistical assumption, which
means a second, "aggressive", option will have to be
available, with all the warnings of the case.

> guess (and could iterate guesses, provided proper stripe backups):
> raid6check /dev/md0 repair 3 5 3

Actually, this could also be an improvement, I mean
the possibility to backup stripes, so that other,
advanced, recovery could be tried and reverted, if
necessary.

Finally, someone should consider to use the optimized
raid6 code, from the kernel module (can we link that
code directly?), in order to speed up the check/repair.

Thanks again for the patches, good job!

bye,

pg
 
> I'd very much like to add cache invalidation (of the data buffered from 
> the md device) to the tool, maybe someone has a pointer how to do that.
> 
> 
> Cheers
> Robert

> >From 909cf4e15e6bc3eaca49b9d0bd09e55ecf20b059 Mon Sep 17 00:00:00 2001
> From: Robert Buchholz <rbu@goodpoint.de>
> Date: Fri, 29 Jun 2012 19:15:45 +0200
> Subject: [PATCH 1/3] Extract function to generate zeroes and expose xor function
> 
> ---
>  restripe.c |   25 +++++++++++++++----------
>  1 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/restripe.c b/restripe.c
> index 00e7a82..fe365a3 100644
> --- a/restripe.c
> +++ b/restripe.c
> @@ -211,7 +211,7 @@ static int is_ddf(int layout)
>  }
>  
>  
> -static void xor_blocks(char *target, char **sources, int disks, int size)
> +void xor_blocks(char *target, char **sources, int disks, int size)
>  {
>  	int i, j;
>  	/* Amazingly inefficient... */
> @@ -337,6 +337,19 @@ uint8_t *zero;
>  int zero_size;
>  /* Following was taken from linux/drivers/md/raid6recov.c */
>  
> +void ensure_zero_has_size(int chunk_size)
> +{
> +	if (zero == NULL || chunk_size > zero_size) {
> +		if (zero)
> +			free(zero);
> +		zero = malloc(chunk_size);
> +		if (zero)
> +			memset(zero, 0, chunk_size);
> +		zero_size = chunk_size;
> +	}
> +}
> +
> +
>  /* Recover two failed data blocks. */
>  void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
>  		       uint8_t **ptrs)
> @@ -510,15 +523,7 @@ int save_stripes(int *source, unsigned long long *offsets,
>  
>  	if (!tables_ready)
>  		make_tables();
> -
> -	if (zero == NULL || chunk_size > zero_size) {
> -		if (zero)
> -			free(zero);
> -		zero = malloc(chunk_size);
> -		if (zero)
> -			memset(zero, 0, chunk_size);
> -		zero_size = chunk_size;
> -	}
> +	ensure_zero_has_size(chunk_size);
>  
>  	len = data_disks * chunk_size;
>  	length_test = length / len;
> -- 
> 1.7.3.4
> 

> >From fcbfdbd2a692f84330a2506c1d57222b6bc5a252 Mon Sep 17 00:00:00 2001
> From: Robert Buchholz <rbu@goodpoint.de>
> Date: Fri, 29 Jun 2012 19:19:29 +0200
> Subject: [PATCH 2/3] Make test a bash script (as it is)
> 
> ---
>  test |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/test b/test
> index 80e1915..9340afe 100755
> --- a/test
> +++ b/test
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  #
>  # run test suite for mdadm
>  user=`id -un`
> -- 
> 1.7.3.4
> 

> >From 0afe4f87a63232fd5da52133222ab149163b324d Mon Sep 17 00:00:00 2001
> From: Robert Buchholz <rbu@goodpoint.de>
> Date: Fri, 29 Jun 2012 19:32:49 +0200
> Subject: [PATCH 3/3] Repair mode for raid6
> 
> In repair mode, raid6check will rewrite one single stripe
> by regenerating the data (or parity) of two raid devices that
> are specified via the command line.
> If you need to rewrite just one slot, pick any other slot
> at random.
> 
> Note that the repair option will change data on the disks
> directly, so both the md layer above as well as any layers
> above md (such as filesystems) may be accessing the stripe
> data from cached buffers. Either instruct the kernels
> to drop the caches or reassemble the raid after repair.
> ---
>  raid6check.c        |  127 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  tests/19raid6repair |   47 +++++++++++++++++++
>  2 files changed, 169 insertions(+), 5 deletions(-)
>  create mode 100644 tests/19raid6repair
> 
> diff --git a/raid6check.c b/raid6check.c
> index d4b6085..95a0721 100644
> --- a/raid6check.c
> +++ b/raid6check.c
> @@ -31,6 +31,12 @@ int geo_map(int block, unsigned long long stripe, int raid_disks,
>  	    int level, int layout);
>  void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size);
>  void make_tables(void);
> +void ensure_zero_has_size(int chunk_size);
> +void raid6_datap_recov(int disks, size_t bytes, int faila, uint8_t **ptrs);
> +void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
> +		       uint8_t **ptrs);
> +void xor_blocks(char *target, char **sources, int disks, int size);
> +
>  
>  /* Collect per stripe consistency information */
>  void raid6_collect(int chunk_size, uint8_t *p, uint8_t *q,
> @@ -103,7 +109,8 @@ int raid6_stats(int *results, int raid_disks, int chunk_size)
>  
>  int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
>  		  int raid_disks, int chunk_size, int level, int layout,
> -		  unsigned long long start, unsigned long long length, char *name[])
> +		  unsigned long long start, unsigned long long length, char *name[],
> +		  int repair, int failed_disk1, int failed_disk2)
>  {
>  	/* read the data and p and q blocks, and check we got them right */
>  	char *stripe_buf = malloc(raid_disks * chunk_size);
> @@ -180,10 +187,13 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
>  
>  		qsyndrome(p, q, (uint8_t**)blocks, data_disks, chunk_size);
>  		diskP = geo_map(-1, start, raid_disks, level, layout);
> +		diskQ = geo_map(-2, start, raid_disks, level, layout);
> +		blocks[data_disks] = stripes[diskP];
> +		blocks[data_disks+1] = stripes[diskQ];
> +		
>  		if (memcmp(p, stripes[diskP], chunk_size) != 0) {
>  			printf("P(%d) wrong at %llu\n", diskP, start);
>  		}
> -		diskQ = geo_map(-2, start, raid_disks, level, layout);
>  		if (memcmp(q, stripes[diskQ], chunk_size) != 0) {
>  			printf("Q(%d) wrong at %llu\n", diskQ, start);
>  		}
> @@ -200,6 +210,80 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
>  		if(disk == -65535) {
>  			printf("Error detected at %llu: disk slot unknown\n", start);
>  		}
> +		if(repair == 1) {
> +			printf("Repairing stripe %llu\n", start);
> +			printf("Assuming slots %d (%s) and %d (%s) are incorrect\n", failed_disk1, name[failed_disk1], failed_disk2, name[failed_disk2]);
> +			
> +			if (failed_disk1 == diskQ || failed_disk2 == diskQ) {
> +				int failed_data;
> +				if (failed_disk1 == diskQ)
> +					failed_data = failed_disk2;
> +				else
> +					failed_data = failed_disk1;
> +				printf("Repairing D/P(%d) and Q\n", failed_data);
> +				int failed_block_index = geo_map(failed_data, start, raid_disks, level, layout);
> +				char *all_but_failed_blocks[data_disks];
> +				for (i=0; i < data_disks; i++)
> +					if (failed_block_index == i)
> +						all_but_failed_blocks[i] = stripes[diskP];
> +					else
> +						all_but_failed_blocks[i] = blocks[i];
> +				xor_blocks(stripes[failed_data],
> +					all_but_failed_blocks, data_disks, chunk_size);
> +				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
> +			} else {
> +				ensure_zero_has_size(chunk_size);
> +				if (failed_disk1 == diskP || failed_disk2 == diskP) {
> +					int failed_data;
> +					if (failed_disk1 == diskP)
> +						failed_data = failed_disk2;
> +					else
> +						failed_data = failed_disk1;
> +					int failed_block_index = geo_map(failed_data, start, raid_disks, level, layout);
> +					printf("Repairing D(%d) and P\n", failed_data);
> +					raid6_datap_recov(raid_disks, chunk_size, failed_block_index, (uint8_t**)blocks);
> +				} else {
> +					printf("Repairing D and D\n");
> +					int failed_block_index1 = geo_map(failed_disk1, start, raid_disks, level, layout);
> +					int failed_block_index2 = geo_map(failed_disk2, start, raid_disks, level, layout);
> +					if (failed_block_index1 > failed_block_index2) {
> +						int t = failed_block_index1;
> +						failed_block_index1 = failed_block_index2;
> +						failed_block_index2 = t;
> +					}
> +					raid6_2data_recov(raid_disks, chunk_size, failed_block_index1, failed_block_index2, (uint8_t**)blocks);
> +				}
> +			}
> +			if(mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
> +				err = 2;
> +				goto exitCheck;
> +			}
> +			sig[0] = signal(SIGTERM, SIG_IGN);
> +			sig[1] = signal(SIGINT, SIG_IGN);
> +			sig[2] = signal(SIGQUIT, SIG_IGN);
> +			rv = sysfs_set_num(info, NULL, "suspend_lo", start * chunk_size * data_disks);
> +			rv |= sysfs_set_num(info, NULL, "suspend_hi", (start + 1) * chunk_size * data_disks);
> +			lseek64(source[failed_disk1], offsets[failed_disk1] + start * chunk_size, 0);
> +			write(source[failed_disk1], stripes[failed_disk1], chunk_size);
> +			lseek64(source[failed_disk2], offsets[failed_disk2] + start * chunk_size, 0);
> +			write(source[failed_disk2], stripes[failed_disk2], chunk_size);
> +			rv |= sysfs_set_num(info, NULL, "suspend_lo", 0x7FFFFFFFFFFFFFFFULL);
> +			rv |= sysfs_set_num(info, NULL, "suspend_hi", 0);
> +			rv |= sysfs_set_num(info, NULL, "suspend_lo", 0);
> +			signal(SIGQUIT, sig[2]);
> +			signal(SIGINT, sig[1]);
> +			signal(SIGTERM, sig[0]);
> +			if(munlockall() != 0) {
> +				err = 3;
> +				goto exitCheck;
> +			}
> +
> +			if(rv != 0) {
> +				err = rv * 256;
> +				goto exitCheck;
> +			}
> +		}
> +
>  
>  		length--;
>  		start++;
> @@ -240,6 +324,8 @@ int main(int argc, char *argv[])
>  	int chunk_size = 0;
>  	int layout = -1;
>  	int level = 6;
> +	int repair = 0;
> +	int failed_disk1, failed_disk2;
>  	unsigned long long start, length;
>  	int i;
>  	int mdfd;
> @@ -256,6 +342,7 @@ int main(int argc, char *argv[])
>  
>  	if (argc < 4) {
>  		fprintf(stderr, "Usage: %s md_device start_stripe length_stripes\n", prg);
> +		fprintf(stderr, "   or: %s md_device repair stripe failed_slot_1 failed_slot_2\n", prg);
>  		exit_err = 1;
>  		goto exitHere;
>  	}
> @@ -321,8 +408,38 @@ int main(int argc, char *argv[])
>  	raid_disks = info->array.raid_disks;
>  	chunk_size = info->array.chunk_size;
>  	layout = info->array.layout;
> -	start = getnum(argv[2], &err);
> -	length = getnum(argv[3], &err);
> +	if (strcmp(argv[2], "repair")==0) {
> +		if (argc < 6) {
> +			fprintf(stderr, "For repair mode, call %s md_device repair stripe failed_slot_1 failed_slot_2\n", prg);
> +			exit_err = 1;
> +			goto exitHere;
> +		}
> +		repair = 1;
> +		start = getnum(argv[3], &err);
> +		length = 1;
> +		failed_disk1 = getnum(argv[4], &err);
> +		failed_disk2 = getnum(argv[5], &err);
> +		
> +		if(failed_disk1 > info->array.raid_disks) {
> +			fprintf(stderr, "%s: failed_slot_1 index is higher than number of devices in raid\n", prg);
> +			exit_err = 4;
> +			goto exitHere;
> +		}
> +		if(failed_disk2 > info->array.raid_disks) {
> +			fprintf(stderr, "%s: failed_slot_2 index is higher than number of devices in raid\n", prg);
> +			exit_err = 4;
> +			goto exitHere;
> +		}
> +		if(failed_disk1 == failed_disk2) {
> +			fprintf(stderr, "%s: failed_slot_1 and failed_slot_2 are the same\n", prg);
> +			exit_err = 4;
> +			goto exitHere;
> +		}
> +	}
> +	else {
> +		start = getnum(argv[2], &err);
> +		length = getnum(argv[3], &err);
> +	}
>  
>  	if (err) {
>  		fprintf(stderr, "%s: Bad number: %s\n", prg, err);
> @@ -380,7 +497,7 @@ int main(int argc, char *argv[])
>  
>  	int rv = check_stripes(info, fds, offsets,
>  			       raid_disks, chunk_size, level, layout,
> -			       start, length, disk_name);
> +			       start, length, disk_name, repair, failed_disk1, failed_disk2);
>  	if (rv != 0) {
>  		fprintf(stderr,
>  			"%s: check_stripes returned %d\n", prg, rv);
> diff --git a/tests/19raid6repair b/tests/19raid6repair
> new file mode 100644
> index 0000000..ed7d52d
> --- /dev/null
> +++ b/tests/19raid6repair
> @@ -0,0 +1,47 @@
> +number_of_disks=4
> +chunksize_in_kib=512
> +chunksize_in_b=$[chunksize_in_kib*1024]
> +array_data_size_in_kib=$[chunksize_in_kib*(number_of_disks-2)*number_of_disks]
> +array_data_size_in_b=$[array_data_size_in_kib*1024]
> +devs="$dev1 $dev2 $dev3 $dev4"
> +
> +# default 32 sectors
> +data_offset_in_kib=$[32/2]
> +
> +for failure in "$dev3 3 3 2" "$dev3 3 2 3" "$dev3 3 2 1" "$dev3 3 2 0" "$dev4 3 3 0" "$dev4 3 3 1" "$dev4 3 3 2" \
> +		"$dev1 3 0 1" "$dev1 3 0 2" "$dev1 3 0 3" "$dev2 3 1 0" "$dev2 3 1 2" "$dev2 3 1 3" ; do
> +	failure_split=( $failure )
> +	device_with_error=${failure_split[0]}
> +	stripe_with_error=${failure_split[1]}
> +	repair_params="$stripe_with_error ${failure_split[2]} ${failure_split[3]}"
> +	start_of_errors_in_kib=$[data_offset_in_kib+chunksize_in_kib*stripe_with_error]
> +
> +	# make a raid5 from a file
> +	dd if=/dev/urandom of=/tmp/RandFile bs=1024 count=$array_data_size_in_kib
> +	mdadm -CR $md0 -l6 -n$number_of_disks -c $chunksize_in_kib $devs
> +	dd if=/tmp/RandFile of=$md0 bs=1024 count=$array_data_size_in_kib
> +	blockdev --flushbufs $md0; sync
> +
> +	check wait
> +	blockdev --flushbufs $devs; sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +	cmp -s -n $array_data_size_in_b $md0 /tmp/RandFile || { echo sanity cmp failed ; exit 2; }
> +
> +	dd if=/dev/urandom of=$device_with_error bs=1024 count=$chunksize_in_kib seek=$start_of_errors_in_kib
> +	blockdev --flushbufs $device_with_error; sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +
> +	$dir/raid6check $md0 0 0 2>&1 | grep -qs "Error" || { echo should detect errors; exit 2; }
> +
> +	$dir/raid6check $md0 repair $repair_params > /dev/null || { echo repair failed; exit 2; }
> +	blockdev --flushbufs $md0 $devs; sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +
> +	$dir/raid6check $md0 0 0 2>&1 | grep -qs "Error" && { echo errors detected; exit 2; }
> +	cmp -s -n $array_data_size_in_b $md0 /tmp/RandFile || { echo cmp failed ; exit 2; }
> +
> +	mdadm -S $md0
> +	udevadm settle
> +	blockdev --flushbufs $md0 $devs; sync
> +	echo 3 > /proc/sys/vm/drop_caches
> +done
> \ No newline at end of file
> -- 
> 1.7.3.4
> 




-- 

piergiorgio
