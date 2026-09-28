Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288C4FD79E
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630688; cv=none; b=TqbNzGBX3SotBk2S8H+2uBStTpk5PXJaUjVv5s5AXfkVPFXgnXBDI0Vq2tHPfp//NWzp73K/vTVHHxvoQkaaLHD62+qHRxKEU6/Hb0ORssmF0RMLjy7wVesML+Z9eEcI0K0MUmcQb6ZGqsr9k6s8BMZeJL2lHOSqyMokbSm7zZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630688; c=relaxed/simple;
	bh=cJyS1xiw5ZLADoePMXJFrNVNtcxQ8AQpJadI9rDn1S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqAQTG73jqES7XOGh2XWG1jTP8gp0qRHdgP2+GX/AniFw+QjwLK9NTHK2XDTi2ck/anh/cGlUBR33KrCLQKrNEguX2GaDXsHrPoMvFEjDjAgh2IxP1v9COb87qlVtd+JW6RDe2b5S5yQ44DL0dLbSgEur6O/Yxz4lyIQK1m1hR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYea6HC7; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYea6HC7"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f690df6so2493909f8f.1
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 14:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790630676; x=1791235476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DsWVZv2Z/Ga8arU/l+csLRDc5/u4mS0Tijrt8R0Mm3E=;
        b=QYea6HC7ERdE7HGkrmRJjdkm0mgaNCovPis7pDpb8f/GTHWALIFBkVYtXG+u00JzZf
         4je6/+zJr4zojycCL2fQZA4cV1tpKkoYlpE+4LTCldmBdOaLO8opmvAZ0H0XNOzmWbdY
         qN+5niquCECsGm7w316opceXRgcn8oxj0HPlMOZ+gdZlHQLwSmcruntv5xk/ysFloPbB
         mOw261+6575rYhEgpiXEzN4bjKp+3VL5JfqK5J4E9RvaqTsnAUYcOg2OkFM6+mELpzTu
         hFyk2kdL+kG4rU+TwD10E37FjmljUJaA/ckNK7dyS3ffGk9cH/v+cDheH4fI1B2tTAzD
         DD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790630676; x=1791235476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DsWVZv2Z/Ga8arU/l+csLRDc5/u4mS0Tijrt8R0Mm3E=;
        b=vBAXaL6TF9EBUXNbdUKwu0O5QuU3oGbELW6GdNWjelHNPvZNFIWsEvEomFKmOy4g0h
         sGSb0K+aNnfAmlwcRoBjZb3ZIcOXUCAXwT/WNXieAhJ0AF9Gc4ipoSS2SA7ZuFtVl2XE
         Ln8z/Jv0BnQDGJaNTbfnepWEcC9BDJfvhmUpOpMJ4zOW7Tx7uHk6W28+WFIW/tu3AH8t
         NOLbnEYll735B/O+RNaiIuDgHE4ShaN5hsqnZ2nPQ9ZVp2j88g1DNbnTq7rj3aBSJKjs
         K++8XaPAoKB9W5Lqpnt6ecGx60M43lCo88RTtPBCTq+h5+8hOX2NSkhAL8+uULqacUrK
         TRgA==
X-Gm-Message-State: AFq9FYJfsRprbM0tE3S2NVaduxGszsXuCdCgj4yvMyF0bVyYzEDnotDE
	a7UK8NHpPzAJA2Y0n2ixLPNg41XyDoDGs7v7mol+TjmxNRVR7O7tqVSt
X-Gm-Gg: AYBFou17dMg3Ws4MXBHcJeGErXJ+TCc71QPdZElXrfhpgv/nkkcENCV7b7tsCC7cF1d
	Pv7HrEHdsYYJAFiIX3b8XRKEAmM7aFyNm4Yq2p8aQVVKny83sa1zlwinYMluTwN8ekFVkYmIbMB
	8/EYl68uAfCch55UDuDEYr22bqMk8xerwOpuSjXmPOIz4xASETpOA9HD/j7FgR9bmY4abFGSGbo
	jvGLdIM3xJ1Os00ZsRSwLBqcITjziJwNIG76uRplcTmZ1hmW7z5Akhr02Cdqn7i4B7mvHa8JfUH
	E7ARmqrDH7g5wjMIsC09aSCAlpENmXV99TbHZbGFtIwHVFLzza8edkNXzQC8LOGeQN/lGNOereZ
	Gd95ltxshP3+/2LST8qckW45Z9amamj9buplodQkoYR6gnGqA9ju2JwLr9m3U/kFd/BDLe4nNYX
	Ikp8c9PdFlGGgHi/iwaMRZt4Bd5Rfo/Bn7TrPISscU0e7BlX9AXY0YO+XWeFfKu+VE7MtzPc3IK
	SCn9UR36JoilcTPviQiVr50oCjQbwTtrfb48mR+D6Ljgg8=
X-Received: by 2002:a05:6000:230b:b0:487:ae2:4d01 with SMTP id ffacd0b85a97d-488716836ccmr26561557f8f.22.1790630675715;
        Mon, 28 Sep 2026 14:24:35 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a314sm30869895f8f.6.2026.09.28.14.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 14:24:35 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yukuai@fygo.io,
	chengzhihao1@huawei.com,
	blazej.kucman@graidtech.com,
	mtkaczyk@kernel.org,
	ncroxon@redhat.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 1/2] mdadm: add md_ioctl() for the md control device
Date: Mon, 28 Sep 2026 21:18:48 +0000
Message-ID: <20260928211849.3602414-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928211849.3602414-1-abd.masalkhi@gmail.com>
References: <20260928211849.3602414-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux adds /dev/md-control, a misc character device for md management
ioctls. Each request names its array in the payload, so the caller
does not need to open the md block device. The kernel can then refuse
to stop an array that anyone still has open, which fixes a race
between STOP_ARRAY and writes from tasks that share the same file
descriptor table.

Update md_u.h with the new definitions from the kernel's
include/uapi/linux/raid/md_u.h.

Add md_ioctl(), which sends a management command to
/dev/md-control and identifies the array by its name.

The STOP_ARRAY_RO command is now handled via the MD_STOP_ARRAY
command with the MD_RO_FLAG set.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 md_u.h  | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.h |   8 ++++
 util.c  |  23 +++++++++++
 3 files changed, 148 insertions(+)

diff --git a/md_u.h b/md_u.h
index b30893c0..f816ab87 100644
--- a/md_u.h
+++ b/md_u.h
@@ -15,6 +15,10 @@
 #ifndef _MD_U_H
 #define _MD_U_H
 
+#define MD_NAME_LEN                     32
+#define MD_UUID_LEN                     16
+#define MD_CTL_NODE	                "md-control"
+
 /* ioctls */
 
 /* status */
@@ -38,6 +42,29 @@
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
 #define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
 
+/* ioctl commands for the MD misc control driver */
+/* status */
+#define MD_RAID_VERSION		_IOR(MD_MAJOR, 0x40, struct mdu_version64)
+#define MD_GET_ARRAY_INFO	_IOWR(MD_MAJOR, 0x41, struct mdu_ioctl)
+#define MD_GET_DISK_INFO	_IOWR(MD_MAJOR, 0x42, struct mdu_ioctl)
+#define MD_RAID_AUTORUN		_IOWR(MD_MAJOR, 0x43, struct mdu_ioctl)
+#define MD_GET_BITMAP_FILE	_IOWR(MD_MAJOR, 0x44, struct mdu_ioctl)
+
+/* configuration */
+#define MD_ADD_NEW_DISK		_IOWR(MD_MAJOR, 0x50, struct mdu_ioctl)
+#define MD_HOT_ADD_DISK		_IOWR(MD_MAJOR, 0x51, struct mdu_ioctl)
+#define MD_HOT_REMOVE_DISK	_IOWR(MD_MAJOR, 0x52, struct mdu_ioctl)
+#define MD_SET_ARRAY_INFO	_IOWR(MD_MAJOR, 0x53, struct mdu_ioctl)
+#define MD_SET_DISK_INFO	_IOWR(MD_MAJOR, 0x54, struct mdu_ioctl)
+#define MD_SET_DISK_FAULTY	_IOWR(MD_MAJOR, 0x55, struct mdu_ioctl)
+#define MD_SET_BITMAP_FILE	_IOWR(MD_MAJOR, 0x56, struct mdu_ioctl)
+
+/* usage */
+#define MD_RUN_ARRAY		_IOWR(MD_MAJOR, 0x60, struct mdu_ioctl)
+#define MD_STOP_ARRAY		_IOWR(MD_MAJOR, 0x61, struct mdu_ioctl)
+#define MD_RESTART_ARRAY_RW	_IOWR(MD_MAJOR, 0x62, struct mdu_ioctl)
+#define MD_CLUSTERED_DISK_NACK	_IOWR(MD_MAJOR, 0x63, struct mdu_ioctl)
+
 typedef struct mdu_version_s {
 	int major;
 	int minor;
@@ -112,4 +139,94 @@ typedef struct mdu_param_s
 	int			max_fault;	/* unused for now */
 } mdu_param_t;
 
+/* structures for the MD misc control driver */
+struct mdu_version64 {
+	__u32 major;
+	__u32 minor;
+	__u32 patchlevel;
+	__u32 padding;
+};
+
+struct mdu_array_info64 {
+	/*
+	 * Generic constant information
+	 */
+	__u32 major_version;
+	__u32 minor_version;
+	__u32 patch_version;
+	__s32 level;
+
+	__u64 ctime;
+	__u64 size;
+
+	__u32 nr_disks;
+	__u32 raid_disks;
+	__u32 md_minor;
+	__u32 not_persistent;
+
+	/*
+	 * Generic state information
+	 */
+	__u64 utime;		/*  0 Superblock update time		      */
+
+	__u32 state;		/*  1 State bits (clean, ...)		      */
+	__u32 active_disks;	/*  2 Number of currently active disks	      */
+	__u32 working_disks;	/*  3 Number of working disks		      */
+	__u32 failed_disks;	/*  4 Number of failed disks		      */
+	__u32 spare_disks;	/*  5 Number of spare disks		      */
+	__u32 journal_disks;    /*  6 Number of disks used for journaling     */
+
+	/*
+	 * Personality information
+	 */
+	__s32 layout;		/*  0 the array's physical layout	      */
+	__u32 chunk_size;	/*  1 chunk size in bytes		      */
+
+};
+
+struct mdu_disk_info64 {
+	/*
+	 * configuration/status of one particular disk
+	 */
+	__u32 state;
+	__u32 major;
+	__u32 minor;
+	__u32 padding;
+
+	__s32 number;
+	__s32 raid_disk;
+};
+
+struct mdu_bitmap_file64 {
+	char pathname[4096];
+};
+
+struct mdu_param64 {
+	__s32 personality;	/* 1,2,3,4 */
+	__u32 max_fault;	/* unused for now */
+	__u32 chunk_size;	/* in bytes */
+	__u32 padding;
+};
+
+struct mdu_ioctl {
+	char name[MD_NAME_LEN];
+	char uuid[MD_UUID_LEN];
+	__u64 dev;
+	__u32 flags;
+	__u32 padding;
+	union {
+		__u64 array;
+		__u64 disk;
+		__u64 param;
+		__u64 bitmap_file;
+		__u64 arg;
+	};
+};
+
+/*
+ * If set, MD_STOP_ARRAY will switch the array to read-only mode instead
+ * of fully stopping it.
+ */
+#define MD_RO_FLAG              (1u << 0)
+
 #endif
diff --git a/mdadm.h b/mdadm.h
index deac7a56..fb85ed6d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1736,6 +1736,14 @@ extern void sleep_for(unsigned int sec, long nsec, bool wake_after_interrupt);
 extern bool is_directory(const char *path);
 extern bool is_file(const char *path);
 extern int s_gethostname(char *buf, int buf_len);
+extern int md_do_ioctl(int fd, unsigned long cmd, __u64 arg, __u32 flags);
+
+#define md_ioctl0(fd, cmd)	       md_do_ioctl(fd, cmd, 0, 0)
+#define md_ioctl1(fd, cmd, arg)	       md_do_ioctl(fd, cmd, (uintptr_t)arg, 0)
+#define md_ioctl2(fd, cmd, arg, flag)  md_do_ioctl(fd, cmd, (uintptr_t)arg, flag)
+#define __md_ioctl(a, b, c, d, e, ...) md_ioctl ## e
+#define md_ioctl(fd, cmd, ...)						\
+	__md_ioctl(fd, cmd, ##__VA_ARGS__, 2, 1, 0)(fd, cmd, ##__VA_ARGS__)
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
diff --git a/util.c b/util.c
index 3bd4829a..5f0f401b 100644
--- a/util.c
+++ b/util.c
@@ -229,6 +229,29 @@ out:
 	return ret;
 }
 
+int md_do_ioctl(int fd, unsigned long cmd, __u64 arg, __u32 flags)
+{
+	static int fd_ctl = -2;
+	struct mdu_ioctl mdctl = {.arg = arg, .flags = flags};
+	char *name;
+
+	if (fd_ctl == -2)
+		fd_ctl = open("/dev/" MD_CTL_NODE, O_RDWR | O_CLOEXEC);
+
+	if (fd_ctl == -1)
+		return -1;
+
+	if (cmd == MD_RAID_VERSION)
+		return ioctl(fd_ctl, cmd, arg);
+
+	name = fd2devnm(fd);
+	if (!name)
+		return -1;
+
+	strncpy(mdctl.name, name, MD_NAME_LEN);
+	return ioctl(fd_ctl, cmd, &mdctl);
+}
+
 int md_array_valid(int fd)
 {
 	struct mdinfo *sra;
-- 
2.43.0

