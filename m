From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: Wed, 12 Mar 2003 14:59:36 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E18sxOy-0004pf-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Here are 12 patches for md/raid in 2.5.latest.
As well as some tidy-ups and bug fixes they include:

  /proc/mdstat as a seq_file
  "safe_mode" is always on, but normally with a 20msec delay. 
    This means that if there are no writes for 20msec, the superblock
    is marked 'clean' so that an unclean shutdown does not cause
    a complete resync.
  New super-block format (no user-level code to support this yet).

NeilBrown

### Comments for ChangeSet

Whenever a ITERATE_MDDEV loop is exitted abnormally
we need to mddev_put the current mddev.  There was
one point in md_do_sync where we didn't so use counts
became wrong.

 ----------- Diffstat output ------------
 ./drivers/md/md.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-03-12 09:31:38.000000000 +1100
+++ ./drivers/md/md.c	2003-03-12 09:31:38.000000000 +1100
@@ -2920,8 +2920,10 @@ static void md_do_sync(void *data)
 					goto skip;
 				}
 			}
-			if (mddev->curr_resync == 1)
+			if (mddev->curr_resync == 1) {
+				mddev_put(mddev2);
 				break;
+			}
 		}
 	} while (mddev->curr_resync < 2);
 
