From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 06/24] md: open code vfs_stat in md_setup_drive
Date: Wed, 22 Jul 2020 08:44:32 +0100
Message-ID: <20200722074432.GD2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-7-hch@lst.de>
 <20200721165539.GT2786714@ZenIV.linux.org.uk>
 <20200721182701.GB14450@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200721182701.GB14450-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 08:27:01PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 21, 2020 at 05:55:39PM +0100, Al Viro wrote:
> > How about fs/for_init.c and putting the damn helpers there?  With
> > calling conventions as close to syscalls as possible, and a fat
> > comment regarding their intended use being _ONLY_ the setup
> > in should-have-been-done-in-userland parts of init?
> 
> Where do you want the prototypes to go?  Also do you want devtmpfs
> use the same helpers, which then't can't be marked __init (mount,
> chdir, chroot), or separate copies?

Hmm...  mount still can be __init (devtmpfs_mount() is), and I suspect
devtmpfs_setup() could also be made such - just turn devtmpfsd()
into
static int __init devtmpfsd(void *p)
{
        int err = devtmpfs_setup(p);

	if (!err)
		devtmpfsd_real();	/* never returns */
	return err;
}
and you are done.  As for the prototypes... include/linux/init_syscalls.h,
perhaps?
