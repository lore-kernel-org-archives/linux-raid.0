From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD fix for 4.6-rc6
Date: Mon, 2 May 2016 10:32:57 -0700
Message-ID: <20160502173257.GA117944@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Linus,

please pull MD fix for 4.6. This update includes several trival fixes. =
The only
important one is to fix MD bio merge, which has big performance impact.

Thanks,
Shaohua

The following changes since commit 5b5b7fd185e997ebc18f76b98b9f4ff148d3=
f5bb:

  Merge branch 'parisc-4.6-3' of git://git.kernel.org/pub/scm/linux/ker=
nel/git/deller/parisc-linux (2016-04-09 14:10:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.6=
-rc6-fix

for you to fetch changes up to b8a0b8e94648179b92191e5cf4fd3c4379b31cc4=
:

  raid5: delete unnecessary warnning (2016-04-29 14:18:03 -0700)

----------------------------------------------------------------
Dan Carpenter (1):
      md/raid0: fix uninitialized variable bug

Micha=C5=82 Pecio (1):
      md/raid0: remove empty line printk from dump_zones

Shaohua Li (2):
      MD: make bio mergeable
      raid5: delete unnecessary warnning

 drivers/md/md.c    | 2 ++
 drivers/md/raid0.c | 2 +-
 drivers/md/raid5.c | 2 --
 3 files changed, 3 insertions(+), 3 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
