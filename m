From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Mon, 21 Nov 2016 12:19:43 +1100
Message-ID: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are 2 problems with using bi_phys_segments as a counter
1/ we only use 16bits, which limits bios to 256M
2/ it is poor form to reuse a field like this.  It interferes
   with other changes to bios.

We need to clean up a few things before we can change the use the
counter which is now available inside a bio.

I have only tested this lightly.  More review and testing would be
appreciated.

NeilBrown


---

NeilBrown (5):
      md: optimize md_write_start() slightly.
      md/raid5: use md_write_start to count stripes, not bios
      md/raid5: simplfy delaying of writes while metadata is updated.
      md/raid5: call bio_endio() directly rather than queuing for later.
      md/raid5: use bio_inc_remaining() instead of repurposing bi_phys_segments as a counter


 drivers/md/md.c    |   32 ++++++------
 drivers/md/raid5.c |  136 +++++++++++-----------------------------------------
 drivers/md/raid5.h |    4 --
 3 files changed, 44 insertions(+), 128 deletions(-)

--
Signature

