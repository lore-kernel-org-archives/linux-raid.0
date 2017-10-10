From: Coly Li <i@coly.li>
Subject: Re: [PATCH] bcache: mark expected switch fall-throughs in STRTO_H
Date: Tue, 10 Oct 2017 14:31:23 +0800
Message-ID: <33d4e79a-114b-6352-3548-8171eda39453@coly.li>
References: <20171009215425.GA21563@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171009215425.GA21563@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 2017/10/10 上午5:54, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

It seems for gcc7, and -Wimplicit-fallthrough is equal to
-Wimplicit-fallthrough=3, code comments work.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.

Coly

> ---
>  drivers/md/bcache/util.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 176d3c2..da9194b 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -32,20 +32,27 @@ int bch_ ## name ## _h(const char *cp, type *res)		\
>  	case 'y':						\
>  	case 'z':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 'e':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 'p':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 't':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 'g':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 'm':						\
>  		u++;						\
> +		/* fall through */				\
>  	case 'k':						\
>  		u++;						\
>  		if (e++ == cp)					\
>  			return -EINVAL;				\
> +		/* fall through */				\
>  	case '\n':						\
>  	case '\0':						\
>  		if (*e == '\n')					\
> 
