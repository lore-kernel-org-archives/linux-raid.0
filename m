From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 18/23] init: open code setting up stdin/stdout/stderr
Date: Mon, 27 Jul 2020 04:05:34 +0100
Message-ID: <20200727030534.GD795125@ZenIV.linux.org.uk>
References: <20200714190427.4332-1-hch@lst.de>
 <20200714190427.4332-19-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200714190427.4332-19-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 14, 2020 at 09:04:22PM +0200, Christoph Hellwig wrote:
> Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to work, but
> instead open a struct file for /dev/console and then install it as FD
> 0/1/2 manually.

I really hate that one.  Every time we exposed the internal details to
the fucking early init code, we paid for that afterwards.  And this
goes over the top wrt the level of details being exposed.

_IF_ you want to keep that thing, move it to fs/file.c, with dire comment
re that being very special shite for init and likely cause of subsequent
trouble whenever anything gets changed, a gnat farts somewhere, etc.

	Do not leave that kind of crap sitting around init/*.c; KERNEL_DS
may be a source of occasional PITA, but here you are trading it for a lot
worse one in the future.
