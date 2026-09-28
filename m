Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054034D7D32
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626370; cv=none; b=rD1EMDQjqKMw49wDpYM+rUbsBzOAbOU4rWMVhVNWtdJcyXK7AtkjYw4z9Qd5iXeW+btY5TYfkTP+IoGSDS6x+Pi9twfYf2HPHT9Zf4xbhu+KM9rzCmCLK2piC3TTLxYY4ADg4kULbBpp609IM5xQyGcjs3cNmDwsbep9yAvwryw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626370; c=relaxed/simple;
	bh=6Dp/hhMzy2cZom8NGxLWZtptCrgvBGm+SG+vfodARZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M8mCBc6cfPKY9JQNlMeLEsE+a6kF3fh7oWfgz/HNyQJShGMm6cXqPP+EsbNjGeOe2jEirX8zn21I897BcpvknRmabBlck8rU/Kl9lUhS+8W78M0632zGZDxWanA/Y0nV0AOAJ9WzVtmB4M7YvFsRwdDEp6FDdE/94aZ/eG1HW04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fnfjTAeU; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnfjTAeU"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so19262175e9.3
        for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 13:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790626365; x=1791231165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xiagLwmOxbDGI/iupLudQ2PVS19f/NOJ4+VSuZuRNvA=;
        b=fnfjTAeUr0sih+Q+h4T7gNb9C6Qh2A+2JNjWMlRhwwrmJ8E1jJ7pY/A7y424ajVIaz
         zQDdoA66nP1wEq57kaQr83zO2AKMvvCv7OQ0uAO9/MjMLD4uz0HPECc6ZTn+TpkkpbR8
         QPNfMes/OD+wRQVkN+5SLIEOhn+wDs3YAsT+UdP8XtlcM6jQtazEIrmC5i2pZgjPMn2F
         7YJHUAf+DDWGfukWFtqomxk1awtC1Tuo75svR95VUKAB/Ynsowl1No6KGdbCyTLGe9Tr
         G+YbnbolqKhtTI2jDK6dEBOnnWsjGJZrr/8E1yxVwrC7MaVfUnEKpBO16+trlaWtlWWH
         RShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790626365; x=1791231165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xiagLwmOxbDGI/iupLudQ2PVS19f/NOJ4+VSuZuRNvA=;
        b=LDL6yeR+7gIvNXI+INOoxGZ9saS/BrzuEX33/dGy+qXnfwvg/7glZ/7nmB1WdLQALl
         H82CAtTU9L3tWn2/AzRmd2c75cT3zgu91Q+EhzJWZZ9H3fr7V0+GrzoQvk3AEKpHicAK
         dMkAHAH3USdRL4IvhHLUKB9N7jFYI+tBRO/piN7S/mkH6VU5mOA6MbJ0Z5ZXcIFxCwju
         D8cDwaKD914AnStNZBLF0weoRF0GndpaEZCgABnlugm4LpZ3hhcfT9fx66xnmxOMulcH
         1xnYk4voZtG48mjYioHUqCHh1P9Ukiu2Tn80AfdK97AMKknGun8MPMyNNYIfunz52gP8
         ochQ==
X-Forwarded-Encrypted: i=1; AKwUvBwZIeQJXD75sTb72jlhklmk49ZF/eCwSV401ZEH7o8uvjowjXOHX8s+zj3AKjOK5yBx96xRHcGcueI4@vger.kernel.org
X-Gm-Message-State: AFuF++mg2OaM0ABdw47EsZWlhXGKlAGWbSctxxIpni5RuTL67aauRIsm
	n4xTaFes4aPrzau/STMFZGANbUu+p/pUZoNTVyrzTGmirpX8epy5MruN
X-Gm-Gg: AYBFou2UG9VHM1cCS09ZnmdOlrRYNGyibqd7BWAeLdokyso+k2anIFJQ42FwMzakv6z
	+qEjofAPmJ31kO1l9Mc5Lz0uttfkVkRVRgbrtP0bxDUo9wA+DXwsuvnJFpq+Ix4l1T65KLIekCd
	HHe9/YwZcDnedlL4bAozsWV0MI1/kWwsKcVbCPTIgPEVOT8sxuju4LkQu8ytnZpq5v6uNDNM1Za
	7+d7w5mEM8jxNI3cbOHJ0ZLvcmY1lc2cU7Hj7j1HP5wvq53U1sHOhfdrKlDFrcE6OGoAajzMITZ
	jDfI6BSypEglGqhnRACQIrAORQ2Mk9q/uIrnmNoyBumo8BEzOUGTwS3iB3B9YLvB01zQnxc8Rq7
	IDTeOQ/4g35mShR27S7pQzyWskxCNbV5mydwvEG6FWStjEnr0b4upT5EEu9+n23pN3gq5/Lh/Fd
	LfhLBHIWd9CGP2oMQvFB5u/FRTbN6G6K3uSN26qaLtZtTTw2mu120IeH52FZd1xRZv1UbYb6bm4
	LPOy1t5MEFZ6NPnrf8BFq+JQOigdt9BuO+2DfeuRUMcVow7VWz3HoWRTg==
X-Received: by 2002:a05:600c:348e:b0:49e:8191:e5cb with SMTP id 5b1f17b1804b1-49ff06b2ef6mr188592985e9.5.1790626364553;
        Mon, 28 Sep 2026 13:12:44 -0700 (PDT)
Received: from env.. (dynamic-176-003-100-011.176.3.pool.telefonica.de. [176.3.100.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00c11a9d2sm30457755e9.3.2026.09.28.13.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 13:12:43 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 0/2] md: add a control device for array management
Date: Mon, 28 Sep 2026 20:12:22 +0000
Message-ID: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All md management ioctls (SET_ARRAY_INFO, ADD_NEW_DISK, RUN_ARRAY,
STOP_ARRAY, ...) are issued on the md block device itself, so the
caller must hold the array open while it configures or stops it.

This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is
stopped, the page cache must be flushed, and no other task may have the
device open or be writing to it. The issue arises when several tasks
share the same file descriptor table, as they count as a single opener.
Consequently, one task may still be writing while another task flushes
the page cache and stops the array. A write within this window can race
with the stop operation.

Add a misc character device, /dev/md-control, with a fixed minor
MD_CTRL_MINOR. The control device is not tied to any md device, each
request specifies the array in the payload, either by name, by UUID or
by device number, without the need to open the md block device.

The new ioctls use the existing MD_MAJOR ioctl type, starting at 0x40,
with an MD_ prefix. Every request structure has a flags field. Unknown
flags are rejected with -EINVAL.

Each new command matches an existing block device ioctl with only one
exception. The STOP_ARRAY_RO has no separate command, it is handled
via MD_STOP_ARRAY with the MD_RO_FLAG set.

New 64-bit structures, including mdu_ioctl, are introduced
(mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,
and mdu_version64) to resolve padding and overflow issues in fields
such as size, ctime, and utime.

The existing ioctl on the md block device is unchanged, but a
warning message will be printed to recommend upgrading mdadm.

The mdadm tool has been updated accordingly, and the mdadm patches will
be posted to the linux-raid mailing list shortly.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

Abd-Alrhman Masalkhi (2):
  md: make mddev lookup and ioctl helpers non-static
  md: add a control device for array management

 drivers/md/Makefile            |   2 +-
 drivers/md/md-ctl.c            | 597 +++++++++++++++++++++++++++++++++
 drivers/md/md.c                |  41 ++-
 drivers/md/md.h                |  10 +
 include/linux/miscdevice.h     |   1 +
 include/uapi/linux/raid/md_u.h | 119 +++++++
 6 files changed, 758 insertions(+), 12 deletions(-)
 create mode 100644 drivers/md/md-ctl.c

-- 
2.43.0

