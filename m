From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/16] initrd: remove the BLKFLSBUF call in
 handle_initrd
Date: Tue, 7 Jul 2020 11:03:50 +0200
Message-ID: <20200707090350.GA28510@lst.de>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-10-hch@lst.de> <514b0176-d235-f640-b278-9a7d49af356f@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <514b0176-d235-f640-b278-9a7d49af356f@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 02, 2020 at 08:40:31PM -0700, H. Peter Anvin wrote:
> On 2020-06-15 05:53, Christoph Hellwig wrote:
> > BLKFLSBUF used to be overloaded for the ramdisk driver to free the whole
> > ramdisk, which was completely different behavior compared to all other
> > drivers.  But this magic overload got removed in commit ff26956875c2
> > ("brd: remove support for BLKFLSBUF"), so this call is entirely
> > pointless now.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Does *anyone* use initrd as opposed to initramfs anymore? It would seem
> like a good candidate for deprecation/removal.

I thought about that as well.  I think deprecating it at least is a good
idea and can add a patch doing that to the next version.
