From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Unable to mount root & Problems with Woody
Date: Fri, 21 Feb 2003 14:01:01 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.43.0302211350010.29808-100000@unicorn.drogon.net>
References: <20030221134704.GA12443@willow.seitz.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030221134704.GA12443@willow.seitz.com>
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 21 Feb 2003, Ross Vandegrift wrote:

> On Fri, Feb 21, 2003 at 10:24:25AM +0000, Gordon Henderson wrote:
> > I've built several boxes to boot off raid1 using Debian woody. Eg:
>
> Same here, using custom compiled kernels.  Have you ever managed to get
> a system up and booting off of raid1 with a Debian-supplied kernel?  I'm
> not one for that whole initrd thing, so I'm kinda lost.

No, but I've never tried. I always build a custom kernel with everything
for that particular hardware configuration statically compiled in as soon
as I can and run without modules. (except laptops and the pcmcia stuff,
but they are hardly going to be running raid, anyway!)

I use the Debian install process to get a bare-minimal system installed,
(99% of the time I'm building a server rather than a workstation, so I
don't want X, etc.) with a packaged kernel (which makes sure I get the
right stuff to build a kernel), but then get a stock kernel off kernel.org
and use that rather than the packaged one... If nothing else, a kernel
compilation is a good, if crude test of the system, memory, disk, etc. and
is useful if it's a new system you've just built from scratch...

Gordon

