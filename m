From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: decruft the early init / initrd / initramfs code v2
Date: Tue, 14 Jul 2020 12:34:45 -0700
Message-ID: <CAHk-=wgxV9We+nVcJtQu2DHco+HSeja-WqVdA-KUcB=nyUYuoQ@mail.gmail.com>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 14, 2020 at 12:06 PM Christoph Hellwig <hch@lst.de> wrote:
>
> this series starts to move the early init code away from requiring
> KERNEL_DS to be implicitly set during early startup.  It does so by
> first removing legacy unused cruft, and the switches away the code
> from struct file based APIs to our more usual in-kernel APIs.

Looks good to me, with the added note on the utimes cruft too as a
further cleanup (separate patch).

So you can add my acked-by.

I _would_ like the md parts to get a few more acks. I see the one from
Song Liu, anybody else in md land willing to go through those patches?
They were the bulk of it, and the least obvious to me because I don't
know that code at all?

              Linus
