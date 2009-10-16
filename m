From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/11] md/raid1/raid10: add a cond_resched
Date: Fri, 16 Oct 2009 16:49:18 +1100
Message-ID: <20091016054917.24208.99548.stgit@notabene.brown>
References: <20091016054316.24208.33818.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091016054316.24208.33818.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

During 'check' of a raid1 or raid10 it is possible for the management
thread to spend a lot of time running 'memcmp' on blocks from
different devices, so make sure the thread has a chance to schedule.
raid5d already has a cond_resched (in process_stripe).

Reported-By: Lee Howard <faxguy@howardsilvan.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d1b9bd5..71a01a2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1683,6 +1683,7 @@ static void raid1d(mddev_t *mddev)
 				generic_make_request(bio);
 			}
 		}
+		cond_resched();
 	}
 	if (unplug)
 		unplug_slaves(mddev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 51c4c5c..69fc76c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1632,6 +1632,7 @@ static void raid10d(mddev_t *mddev)
 				generic_make_request(bio);
 			}
 		}
+		cond_resched();
 	}
 	if (unplug)
 		unplug_slaves(mddev);


