From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 16/23] initramfs: simplify clean_rootfs
Date: Mon, 27 Jul 2020 03:41:49 +0100
Message-ID: <20200727024149.GB795125@ZenIV.linux.org.uk>
References: <20200714190427.4332-1-hch@lst.de>
 <20200714190427.4332-17-hch@lst.de>
 <CGME20200717205549eucas1p13fca9a8496836faa71df515524743648@eucas1p1.samsung.com>
 <7f37802c-d8d9-18cd-7394-df51fa785988@samsung.com>
 <20200718100035.GA8856@lst.de>
 <20200723092200.GA19922@lst.de>
 <dleftjblk6b95t.fsf%l.stelmach@samsung.com>
 <20200723142734.GA11080@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200723142734.GA11080@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Lukasz Stelmach <l.stelmach@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shaohua Li <shaohua.li@intel.com>
List-Id: linux-raid.ids

On Thu, Jul 23, 2020 at 04:27:34PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 23, 2020 at 04:25:34PM +0200, Lukasz Stelmach wrote:
> > >> Can you comment out the call to d_genocide?  It seems like for your
> > >> the fact that clean_rootfs didn't actually clean up was a feature and
> > >> not a bug.
> > >> 
> > >> I guess the old, pre-2008 code also wouldn't have worked for you in
> > >> that case.
> > >
> > > Did you get a chance to try this?
> > 
> > Indeed, commenting out d_genocide() helps.
> 
> So given that people have relied on at least the basic device nodes
> like /dev/console to not go away since 2008, I wonder if we should just
> remove clean_rootfs entirely
> 
> Linus, Al?

First of all, d_genocide() is simply wrong here from VFS point of view.  _IF_
you want recursive removal, you need simple_recursive_remove(path.dentry, NULL).
And it's a userland-visible change of behaviour.

As for removal of clean_rootfs()...  FWIW, the odds of an image that would
eventually fail accidentally getting past the signature mismatch check are
fairly low.  I've no idea what scenario the author of that thing used to have;
that would be Shaohua Li <shaohua.li@intel.com>.  Cc'd...
