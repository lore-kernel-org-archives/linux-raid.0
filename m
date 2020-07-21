From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 13/24] init: add an init_unlink helper
Date: Tue, 21 Jul 2020 18:12:14 +0100
Message-ID: <20200721171214.GY2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-14-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-14-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:07PM +0200, Christoph Hellwig wrote:
> diff --git a/init/fs.c b/init/fs.c
> index 73423f5461f934..1bdb5dc5ec12ba 100644
> --- a/init/fs.c
> +++ b/init/fs.c
> @@ -3,6 +3,7 @@
>  #include <linux/mount.h>
>  #include <linux/namei.h>
>  #include <linux/fs.h>
> +#include <../fs/internal.h>

... and that is why the damn thing would be better off in fs/
