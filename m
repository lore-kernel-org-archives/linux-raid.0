From: NeilBrown <neilb@suse.de>
Subject: [PATCH 0/8] Fixes for md/raid5 stripe batching code.
Date: Fri, 22 May 2015 15:30:58 +1000
Message-ID: <20150522052802.2117.40527.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Shaohua,
 thanks for explaining a bit more your thinking about this code.

 I've been testing and reviewing and found a few bugs and done some
 cleaning up (e.g. share code).  It seems to be working OK and I'm
 starting to feel confident about it.

 Could you please review all of these patches and confirm that the
 changes I have made are consistent with your understanding of how it
 should work?  Maybe if you could test (there are all in my for-next
 branch) and make sure the performance improvements are still there,
 that would be great.

Thanks,
NeilBrown


---

NeilBrown (8):
      md/raid5: ensure whole batch is delayed for all required bitmap updates.
      md/raid5: Ensure a batch member is not handled prematurely.
      md/raid5: remove condition test from check_break_stripe_batch_list.
      md/raid5: duplicate some more handle_stripe_clean_event code in break_stripe_batch_list
      md/raid5: add handle_flags arg to break_stripe_batch_list.
      md/raid5: be more selective about distributing flags across batch.
      md/raid5: call break_stripe_batch_list from handle_stripe_clean_event
      md/raid5: break stripe-batches when the array has failed.


 drivers/md/raid5.c |  122 ++++++++++++++++++++++++++++------------------------
 drivers/md/raid5.h |    2 -
 2 files changed, 66 insertions(+), 58 deletions(-)

--
Signature

