From: Neil Brown <neilb@suse.de>
Subject: [PULL request]  md fixes for 2.6.36
Date: Thu, 7 Oct 2010 12:57:56 +1100
Message-ID: <20101007125756.15d5d5c8@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, Vasiliy Kulikov <segooon@gmail.com>, George Spelvin <linux@horizon.com>, maciej.rutecki@gmail.com
List-Id: linux-raid.ids


Hi Linus,
 It turns out there is a regression:
     https://bugzilla.kernel.org/show_bug.cgi?id=19642

that was my fault.
The first of these three patches (avoid overflow...) fixes it.
The other two are very small fixes that seem suitable to include at this time.

Thanks,
NeilBrown


The following changes since commit 7c6d45e665d5322401e4439060bbf758b08422d4:

  powerpc: remove unused variable (2010-10-05 17:27:54 -0700)

are available in the git repository at:
  git://neil.brown.name/md for-linus

NeilBrown (2):
      md/raid1:  avoid overflow in raid1 resync when bitmap is in use.
      md/raid1: minor bio initialisation improvements.

Vasiliy Kulikov (1):
      md: check return code of read_sb_page

 drivers/md/bitmap.c |    9 +++++----
 drivers/md/raid1.c  |    4 +++-
 2 files changed, 8 insertions(+), 5 deletions(-)
