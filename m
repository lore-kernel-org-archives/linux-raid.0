From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v3
Date: Sun, 26 Jul 2020 17:21:13 +0100
Message-ID: <20200726162113.GR2786714@ZenIV.linux.org.uk>
References: <20200726071356.287160-1-hch@lst.de>
 <CAHk-=wgq8evViJD9Hnjugq=V0eUAn7K6ZjOP7P7qki-nOTx_jg@mail.gmail.com>
 <20200726155204.GA24103@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200726155204.GA24103@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 05:52:04PM +0200, Christoph Hellwig wrote:
> On Sun, Jul 26, 2020 at 08:49:28AM -0700, Linus Torvalds wrote:
> > On Sun, Jul 26, 2020 at 12:14 AM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Hi Al and Linus,
> > >
> > > currently a lot of the file system calls in the early in code (and the
> > > devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> > > This is one of the few last remaining places we need to deal with to kill
> > > off set_fs entirely, so this series adds new helpers that take kernel
> > > pointers.  These helpers are in init/ and marked __init and thus will
> > > be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> > > though unfortunately.
> > 
> > I see nothing objectionable here.
> > 
> > The only bikeshed comment I have is that I think the "for_init.c" name
> > is ugly and pointless - I think you could just call it "fs/init.c" and
> > it's both simpler and more straightforward. It _is_ init code, it's
> > not "for" init.
> 
> That was Al's suggestion.  I personally don't care, so if between the
> two of you, you can come up with a preferred choice I'll switch to it.

I can live with either variant; the only problem with fs/init.c is that
such name would imply the init code _of_ VFS, rather than VFS helpers for
init.

Anyway, the series looks generally sane; if no other objections are raised,
I'm adding it to vfs.git#for-next
