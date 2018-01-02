From: Sean Fu <fxinrong@gmail.com>
Subject: [PATCH 0/3] Create circular buffer list for every page instead of linear list.
Date: Tue,  2 Jan 2018 14:54:46 +0800
Message-ID: <cover.1514867850.git.fxinrong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org, viro@zeniv.linux.org.uk, anton@tuxera.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, Sean Fu <fxinrong@gmail.com>
List-Id: linux-raid.ids

1.Create circular buffer list in alloc_page_buffers.
Remove unnecessary traversal in link_dev_buffers to create circular buffer list.
Make nobh_write_begin and nobh_write_end to support circular buffer list.

2.fs/ntfs: Make ntfs to support circular buffer list.

3.md: bitmap: Support circular buffer list.
Modify write_page free_buffers and read_page to support circular buffer list.

Sean Fu (3):
  fs: buffer: Create circular buffer list for pages.
  fs/ntfs: Make ntfs to support circular buffer list.
  md: bitmap: Support circular buffer list.

 drivers/md/md-bitmap.c | 36 +++++++++++++++++++-----------------
 fs/buffer.c            | 48 +++++++++++++++++++++---------------------------
 fs/ntfs/aops.c         |  6 ++----
 fs/ntfs/mft.c          |  4 ----
 4 files changed, 42 insertions(+), 52 deletions(-)

-- 
2.6.2
