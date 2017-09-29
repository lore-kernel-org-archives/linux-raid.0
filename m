From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.14-rc3
Date: Fri, 29 Sep 2017 11:43:01 -0700
Message-ID: <20170929184301.ms4brdhaafb2fppd@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
A few fixes for MD. Mainly fix a problem introduced in 4.13, which we retry bio
for some code paths but not all in some situration.

Thanks,
Shaohua

The following changes since commit 4a704d6db0ee4a349d5d523813a718e429b4914d:

  Merge tag 'kbuild-fixes-v4.14' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild (2017-09-21 06:01:03 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.14-rc3

for you to fetch changes up to 7d5d7b5058fbd638914e42504677141a69f43011:

  md/raid5: cap worker count (2017-09-27 20:08:44 -0700)

----------------------------------------------------------------
Shaohua Li (4):
      md: separate request handling
      md: fix a race condition for flush request handling
      dm-raid: fix a race condition in request handling
      md/raid5: cap worker count

 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 72 +++++++++++++++++++++++++++++++---------------------
 drivers/md/md.h      |  1 +
 drivers/md/raid5.c   |  7 +++--
 4 files changed, 50 insertions(+), 32 deletions(-)
