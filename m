From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [Patch v1] Detail: fix a bug when trying to show the detail of a
 raid device
Date: Fri, 26 May 2017 14:33:08 +0800
Message-ID: <075dc0fd-6b96-2994-a2fd-e5130d50a19b@suse.com>
References: <20170526024216.10248-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170526024216.10248-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com, neilb@suse.com
List-Id: linux-raid.ids

Hi,
Please ignore this patch. It has been fixed by Tomasz two days ago.
Sorry for the noise.

Thanks,
Lidong

On 05/26/2017 10:42 AM, Lidong Zhong wrote:
> It's introduced from commit a4dcdb23ea63.
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  Detail.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/Detail.c b/Detail.c
> index bf881ff..c89b927 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -98,8 +98,8 @@ int Detail(char *dev, struct context *c)
>  		    sra->array.minor_version == -2);
>  	inactive = (sra->array_state == ARRAY_ACTIVE ||
>  		    sra->array_state == ARRAY_CLEAR);
> -	st = super_by_fd(fd, &subarray);
> -	if (md_get_array_info(fd, &array) && errno == ENODEV) {
> +	rv = md_get_array_info(fd, &array);
> +	if (rv && errno == ENODEV) {
>  		if (sra->array.major_version == -1 &&
>  		    sra->array.minor_version == -1 &&
>  		    sra->devs == NULL) {
> @@ -109,7 +109,7 @@ int Detail(char *dev, struct context *c)
>  			return rv;
>  		}
>  		array = sra->array;
> -	} else {
> +	} else if (rv) {
>  		pr_err("cannot get array detail for %s: %s\n",
>  		       dev, strerror(errno));
>  		close(fd);
> @@ -118,8 +118,8 @@ int Detail(char *dev, struct context *c)
>
>  	if (fstat(fd, &stb) != 0 && !S_ISBLK(stb.st_mode))
>  		stb.st_rdev = 0;
> -	rv = 0;
>
> +	st = super_by_fd(fd, &subarray);
>  	if (st)
>  		max_disks = st->max_devs;
>
>
