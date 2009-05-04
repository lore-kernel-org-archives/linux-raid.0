From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 6/7] md: remove ability to explicit set an inactive array
	to 'clean'.
Date: Mon, 04 May 2009 16:58:50 +1000
Message-ID: <20090504065850.11688.1442.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Being able to write 'clean' to an 'array_state' of an inactive array
to activate it in 'clean' mode is both unnecessary and inconvenient.

It is unnecessary because the same can be achieved by writing
'active'.  This activates and array, but it still remains 'clean'
until the first write.

It is inconvenient because writing 'clean' is more often used to
cause an 'active' array to revert to 'clean' mode (thus blocking
any writes until a 'write-pending' is promoted to 'active').

Allowing 'clean' to both activate an array and mark an active array as
clean can lead to races:  One program writes 'clean' to mark the
active array as clean at the same time as another program writes
'inactive' to deactivate (stop) and active array.  Depending on which
writes first, the array could be deactivated and immediately
reactivated which isn't what was desired.

So just disable the use of 'clean' to activate an array.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8350bde..1dd723d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3066,11 +3066,8 @@ array_state_store(mddev_t *mddev, const char *buf, size_t len)
 			} else
 				err = -EBUSY;
 			spin_unlock_irq(&mddev->write_lock);
-		} else {
-			mddev->ro = 0;
-			mddev->recovery_cp = MaxSector;
-			err = do_md_run(mddev);
-		}
+		} else
+			err = -EINVAL;
 		break;
 	case active:
 		if (mddev->pers) {


