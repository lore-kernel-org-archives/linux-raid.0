From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH] allow RAID5 to grow to RAID6 with a backup_file
Date: Tue, 5 May 2020 13:59:31 -0400
Message-ID: <01d95357-ce4b-3cd8-2e33-e619c11ea325@trained-monkey.org>
References: <20200504163138.22787-1-ncroxon@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200504163138.22787-1-ncroxon@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/4/20 12:31 PM, Nigel Croxon wrote:
> This problem came in, as the user did not specify a full path with
> the backup_file option when growing an RAID5 array to RAID6.
> When the full path is specified, the symbolic link is created
> properly (/run/mdadm/backup_file-mdX). But the code did not support
> the symbolic link when looking for the backup_file. Added two
> checks for symlink.
> 
> This addresses https://www.spinics.net/lists/raid/msg48910.html
> and numerous customer reported problems.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Grow.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 764374f..6dce71c 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1135,6 +1135,16 @@ int reshape_open_backup_file(char *backup_file,
>  	unsigned int dev;
>  	int i;
>  
> +	if (lstat(backup_file, &stb) != -1) {
> +		switch (stb.st_mode & S_IFMT) {
> +		case S_IFLNK:
> +			return 1;
> +			break;

It doesn't make sense to have a break after a return here.

> +		default:
> +			break;
> +		}
> +	}
> +
>  	*fdlist = open(backup_file, O_RDWR|O_CREAT|(restart ? O_TRUNC : O_EXCL),
>  		       S_IRUSR | S_IWUSR);
>  	*offsets = 8 * 512;
> @@ -5236,8 +5246,17 @@ char *locate_backup(char *name)
>  	char *fl = make_backup(name);
>  	struct stat stb;
>  
> -	if (stat(fl, &stb) == 0 && S_ISREG(stb.st_mode))> +	lstat(fl, &stb);

You ditched the error check for lstat here. You cannot count on the
contents of stb being valid in this case.

> +	switch (stb.st_mode & S_IFMT) {
> +	case S_IFLNK:
>  		return fl;
> +		break;
> +	case S_IFREG:
> +		return fl;
> +		break;

Same with the break statements here.

Mind fixing this up and submitting a v2.

Thanks,
Jes

> +	default:
> +		break;
> +	}
>  
>  	free(fl);
>  	return NULL;
> 
