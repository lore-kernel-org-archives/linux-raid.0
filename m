From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/23] initramfs: simplify clean_rootfs
Date: Thu, 23 Jul 2020 11:22:00 +0200
Message-ID: <20200723092200.GA19922@lst.de>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-17-hch@lst.de> <CGME20200717205549eucas1p13fca9a8496836faa71df515524743648@eucas1p1.samsung.com> <7f37802c-d8d9-18cd-7394-df51fa785988@samsung.com> <20200718100035.GA8856@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200718100035.GA8856@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-raid.ids

On Sat, Jul 18, 2020 at 12:00:35PM +0200, Christoph Hellwig wrote:
> On Fri, Jul 17, 2020 at 10:55:48PM +0200, Marek Szyprowski wrote:
> > Hi Christoph,
> > 
> > On 14.07.2020 21:04, Christoph Hellwig wrote:
> > > Just use d_genocide instead of iterating through the root directory with
> > > cumbersome userspace-like APIs.  This also ensures we actually remove files
> > > that are not direct children of the root entry, which the old code failed
> > > to do.
> > >
> > > Fixes: df52092f3c97 ("fastboot: remove duplicate unpack_to_rootfs()")
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > This patch breaks initrd support ;-(
> > 
> > I use initrd to deploy kernel modules on my test machines. It was 
> > automatically mounted on /initrd. /lib/modules is just a symlink to 
> > /initrd. I know that initrd support is marked as deprecated, but it 
> > would be really nice to give people some time to update their machines 
> > before breaking the stuff.
> 
> Looks like your setup did rely on the /dev/ notes from the built-in
> initramfs to be preserved.
> 
> Can you comment out the call to d_genocide?  It seems like for your
> the fact that clean_rootfs didn't actually clean up was a feature and
> not a bug.
> 
> I guess the old, pre-2008 code also wouldn't have worked for you in
> that case.

Did you get a chance to try this?
