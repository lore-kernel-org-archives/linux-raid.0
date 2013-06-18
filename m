From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 1/6] raid6check: Fix build of raid6check
Date: Tue, 18 Jun 2013 11:09:16 +0200
Message-ID: <20130618090916.1161109.53519.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, piergiorgio.sartor@nexgo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After recent git pull 'make raid6check' did not work anymore, as
sysfs_read() was called with a wrong argument and as check_env()
was used by use_udev(), but not defined.


Replace sysfs_read(..., -1, ...) by sysfs_read(..., NULL, ...)

Move check_env() from util.c to lib.c

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 lib.c        |   10 ++++++++++
 raid6check.c |    2 +-
 util.c       |   10 ----------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib.c b/lib.c
index 1958029..2c3d936 100644
--- a/lib.c
+++ b/lib.c
@@ -378,6 +378,16 @@ void print_escape(char *str)
 	}
 }
 
+int check_env(char *name)
+{
+	char *val = getenv(name);
+
+	if (val && atoi(val) == 1)
+		return 1;
+
+	return 0;
+}
+
 int use_udev(void)
 {
 	static int use = -1;
diff --git a/raid6check.c b/raid6check.c
index e9a17a7..f5aeee4 100644
--- a/raid6check.c
+++ b/raid6check.c
@@ -386,7 +386,7 @@ int main(int argc, char *argv[])
 		goto exitHere;
 	}
 
-	info = sysfs_read(mdfd, -1,
+	info = sysfs_read(mdfd, NULL,
 			  GET_LEVEL|
 			  GET_LAYOUT|
 			  GET_DISKS|
diff --git a/util.c b/util.c
index 3ac63e3..7da69ac 100644
--- a/util.c
+++ b/util.c
@@ -1798,16 +1798,6 @@ int start_mdmon(char *devnm)
 	return 0;
 }
 
-int check_env(char *name)
-{
-	char *val = getenv(name);
-
-	if (val && atoi(val) == 1)
-		return 1;
-
-	return 0;
-}
-
 __u32 random32(void)
 {
 	__u32 rv;

