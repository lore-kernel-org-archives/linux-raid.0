From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v3
Date: Sun, 26 Jul 2020 08:49:28 -0700
Message-ID: <CAHk-=wgq8evViJD9Hnjugq=V0eUAn7K6ZjOP7P7qki-nOTx_jg@mail.gmail.com>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200726071356.287160-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jul 26, 2020 at 12:14 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hi Al and Linus,
>
> currently a lot of the file system calls in the early in code (and the
> devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> This is one of the few last remaining places we need to deal with to kill
> off set_fs entirely, so this series adds new helpers that take kernel
> pointers.  These helpers are in init/ and marked __init and thus will
> be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> though unfortunately.

I see nothing objectionable here.

The only bikeshed comment I have is that I think the "for_init.c" name
is ugly and pointless - I think you could just call it "fs/init.c" and
it's both simpler and more straightforward. It _is_ init code, it's
not "for" init.

Other than that it all looked straightforward to me.

                Linus
