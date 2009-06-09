From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 0/3] reshape bug fixes for 2.6.30
Date: Tue, 09 Jun 2009 16:39:57 +1000
Message-ID: <20090609063828.11737.65814.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 just for general information and review, I've nearly got
 mdadm to request and manage the new reshape modes and testing
 has revealed a few bugs in the kernel.
 So the following three are off to Linus shortly, hopefully in
 time for 2.6.30.

NeilBrown


---

NeilBrown (3):
      md/raid5: fix bug in reshape code when chunk_size decreases.
      md/raid5 - avoid deadlocks in get_active_stripe during reshape
      md/raid5: use conf->raid_disks in preference to mddev->raid_disk


 drivers/md/raid5.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

-- 

