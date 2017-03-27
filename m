From: jes.sorensen@gmail.com
Subject: Re: [PATCH] mdadm/Monitor:triggers core dump when stat2devnm return NULL
Date: Mon, 27 Mar 2017 18:25:20 -0400
Message-ID: <wrfj7f3aichb.fsf@gmail.com>
References: <1489987301-22836-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489987301-22836-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Mon, 20 Mar 2017 13:21:41 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> Monitor: ensure that the device should be a block
> device when uses --wait parameter, such as the 'f'
> and 'd' type file would be triggered core dumped.
> such as: ./mdadm --wait /dev/md/

I modified the patch description here to make it easier to read.

> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Monitor.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 802a9d9..f8850d3 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -1002,7 +1002,12 @@ int Wait(char *dev)
>  			strerror(errno));
>  		return 2;
>  	}
> -	strcpy(devnm, stat2devnm(&stb));
> +	char *tmp = stat2devnm(&stb);

Please do not declare variables in the middle of the codeflow, that is
extremely bad programming practice.

I fixed this up and applied the patch.

Thanks,
Jes
