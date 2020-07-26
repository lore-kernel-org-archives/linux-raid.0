From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v3
Date: Sun, 26 Jul 2020 17:52:04 +0200
Message-ID: <20200726155204.GA24103@lst.de>
References: <20200726071356.287160-1-hch@lst.de> <CAHk-=wgq8evViJD9Hnjugq=V0eUAn7K6ZjOP7P7qki-nOTx_jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgq8evViJD9Hnjugq=V0eUAn7K6ZjOP7P7qki-nOTx_jg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 08:49:28AM -0700, Linus Torvalds wrote:
> On Sun, Jul 26, 2020 at 12:14 AM Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> >
> > Hi Al and Linus,
> >
> > currently a lot of the file system calls in the early in code (and the
> > devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> > This is one of the few last remaining places we need to deal with to kill
> > off set_fs entirely, so this series adds new helpers that take kernel
> > pointers.  These helpers are in init/ and marked __init and thus will
> > be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> > though unfortunately.
> 
> I see nothing objectionable here.
> 
> The only bikeshed comment I have is that I think the "for_init.c" name
> is ugly and pointless - I think you could just call it "fs/init.c" and
> it's both simpler and more straightforward. It _is_ init code, it's
> not "for" init.

That was Al's suggestion.  I personally don't care, so if between the
two of you, you can come up with a preferred choice I'll switch to it.
