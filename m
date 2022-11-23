Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46361C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 23 Nov 2022 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbiKWTKO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239768AbiKWTKE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Nov 2022 14:10:04 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16208FE7A
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 11:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=mMdMtZmpvWFfCJzzZCvEWJl2sHKNaM9hteKbeSqTUG0=; b=rTMcXOfbnj5A8FEfOCfDpaVuJ4
        QStDuimaZb3wYCDdOmVOtjrpv5jWLywFQXpZRz06px2+3r5F4niglZTam37foIByGBpr/IAgpC+HM
        nuFFyBVdnP7Ke88qWfEmknTGevEPUddz0cr/YXfwZrdFdDqGt+kPpZ5nGj6SqwsO3jqloLzz+dSB3
        OnDCcRs7zifilnyQOoVxaFyptdcZOrwMXKPWliRNgAjUeIvMEZUjHtRHSKsRnJf3hNmKVf17LcvcN
        5dExfz4IzGa7Pe+gvI0SFnLiFakkM5Um1Zj5qkhHdnFfZHPXttExhpoe5hafcj8iWINo7fh8elokf
        NnGNablQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv8C-009Siy-PO; Wed, 23 Nov 2022 12:10:01 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1oxv89-000Oph-4p; Wed, 23 Nov 2022 12:09:57 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Date:   Wed, 23 Nov 2022 12:09:52 -0700
Message-Id: <20221123190954.95391-6-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123190954.95391-1-logang@deltatee.com>
References: <20221123190954.95391-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v6 5/7] mdadm: Add --write-zeros option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add the --write-zeros option for Create which will send a write zeros
request to all the disks before assembling the array. After zeroing
the array, the disks will be in a known clean state and the initial
sync may be skipped.

Writing zeroes is best used when there is a hardware offload method
to zero the data. But even still, zeroing can take several minutes on
a large device. Because of this, all disks are zeroed in parallel using
their own forked process and a message is printed to the user. The main
process will proceed only after all the zeroing processes have completed
successfully.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
---
 Create.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ReadMe.c |   2 +
 mdadm.c  |   9 +++
 mdadm.h  |   5 ++
 4 files changed, 189 insertions(+), 2 deletions(-)

diff --git a/Create.c b/Create.c
index 4acda30c5256..a6bf1ccd296b 100644
--- a/Create.c
+++ b/Create.c
@@ -26,6 +26,10 @@
 #include	"md_u.h"
 #include	"md_p.h"
 #include	<ctype.h>
+#include	<fcntl.h>
+#include	<signal.h>
+#include	<sys/signalfd.h>
+#include	<sys/wait.h>
 
 static int round_size_and_verify(unsigned long long *size, int chunk)
 {
@@ -91,9 +95,148 @@ int default_layout(struct supertype *st, int level, int verbose)
 	return layout;
 }
 
+static pid_t write_zeroes_fork(int fd, struct shape *s, struct supertype *st,
+			       struct mddev_dev *dv)
+
+{
+	const unsigned long long req_size = 1 << 30;
+	unsigned long long offset_bytes, size_bytes, sz;
+	sigset_t sigset;
+	int ret = 0;
+	pid_t pid;
+
+	size_bytes = KIB_TO_BYTES(s->size);
+
+	/*
+	 * If size_bytes is zero, this is a zoned raid array where
+	 * each disk is of a different size and uses its full
+	 * disk. Thus zero the entire disk.
+	 */
+	if (!size_bytes && !get_dev_size(fd, dv->devname, &size_bytes))
+		return -1;
+
+	if (dv->data_offset != INVALID_SECTORS)
+		offset_bytes = SEC_TO_BYTES(dv->data_offset);
+	else
+		offset_bytes = SEC_TO_BYTES(st->data_offset);
+
+	pr_info("zeroing data from %lld to %lld on: %s\n",
+		offset_bytes, size_bytes, dv->devname);
+
+	pid = fork();
+	if (pid < 0) {
+		pr_err("Could not fork to zero disks: %m\n");
+		return pid;
+	} else if (pid != 0) {
+		return pid;
+	}
+
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIGINT);
+	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
+
+	while (size_bytes) {
+		/*
+		 * Split requests to the kernel into 1GB chunks seeing the
+		 * fallocate() call is not interruptible and blocking a
+		 * ctrl-c for several minutes is not desirable.
+		 *
+		 * 1GB is chosen as a compromise: the user may still have
+		 * to wait several seconds if they ctrl-c on devices that
+		 * zero slowly, but will reduce the number of requests
+		 * required and thus the overhead on devices that perform
+		 * better.
+		 */
+		sz = size_bytes;
+		if (sz >= req_size)
+			sz = req_size;
+
+		if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+			      offset_bytes, sz)) {
+			pr_err("zeroing %s failed: %m\n", dv->devname);
+			ret = 1;
+			break;
+		}
+
+		offset_bytes += sz;
+		size_bytes -= sz;
+	}
+
+	exit(ret);
+}
+
+static int wait_for_zero_forks(int *zero_pids, int count)
+{
+	int wstatus, ret = 0, i, sfd, wait_count = 0;
+	struct signalfd_siginfo fdsi;
+	bool interrupted = false;
+	sigset_t sigset;
+	ssize_t s;
+
+	for (i = 0; i < count; i++)
+		if (zero_pids[i])
+			wait_count++;
+	if (!wait_count)
+		return 0;
+
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIGINT);
+	sigaddset(&sigset, SIGCHLD);
+	sigprocmask(SIG_BLOCK, &sigset, NULL);
+
+	sfd = signalfd(-1, &sigset, 0);
+	if (sfd < 0) {
+		pr_err("Unable to create signalfd: %m");
+		return 1;
+	}
+
+	while (1) {
+		s = read(sfd, &fdsi, sizeof(fdsi));
+		if (s != sizeof(fdsi)) {
+			pr_err("Invalid signalfd read: %m");
+			close(sfd);
+			return 1;
+		}
+
+		if (fdsi.ssi_signo == SIGINT) {
+			printf("\n");
+			pr_info("Interrupting zeroing processes, please wait...\n");
+			interrupted = true;
+		} else if (fdsi.ssi_signo == SIGCHLD) {
+			if (!--wait_count)
+				break;
+		}
+	}
+
+	close(sfd);
+
+	for (i = 0; i < count; i++) {
+		if (!zero_pids[i])
+			continue;
+
+		waitpid(zero_pids[i], &wstatus, 0);
+		zero_pids[i] = 0;
+		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
+			ret = 1;
+	}
+
+	if (interrupted) {
+		pr_err("zeroing interrupted!\n");
+		return 1;
+	}
+
+	if (ret)
+		pr_err("zeroing failed!\n");
+	else
+		pr_info("zeroing finished\n");
+
+	return ret;
+}
+
 static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 		struct supertype *st, struct mddev_dev *dv,
-		struct mdinfo *info, int have_container, int major_num)
+		struct mdinfo *info, int have_container, int major_num,
+		int *zero_pid)
 {
 	dev_t rdev;
 	int fd;
@@ -148,6 +291,14 @@ static int add_disk_to_super(int mdfd, struct shape *s, struct context *c,
 	}
 	st->ss->getinfo_super(st, info, NULL);
 
+	if (fd >= 0 && s->write_zeroes) {
+		*zero_pid = write_zeroes_fork(fd, s, st, dv);
+		if (*zero_pid <= 0) {
+			ioctl(mdfd, STOP_ARRAY, NULL);
+			return 1;
+		}
+	}
+
 	if (have_container && c->verbose > 0)
 		pr_err("Using %s for device %d\n",
 		       map_dev(info->disk.major, info->disk.minor, 0),
@@ -224,10 +375,23 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
 {
 	struct mddev_dev *moved_disk = NULL;
 	int pass, raid_disk_num, dnum;
+	int zero_pids[total_slots];
 	struct mddev_dev *dv;
 	struct mdinfo *infos;
+	sigset_t sigset, orig_sigset;
 	int ret = 0;
 
+	/*
+	 * Block SIGINT so the main thread will always wait for the
+	 * zeroing processes when being interrupted. Otherwise the
+	 * zeroing processes will finish their work in the background
+	 * keeping the disk busy.
+	 */
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIGINT);
+	sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
+	memset(zero_pids, 0, sizeof(zero_pids));
+
 	infos = xmalloc(sizeof(*infos) * total_slots);
 	enable_fds(total_slots);
 	for (pass = 1; pass <= 2; pass++) {
@@ -261,7 +425,7 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
 
 				ret = add_disk_to_super(mdfd, s, c, st, dv,
 						&infos[dnum], have_container,
-						major_num);
+						major_num, &zero_pids[dnum]);
 				if (ret)
 					goto out;
 
@@ -287,6 +451,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
 		}
 
 		if (pass == 1) {
+			ret = wait_for_zero_forks(zero_pids, total_slots);
+			if (ret)
+				goto out;
+
 			ret = update_metadata(mdfd, s, st, map, info,
 					      chosen_name);
 			if (ret)
@@ -295,7 +463,10 @@ static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
 	}
 
 out:
+	if (ret)
+		wait_for_zero_forks(zero_pids, total_slots);
 	free(infos);
+	sigprocmask(SIG_SETMASK, &orig_sigset, NULL);
 	return ret;
 }
 
diff --git a/ReadMe.c b/ReadMe.c
index 50a5e36d05fc..9424bfc3eeca 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -138,6 +138,7 @@ struct option long_options[] = {
     {"size",	  1, 0, 'z'},
     {"auto",	  1, 0, Auto}, /* also for --assemble */
     {"assume-clean",0,0, AssumeClean },
+    {"write-zeroes",0,0, WriteZeroes },
     {"metadata",  1, 0, 'e'}, /* superblock format */
     {"bitmap",	  1, 0, Bitmap},
     {"bitmap-chunk", 1, 0, BitmapChunk},
@@ -390,6 +391,7 @@ char Help_create[] =
 "  --write-journal=      : Specify journal device for RAID-4/5/6 array\n"
 "  --consistency-policy= : Specify the policy that determines how the array\n"
 "                     -k : maintains consistency in case of unexpected shutdown.\n"
+"  --write-zeroes        : Write zeroes to the disks before creating. This will bypass initial sync.\n"
 "\n"
 ;
 
diff --git a/mdadm.c b/mdadm.c
index 972adb524dfb..141838bd394f 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -602,6 +602,10 @@ int main(int argc, char *argv[])
 			s.assume_clean = 1;
 			continue;
 
+		case O(CREATE, WriteZeroes):
+			s.write_zeroes = 1;
+			continue;
+
 		case O(GROW,'n'):
 		case O(CREATE,'n'):
 		case O(BUILD,'n'): /* number of raid disks */
@@ -1306,6 +1310,11 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (s.write_zeroes && !s.assume_clean) {
+		pr_info("Disk zeroing requested, setting --assume-clean to skip resync\n");
+		s.assume_clean = 1;
+	}
+
 	if (!mode && devs_found) {
 		mode = MISC;
 		devmode = 'Q';
diff --git a/mdadm.h b/mdadm.h
index 18c24915e94c..82e920fb523a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -273,6 +273,9 @@ static inline void __put_unaligned32(__u32 val, void *p)
 
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
+#define KIB_TO_BYTES(x)	((x) << 10)
+#define SEC_TO_BYTES(x)	((x) << 9)
+
 extern const char Name[];
 
 struct md_bb_entry {
@@ -433,6 +436,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
  */
 enum special_options {
 	AssumeClean = 300,
+	WriteZeroes,
 	BitmapChunk,
 	WriteBehind,
 	ReAdd,
@@ -593,6 +597,7 @@ struct shape {
 	int	bitmap_chunk;
 	char	*bitmap_file;
 	int	assume_clean;
+	bool	write_zeroes;
 	int	write_behind;
 	unsigned long long size;
 	unsigned long long data_offset;
-- 
2.30.2

