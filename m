From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: decruft the early init / initrd / initramfs code v2
Date: Thu, 9 Jul 2020 11:08:42 -0700
Message-ID: <CAHk-=wibathZJc6oSfgBdw7qhW75eF1ukg9y3bMXFfmp5t_uig@mail.gmail.com>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 9, 2020 at 8:18 AM Christoph Hellwig <hch@lst.de> wrote:
>
> There is no really good tree for this, so if there are no objections
> I'd like to set up a new one for linux-next.

All looks good to me. I had a wish-list change for one of the patches
that I sent a reply out for, but even without that it's clearly an
improvement.

Of course, I just looked at the patches for sanity, rather than
testing anything. Maybe there's something stupid in there. But it all
looked straightforward. So Ack from me, with the hope that you'd do
that "vfs_chown/chmod()" thing.

                Linus
