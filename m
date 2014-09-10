From: NeilBrown <neilb@suse.de>
Subject: [PATCH 0/5] Fixes for RAID1 resync
Date: Wed, 10 Sep 2014 16:20:44 +1000
Message-ID: <20140910062039.26400.36745.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

This set of patches fixes all the issues that I could
find with the new raid1 resync code.
I didn't find anything that would obviously fix the hang
that Jon Brassow reported.

Jon: could you test with these patches on top of what you
have just in case something happens to fix the problem without
me realising it?

Eivind: if you could test too, I'd really appreciate it.

Thanks,
NeilBrown


---

NeilBrown (5):
      md/raid1:  be more cautious where we read-balance during resync.
      md/raid1: clean up request counts properly in close_sync()
      md/raid1: make sure resync waits for conflicting writes to complete.
      md/raid1: Don't use next_resync to determine how far resync has progressed
      md/raid1: update next_resync under resync_lock.


 drivers/md/raid1.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

-- 
Signature

