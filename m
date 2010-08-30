From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] minor md updates.
Date: Mon, 30 Aug 2010 18:32:28 +1000
Message-ID: <20100830183228.22cec1a6@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


My earlier pull request broke MD_CHANGE_CLEAN handling because it is confused.
So Dan fixed it, and then I made it all less confusing.

And when we moved raid6 from drivers/md to lib, we missed  the .gitignore
file.

Thanks,
NeilBrown


The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Dan Williams (1):
      md: don't clear MD_CHANGE_CLEAN in md_update_sb() for external arrays

NeilBrown (2):
      Move .gitignore from drivers/md to lib/raid6
      md: resolve confusion of MD_CHANGE_CLEAN

 drivers/md/.gitignore |    4 ----
 drivers/md/bitmap.c   |    3 +--
 drivers/md/md.c       |   25 ++++++++++---------------
 drivers/md/md.h       |    2 +-
 lib/raid6/.gitignore  |    4 ++++
 5 files changed, 16 insertions(+), 22 deletions(-)
 delete mode 100644 drivers/md/.gitignore
 create mode 100644 lib/raid6/.gitignore
