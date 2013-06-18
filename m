From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 4/6] raid6check: Use enums for repair type
Date: Tue, 18 Jun 2013 11:09:31 +0200
Message-ID: <20130618090931.1161109.97315.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

Using hard coded numbers is error prone and hard to read by humans.


Signed-off-by: Bernd Schubert <bernd.schubert@fastmail.fm>
---
 raid6check.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index 17f7430..480422d 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -27,6 +27,12 @@
 #include <signal.h>
 #include <sys/mman.h>
 
+enum repair {
+	NO_REPAIR = 0,
+	MANUAL_REPAIR,
+	AUTO_REPAIR
+};
+
 int geo_map(int block, unsigned long long stripe, int raid_disks,
 	    int level, int layout);
 void qsyndrome(uint8_t *p, uint8_t *q, uint8_t **sources, int disks, int size);
@@ -142,7 +148,7 @@ int unlock_all_stripes(struct mdinfo *info, sighandler_t *sig) {
 int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		  int raid_disks, int chunk_size, int level, int layout,
 		  unsigned long long start, unsigned long long length, char *name[],
-		  int repair, int failed_disk1, int failed_disk2)
+		  enum repair repair, int failed_disk1, int failed_disk2)
 {
 	/* read the data and p and q blocks, and check we got them right */
 	char *stripe_buf = xmalloc(raid_disks * chunk_size);
@@ -220,7 +226,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		if(disk == -65535) {
 			printf("Error detected at %llu: disk slot unknown\n", start);
 		}
-		if(repair == 1) {
+		if(repair == MANUAL_REPAIR) {
 			printf("Repairing stripe %llu\n", start);
 			printf("Assuming slots %d (%s) and %d (%s) are incorrect\n",
 			       failed_disk1, name[failed_disk1],
@@ -284,7 +290,7 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 			err = unlock_all_stripes(info, sig);
 			if(err != 0)
 				goto exitCheck;
-		} else if (disk >= 0 && repair == 2) {
+		} else if (disk >= 0 && repair == AUTO_REPAIR) {
 			printf("Auto-repairing slot %d (%s)\n", disk, name[disk]);
 			if (disk == diskQ) {
 				qsyndrome(p, (uint8_t*)stripes[diskQ], (uint8_t**)blocks, data_disks, chunk_size);
@@ -357,7 +363,7 @@ int main(int argc, char *argv[])
 	int chunk_size = 0;
 	int layout = -1;
 	int level = 6;
-	int repair = 0;
+	enum repair repair = NO_REPAIR;
 	int failed_disk1, failed_disk2;
 	unsigned long long start, length;
 	int i;
@@ -447,7 +453,7 @@ int main(int argc, char *argv[])
 			exit_err = 1;
 			goto exitHere;
 		}
-		repair = 1;
+		repair = MANUAL_REPAIR;
 		start = getnum(argv[3], &err);
 		length = 1;
 		failed_disk1 = getnum(argv[4], &err);
@@ -473,7 +479,7 @@ int main(int argc, char *argv[])
 		start = getnum(argv[2], &err);
 		length = getnum(argv[3], &err);
 		if (argc >= 5 && strcmp(argv[4], "autorepair")==0)
-			repair = 2;
+			repair = AUTO_REPAIR;
 	}
 
 	if (err) {

