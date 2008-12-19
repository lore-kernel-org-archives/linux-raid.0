From: Neil Brown <neilb@suse.de>
Subject: [PULL-REQUEST] md: avoid bogus read error on large-PAGE_SIZE machines
Date: Fri, 19 Dec 2008 16:44:19 +1100
Message-ID: <18763.13491.611860.250273@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids



Hoping this isn't too late for 2.6.28.

This fixes a bug that makes it impossible to start md arrays with
write-intent-bitmaps on machines with 64K PAGE_SIZE.
We read whole pages and as easily fall off the end of the device.

It is a bug that has been around for a long time and is suitable for
any currently maintained -stable.  As such it has a 
Cc: stable@kernel.org
line.

Thanks,
NeilBrown



The following changes since commit 55dac3a5553b13891f0ae4bbd11920619b5436d4:
  Linus Torvalds (1):
        Merge branch 'i2c-fixes' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md: Don't read past end of bitmap when reading bitmap.

 drivers/md/bitmap.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)
