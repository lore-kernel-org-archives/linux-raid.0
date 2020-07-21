From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 12/24] init: add an init_mount helper
Date: Tue, 21 Jul 2020 17:58:24 +0100
Message-ID: <20200721165824.GU2786714@ZenIV.linux.org.uk>
References: <20200721162818.197315-1-hch@lst.de>
 <20200721162818.197315-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200721162818.197315-13-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 21, 2020 at 06:28:06PM +0200, Christoph Hellwig wrote:
> Like do_mount, but takes a kernel pointer for the destination path.
> Switch over the mounts in the init code and devtmpfs to it, which
> just happen to work due to the implicit set_fs(KERNEL_DS) during early
> init right now.

>  init/fs.c               | 20 ++++++++++++++++++++

fs/for_init.c, please.
