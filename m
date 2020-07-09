From: hpa@zytor.com
Subject: Re: decruft the early init / initrd / initramfs code v2
Date: Thu, 09 Jul 2020 16:32:07 -0700
Message-ID: <31944685-7627-43BA-B9A2-A4743AFF0AB7@zytor.com>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On July 9, 2020 8:17:57 AM PDT, Christoph Hellwig <hch@lst=2Ede> wrote:
>Hi all,
>
>this series starts to move the early init code away from requiring
>KERNEL_DS to be implicitly set during early startup=2E  It does so by
>first removing legacy unused cruft, and the switches away the code
>from struct file based APIs to our more usual in-kernel APIs=2E
>
>There is no really good tree for this, so if there are no objections
>I'd like to set up a new one for linux-next=2E
>
>
>Git tree:
>
>    git://git=2Einfradead=2Eorg/users/hch/misc=2Egit init-user-pointers
>
>Gitweb:
>
>http://git=2Einfradead=2Eorg/users/hch/misc=2Egit/shortlog/refs/heads/ini=
t-user-pointers
>
>
>Changes since v1:
> - add a patch to deprecated "classic" initrd support
>
>Diffstat:
> b/arch/arm/kernel/atags_parse=2Ec |    2=20
> b/arch/sh/kernel/setup=2Ec        |    2=20
> b/arch/sparc/kernel/setup_32=2Ec  |    2=20
> b/arch/sparc/kernel/setup_64=2Ec  |    2=20
> b/arch/x86/kernel/setup=2Ec       |    2=20
> b/drivers/md/Makefile           |    3=20
>b/drivers/md/md-autodetect=2Ec    |  239
>++++++++++++++++++----------------------
> b/drivers/md/md=2Ec               |   34 +----
> b/drivers/md/md=2Eh               |   10 +
> b/fs/file=2Ec                     |    7 -
> b/fs/open=2Ec                     |   18 +--
> b/fs/read_write=2Ec               |    2=20
> b/fs/readdir=2Ec                  |   11 -
> b/include/linux/initrd=2Eh        |    6 -
> b/include/linux/raid/detect=2Eh   |    8 +
> b/include/linux/syscalls=2Eh      |   16 --
> b/init/Makefile                 |    1=20
> b/init/do_mounts=2Ec              |   70 +----------
> b/init/do_mounts=2Eh              |   21 ---
> b/init/do_mounts_initrd=2Ec       |   13 --
> b/init/do_mounts_rd=2Ec           |  102 +++++++----------
> b/init/initramfs=2Ec              |  103 +++++------------
> b/init/main=2Ec                   |   16 +-
> include/linux/raid/md_u=2Eh       |   13 --
> 24 files changed, 251 insertions(+), 452 deletions(-)

I guess I could say something here=2E=2E=2E ;)
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
