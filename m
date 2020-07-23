From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/23] initramfs: simplify clean_rootfs
Date: Thu, 23 Jul 2020 16:27:34 +0200
Message-ID: <20200723142734.GA11080@lst.de>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-17-hch@lst.de> <CGME20200717205549eucas1p13fca9a8496836faa71df515524743648@eucas1p1.samsung.com> <7f37802c-d8d9-18cd-7394-df51fa785988@samsung.com> <20200718100035.GA8856@lst.de> <20200723092200.GA19922@lst.de> <dleftjblk6b95t.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dleftjblk6b95t.fsf%l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukasz Stelmach <l.stelmach@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-raid.ids

On Thu, Jul 23, 2020 at 04:25:34PM +0200, Lukasz Stelmach wrote:
> >> Can you comment out the call to d_genocide?  It seems like for your
> >> the fact that clean_rootfs didn't actually clean up was a feature and
> >> not a bug.
> >> 
> >> I guess the old, pre-2008 code also wouldn't have worked for you in
> >> that case.
> >
> > Did you get a chance to try this?
> 
> Indeed, commenting out d_genocide() helps.

So given that people have relied on at least the basic device nodes
like /dev/console to not go away since 2008, I wonder if we should just
remove clean_rootfs entirely

Linus, Al?
