From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/5] Check return of stat() to avoid covscan complaining
Date: Tue, 24 Feb 2015 16:00:37 -0500
Message-ID: <1424811640-26569-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424811640-26569-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Assemble.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Assemble.c b/Assemble.c
index 131f871..b392214 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -688,7 +688,11 @@ static int load_devices(struct devs *devices, char *devmap,
 			close(dfd);
 		}
 
-		stat(devname, &stb);
+		if (stat(devname, &stb)) {
+			pr_err("Unsable to stat(%s) - skipping device.\n",
+			       devname);
+			continue;
+		}
 
 		if (c->verbose > 0)
 			pr_err("%s is identified as a member of %s, slot %d%s.\n",
-- 
2.1.0

