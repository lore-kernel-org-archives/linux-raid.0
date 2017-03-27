From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm/Monitor:dev should be a block file when use --waitclean
Date: Mon, 27 Mar 2017 18:29:40 -0400
Message-ID: <wrfj37dyica3.fsf@gmail.com>
References: <1489987317-22895-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489987317-22895-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Mon, 20 Mar 2017 13:21:57 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> Monitor: mdadm --wait-clean /dev/mdX, the dev should
> be a block file, otherwise fd2devnm returns NULL and
> then triggers core dumped.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Monitor.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/Monitor.c b/Monitor.c
> index f8850d3..5a2b5ca 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -1065,7 +1065,17 @@ int WaitClean(char *dev, int sock, int verbose)
>  	struct mdinfo *mdi;
>  	int rv = 1;
>  	char devnm[32];
> +	struct stat stb;
>  
> +	if (stat(dev, &stb) != 0) {
> +		pr_err("Cannot find %s: %s\n", dev,
> +			strerror(errno));

Please use the 80 characters in the line.

> +		return 2;
> +	}
> +	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
> +		pr_err("%s is not a block device.\n", dev);
> +		return 2;
> +	}
>  	fd = open(dev, O_RDONLY);
>  	if (fd < 0) {
>  		if (verbose)

We have 7-8 instances of this throughout the code (stat and fstat).
Maybe we should make it a utility function instead of duplicating it
further.

Cheers,
Jes
