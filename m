From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Thu, 4 May 2017 20:20:55 +0800
Message-ID: <430f083a-2501-cb74-4ac1-89d1c4620a03@suse.com>
References: <1493190229-14329-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1493190229-14329-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jes,

apply for review, this is a bug I ever encountered.


On 04/26/2017 03:03 PM, Zhilong Liu wrote:
> The sysfs entry and devnm would be created once create_mddev()
> performed successfully, but the creating isn't completed here,
> move STOP_ARRAY to abort_locked, the purpose is to cleanup the
> partially created array.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>   Create.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/Create.c b/Create.c
> index 6ca0924..fe0ab7e 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -904,10 +904,8 @@ int Create(struct supertype *st, char *mddev,
>   					remove_partitions(fd);
>   				if (st->ss->add_to_super(st, &inf->disk,
>   							 fd, dv->devname,
> -							 dv->data_offset)) {
> -					ioctl(mdfd, STOP_ARRAY, NULL);
> +							 dv->data_offset))
>   					goto abort_locked;
> -				}
>   				st->ss->getinfo_super(st, inf, NULL);
>   				safe_mode_delay = inf->safe_mode_delay;
>   
> @@ -1008,7 +1006,6 @@ int Create(struct supertype *st, char *mddev,
>   			sysfs_set_safemode(&info, safe_mode_delay);
>   			if (err) {
>   				pr_err("failed to activate array.\n");
> -				ioctl(mdfd, STOP_ARRAY, NULL);
>   				goto abort;
>   			}
>   		} else if (c->readonly &&
> @@ -1018,7 +1015,6 @@ int Create(struct supertype *st, char *mddev,
>   					  "array_state", "readonly") < 0) {
>   				pr_err("Failed to start array: %s\n",
>   				       strerror(errno));
> -				ioctl(mdfd, STOP_ARRAY, NULL);
>   				goto abort;
>   			}
>   		} else {
> @@ -1030,7 +1026,6 @@ int Create(struct supertype *st, char *mddev,
>   				if (info.array.chunk_size & (info.array.chunk_size-1)) {
>   					cont_err("Problem may be that chunk size is not a power of 2\n");
>   				}
> -				ioctl(mdfd, STOP_ARRAY, NULL);
>   				goto abort;
>   			}
>   			/* if start_ro module parameter is set, array is
> @@ -1061,7 +1056,9 @@ int Create(struct supertype *st, char *mddev,
>   	map_remove(&map, fd2devnm(mdfd));
>   	map_unlock(&map);
>   
> -	if (mdfd >= 0)
> +	if (mdfd >= 0) {
> +		ioctl(mdfd, STOP_ARRAY, NULL);
>   		close(mdfd);
> +	}
>   	return 1;
>   }

