From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH] mdadm/Detail: show correct state for cluster-md array
Date: Sat, 18 Jul 2020 01:55:20 +0800
Message-ID: <030cd214-f573-2942-353b-c0fac70905f2@suse.com>
References: <1595008271-3234-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595008271-3234-1-git-send-email-heming.zhao@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

I am very sorry, this patch contains bug.
please ignore this mail.
I will resend this patch very soon.

On 7/18/20 1:51 AM, Zhao Heming wrote:
> After kernel md module commit 480523feae581, in md-cluster env,
> mddev->in_sync always zero, it will make array.state never set
> up MD_SB_CLEAN. it causes "mdadm -D /dev/mdX" show state 'active'
> all the time.
> 
> bitmap.c: add a new API IsBitmapDirty() to support inquiry bitmap
> dirty or clean.
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   Detail.c | 21 ++++++++++++++++++++-
>   bitmap.c | 22 ++++++++++++++++++++++
>   mdadm.h  |  1 +
>   3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 24eeba0..fd580a3 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -495,8 +495,27 @@ int Detail(char *dev, struct context *c)
>   							  sra->array_state);
>   				else
>   					arrayst = "clean";
> -			} else
> +			} else {
>   				arrayst = "active";
> +				if (array.state & (1<<MD_SB_CLUSTERED)) {
> +					int dirty = 0;
> +					for (d = 0; d < max_disks * 2; d++) {
> +						char *dv;
> +						mdu_disk_info_t disk = disks[d];
> +
> +						if (d >= array.raid_disks * 2 &&
> +								disk.major == 0 && disk.minor == 0)
> +							continue;
> +						if ((d & 1) && disk.major == 0 && disk.minor == 0)
> +							continue;
> +						dv = map_dev_preferred(disk.major, disk.minor, 0, c->prefer);
> +						if (dv != NULL)
> +							if ((dirty = IsBitmapDirty(dv))) break;
> +					}
> +					if (dirty == 0)
> +						arrayst = "clean";
> +				}
> +			}
>   
>   			printf("             State : %s%s%s%s%s%s%s \n",
>   			       arrayst, st,
> diff --git a/bitmap.c b/bitmap.c
> index e38cb96..10c2045 100644
> --- a/bitmap.c
> +++ b/bitmap.c
> @@ -368,6 +368,28 @@ free_info:
>   	return rv;
>   }
>   
> +int IsBitmapDirty(char *filename)
> +{
> +	/*
> +	 * Read the bitmap file
> +	 * return: 1(dirty), 0 (clean), -1(error)
> +	 */
> +
> +	struct supertype *st = NULL;
> +	bitmap_info_t *info;
> +	int fd = -1, rv = -1;
> +
> +	fd = bitmap_file_open(filename, &st, 0);
> +	if (fd < 0)
> +		return rv;
> +
> +	info = bitmap_fd_read(fd, 0);
> +	if (!info)
> +		return rv;
> +	close(fd);
> +	return info->dirty_bits ? 1 : 0;
> +}
> +
>   int CreateBitmap(char *filename, int force, char uuid[16],
>   		 unsigned long chunksize, unsigned long daemon_sleep,
>   		 unsigned long write_behind,
> diff --git a/mdadm.h b/mdadm.h
> index 399478b..ba8ba91 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1447,6 +1447,7 @@ extern int CreateBitmap(char *filename, int force, char uuid[16],
>   			unsigned long long array_size,
>   			int major);
>   extern int ExamineBitmap(char *filename, int brief, struct supertype *st);
> +extern int IsBitmapDirty(char *filename);
>   extern int Write_rules(char *rule_name);
>   extern int bitmap_update_uuid(int fd, int *uuid, int swap);
>   
> 
