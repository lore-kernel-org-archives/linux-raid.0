From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/1] super-intel.c: use %zu specifier for printf of
 size_t
Date: Mon, 1 Feb 2010 09:17:51 +1100
Message-ID: <20100201091751.7f6c716b@notabene.brown>
References: <20100130095928.GD15471@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100130095928.GD15471@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 30 Jan 2010 10:59:29 +0100
Luca Berra <bluca@comedia.it> wrote:

> 
> Signed-off-by: Luca Berra <bluca@vodka.it>
> ---
>   super-intel.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index fcf438c..91479a2 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4076,7 +4076,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
>   
>   		this = malloc(sizeof(*this));
>   		if (!this) {
> -			fprintf(stderr, Name ": failed to allocate %lu bytes\n",
> +			fprintf(stderr, Name ": failed to allocate %zu bytes\n",
>   				sizeof(*this));
>   			break;
>   		}


Applied, thanks.

NeilBrown
