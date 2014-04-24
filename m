From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 03/11] Assemble: show the uuid in the verbose case
Date: Thu, 24 Apr 2014 00:22:33 -0700
Message-ID: <20140424072233.4515.83270.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

Make the verbose output more usable when the array name is not given.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Assemble.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 05ace561fb50..a72d427f4773 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1288,9 +1288,21 @@ try_again:
 	 */
 	if (!st && ident->st)
 		st = ident->st;
-	if (c->verbose>0)
-		pr_err("looking for devices for %s\n",
-		       mddev ? mddev : "further assembly");
+
+	if (c->verbose > 0) {
+		char uuid[64], *id;
+
+		if (mddev)
+			id = mddev;
+		else if (ident->uuid_set) {
+			__fname_from_uuid(ident->uuid,
+					  st ? st->ss->swapuuid : 0,
+					  uuid, ':');
+			id = uuid + 5;
+		} else
+			id = "further assembly";
+		pr_err("looking for devices for %s\n", id);
+	}
 
 	content = &info;
 	if (st)

