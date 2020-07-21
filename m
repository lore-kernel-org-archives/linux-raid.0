From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 06/24] md: open code vfs_stat in md_setup_drive
Date: Tue, 21 Jul 2020 17:55:39 +0100
Message-ID: <20200721165539.GT2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-7-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:00PM +0200, Christoph Hellwig wrote:
> Instead of passing a kernel pointer to vfs_stat by relying on the
> implicit set_fs(KERNEL_DS) in md_setup_drive, just open code the
> trivial getattr, and use the opportunity to move a little bit more
> code from the caller into the new helper.

Ugh...

> +static void __init md_lookup_dev(const char *devname, dev_t *dev)
> +{
> +	struct kstat stat;
> +	struct path path;
> +	char filename[64];
> +
> +	if (strncmp(devname, "/dev/", 5) == 0)
> +		devname += 5;
> +	snprintf(filename, 63, "/dev/%s", devname);
> +
> +	if (!kern_path(filename, LOOKUP_FOLLOW, &path) &&
> +	    !vfs_getattr(&path, &stat, STATX_BASIC_STATS, AT_NO_AUTOMOUNT) &&
> +	    S_ISBLK(stat.mode))
> +		*dev = new_decode_dev(stat.rdev);
> +	path_put(&path);
> +}

How about fs/for_init.c and putting the damn helpers there?  With
calling conventions as close to syscalls as possible, and a fat
comment regarding their intended use being _ONLY_ the setup
in should-have-been-done-in-userland parts of init?

I really want to keep the surface as small as possible - we had
fun shite several releases ago when somebody tried that kind of
crap (with open(), IIRC).  Let's not go there again...
