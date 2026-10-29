Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305342;
	b=VqtaSejYyjXUTpXhVvETVB8/6GrtOG9ZdZyQDeqFMPlS0Hk51MTR5gLDYQYKBPYug6pf
	 rzZPUY5hvUAChSZAkXAb9MFwDFAOgghDLwnM0uCMJ8xr5XSboMs+Lks+YkxWpcm0QNbKF
	 HazTuuOiw48ecICW7N1dZwemX929uTpo70E7q74/c8XpDLy2eC7yt4RDlrGK1wM0curip
	 QbpiGTOLD+k0OoartsyoLUoY0IBIRoDyjb9kC8lBOUk/OD0l4a63GALsaxGKjb+UO/Pzv
	 uSLn/ZLp1lYmXjXEXBtTi9Cl8tMkkXbarE2Q2sQPD0TGC5OuWbsmBgyEnl+Mh80+qTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305342;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+alK+kLJ7amoIBUyXbsYxnMkr961PG7p4vFJ8+VXAFw=;
	b=ewN39Ea11r67eMh+y9JPyF0j2rr77qfOptHtcbO+XViKy5hDE82QHF0egJWpSOKWb1Fo
	 Rct6dqt5aBTjyu7H9sA1nFDV3FCOu9n8irhRsdLY882ruV5aix/k+WwCvVX9To4PaWHjJ
	 Bg4s6CLfAu7JhxbHAJZ3JXhcN8e0gIF4G0+m+cTTU0Myl21sn2MvdsXeva/5QGufT8EVh
	 BmHYnt/uuLF5lC8Bd2uo6aPMVDyNRw4Q26O0Di+k+8p4aUMNLVD90JlupD/MFBqMC4nR1
	 l0kb5h4eqbOVkoSyOZN9dOkWz/QuChrz11tVkjqCwVzTGFRvoq8WoTEVsBkUJhGWI6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zZwAeLoP;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D527F606A336
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D527F606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zZwAeLoP
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so28800325e9.2
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 13:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793305340; x=1793910140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+alK+kLJ7amoIBUyXbsYxnMkr961PG7p4vFJ8+VXAFw=;
        b=zZwAeLoPIcpyLuKkZr8FqzwEUCgJ2THkqWg/AibXfpeOFFC0uZFMGwcNKY0pxxX5M2
         gEDvQKQEBDIx+WJ/ISRAarAP80bmXP6IslqeM+WjRFlXucm0TU/ad/iceLVg676SKoMQ
         yv0vdxE76efT/RAtzwv8x26DOszTYu/RACCHnOE9m7UtDCS5xfYKtHqoYLUAfkrfNSlQ
         JtUilijpf9MI48GX8pKMmHH3dImgnYtgYrLhPgn+6zO9Im0UkwY+ygelER20mIEmgE9G
         kwjjKwQ2fu4/jFv9vNraPYWJ3smbxDS8z71YAI2PgRDoHVU8WqVQeaPZbum1LBR2FSEW
         2mxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305340; x=1793910140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+alK+kLJ7amoIBUyXbsYxnMkr961PG7p4vFJ8+VXAFw=;
        b=oOkQ+gXm1WCnKuS4lN6O8IbWfDCWc5Tf9kpYBP/P0lLa79MtNBgSzgJuhzJNhZfaPt
         AqThkOxvZcLD3+uyrVGxu4ppl/NKNjPlNRZKvDWOY28nMz55tRWrDfCVFS8qU1uXGnUQ
         Ch2n5uuIj8YOaYvBXzBm0g8TYms6EDmOEfbN/lPSOrnz5qBYgjXsjRAZiFmRfJ2mE/BU
         WAfKhAZ7SsYta+VjQSzvlppS1zvs5lNWtsV12WtC0F28KOWenLAUrfI+9vATkIDq6l58
         Be8GhvkEgwfQ56KrpfqTv0g9tMyWNiiPIyYIxPTleKK/H2P5ZTwOQLiorJINzmV+UiAE
         btoA==
X-Gm-Message-State: AFq9FYK/FfbGhPcyZvQkIGUbZOEHTePjE39Q/uVGHiVRs4nnOCA5lykY
	zOB4mXg+M8kdcRjGXl6K/oRmfj22Zr1vMhyo9FVXqKCLSoceUbvBtTY7
X-Gm-Gg: AYBFou289i4M/0YJ8W5lDB3Cf/7DIO/Ak6PYhcUcu2UkB/uhV9nfig9OStg0YW/PGSK
	2C3ER+JPUePT5tZ1MmDxqkZB/qG/MfvzwkpnyB5a/ZnusM8StGTu/NQhE3OWBkuzbftOOUgXM/6
	r+um7vyADAdmbAp6Rvxh/k/ZnJtYWqglvzmpcY3rrTTI0EJAwo6CDTVYRBPV9NtGHf5ye8UyUd6
	QjXQVvgVkMor7VSbQq7UsdwUGSC57LtXEPl0bXuTyXmO3VpdVzQzKgF7y+YACPcyI/3Uoeippba
	CKLmOR0fiDPmc+E3yofEaw96ppFGU4lprwB6FRHUe0095JBtCN91fMm9hQcAOgpAyAiyKRtuNRl
	wDyegxEGbm5sXpyalPbu14rBxhKJYhtbH/We1aXnTxdChU1dUWfbO6mF62UztFR9NujlBw37wnO
	FQMGaLhhXVaI94P/kfK0rLuCptb/I4UHhPHjcqRUW4UWnrZalIrcSgohNrEZGZq+F8ERRSm3sec
	UYYuNrZsihIu7muD3yNGKjzQ8jF0yb4zNuQKcWA1lOPOa66QYHvQfZCPwKWeKz7RHP9j/CocQ3K
	5rtZ267W/cTcvaytciTFcjrGc9wp9D/D4TbiV+21owFlS+278+y68mHTgbSa5JnLIoehH2ejuXX
	NoEvOT50Ovnh+DnbKB9F4GpU=
X-Received: by 2002:a05:600c:8b0a:b0:4a1:742e:3 with SMTP id 5b1f17b1804b1-4ac185bc4a1mr1887535e9.27.1793305340269;
        Thu, 29 Oct 2026 13:22:20 -0700 (PDT)
Received: from env.. (dynamic-176-003-098-140.176.3.pool.telefonica.de. [176.3.98.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm9424335e9.13.2026.10.29.13.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:22:19 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	mtkaczyk@kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v5 1/4] md: add uapi definitions for the md control device
Date: Thu, 29 Oct 2026 20:22:05 +0000
Message-ID: <20261029202209.1422567-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
References: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the ioctl commands and structures for /dev/md-control, a misc device
that manages md arrays without opening the md block device. The device
itself is added in the next patch.

Every command except MD_CTL_RAID_VERSION takes a struct mdu_ioctl, which
names the array by name, UUID (it is only available for arrays with
native metadata) or device number, carries a flags field, and points to
the command's payload .

The commands mirror the existing block device ioctls. They use the
MD_MAJOR ioctl type, with numbers starting at 0x40, grouped like the
old ones: status at 0x40, configuration at 0x50 and usage at 0x60.

STOP_ARRAY_RO has no separate command: MD_CTL_STOP_ARRAY with
MD_CTL_RO_FLAG set switches the array to read-only mode instead of
stopping it.

MD_CTL_LOOKUP_ARRAY has no equivalent among the legacy ioctls. Given
the kernel name, device number, or UUID of an array, it returns all
three identifiers. It also indicates whether the array exists, even
if it has not yet been configured. It returns ENODEV only if no such
MD device exists. For arrays using external metadata or having no
superblock, the UUID is returned as all zeros.

The payload structures are new versions of the old ones with fixed-size
types and explicit padding, so they have the same layout on 32-bit and
64-bit systems. Fields that overflow in the old structures are 64-bit
now: size, ctime and utime in struct mdu_array_info64.
struct mdu_array_info64 also reports the number of journal disks.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 include/uapi/linux/raid/md_u.h | 119 +++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_u.h
index a893010735fb..3616127eacea 100644
--- a/include/uapi/linux/raid/md_u.h
+++ b/include/uapi/linux/raid/md_u.h
@@ -12,6 +12,8 @@
 #ifndef _UAPI_MD_U_H
 #define _UAPI_MD_U_H
 
+#include <linux/types.h>
+
 /*
  * Different major versions are not compatible.
  * Different minor versions are only downward compatible.
@@ -30,6 +32,10 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+#define MD_NAME_LEN                     32
+#define MD_UUID_LEN                     16
+#define MD_CTL_NODE                     "md-control"
+
 /* ioctls */
 
 /* status */
@@ -61,6 +67,28 @@
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
 #define CLUSTERED_DISK_NACK	_IO (MD_MAJOR, 0x35)
 
+/* ioctl commands for the MD misc control driver */
+/* status */
+#define MD_CTL_RAID_VERSION          _IOR(MD_MAJOR, 0x40, struct mdu_version64)
+#define MD_CTL_LOOKUP_ARRAY          _IOWR(MD_MAJOR, 0x41, struct mdu_ioctl)
+#define MD_CTL_GET_ARRAY_INFO	     _IOWR(MD_MAJOR, 0x42, struct mdu_ioctl)
+#define MD_CTL_GET_DISK_INFO	     _IOWR(MD_MAJOR, 0x43, struct mdu_ioctl)
+#define MD_CTL_GET_BITMAP_FILE	     _IOWR(MD_MAJOR, 0x44, struct mdu_ioctl)
+
+/* configuration */
+#define MD_CTL_SET_ARRAY_INFO        _IOWR(MD_MAJOR, 0x50, struct mdu_ioctl)
+#define MD_CTL_ADD_NEW_DISK	     _IOWR(MD_MAJOR, 0x51, struct mdu_ioctl)
+#define MD_CTL_HOT_ADD_DISK	     _IOWR(MD_MAJOR, 0x52, struct mdu_ioctl)
+#define MD_CTL_HOT_REMOVE_DISK	     _IOWR(MD_MAJOR, 0x53, struct mdu_ioctl)
+#define MD_CTL_SET_DISK_FAULTY	     _IOWR(MD_MAJOR, 0x54, struct mdu_ioctl)
+#define MD_CTL_SET_BITMAP_FILE	     _IOWR(MD_MAJOR, 0x55, struct mdu_ioctl)
+
+/* usage */
+#define MD_CTL_RUN_ARRAY	     _IOWR(MD_MAJOR, 0x60, struct mdu_ioctl)
+#define MD_CTL_STOP_ARRAY	     _IOWR(MD_MAJOR, 0x61, struct mdu_ioctl)
+#define MD_CTL_RESTART_ARRAY_RW	     _IOWR(MD_MAJOR, 0x62, struct mdu_ioctl)
+#define MD_CTL_CLUSTERED_DISK_NACK   _IOWR(MD_MAJOR, 0x63, struct mdu_ioctl)
+
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
 
@@ -146,4 +174,95 @@ typedef struct mdu_param_s
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
+	__s64 size;
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
+struct mdu_param64 {
+	__s32 personality;	/* 1,2,3,4 */
+	__u32 max_fault;	/* unused for now */
+	__u32 chunk_size;	/* in bytes */
+	__u32 padding;
+};
+
+struct mdu_ioctl {
+	char md_name[MD_NAME_LEN];
+	char md_uuid[MD_UUID_LEN];
+	__u64 md_dev;               /* md array device number              */
+	__u32 flags;                /* Flags for the ioctl operation       */
+	__u32 padding;
+	union {
+		__u64 array;        /* Pointer to struct mdu_array_info64  */
+		__u64 disk;         /* Pointer to struct mdu_disk_info64   */
+		__u64 param;        /* Pointer to struct mdu_param64       */
+
+		/* GET_BITMAP_FILE: pointer to struct mdu_bitmap_file_s
+		 * SET_BITMAP_FILE: file descriptor.
+		 */
+		__u64 bitmap_file;
+		__u64 disk_dev;     /* Disk device number                  */
+		__u64 arg;          /* Generic argument                    */
+	};
+};
+
+/*
+ * If set, MD_STOP_ARRAY will switch the array to read-only mode instead
+ * of fully stopping it.
+ */
+#define MD_CTL_RO_FLAG              (1u << 0)
+
 #endif /* _UAPI_MD_U_H */
-- 
2.43.0

