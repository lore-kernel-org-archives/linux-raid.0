From: CoolCold <coolthecold@gmail.com>
Subject: [PATCH] Update documentation for sync_min and sync_max entries
Date: Tue, 15 Mar 2011 15:30:38 +0300
Message-ID: <AANLkTinEzjxW6ZFkBWYc6UY6Pus1NoY_O+bKyCoDgC6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This patch is against 2.6.37 (
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
, commit id 97b197f07d15dbcd53328e75754e2f947814c733 ) but I didn't
notice any changes in 2.6.38 though.

linux/Documentation/md.txt is missing description for sync_min and
sync_max entries.
This patch adds description for sync_min and sync_max entries.

Signed-off-by: Roman Ovchinnikov <coolthecold@gmail.com>
---
 Documentation/md.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/md.txt b/Documentation/md.txt
index a81c7b4..8f8cb4f 100644
--- a/Documentation/md.txt
+++ b/Documentation/md.txt
@@ -552,6 +552,16 @@ also have
      within the array where IO will be blocked.  This is currently
      only supported for raid4/5/6.

+   sync_min
+   sync_max
+     The two values, given as numbers of sectors, indicate a range
+     withing the array where 'check'/'repair' will operate. Must be
+     a multiple of chunk_size. When it reaches "sync_max" it will
+     pause, rather than complete.
+     You can use 'select' or 'poll' on "sync_completed" to wait for
+     that number to reach sync_max.  Then you can either increase
+     "sync_max", or can write 'idle' to "sync_action".
+

 Each active md device may also have attributes specific to the
 personality module that manages it.
