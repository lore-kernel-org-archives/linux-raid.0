From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 0/7] more md patches heading for 2.6.20
Date: Mon, 04 May 2009 16:58:49 +1000
Message-ID: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
List-Id: linux-raid.ids

Following are a few more patches which Linus will be asked to pull
shortly.
There are a few that fix up problems with bitmaps on raid10 arrays
larger than 2TB as found by Mario 'BitKoenig' Holbe.
And some other assorted bit.

A couple of these are destines for -stable.

NeilBrown

---

Jan Engelhardt (1):
      md: constify VFTs

NeilBrown (6):
      md: remove rd%d links immediately after stopping an array.
      md: remove ability to explicit set an inactive array to 'clean'.
      md: tidy up status_resync to handle large arrays.
      md: fix some (more) errors with bitmaps on devices larger than 2TB.
      md/raid10: don't clear bitmap during recovery if array will still be degraded.
      md: fix loading of out-of-date bitmap.


 drivers/md/bitmap.c |   29 +++++++++++----------
 drivers/md/md.c     |   70 ++++++++++++++++++++++++++++-----------------------
 drivers/md/raid10.c |   12 ++++-----
 3 files changed, 60 insertions(+), 51 deletions(-)

-- 
