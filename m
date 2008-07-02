From: Neil Brown <neilb@suse.de>
Subject: [PULL-REQUEST] md bugfixes for 2.6.26
Date: Thu, 3 Jul 2008 08:24:36 +1000
Message-ID: <18540.36.610609.783148@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 please pull as follows:  three bugfixs that also need to go to
 -stable.

Thanks,
NeilBrown



The following changes since commit 543cf4cb3fe6f6cae3651ba918b9c56200b257d0:
  Linus Torvalds (1):
        Linux 2.6.26-rc8

are available in the git repository at:

  git://neil.brown.name/md for-2.6.26

Neil Brown (3):
      Ensure interrupted recovery completed properly (v1 metadata plus bitmap)
      Don't acknowlege that stripe-expand is complete until it really is.
      Fix error paths if md_probe fails.

 drivers/md/md.c     |    6 ++++--
 drivers/md/raid10.c |    2 ++
 drivers/md/raid5.c  |    7 ++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)
