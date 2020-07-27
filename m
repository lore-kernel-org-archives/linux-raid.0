From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 17/23] initramfs: switch initramfs unpacking to struct
 file based APIs
Date: Mon, 27 Jul 2020 03:55:07 +0100
Message-ID: <20200727025507.GC795125@ZenIV.linux.org.uk>
References: <20200714190427.4332-1-hch@lst.de>
 <20200714190427.4332-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200714190427.4332-18-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 14, 2020 at 09:04:21PM +0200, Christoph Hellwig wrote:

> -		ssize_t rv = ksys_write(fd, p, count);
> +		ssize_t rv = kernel_write(file, p, count, &file->f_pos);

No.  Sure, that'll work for ramfs with nobody else playing with those.
However, this is the wrong way to do such things; do *NOT* pass the
address of file->f_pos to anything.  The few places that still do that
are wrong.

As a general rule, ->read() and ->write() instances should never be
given &file->f_pos.  Address of a local variable - sure, no problem.
Copy it back into ->f_pos when they are done?  Also fine.  But not
this,

Keep that offset in a variable (static in file, argument of xwrite(),
whatever).
