From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] trival: md_k.h should be md.h in the beginning comment
 of file md.h
Date: Wed, 7 Sep 2011 10:55:43 +1000
Message-ID: <20110907105543.2a502587@notabene.brown>
References: <4E635D74.7090808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E635D74.7090808@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 04 Sep 2011 19:13:56 +0800 Wang Sheng-Hui <shhuiw@gmail.com> wrote:

> The patch is against 3.1-rc3.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  drivers/md/md.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1e586bb..4b304ad 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1,5 +1,5 @@
>  /*
> -   md_k.h : kernel internal structure of the Linux MD driver
> +   md.h : kernel internal structure of the Linux MD driver
>            Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
>  	  
>     This program is free software; you can redistribute it and/or modify

Thanks.  I'll go upstream in the next merge window.

NeilBrown
