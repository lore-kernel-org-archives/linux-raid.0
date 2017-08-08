From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/2] Fix two bug in the new write_pending counting.
Date: Tue, 08 Aug 2017 16:56:36 +1000
Message-ID: <150217527795.23065.7747775748038187816.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, David R <david@unsolicited.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two separate bugs caused by the same patch.
One causes a hard lockup that was reported on the list.
Other found by inspection.
Both suitable for -stable.

Please review the second one closely.  I think it is correct now, but
then I thought it was correct before too :-(

Thanks,
NeilBrown


---

NeilBrown (2):
      md: always clear ->safemode when md_check_recovery gets the mddev lock.
      md: fix test in md_write_start()


 drivers/md/md.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--
Signature

