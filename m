From: Jes.Sorensen@redhat.com
Subject: [PATCH] Print correct md device name if write_init_super fails
Date: Tue, 21 Feb 2012 13:30:02 +0100
Message-ID: <1329827402-12124-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: meyering@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This avoids a segfault in case one tries to create a raid from a non
existing device (like a loop device).

Reported by Jim Meyering in
https://bugzilla.redhat.com/show_bug.cgi?id=795461

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Create.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Create.c b/Create.c
index 90ff3ed..702ac34 100644
--- a/Create.c
+++ b/Create.c
@@ -926,7 +926,7 @@ int Create(struct supertype *st, char *mddev,
 			if (st->ss->write_init_super(st)) {
 				fprintf(stderr,
 					Name ": Failed to write metadata to %s\n",
-					dv->devname);
+					mddev);
 				st->ss->free_super(st);
 				goto abort_locked;
 			}
-- 
1.7.7.6

