From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/5] MD: don't abuse bi_phys_segements
Date: Tue, 7 Feb 2017 08:55:57 -0800
Message-ID: <cover.1486485935.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: khlebnikov@yandex-team.ru, hch@lst.de, neilb@suse.com
List-Id: linux-raid.ids

This patchset removes the hack of bio->by_phys_segements usage

Shaohua Li (5):
  MD: attach data to each bio
  md/raid5: don't abuse bio->bi_phys_segments
  md/raid5: change disk limits
  md/raid1: don't abuse bio->bi_phys_segments
  md/raid10: don't abuse bio->bi_phys_segments

 drivers/md/md.c     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h     | 18 ++++++++++++++
 drivers/md/raid1.c  | 44 +++++++++++++++++++---------------
 drivers/md/raid10.c | 40 ++++++++++++++++++-------------
 drivers/md/raid5.c  | 21 ++++++++---------
 drivers/md/raid5.h  | 37 +++++++++++++++--------------
 6 files changed, 164 insertions(+), 64 deletions(-)

-- 
2.9.3

