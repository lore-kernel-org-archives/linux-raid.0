From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 5/6] raid6check: Fix compiler warnings.
Date: Tue, 18 Jun 2013 11:09:36 +0200
Message-ID: <20130618090936.1161109.67664.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
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

Fix some compiler warnings appearing with optimization levels.

Signed-off-by: Bernd Schubert <bernd.schubert@fastmail.fm>
---
 raid6check.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/raid6check.c b/raid6check.c
index 480422d..90a7fd3 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -186,7 +186,12 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 		}
 		for (i = 0 ; i < raid_disks ; i++) {
 			lseek64(source[i], offsets[i] + start * chunk_size, 0);
-			read(source[i], stripes[i], chunk_size);
+			int read_res = read(source[i], stripes[i], chunk_size);
+			if (read_res < chunk_size) {
+				fprintf(stderr, "Failed to read complete chunk disk %d, aborting\n", i);
+				unlock_all_stripes(info, sig);
+				goto exitCheck;
+			}
 		}
 		err = unlock_all_stripes(info, sig);
 		if(err != 0)
@@ -282,14 +287,23 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 				goto exitCheck;
 			}
 
+			int write_res1, write_res2;
+
 			lseek64(source[failed_disk1], offsets[failed_disk1] + start * chunk_size, 0);
-			write(source[failed_disk1], stripes[failed_disk1], chunk_size);
+			write_res1 = write(source[failed_disk1], stripes[failed_disk1], chunk_size);
 			lseek64(source[failed_disk2], offsets[failed_disk2] + start * chunk_size, 0);
-			write(source[failed_disk2], stripes[failed_disk2], chunk_size);
+			write_res2 = write(source[failed_disk2], stripes[failed_disk2], chunk_size);
 
 			err = unlock_all_stripes(info, sig);
 			if(err != 0)
 				goto exitCheck;
+
+
+			if (write_res1 != chunk_size || write_res2 != chunk_size) {
+				fprintf(stderr, "Failed to write a complete chunk.\n");
+				goto exitCheck;
+			}
+
 		} else if (disk >= 0 && repair == AUTO_REPAIR) {
 			printf("Auto-repairing slot %d (%s)\n", disk, name[disk]);
 			if (disk == diskQ) {
@@ -314,11 +328,16 @@ int check_stripes(struct mdinfo *info, int *source, unsigned long long *offsets,
 			}
 
 			lseek64(source[disk], offsets[disk] + start * chunk_size, 0);
-			write(source[disk], stripes[disk], chunk_size);
+			int write_res = write(source[disk], stripes[disk], chunk_size);
 
 			err = unlock_all_stripes(info, sig);
-			if(err != 0)
+			if(err != 0 || write_res != chunk_size)
 				goto exitCheck;
+
+			if (write_res != chunk_size) {
+				fprintf(stderr, "Failed to write a full chunk.\n");
+				goto exitCheck;
+			}
 		}
 
 
@@ -364,7 +383,8 @@ int main(int argc, char *argv[])
 	int layout = -1;
 	int level = 6;
 	enum repair repair = NO_REPAIR;
-	int failed_disk1, failed_disk2;
+	int failed_disk1 = -1; 
+	int failed_disk2 = -1;
 	unsigned long long start, length;
 	int i;
 	int mdfd;

