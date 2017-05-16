From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear
 array
Date: Tue, 16 May 2017 12:28:53 +0800
Message-ID: <9ceaf11c-80ec-4e6c-a4ad-ef9a5b38894c@suse.com>
References: <20170512015145.18542-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170512015145.18542-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids



On 05/12/2017 09:51 AM, Lidong Zhong wrote:
> The value of sb->max_dev will always be increased by 1 when adding
> a new disk in linear array. It causes an inconsistence between each
> disk in the array and the "Array State" value of "mdadm --examine DISK"
> is wrong. For example, when adding the first new disk into linear array
> it will be:
>
> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' == active, '.' == missing, 'R' == replacing)
>
> Adding the second disk into linear array it will be
>
> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
> ('A' == active, '.' == missing, 'R' == replacing)
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  super1.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/super1.c b/super1.c
> index 87a74cb..4fb655f 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>  				break;
>  		sb->dev_number = __cpu_to_le32(i);
>  		info->disk.number = i;
> -		if (max >= __le32_to_cpu(sb->max_dev))
> +		if (i >= __le32_to_cpu(sb->max_dev)) {
>  			sb->max_dev = __cpu_to_le32(max+1);
> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_FAULTY);
> +		}
>
Hi,

I realized that the initial value for dev_roles should be 0xffff, that 
is MD_DISK_ROLE_SPARE. Sorry for the typo, I will send another patch
later.

Thanks,
Lidong
>  		random_uuid(sb->device_uuid);
>
> @@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>  		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>  		sb->dev_roles[info->disk.number] =
>  			__cpu_to_le16(info->disk.raid_disk);
> +		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
> +			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_FAULTY);
> +		}
>  	} else if (strcmp(update, "resync") == 0) {
>  		/* make sure resync happens */
>  		sb->resync_offset = 0ULL;
>
