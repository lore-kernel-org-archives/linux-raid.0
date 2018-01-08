From: Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH resubmit] Assemble: prevent segfault with faulty "best"
 devices
Date: Mon, 8 Jan 2018 19:23:46 +0100
Message-ID: <20180108182346.GA16046@Dell>
References: <87bmnpsh43.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bmnpsh43.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: Robert LeBlanc <robert@leblancnet.us>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In Assemble(), after context reload, best[i] can be -1 in some cases,
and before checking if this value is negative we use it to access
devices[j].i.disk.raid_disk, potentially causing a segfault.

Check if best[i] is negative before using it to prevent this potential
segfault.

Regression was causes by commit 69a481166be6 ("Assemble array with write
journal").

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 Assemble.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 3da0903..fc681eb 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1669,6 +1669,8 @@ try_again:
 		int j = best[i];
 		unsigned int desired_state;
 
+		if (j < 0)
+			continue;
 		if (devices[j].i.disk.raid_disk == MD_DISK_ROLE_JOURNAL)
 			desired_state = (1<<MD_DISK_JOURNAL);
 		else if (i >= content->array.raid_disks * 2)
@@ -1678,8 +1680,6 @@ try_again:
 		else
 			desired_state = (1<<MD_DISK_ACTIVE) | (1<<MD_DISK_SYNC);
 
-		if (j<0)
-			continue;
 		if (!devices[j].uptodate)
 			continue;
 

