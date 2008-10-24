From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] supplementary md patches for 2.6.28
Date: Fri, 24 Oct 2008 15:43:42 +1100
Message-ID: <18689.21118.233817.75472@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-raid.ids


These patches cause md to make use of some functionality that was
added to the kernel since 2.6.27 and so were not in the main batch of
md patches.

The first two convert some calls in md from sysfs_notify to
sysfs_notify_dirent.  sysfs_notify_dirent arrived recently via Greg KH
and is a cleaner interface for sysfs notification.  There are some
further conversions that can happen later, but these two are in places
where the new call makes a real difference.

The third causes md to use the new extended partitioning scheme
(thanks Tejun) so that regular md devices (e.g. /dev/mdX - major
number 9) can have partitions.  This means we could eventually
deprecate the 'mdp' alternate major number that allows partitions md
devices.

Thanks,
NeilBrown


The following changes since commit 0cfd81031a26717fe14380d18275f8e217571615:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (3):
      md: use sysfs_notify_dirent to notify changes to md/array_state
      md: use sysfs_notify_dirent to notify changes to md/dev-xxx/state
      md: allow extended partitions on md devices.

 drivers/md/md.c           |   56 ++++++++++++++++++++++++++------------------
 include/linux/raid/md_k.h |    8 +++++-
 2 files changed, 40 insertions(+), 24 deletions(-)
