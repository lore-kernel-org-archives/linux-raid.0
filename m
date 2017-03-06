From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm:fix typo in comment
Date: Mon, 06 Mar 2017 16:27:46 -0500
Message-ID: <wrfj8toim6y5.fsf@gmail.com>
References: <1488357873-19495-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488357873-19495-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Wed, 1 Mar 2017 16:44:33 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>
> diff --git a/mdadm.c b/mdadm.c
> index b5d89e4..16fd49a 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1268,7 +1268,7 @@ int main(int argc, char *argv[])
>  	 * hopefully it's mostly right but there might be some stuff
>  	 * missing
>  	 *
> -	 * That is mosty checked in the per-mode stuff but...
> +	 * That is mostly checked in the per-mode stuff but...
>  	 *
>  	 * For @,B,C and A without -s, the first device listed must be
>  	 * an md device.  We check that here and open it.

Applied!

Thanks,
Jes
