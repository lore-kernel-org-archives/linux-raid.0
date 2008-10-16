From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [2.6 patch] init/do_mounts_md.c must #include <linux/delay.h>
Date: Thu, 16 Oct 2008 18:41:02 -0400
Message-ID: <48F7C2FE.8070907@linux.intel.com>
References: <20081016202921.GD22554@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081016202921.GD22554@cs181140183.pp.htv.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sigh; header "cleanups" crossing ;(


Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c
> (fastboot: make the raid autodetect code wait for all devices to init):
> 
> <--  snip  -->
> 
> ...
>   CC      init/do_mounts_md.o
> init/do_mounts_md.c: In function 'autodetect_raid':
> init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'
> make[2]: *** [init/do_mounts_md.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
> index 48b3fad..4c87ee1 100644
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -1,5 +1,6 @@
>  
>  #include <linux/raid/md.h>
> +#include <linux/delay.h>
>  
>  #include "do_mounts.h"
>  
> 

