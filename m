Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B1CC00140
	for <linux-raid@archiver.kernel.org>; Fri, 12 Aug 2022 14:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiHLOwp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Aug 2022 10:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiHLOwo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Aug 2022 10:52:44 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7301F2F4
        for <linux-raid@vger.kernel.org>; Fri, 12 Aug 2022 07:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660315963; x=1691851963;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0L1lz1gdP0a3JQIuqzz5Y3MBX765v5fKphxYq53tUys=;
  b=VkZVRuio4HFXUsQW/VhchU82qMe4QHsTGivGuzSEKTYumvNcBf3D0qYv
   ywfgEGXMIbgI2ptgxR1MhHoK7wAoAaid1grmwn69s3bzO0Hh4VdoDTFfI
   E4AOTsj9wVhkpeHoHqGvIeUJgwu/NBxpizgbNBp+0471tTfQJMBYvYpPi
   WKTNjz/+cC+Sddp+HLf/QiWr8e3ATWSYIrMQ/R1XxD7x6gukMfkTriESC
   UPDr2RdLuo+kwrYL+zZ25gN6IaeSgsfsOIdabIu4a/b87Qjk0APh7wY5V
   aLAOPQy+JTa8PEbBMcgYfLWcKXNgzi0c8tLw9zPcNVDsL4NUKR3gA7RW5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="317578511"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="317578511"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 07:52:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="605934546"
Received: from unknown (HELO localhost.elements.local) ([10.102.102.57])
  by orsmga002.jf.intel.com with ESMTP; 12 Aug 2022 07:52:41 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] mdadm: Replace obsolete usleep with nanosleep
Date:   Fri, 12 Aug 2022 16:36:02 +0200
Message-Id: <20220812143602.15338-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

According to POSIX.1-2001, usleep is considered obsolete.
Replace it with a wrapper that uses nanosleep, as recommended in man.
Add handy macros for conversions between msec, usec and nsec.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 Assemble.c    |  2 +-
 Grow.c        |  4 ++--
 Manage.c      | 10 +++++-----
 managemon.c   |  8 ++++----
 mdadm.h       |  4 ++++
 mdmon.c       |  4 ++--
 super-intel.c |  6 +++---
 util.c        | 42 +++++++++++++++++++++++++++++++++---------
 8 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 9eac9ce0..1f14175d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1949,7 +1949,7 @@ out:
 						break;
 					close(mdfd);
 				}
-				usleep(usecs);
+				sleep_for(0, USEC_TO_NSEC(usecs), true);
 				usecs <<= 1;
 			}
 		}
diff --git a/Grow.c b/Grow.c
index 8a242b0f..6610423a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -954,7 +954,7 @@ int start_reshape(struct mdinfo *sra, int already_running,
 			err = sysfs_set_str(sra, NULL, "sync_action",
 					    "reshape");
 			if (err)
-				sleep(1);
+				sleep_for(1, 0, true);
 		} while (err && errno == EBUSY && cnt-- > 0);
 	}
 	return err;
@@ -5048,7 +5048,7 @@ int Grow_continue_command(char *devname, int fd,
 			}
 			st->ss->getinfo_super(st, content, NULL);
 			if (!content->reshape_active)
-				sleep(3);
+				sleep_for(3, 0, true);
 			else
 				break;
 		} while (cnt-- > 0);
diff --git a/Manage.c b/Manage.c
index f789e0c1..150a684c 100644
--- a/Manage.c
+++ b/Manage.c
@@ -244,7 +244,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 					    "array_state",
 					    "inactive")) < 0 &&
 		       errno == EBUSY) {
-			usleep(200000);
+			sleep_for(0, MSEC_TO_NSEC(200), true);
 			count--;
 		}
 		if (err) {
@@ -328,7 +328,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 		       sysfs_get_ll(mdi, NULL, "sync_max", &old_sync_max) == 0) {
 			/* must be in the critical section - wait a bit */
 			delay -= 1;
-			usleep(100000);
+			sleep_for(0, MSEC_TO_NSEC(100), true);
 		}
 
 		if (sysfs_set_str(mdi, NULL, "sync_action", "frozen") != 0)
@@ -405,7 +405,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 				 * quite started yet.  Wait a bit and
 				 * check  'sync_action' to see.
 				 */
-				usleep(10000);
+				sleep_for(0, MSEC_TO_NSEC(10), true);
 				sysfs_get_str(mdi, NULL, "sync_action", buf, sizeof(buf));
 				if (strncmp(buf, "reshape", 7) != 0)
 					break;
@@ -447,7 +447,7 @@ done:
 	count = 25; err = 0;
 	while (count && fd >= 0 &&
 	       (err = ioctl(fd, STOP_ARRAY, NULL)) < 0 && errno == EBUSY) {
-		usleep(200000);
+		sleep_for(0, MSEC_TO_NSEC(200), true);
 		count --;
 	}
 	if (fd >= 0 && err) {
@@ -1105,7 +1105,7 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
 				ret = sysfs_unique_holder(devnm, rdev);
 				if (ret < 2)
 					break;
-				usleep(100 * 1000);	/* 100ms */
+				sleep_for(0, MSEC_TO_NSEC(100), true);
 			} while (--count > 0);
 
 			if (ret == 0) {
diff --git a/managemon.c b/managemon.c
index 0e9bdf00..a7bfa8f6 100644
--- a/managemon.c
+++ b/managemon.c
@@ -207,7 +207,7 @@ static void replace_array(struct supertype *container,
 	remove_old();
 	while (pending_discard) {
 		while (discard_this == NULL)
-			sleep(1);
+			sleep_for(1, 0, true);
 		remove_old();
 	}
 	pending_discard = old;
@@ -568,7 +568,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 		updates = NULL;
 		while (update_queue_pending || update_queue) {
 			check_update_queue(container);
-			usleep(15*1000);
+			sleep_for(0, MSEC_TO_NSEC(15), true);
 		}
 		replace_array(container, a, newa);
 		if (sysfs_set_str(&a->info, NULL,
@@ -822,7 +822,7 @@ static void handle_message(struct supertype *container, struct metadata_update *
 	if (msg->len <= 0)
 		while (update_queue_pending || update_queue) {
 			check_update_queue(container);
-			usleep(15*1000);
+			sleep_for(0, MSEC_TO_NSEC(15), true);
 		}
 
 	if (msg->len == 0) { /* ping_monitor */
@@ -836,7 +836,7 @@ static void handle_message(struct supertype *container, struct metadata_update *
 		wakeup_monitor();
 
 		while (monitor_loop_cnt - cnt < 0)
-			usleep(10 * 1000);
+			sleep_for(0, MSEC_TO_NSEC(10), true);
 	} else if (msg->len == -1) { /* ping_manager */
 		struct mdstat_ent *mdstat = mdstat_read(1, 0);
 
diff --git a/mdadm.h b/mdadm.h
index 09915a00..1c3bc9e3 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1707,6 +1707,10 @@ extern int cluster_get_dlmlock(void);
 extern int cluster_release_dlmlock(void);
 extern void set_dlm_hooks(void);
 
+#define MSEC_TO_NSEC(msec) ((msec) * 1000000)
+#define USEC_TO_NSEC(usec) ((usec) * 1000)
+extern void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt);
+
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
 #define ROUND_UP_PTR(ptr, base)	((typeof(ptr)) \
diff --git a/mdmon.c b/mdmon.c
index 5570574b..2f8e676f 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -99,7 +99,7 @@ static int clone_monitor(struct supertype *container)
 	if (rc)
 		return rc;
 	while (mon_tid == -1)
-		usleep(10);
+		sleep_for(0, USEC_TO_NSEC(10), true);
 	pthread_attr_destroy(&attr);
 
 	mgr_tid = syscall(SYS_gettid);
@@ -209,7 +209,7 @@ static void try_kill_monitor(pid_t pid, char *devname, int sock)
 		rv = kill(pid, SIGUSR1);
 		if (rv < 0)
 			break;
-		usleep(200000);
+		sleep_for(0, MSEC_TO_NSEC(200), true);
 	}
 }
 
diff --git a/super-intel.c b/super-intel.c
index ba3bd41f..65c42089 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5220,7 +5220,7 @@ static int get_super_block(struct intel_super **super_list, char *devnm, char *d
 	/* retry the load if we might have raced against mdmon */
 	if (err == 3 && devnm && mdmon_running(devnm))
 		for (retry = 0; retry < 3; retry++) {
-			usleep(3000);
+			sleep_for(0, MSEC_TO_NSEC(3), true);
 			err = load_and_parse_mpb(dfd, s, NULL, keep_fd);
 			if (err != 3)
 				break;
@@ -5322,7 +5322,7 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 
 		if (mdstat && mdmon_running(mdstat->devnm) && getpid() != mdmon_pid(mdstat->devnm)) {
 			for (retry = 0; retry < 3; retry++) {
-				usleep(3000);
+				sleep_for(0, MSEC_TO_NSEC(3), true);
 				rv = load_and_parse_mpb(fd, super, devname, 0);
 				if (rv != 3)
 					break;
@@ -11991,7 +11991,7 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int ndata)
 				close(fd);
 				return 1;
 			}
-			usleep(30000);
+			sleep_for(0, MSEC_TO_NSEC(30), true);
 		} else
 			break;
 	} while (retry--);
diff --git a/util.c b/util.c
index cc94f96e..f9d3e6e0 100644
--- a/util.c
+++ b/util.c
@@ -166,7 +166,7 @@ retry:
 		pr_err("error %d when get PW mode on lock %s\n", errno, str);
 		/* let's try several times if EAGAIN happened */
 		if (dlm_lock_res->lksb.sb_status == EAGAIN && retry_count < 10) {
-			sleep(10);
+			sleep_for(10, 0, true);
 			retry_count++;
 			goto retry;
 		}
@@ -1085,7 +1085,7 @@ int open_dev_excl(char *devnm)
 	int i;
 	int flags = O_RDWR;
 	dev_t devid = devnm2devid(devnm);
-	long delay = 1000;
+	unsigned int delay = 1; // miliseconds
 
 	sprintf(buf, "%d:%d", major(devid), minor(devid));
 	for (i = 0; i < 25; i++) {
@@ -1098,8 +1098,8 @@ int open_dev_excl(char *devnm)
 		}
 		if (errno != EBUSY)
 			return fd;
-		usleep(delay);
-		if (delay < 200000)
+		sleep_for(0, MSEC_TO_NSEC(delay), true);
+		if (delay < 200)
 			delay *= 2;
 	}
 	return -1;
@@ -1123,7 +1123,7 @@ void wait_for(char *dev, int fd)
 {
 	int i;
 	struct stat stb_want;
-	long delay = 1000;
+	unsigned int delay = 1; // miliseconds
 
 	if (fstat(fd, &stb_want) != 0 ||
 	    (stb_want.st_mode & S_IFMT) != S_IFBLK)
@@ -1135,8 +1135,8 @@ void wait_for(char *dev, int fd)
 		    (stb.st_mode & S_IFMT) == S_IFBLK &&
 		    (stb.st_rdev == stb_want.st_rdev))
 			return;
-		usleep(delay);
-		if (delay < 200000)
+		sleep_for(0, MSEC_TO_NSEC(delay), true);
+		if (delay < 200)
 			delay *= 2;
 	}
 	if (i == 25)
@@ -1821,7 +1821,7 @@ int hot_remove_disk(int mdfd, unsigned long dev, int force)
 	while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
 	       errno == EBUSY &&
 	       cnt-- > 0)
-		usleep(10000);
+		sleep_for(0, MSEC_TO_NSEC(10), true);
 
 	return ret;
 }
@@ -1834,7 +1834,7 @@ int sys_hot_remove_disk(int statefd, int force)
 	while ((ret = write(statefd, "remove", 6)) == -1 &&
 	       errno == EBUSY &&
 	       cnt-- > 0)
-		usleep(10000);
+		sleep_for(0, MSEC_TO_NSEC(10), true);
 	return ret == 6 ? 0 : -1;
 }
 
@@ -2375,3 +2375,27 @@ out:
 	close(fd_zero);
 	return ret;
 }
+
+/**
+ * sleep_for() - Sleeps for specified time.
+ * @sec: Seconds to sleep for.
+ * @nsec: Nanoseconds to sleep for, has to be less than one second.
+ * @wake_after_interrupt: If set, wake up if interrupted.
+ *
+ * Function immediately returns if error different than EINTR occurs.
+ */
+void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt)
+{
+	struct timespec delay = {.tv_sec = sec, .tv_nsec = nsec};
+
+	assert(nsec < MSEC_TO_NSEC(1000));
+
+	do {
+		errno = 0;
+		nanosleep(&delay, &delay);
+		if (errno != 0 && errno != EINTR) {
+			pr_err("Error sleeping for %us %ldns: %s\n", sec, nsec, strerror(errno));
+			return;
+		}
+	} while (!wake_after_interrupt && errno == EINTR);
+}
-- 
2.26.2

