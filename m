From: Neil Brown <neilb@suse.de>
Subject: [PULL-REQUEST] md: remove a potential deadlock.
Date: Mon, 9 Mar 2009 10:12:49 +1100
Message-ID: <18868.20721.541359.900702@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


Hi Linus / stable.

 The following fixes a potential deadlock in md.  The possibility has
 been around for a while, but only more recently has userspace code
 been acting in a way that is likely to trigger it.

 It is tagged "Cc: <stable@kernel.org>" to make sure stable eventually
 gets it.

Thanks,
NeilBrown


The following changes since commit fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc:
  Linus Torvalds (1):
        Linux 2.6.29-rc7

are available in the git repository at:

  git://neil.brown.name/md for-linus

Dan Williams (1):
      md: fix deadlock when stopping arrays

 drivers/md/md.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)
