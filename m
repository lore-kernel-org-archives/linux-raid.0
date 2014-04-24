From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 04/11] Assemble: teardown partially assembled
 arrays
Date: Thu, 24 Apr 2014 00:22:38 -0700
Message-ID: <20140424072238.4515.63728.stgit@viggo.jf.intel.com>
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

In the scenario of assembling composite md arrays, e.g. /dev/md2 with
/dev/md1 and /dev/md0 as components, we want /dev/md2 assembly to be
delayed until the components are available.  If we attempt to assemble
/dev/md2 when only /dev/md0 is available /dev/md2 will not be fully
initialized, and /dev/md1 will be assembled to an equally defunct
/dev/md3.

So teardown the early /dev/md2 on the expectation that more devices will
arrive in a later assembly pass.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Assemble.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index a72d427f4773..9a2399ef6411 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1147,16 +1147,17 @@ static int start_array(int mdfd,
 		if (sparecnt)
 			fprintf(stderr, " and %d spare%s", sparecnt, sparecnt==1?"":"s");
 		if (!enough(content->array.level, content->array.raid_disks,
-			    content->array.layout, 1, avail))
+			    content->array.layout, 1, avail)) {
 			fprintf(stderr, " - not enough to start the array.\n");
-		else if (!enough(content->array.level,
+			ioctl(mdfd, STOP_ARRAY, NULL);
+		} else if (!enough(content->array.level,
 				 content->array.raid_disks,
 				 content->array.layout, clean,
-				 avail))
+				 avail)) {
 			fprintf(stderr, " - not enough to start the "
 				"array while not clean - consider "
 				"--force.\n");
-		else {
+		} else {
 			if (req_cnt == (unsigned)content->array.raid_disks)
 				fprintf(stderr, " - need all %d to start it", req_cnt);
 			else

