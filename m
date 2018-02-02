From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/2] Resend raid10-NULL-deref fix
Date: Sat, 03 Feb 2018 09:19:30 +1100
Message-ID: <151760990726.5944.15903931975424856346.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, yuyufen <yuyufen@huawei.com>, colyli@suse.de
List-Id: linux-raid.ids

Hi Shaohua,
 you asked me to resend this (second) patch with improved
 comments back in November, and it completely slipped my mind - sorry.
 I decided the comments would fit better in a separate patch,
 so following are a patch to add comments, and then the bugfix
 patch marked for -stable.

 You asked:

   This will bypass hotadd too, is it what we want?

 No, it doesn't.  In the only cases where the patch makes a
 difference, a non-NULL rdev will have been passed as "this",
 so hot-add will be skipped anyway.

 This patch includes a bugfix as reported by yuyufen
 
Thanks,
NeilBrown

---

NeilBrown (2):
      md: document lifetime of internal rdev pointer.
      md: only allow remove_and_add_spares when no sync_thread running.


 drivers/md/md.c     |    4 ++++
 drivers/md/raid1.h  |   12 ++++++++++++
 drivers/md/raid10.h |   13 +++++++++++++
 drivers/md/raid5.c  |    4 ++--
 drivers/md/raid5.h  |   12 ++++++++++++
 5 files changed, 43 insertions(+), 2 deletions(-)

--
Signature

