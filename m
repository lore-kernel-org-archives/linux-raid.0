From: Christoph Hellwig <hch@lst.de>
Subject: add file system helpers that take kernel pointers for the init code
Date: Mon, 20 Jul 2020 17:58:38 +0200
Message-ID: <20200720155902.181712-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Hi Al,

currently a lot of the file system calls in the early in code (and the
devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
This is one of the few last remaining places we need to deal with to kill
off set_fs entirely, so this series adds new helpers that take kernel
pointers.  That is mostly done by pushing the getname() call further up
the stack so that we can add variants using getname_kernel() without
duplicating code.

The series sits on top of my previous

  "decruft the early init / initrd / initramfs code v2"

series.


Git tree:

    git://git.infradead.org/users/hch/misc.git kern_path

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/kern_path


Diffstat:
 drivers/base/devtmpfs.c    |    8 +-
 drivers/md/md-autodetect.c |    2 
 fs/coredump.c              |    2 
 fs/fs_parser.c             |    1 
 fs/internal.h              |   12 ---
 fs/namei.c                 |  166 +++++++++++++++++++++++++++++++--------------
 fs/namespace.c             |  134 +++++++++++++++++++++---------------
 fs/open.c                  |  149 ++++++++++++++++++++++++++++------------
 fs/stat.c                  |   92 ++++++++++++------------
 fs/utimes.c                |   19 +++--
 include/linux/fs.h         |   39 +++++-----
 include/linux/syscalls.h   |   82 ----------------------
 init/do_mounts.c           |   12 +--
 init/do_mounts.h           |    4 -
 init/do_mounts_initrd.c    |   26 +++----
 init/do_mounts_rd.c        |    2 
 init/initramfs.c           |   27 +++----
 init/main.c                |    9 --
 init/noinitramfs.c         |    9 +-
 kernel/uid16.c             |   15 ----
 20 files changed, 434 insertions(+), 376 deletions(-)
