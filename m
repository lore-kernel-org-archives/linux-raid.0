From: NeilBrown <neilb@suse.de>
Subject: Re: [mdadm PATCH] Fix small memory leak
Date: Wed, 7 Sep 2011 18:11:01 +1000
Message-ID: <20110907181101.24518c64@notabene.brown>
References: <4E573031.9080007@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E573031.9080007@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 26 Aug 2011 07:33:37 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

> Found by cppcheck
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> ---
>  config.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/config.c b/config.c
> index ad75411..c0a6baa 100644
> --- a/config.c
> +++ b/config.c
> @@ -707,6 +707,8 @@ void autoline(char *line)
>  	for (i = 0; i < super_cnt; i++)
>  		if (!seen[i])
>  			policy_add(rule_policy, pol_auto, dflt, pol_metadata, superlist[i]->name, NULL);
> +
> +	free(seen);
>  }
>  
>  int loaded = 0;


Applied, thanks.

NeilBrown
