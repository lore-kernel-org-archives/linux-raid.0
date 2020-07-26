From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: add file system helpers that take kernel pointers for the init code v3
Date: Sun, 26 Jul 2020 09:13:35 +0200
Message-ID: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Hi Al and Linus,

currently a lot of the file system calls in the early in code (and the
devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
This is one of the few last remaining places we need to deal with to kill
off set_fs entirely, so this series adds new helpers that take kernel
pointers.  These helpers are in init/ and marked __init and thus will
be discarded after bootup.  A few also need to be duplicated in devtmpfs,
though unfortunately.

The series sits on top of my previous

  "decruft the early init / initrd / initramfs code v2"

series.


Git tree:

    git://git.infradead.org/users/hch/misc.git init_path

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/init_path


Changes since v2:
 - move to fs/for-init.c
 - reuse the init routines in devtmpfs after refactoring devtmpfsd
   (and thus the broken error handling in the previous version)
 - actually use kern_path in a place where user_path_at sneaked back in

Changes since v1:
 - avoid most core VFS changes
 - renamed the functions and move them to init/ and devtmpfs
 - drop a bunch of cleanups that can be submitted independently now


Diffstat:
 drivers/base/devtmpfs.c       |   54 +++++----
 drivers/md/md-autodetect.c    |    3 
 fs/Makefile                   |    2 
 fs/for_init.c                 |  249 ++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h                 |   19 +--
 fs/namei.c                    |   20 +--
 fs/namespace.c                |  107 ++++++++----------
 fs/open.c                     |   22 +--
 include/linux/init_syscalls.h |   18 +++
 include/linux/syscalls.h      |   66 -----------
 init/do_mounts.c              |   12 +-
 init/do_mounts.h              |    7 -
 init/do_mounts_initrd.c       |   26 ++--
 init/do_mounts_rd.c           |    2 
 init/initramfs.c              |   29 ++--
 init/main.c                   |   10 -
 init/noinitramfs.c            |    8 -
 17 files changed, 423 insertions(+), 231 deletions(-)
