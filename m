From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 6/6] raid6check: Check return value of lseek64()
Date: Tue, 18 Jun 2013 11:09:41 +0200
Message-ID: <20130618090941.1161109.24782.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
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

If lseek64() failed it was still writing to the disks, which would introduce
data corruption.

Signed-off-by: Bernd Schubert <bernd.schubert@fastmail.fm>
---
 raid6check.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index 90a7fd3..ee0de2f 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -185,11 +185,19 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 			goto exitCheck;
 		}
 		for (i = 0 ; i < raid_disks ; i++) {
-			lseek64(source[i], offsets[i] + start * chunk_size, 0);
+			off64_t seek_res = lseek64(source[i], offsets[i] + start * chunk_size, 
+						   SEEK_SET);
+			if (seek_res < 0) {
+				fprintf(stderr, "lseek to source %d failed\n", i);
+				unlock_all_stripes(info, sig);
+				err = -1;
+				goto exitCheck;
+			}
 			int read_res = read(source[i], stripes[i], chunk_size);
 			if (read_res < chunk_size) {
 				fprintf(stderr, "Failed to read complete chunk disk %d, aborting\n", i);
 				unlock_all_stripes(info, sig);
+				err = -1;
 				goto exitCheck;
 			}
 		}
@@ -288,17 +296,33 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 			}
 
 			int write_res1, write_res2;
+			off64_t seek_res;
 
-			lseek64(source[failed_disk1], offsets[failed_disk1] + start * chunk_size, 0);
+			seek_res = lseek64(source[failed_disk1], 
+					   offsets[failed_disk1] + start * chunk_size, SEEK_SET);
+			if (seek_res < 0) {
+				fprintf(stderr, "lseek failed for failed_disk1\n");
+				unlock_all_stripes(info, sig);
+				err = -1;
+				goto exitCheck;
+			}
 			write_res1 = write(source[failed_disk1], stripes[failed_disk1], chunk_size);
-			lseek64(source[failed_disk2], offsets[failed_disk2] + start * chunk_size, 0);
+
+
+			seek_res = lseek64(source[failed_disk2], 
+					   offsets[failed_disk2] + start * chunk_size, SEEK_SET);
+			if (seek_res < 0) {
+				fprintf(stderr, "lseek failed for failed_disk1\n");
+				unlock_all_stripes(info, sig);
+				err = -1;
+				goto exitCheck;
+			}
 			write_res2 = write(source[failed_disk2], stripes[failed_disk2], chunk_size);
 
 			err = unlock_all_stripes(info, sig);
 			if(err != 0)
 				goto exitCheck;
 
-
 			if (write_res1 != chunk_size || write_res2 != chunk_size) {
 				fprintf(stderr, "Failed to write a complete chunk.\n");
 				goto exitCheck;

