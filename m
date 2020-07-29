From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v4
Date: Wed, 29 Jul 2020 20:51:17 +0100
Message-ID: <20200729195117.GE951209@ZenIV.linux.org.uk>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200728163416.556521-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 28, 2020 at 06:33:53PM +0200, Christoph Hellwig wrote:
> Hi Al and Linus,
> 
> currently a lot of the file system calls in the early in code (and the
> devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> This is one of the few last remaining places we need to deal with to kill
> off set_fs entirely, so this series adds new helpers that take kernel
> pointers.  These helpers are in init/ and marked __init and thus will
> be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> though unfortunately.
>
> The series sits on top of my previous
> 
>   "decruft the early init / initrd / initramfs code v2"

Could you fold the fixes in the parent branch to avoid the bisect hazards?
As it is, you have e.g. "initd: pass a non-f_pos offset to kernel_read/kernel_write"
that ought to go into "initrd: switch initrd loading to struct file based APIs"...
