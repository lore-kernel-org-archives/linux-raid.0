From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 004 of 5] Add information about superblock version to /proc/mdstat
Date: Fri, 02 Sep 2005 16:12:54 +1000
Message-ID: <E1EB4nG-0008NI-0T@notabene.cse.unsw.edu.au>
References: <20050902161106.32018.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Leave it unchanged if the original (0.90) is used, incase it might
be a compatability problem.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 15:59:46.000000000 +1000
+++ ./drivers/md/md.c	2005-09-02 15:59:50.000000000 +1000
@@ -3346,6 +3346,15 @@ static int md_seq_show(struct seq_file *
 				seq_printf(seq, "\n      %llu blocks",
 					(unsigned long long)size);
 		}
+		if (mddev->persistent) {
+			if (mddev->major_version != 0 ||
+			    mddev->minor_version != 90) {
+				seq_printf(seq," super %d.%d",
+					   mddev->major_version,
+					   mddev->minor_version);
+			}
+		} else
+			seq_printf(seq, " super non-persistent");
 
 		if (mddev->pers) {
 			mddev->pers->status (seq, mddev);
