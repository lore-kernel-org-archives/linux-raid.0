From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 2/6] md: Fix a bug in super_1_sync().
Date: Mon, 25 May 2009 19:49:30 +1000 (EST)
Message-ID: <0fe21d52863495891c4d62bbbe61a36c.squirrel@neil.brown.name>
References: <1243243657-21855-1-git-send-email-maan@systemlinux.org>
    <1243243657-21855-3-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243243657-21855-3-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

On Mon, May 25, 2009 7:27 pm, Andre Noll wrote:
> The new_chunk fields of both struct mddev_s and struct mdp_superblock_1
> are measured in bytes. However, in super_1_sync(), mddev->new_chunk
> is converted to sectors before it assigned to sb->new_chunk.
>
> This results in a too small number being stored in the in-memory
> image of the superblock which could confuse the reshape process.
>
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/md.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 48bdbdf..66e32e4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1402,7 +1402,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t
> *rdev)
>  		sb->new_layout = cpu_to_le32(mddev->new_layout);
>  		sb->delta_disks = cpu_to_le32(mddev->delta_disks);
>  		sb->new_level = cpu_to_le32(mddev->new_level);
> -		sb->new_chunk = cpu_to_le32(mddev->new_chunk>>9);
> +		sb->new_chunk = cpu_to_le32(mddev->new_chunk);

I think the current code is correct.
For v1.x metadata, the chunk size (both chunksize and new_chunk) is
stored in sectors.  in 0.90 it is stored in bytes. (in DDF, it is stored
as the base-2 log of sectors, but that is not relevant for the kernel).

So as mddev->new_chunk is (still) in bytes, we need to shift by 9.
??

I'll sort through the rest of the patches tomorrow, but that look fine.

Thanks,
NeilBrown


