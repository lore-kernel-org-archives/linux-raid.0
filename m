From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 18/23] init: open code setting up stdin/stdout/stderr
Date: Mon, 27 Jul 2020 16:54:53 +0100
Message-ID: <20200727155453.GE794331@ZenIV.linux.org.uk>
References: <20200714190427.4332-1-hch@lst.de>
 <20200714190427.4332-19-hch@lst.de>
 <20200727030534.GD795125@ZenIV.linux.org.uk>
 <20200727054625.GA1241@lst.de>
 <20200727060322.GC794331@ZenIV.linux.org.uk>
 <20200727064828.GA2317@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200727064828.GA2317@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 27, 2020 at 08:48:28AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 27, 2020 at 07:03:22AM +0100, Al Viro wrote:
> > On Mon, Jul 27, 2020 at 07:46:25AM +0200, Christoph Hellwig wrote:
> > > On Mon, Jul 27, 2020 at 04:05:34AM +0100, Al Viro wrote:
> > > > On Tue, Jul 14, 2020 at 09:04:22PM +0200, Christoph Hellwig wrote:
> > > > > Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to work, but
> > > > > instead open a struct file for /dev/console and then install it as FD
> > > > > 0/1/2 manually.
> > > > 
> > > > I really hate that one.  Every time we exposed the internal details to
> > > > the fucking early init code, we paid for that afterwards.  And this
> > > > goes over the top wrt the level of details being exposed.
> > > > 
> > > > _IF_ you want to keep that thing, move it to fs/file.c, with dire comment
> > > > re that being very special shite for init and likely cause of subsequent
> > > > trouble whenever anything gets changed, a gnat farts somewhere, etc.
> > > 
> > > Err, while I'm all for keeping internals internal, fd_install and
> > > get_unused_fd_flags are exported routines with tons of users of this
> > > pattern all over.
> > 
> > get_file_rcu_many()?  All over the place?  Besides, that's _not_ the normal
> > pattern for get_unused_fd() - there's a very special reason we don't expect
> > an error from it here.
> 
> Oh well.  I can add an init_dup2, but that should probably go after
> the series adding fs/for-init.c or fs/init.c.  I'll skip it for the
> current set of fixups and will send it once we have a stable branch for
> that.

OK.  The really serious ones are around f_pos uses and d_genocide() one.
FWIW, cleanup_rootfs() should probably be removed - it looks rather
pointless.
