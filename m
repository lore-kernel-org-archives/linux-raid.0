From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear
 array
Date: Fri, 12 May 2017 15:53:21 +0800
Message-ID: <66dcee83-e0d3-be5f-d8c4-f06b342afea8@suse.de>
References: <20170512015145.18542-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170512015145.18542-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <Lidong.Zhong@suse.com>, linux-raid@vger.kernel.org
Cc: Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

On 2017/5/12 上午9:51, Lidong Zhong wrote:
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

The above description does not very well explain why this fix is necessary.

For linear device, there was a race condition and got fixed already.
There are users encountered such bug in old kernel, when they trying to
add a hard disk into a linear device. After the kernel panic caused by
the race issue in old md linear code, they reboot from the fixed kernel,
and find 'R' or '?' marks from Array State output.

After analyze the metadata, we found value of
sb->dev_roles[sb->max_dev-1] is 0, but which should be
MD_DISK_ROLE_FAULTY. The reason for the error is, when adding a disk
into linear device, mdadm first increases sb->max_dev value, but not set
its role value. So the corresponding role value keeps as 0, which is
same as No.0 disk's role value in the linear device.

So mdadm -E will find there are 2 same role value for No.0 disk, and the
first state character of Array State is marked as 'R'. If such a panic
happened multiple times, there are more bogus zero value at tail of
dev_roles[], so the character of Array State is marked as '?'.

Now the kernel part is fixed, but mdadm part is not fixed yet. This
patch is an effort to avoid bogus dev_roles[] value if kernel panic
happens in follow ioctl system call (although the possibility is quite
low and who can tel ...).


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
>  		random_uuid(sb->device_uuid);

The above part makes sense to me.



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

Just a lazy question, could you please explain a little bit why you also
modify here ? Thanks.

Coly



