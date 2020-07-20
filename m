From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 06/24] fs: add a kern_chdir helper
Date: Mon, 20 Jul 2020 19:17:06 +0100
Message-ID: <20200720181706.GR2786714@ZenIV.linux.org.uk>
References: <20200720155902.181712-1-hch@lst.de>
 <20200720155902.181712-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200720155902.181712-7-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 20, 2020 at 05:58:44PM +0200, Christoph Hellwig wrote:
> Add a simple helper for a chdir with a kernelspace name and use it in the
> early init code instead of relying on the implicit set_fs(KERNEL_DS)
> there.  Remove the now unused ksys_chdir.

FWIW, my problem with that is that you are making it first-class primitive.
And I don't see any valid use for it - existing one is really "we have
a userland process that would be making syscalls if we only could have it
done right; the only reason we can't is that the infrastructure to build
the binary would be hell to maintain in the tree".  It's *NOT* "kernel
code that has a valid reason to get the syscall functionality".
