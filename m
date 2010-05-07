From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] two small fixes for md for 2.6.34
Date: Fri, 7 May 2010 21:13:07 +1000
Message-ID: <19427.62915.600797.337003@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Bryant <tenminjoe@yahoo.com>, "Gabriele A . Trombetti" <g.trombetti.lkrnl1213@logicschema.com>, Janos Haar <janos.haar@netcenter.hu>
List-Id: linux-raid.ids


Hi Linus,
 please consider pulling these two bug fixes for md for 2.6.34.
 They are not very serious bugs but can lead to unexpected behaviour
 and in one case doesn't protect your data quite as much as you would
 like is certain cases.

Thanks,
NeilBrown


The following changes since commit 722154e4cacf015161efe60009ae9be23d492296:
  Linus Torvalds (1):
        Merge branch 'zerolen' of git://git.kernel.org/.../jgarzik/misc-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

NeilBrown (1):
      md: restore ability of spare drives to spin down.

 drivers/md/md.c    |   10 ++++++++--
 drivers/md/raid5.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)
