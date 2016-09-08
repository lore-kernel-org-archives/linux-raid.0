From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] mdadm: fix a buffer overflow
Date: Thu, 8 Sep 2016 10:56:36 -0700
Message-ID: <20160908175636.GA21973@kernel.org>
References: <1473295415-1859888-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473295415-1859888-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com, shli@fb.com
List-Id: linux-raid.ids

On Wed, Sep 07, 2016 at 05:43:35PM -0700, Song Liu wrote:
> struct mdp_superblock_1.set_name is 32B long, but struct mdinfo.name
> is 33B long. So we need strncpy instead strcpy to avoid buffer
> overflow.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  super1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index f3e4023..46fed54 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1294,7 +1294,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>  			strcat(sb->set_name, ":");
>  			strcat(sb->set_name, info->name);
>  		} else
> -			strcpy(sb->set_name, info->name);
> +			strncpy(sb->set_name, info->name, 32);

strncpy(sb->set_name, info->name, sizeof(sb->set_name)); ?

