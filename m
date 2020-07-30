From: Christoph Hellwig <hch@lst.de>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v4
Date: Thu, 30 Jul 2020 08:25:24 +0200
Message-ID: <20200730062524.GA17980@lst.de>
References: <20200728163416.556521-1-hch@lst.de> <20200729195117.GE951209@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200729195117.GE951209@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 29, 2020 at 08:51:17PM +0100, Al Viro wrote:
> On Tue, Jul 28, 2020 at 06:33:53PM +0200, Christoph Hellwig wrote:
> > Hi Al and Linus,
> > 
> > currently a lot of the file system calls in the early in code (and the
> > devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> > This is one of the few last remaining places we need to deal with to kill
> > off set_fs entirely, so this series adds new helpers that take kernel
> > pointers.  These helpers are in init/ and marked __init and thus will
> > be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> > though unfortunately.
> >
> > The series sits on top of my previous
> > 
> >   "decruft the early init / initrd / initramfs code v2"
> 
> Could you fold the fixes in the parent branch to avoid the bisect hazards?
> As it is, you have e.g. "initd: pass a non-f_pos offset to kernel_read/kernel_write"
> that ought to go into "initrd: switch initrd loading to struct file based APIs"...

I'm not a huge fan of rebasing after it has been out for a long time and
with pending other patches on top of it.  But at your request I've now
folded the fixes and force pushed it.
