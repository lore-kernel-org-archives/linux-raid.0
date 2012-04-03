From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 00/10] md patches for 3.5: RAID10 reshape
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The following patches are now in my queue for 3.5.
(I may add some more, but to avoid patch-bombing I sending these
 now as I think they are ready).

This is all about reshaping arrays and particularly RAID10.

As you probably know, RAID5 reshaping often needs a backup file.
That is a pain for a number of reasons and is slow.
So RAID10 does it without a backup file.

This is achieved by modifying the data_offset during the reshape,
so there is never any need to write data over data that is still
live.

Eventually I'll make RAID5 reshape work this way too (optionally)
however as 0.90 metadata doesn't allow data_offset to be changed,
this is a v1.x feature only.

I have initial patches to support some of this with mdadm, but I don't
know when they'll make it into a release.  I have a very strong
feeling that mdadm needs some major refactoring work before I can feel
happy about it again, and that might have to come first, or at least
it will not come last.
(I'll probably put the patches in my git tree sometime soon for
experimentation).

Review/comments/etc always welcome.

You can find all of these in my 'for-next' branch (and so in
linux-next in a day or so) if you would prefer to look at them that
way.

Thanks,
NeilBrown


---

NeilBrown (10):
      md/raid10: add reshape support
      md/raid10: split out interpretation of layout to separate function.
      md/raid10: Introduce 'prev' geometry to support reshape.
      md: use resync_max_sectors for reshape as well as resync.
      md: teach sync_page_io about new_data_offset.
      md/raid10: collect some geometry fields into a dedicated structure.
      md/raid5: allow for change in data_offset while managing a reshape.
      md/raid5:  Use correct data_offset for all IO.
      md: add possibility to change data-offset for devices.
      md: allow a reshape operation to be reversed.


 drivers/md/md.c           |  299 ++++++++++-
 drivers/md/md.h           |    8 
 drivers/md/raid1.c        |    4 
 drivers/md/raid10.c       | 1236 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid10.h       |   35 +
 drivers/md/raid5.c        |  206 +++++---
 drivers/md/raid5.h        |    6 
 include/linux/raid/md_p.h |   15 -
 8 files changed, 1565 insertions(+), 244 deletions(-)

-- 
Signature

