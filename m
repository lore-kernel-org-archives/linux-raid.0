From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 06/24] md: open code vfs_stat in md_setup_drive
Date: Tue, 21 Jul 2020 20:27:01 +0200
Message-ID: <20200721182701.GB14450@lst.de>
References: <20200721162818.197315-1-hch@lst.de> <20200721162818.197315-7-hch@lst.de> <20200721165539.GT2786714@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200721165539.GT2786714-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 05:55:39PM +0100, Al Viro wrote:
> How about fs/for_init.c and putting the damn helpers there?  With
> calling conventions as close to syscalls as possible, and a fat
> comment regarding their intended use being _ONLY_ the setup
> in should-have-been-done-in-userland parts of init?

Where do you want the prototypes to go?  Also do you want devtmpfs
use the same helpers, which then't can't be marked __init (mount,
chdir, chroot), or separate copies?
