From: Song Liu <song@kernel.org>
Subject: Re: decruft the early init / initrd / initramfs code v2
Date: Tue, 14 Jul 2020 09:20:47 -0700
Message-ID: <CAPhsuW4bNTXE3CTLthUNtnnwf2f9K57gcBxPAjyvgziLrUvyDw@mail.gmail.com>
References: <20200709151814.110422-1-hch@lst.de> <31944685-7627-43BA-B9A2-A4743AFF0AB7@zytor.com>
 <20200714064111.GB32655@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200714064111.GB32655@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, open list <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid <linux-raid@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 13, 2020 at 11:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Jul 09, 2020 at 04:32:07PM -0700, hpa@zytor.com wrote:
> > On July 9, 2020 8:17:57 AM PDT, Christoph Hellwig <hch@lst.de> wrote:
> > >Hi all,
> > >
> > >this series starts to move the early init code away from requiring
> > >KERNEL_DS to be implicitly set during early startup.  It does so by
> > >first removing legacy unused cruft, and the switches away the code
> > >from struct file based APIs to our more usual in-kernel APIs.
> > >
> > >There is no really good tree for this, so if there are no objections
> > >I'd like to set up a new one for linux-next.
> > >
> > >
> > >Git tree:
> > >
> > >    git://git.infradead.org/users/hch/misc.git init-user-pointers
> > >
> > >Gitweb:
> > >
> > >http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/init-user-pointers
> > >
> > >
> > >Changes since v1:
> > > - add a patch to deprecated "classic" initrd support
> > >
> > >Diffstat:
> > > b/arch/arm/kernel/atags_parse.c |    2
> > > b/arch/sh/kernel/setup.c        |    2
> > > b/arch/sparc/kernel/setup_32.c  |    2
> > > b/arch/sparc/kernel/setup_64.c  |    2
> > > b/arch/x86/kernel/setup.c       |    2
> > > b/drivers/md/Makefile           |    3
> > >b/drivers/md/md-autodetect.c    |  239
> > >++++++++++++++++++----------------------
> > > b/drivers/md/md.c               |   34 +----
> > > b/drivers/md/md.h               |   10 +
> > > b/fs/file.c                     |    7 -
> > > b/fs/open.c                     |   18 +--
> > > b/fs/read_write.c               |    2
> > > b/fs/readdir.c                  |   11 -
> > > b/include/linux/initrd.h        |    6 -
> > > b/include/linux/raid/detect.h   |    8 +
> > > b/include/linux/syscalls.h      |   16 --
> > > b/init/Makefile                 |    1
> > > b/init/do_mounts.c              |   70 +----------
> > > b/init/do_mounts.h              |   21 ---
> > > b/init/do_mounts_initrd.c       |   13 --
> > > b/init/do_mounts_rd.c           |  102 +++++++----------
> > > b/init/initramfs.c              |  103 +++++------------
> > > b/init/main.c                   |   16 +-
> > > include/linux/raid/md_u.h       |   13 --
> > > 24 files changed, 251 insertions(+), 452 deletions(-)
> >
> > I guess I could say something here... ;)
>
> Like adding an ACK? :)

For the md bits:
Acked-by: Song Liu <song@kernel.org>

Thanks!
