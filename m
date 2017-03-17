From: jes.sorensen@gmail.com
Subject: Re: [PATCH 1/3] mdadm: Replace snprintf with strncpy at some places to avoid truncation
Date: Fri, 17 Mar 2017 15:55:43 -0400
Message-ID: <wrfjh92rk79c.fsf@gmail.com>
References: <1489751743-11397-1-git-send-email-xni@redhat.com>
        <1489751743-11397-2-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489751743-11397-2-git-send-email-xni@redhat.com> (Xiao Ni's
        message of "Fri, 17 Mar 2017 19:55:41 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> In gcc7 there are some building errors like:
> directive output may be truncated writing up to 31 bytes into a region of size 24
> snprintf(str, MPB_SIG_LEN, %s, mpb->sig);
>
> It just need to copy one string to target. So use strncpy to replace it.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super-intel.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index d5e9517..e1618f1 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1811,7 +1811,8 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
>  	__u32 reserved = imsm_reserved_sectors(super, super->disks);
>  	struct dl *dl;
>  
> -	snprintf(str, MPB_SIG_LEN, "%s", mpb->sig);
> +	strncpy(str, (char *)mpb->sig, MPB_SIG_LEN);
> +	str[MPB_SIG_LEN-1] = '\0';
>  	printf("          Magic : %s\n", str);
>  	snprintf(str, strlen(MPB_VERSION_RAID0), "%s", get_imsm_version(mpb));
>  	printf("        Version : %s\n", get_imsm_version(mpb));

Given str is defined as 'char str[MAX_SIGNATURE_LENGTH]', it would be
more correct to use MAX_SIGNATURE_LENGTH as the size limit here.

> @@ -5227,7 +5228,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
>  			disk->status = CONFIGURED_DISK | FAILED_DISK;
>  			disk->scsi_id = __cpu_to_le32(~(__u32)0);
>  			snprintf((char *) disk->serial, MAX_RAID_SERIAL_LEN,
> -				 "missing:%d", i);
> +				 "missing:%d", (__u8)i);
>  		}
>  		find_missing(super);
>  	} else {

This is unrelated to the commit message.

> @@ -7142,14 +7143,16 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
>  
>  			u->type = update_rename_array;
>  			u->dev_idx = vol;
> -			snprintf((char *) u->name, MAX_RAID_SERIAL_LEN, "%s", name);
> +			strncpy((char *) u->name, name, MAX_RAID_SERIAL_LEN);
> +			u->name[MAX_RAID_SERIAL_LEN-1] = '\0';
>  			append_metadata_update(st, u, sizeof(*u));
>  		} else {
>  			struct imsm_dev *dev;
>  			int i;
>  
>  			dev = get_imsm_dev(super, vol);
> -			snprintf((char *) dev->volume, MAX_RAID_SERIAL_LEN, "%s", name);
> +			strncpy((char *) dev->volume, name, MAX_RAID_SERIAL_LEN);
> +			dev->volume[MAX_RAID_SERIAL_LEN-1] = '\0';
>  			for (i = 0; i < mpb->num_raid_devs; i++) {
>  				dev = get_imsm_dev(super, i);
>  				handle_missing(super, dev);

These two look fine.

Jes
