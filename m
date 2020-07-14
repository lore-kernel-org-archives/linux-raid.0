From: Christoph Hellwig <hch@lst.de>
Subject: decruft the early init / initrd / initramfs code v2
Date: Tue, 14 Jul 2020 21:04:04 +0200
Message-ID: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

this series starts to move the early init code away from requiring
KERNEL_DS to be implicitly set during early startup.  It does so by
first removing legacy unused cruft, and the switches away the code
from struct file based APIs to our more usual in-kernel APIs.

There is no really good tree for this, so if there are no objections
I'd like to set up a new one for linux-next.


Git tree:

    git://git.infradead.org/users/hch/misc.git init-user-pointers

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/init-user-pointers

Changes since v2:
 - add vfs_fchown and vfs_fchmod helpers and use them for initramfs
   unpacking
 - split patches up a little more
 - fix a commit log typo
Changes since v1:
 - add a patch to deprecated "classic" initrd support

Diffstat:
 b/arch/arm/kernel/atags_parse.c |    2 
 b/arch/sh/kernel/setup.c        |    2 
 b/arch/sparc/kernel/setup_32.c  |    2 
 b/arch/sparc/kernel/setup_64.c  |    2 
 b/arch/x86/kernel/setup.c       |    2 
 b/drivers/md/Makefile           |    3 
 b/drivers/md/md-autodetect.c    |  239 ++++++++++++++++++----------------------
 b/drivers/md/md.c               |   34 +----
 b/drivers/md/md.h               |   10 +
 b/fs/file.c                     |    7 -
 b/fs/ioctl.c                    |    7 -
 b/fs/open.c                     |   56 +++++----
 b/fs/read_write.c               |    2 
 b/fs/readdir.c                  |   11 -
 b/include/linux/fs.h            |    3 
 b/include/linux/initrd.h        |    6 -
 b/include/linux/raid/detect.h   |    8 +
 b/include/linux/syscalls.h      |   17 --
 b/init/Makefile                 |    1 
 b/init/do_mounts.c              |   70 +----------
 b/init/do_mounts.h              |   21 ---
 b/init/do_mounts_initrd.c       |   13 --
 b/init/do_mounts_rd.c           |  102 +++++++----------
 b/init/initramfs.c              |  103 +++++------------
 b/init/main.c                   |   16 +-
 include/linux/raid/md_u.h       |   13 --
 26 files changed, 279 insertions(+), 473 deletions(-)
