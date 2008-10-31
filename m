From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] one more fix for md:  destroy partitions when stopping an array.
Date: Fri, 31 Oct 2008 12:05:56 +1100
Message-ID: <18698.23028.593060.515670@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Just one more... :-)

    md: destroy partitions and notify udev when md array is stopped.
    
    md arrays are not currently destroyed when they are stopped - they
    remain in /sys/block.  Last time I tried this I tripped over locking
    too much.
    
    A consequence of this is that udev doesn't remove anything from /dev.
    This is rather ugly.
    
    As an interim measure until proper device removal can be achieved,
    make sure all partitions are removed using the BLKRRPART ioctl, and
    send a KOBJ_CHANGE when an md array is stopped.
    
    Signed-off-by: NeilBrown <neilb@suse.de>


Thanks,
NeilBrown


The following changes since commit f8d56f1771e4867acc461146764b4feeb5245669:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (1):
      md: destroy partitions and notify udev when md array is stopped.

 drivers/md/md.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
