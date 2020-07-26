From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v3
Date: Sun, 26 Jul 2020 17:33:39 +0100
Message-ID: <20200726163339.GT2786714@ZenIV.linux.org.uk>
References: <20200726071356.287160-1-hch@lst.de>
 <CAHk-=wgq8evViJD9Hnjugq=V0eUAn7K6ZjOP7P7qki-nOTx_jg@mail.gmail.com>
 <20200726155204.GA24103@lst.de>
 <20200726162113.GR2786714@ZenIV.linux.org.uk>
 <20200726162426.GA24479@lst.de>
 <20200726162627.GA24522@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200726162627.GA24522-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 06:26:27PM +0200, Christoph Hellwig wrote:
> On Sun, Jul 26, 2020 at 06:24:26PM +0200, Christoph Hellwig wrote:
> > Btw, care to take a look at 
> > 
> > http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/kernel_readwrite
> > 
> > it has been in linux-next for 2 1/2 weeks, and the only interesting
> > thing found was that btrfs didn't wire up iter_splice_write, which has
> > already been fixed in mainline.
> 
> Actually, the above is a stale old branch sorry.  The real one that has
> been in linux-next is:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/set_fs-rw

Will check... still crawling through the accumulated VFS-related threads
from the last weeks ;-/
