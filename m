From: Christoph Hellwig <hch@lst.de>
Subject: add file system helpers that take kernel pointers for the init code v4
Date: Tue, 28 Jul 2020 18:33:53 +0200
Message-ID: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
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


Changes since v3:
 - rename fs/for_init.c to fs/init.c
 - document the purpose of the routines in fs/init.c with a comment
 - don't mark devtmpfs __init as that will cause it to get overwritten
   by initmem poisoning
 - add an init_dup helper to make Al more happy than with the version
   commit to the "decruft the early init / initrd / initramfs code v2"
   series

Changes since v2:
 - move to fs/for_init.c
 - reuse the init routines in devtmpfs after refactoring devtmpfsd
   (and thus the broken error handling in the previous version)
 - actually use kern_path in a place where user_path_at sneaked back in

Changes since v1:
 - avoid most core VFS changes
 - renamed the functions and move them to init/ and devtmpfs
 - drop a bunch of cleanups that can be submitted independently now


Diffstat:
