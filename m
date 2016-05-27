From: Song Liu <songliubraving@fb.com>
Subject: [RFC 0/5] raid5-cache: the write cache part
Date: Thu, 26 May 2016 22:29:38 -0700
Message-ID: <1464326983-3798454-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, nfbrown@novell.com, dan.j.williams@intel.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Hi,

This is the caching part of raid5-cache. The journal part was released
with kernel 4.4.

The caching part uses same disk format of raid456 journal, and provides
acceleration to writes. Write operations are committed (bio_endio) once
the data is secured in journal. Reconstruct and RMW are postponed to
reclaim path, which is (hopefully) not on the critical path.

The patch are splitted in 3 major changes: read path (chunk_aligned_read),
write part (the main changes), and a naive reclaim. I have tested read
and write patches (0001-0004), including data-verify in degraded modes.
The reclaim patch still needs some work.

I haven't finished the recovery part of the raid5-cache. But as the
patch set grows, I would like feedback about current changes.

Thanks,
Song

Song Liu (5):
  add bio_split_mddev
  move stripe cache define and functions to raid5.h
  r5cache: look up stripe cache for chunk_aligned_read
  r5cache: write part of r5cache
  r5cache: naive reclaim approach

 drivers/md/md.c          |  14 +-
 drivers/md/md.h          |   2 +
 drivers/md/raid5-cache.c | 711 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/raid5.c       | 264 ++++++++++++------
 drivers/md/raid5.h       | 101 ++++++-
 5 files changed, 990 insertions(+), 102 deletions(-)

--
2.8.0.rc2
