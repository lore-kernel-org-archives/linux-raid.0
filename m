From: colyli@suse.de
Subject: [PATCH v2 0/4] improve memalloc scope APIs usage
Date: Thu,  9 Apr 2020 19:52:54 +0800
Message-ID: <20200409115258.19330-1-colyli@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: songliubraving@fb.com, linux-raid@vger.kernel.org
Cc: mhocko@suse.com, kent.overstreet@gmail.com, guoqing.jiang@cloud.ionos.com, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

From: Coly Li <colyli@suse.de>

Hi folks,

The motivation of this series is to fix the incorrect GFP_NOIO flag
usage in drivers/md/raid5.c:resize_chunks(). I take the suggestion
from Michal Hocko to use memalloc scope APIs in unified entry point
mddev_suspend()/mddev_resume(). Also I get rid of the incorect GFP_NOIO
usage for scribble_alloc(), and remove redundant memalloc scope APIs
usage in mddev_create_serial_pool(), also as Song Liu suggested, update
the code comments on the header of scribble_alloc().

Thank you in advance for the review and comments.

Coly Li
---
Changelog:
v2: Add memalloc scope APIs in raid array suspend context.
v1: Original version to add memalloc scope APIs in resize_chunks().

Coly Li (4):
  md: use memalloc scope APIs in mddev_suspend()/mddev_resume()
  raid5: remove gfp flags from scribble_alloc()
  raid5: update code comment of scribble_alloc()
  md: remove redundant memalloc scope API usage

 drivers/md/md.c    |  6 ++++--
 drivers/md/md.h    |  1 +
 drivers/md/raid5.c | 22 ++++++++++++++--------
 3 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.25.0
