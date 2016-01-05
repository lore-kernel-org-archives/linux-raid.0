From: Shaohua Li <shli@fb.com>
Subject: [PATCH 0/4]raid5-cache: fix journal hotadd
Date: Tue, 5 Jan 2016 13:26:00 -0800
Message-ID: <cover.1452028077.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

Hi Neil,

This patch set fix some issues for journal disk hotadd, mainly for raid array
which isn't created with journal support. If there are write IO running in the
array when journal disk is adding, the write IO isn't protected by journal (eg,
expose write hole issue), but this is unavoidable.

Thanks,
Shaohua

Shaohua Li (4):
  raid5-cache: use rcu api to access r5conf->log
  raid5-cache: avoid write failure for journal hotadd
  raid5-cache: handle flush request for journal hotadd
  raid5-cache: handle batch stripe for journal hotadd

 drivers/md/md.c          | 10 +++++++-
 drivers/md/md.h          |  2 ++
 drivers/md/raid5-cache.c | 61 +++++++++++++++++++++++++++++++++++++++---------
 drivers/md/raid5.c       | 20 ++++++++--------
 drivers/md/raid5.h       | 10 ++++----
 5 files changed, 76 insertions(+), 27 deletions(-)

-- 
2.4.6

