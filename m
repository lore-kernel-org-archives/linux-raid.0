From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD fix for 4.5-rc2
Date: Wed, 3 Feb 2016 16:49:55 -0800
Message-ID: <20160204004955.GA11987@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.com, gayatri.kammela@intel.com, snitzer@redhat.com
List-Id: linux-raid.ids

Hi Linus,

As you know, Neil steps down from MD. I'm looking after it. Here are some
patches queued. A build fix from Gayatri and several trival patches from me.
Please pull.

Thanks,
Shaohua

----------------------------------------------------------------
The following changes since commit b37a05c083c85c2657dca9bbe1f5d79dccf756d5:

  Merge branch 'akpm' (patches from Andrew) (2016-02-03 10:10:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-linus

for you to fetch changes up to 9ea064158f4e02e64890ee1261449b01e954e594:

  Merge branch 'mymd/for-next' into mymd/for-linus (2016-02-03 15:43:59 -0800)

----------------------------------------------------------------
Gayatri Kammela (1):
      raid6/algos.c : bug fix : Add the missing definitions to the pq.h file

Shaohua Li (5):
      MD: rename some functions
      MD: add myself as MD maintainer
      md-cluster: fix missing memory free
      md-cluster: delete useless code
      Merge branch 'mymd/for-next' into mymd/for-linus

 MAINTAINERS             |  1 +
 drivers/md/bitmap.c     |  4 ----
 drivers/md/faulty.c     | 18 +++++++++---------
 drivers/md/md-cluster.c |  6 +++++-
 drivers/md/raid1.c      | 21 +++++++++++----------
 drivers/md/raid10.c     | 20 ++++++++++----------
 drivers/md/raid5.c      | 45 +++++++++++++++++++++++----------------------
 include/linux/raid/pq.h |  2 ++
 8 files changed, 61 insertions(+), 56 deletions(-)
