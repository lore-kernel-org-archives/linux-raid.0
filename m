From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v3] mdadm/Detail: show correct state for cluster-md array
Date: Fri, 7 Aug 2020 09:39:44 -0400
Message-ID: <36a9bd05-fa7c-0fa8-feae-3c681bdc4db7@trained-monkey.org>
References: <1595994510-16161-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595994510-16161-1-git-send-email-heming.zhao@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

On 7/28/20 11:48 PM, Zhao Heming wrote:
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
> v3:
> - Detail.c: fix error logic: v2 code didn't check bitmap when dv is null.
> v2:
> - Detail.c: change to read only one device.
> - bitmap.c: modify IsBitmapDirty() to check all bitmap on the selected device.
> 
> ---
>  Detail.c | 20 +++++++++++++++++++-
>  bitmap.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mdadm.h  |  1 +
>  3 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/Detail.c b/Detail.c
> index 24eeba0..a69e5ac 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -495,8 +495,26 @@ int Detail(char *dev, struct context *c)
>  							  sra->array_state);
>  				else
>  					arrayst = "clean";
> -			} else
> +			} else {
>  				arrayst = "active";
> +				if (array.state & (1<<MD_SB_CLUSTERED)) {
> +					for (d = 0; d < max_disks * 2; d++) {
> +						char *dv;
> +						mdu_disk_info_t disk = disks[d];
> +
> +						if (d >= array.raid_disks * 2 &&
> +							disk.major == 0 && disk.minor == 0)
> +							continue;
> +						if ((d & 1) && disk.major == 0 && disk.minor == 0)
> +							continue;
> +						dv = map_dev_preferred(disk.major, disk.minor, 0,
> +												c->prefer);
> +						if (!dv) continue;

Minor nit here, never ever put if() < bleh on the same line.

Thanks,
Jes
