Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3E32BD022
	for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2026 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859384; cv=none; b=XRylxUkyzZ4UJqFjf0BU086rWeVeT/Kx+tB1UewlGAqOFEKYWUuHaD/qhRXq9RqyIEgR1BDGfP3ireKmdylWthuA9V9BvFo9GlOruawbp0icKU3fDP7yhkT65UHor9N5+0ARYrBXrM5vgrpwbCsMZOV3WQ99TFqdYC59W2AfBzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859384; c=relaxed/simple;
	bh=FpEbfQyIZj1rInHqPNAUF8GXeB3XCWuWfhWQVrUfd0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RXXGWCBE2EGw8/K2zHyGTQqeY6asxMBN3Zmj5/EMzg1aAdvxgOe/896R+gasKiCgNmHtx9z44a+oYuww5adfm1I4pSQYtOUPiCBPtl1wRJtSG4PyM9wzVsE2WXVok8GHvLZDRDnt1/C1+GL1lqiUPv2iyWEIx2+6AvsRChPpibY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KnLk4PEu; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnLk4PEu"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7bcb94d3so48918595e9.2
        for <linux-raid@vger.kernel.org>; Thu, 01 Oct 2026 05:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790859379; x=1791464179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K+YxthDTsyK1OC9mSBJQAq26traS5e0O0cZBRIdwebI=;
        b=KnLk4PEuCgxmPn5r+TbvTVNmUQDQbQxwJiS6P8HJasa5YasLMX1NQ/cvg01v6mIiDA
         xVd4eoFqgRbHTWJrCorF0l37CIpP3kJ0s910Sz1U+TWrR0c6RW1jGpT5ZaJ14gK0uWIT
         UaYKuuRqTd8tNvrvVat7muXNbLLR3VdtJy0STOTjJ/A4qGqEp8H2Dhrg3YA4Z/Dj7Ef0
         IgxUhHHJLJuuVfFeEW7/czLscwPmKShHdpO52uwyWbdZkYIZ577/X54fiUrea+135Uor
         AV/C9o2EUkHyB9STTKvseTYwZznZu7tp7TB1t/KNjUGBCKzy7p2L3sNvgjGcHhQ4zA/n
         zAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790859379; x=1791464179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+YxthDTsyK1OC9mSBJQAq26traS5e0O0cZBRIdwebI=;
        b=cDW1wz0uOV3pzDmtNGsrPgU/YbK6Dyv+yR602NtSscQI0jRp/tMDnatrzq4AWKUlM+
         p5hgVoDMNlLCWlm4eHG1ZDsC4kdVsKAiVDD4zeLkP5e1bu5Fy2606EAlu2XRNc2pAlGp
         8zSf7TFXx0/1IZUweA6X7fpsx07N6nzhiNBh2W+V4ui3TzvghjZi69u7LDcaZ97xI03j
         r6x1HczCZDyrKli+46ziBHn2fbB54RM3+n5M/1jGT7s1nq21/tDVLwI1swNdur864rNv
         QhYVyDR++vP4TCvXqaBLXAnnu3PX0xBZlGejh3t8p37PA7kWpLfAEhOpscm1Ae8pt58+
         b5MQ==
X-Gm-Message-State: AFuF++lLaD+NS0FYqYDEVH7oJPvQt/ZAPKXxjyg46FMZWbR2HGznUhXi
	D930+FsI9ZsasZN6zQki36OTwJkplIbGnVJ+UkYqy/CSypXXd04b7nrL
X-Gm-Gg: AYBFou3x4EGY3im5iXGTSiz7nwj/gv51Uoo6EfroheDoQ9rblhfchYryNhVbq1CCT/X
	5eoT3s/zEpmQMtNUhIpPoma6ZdDaWoXIpskLoiP29t1GO4d8u3kfMfq5djPnbkqpFAsjTsBf5AZ
	CTMicyQvUj5ZXS3at6w3giwGLAhDaXCu1GmfxWJzO3bwpttCexhuy3+eE5RUIVL/XRsE4oR5aop
	ZGvhFwljeEKoi6GfGLV5oetSh9l3vcJFqJSzeMrf0Ma/2qDlblj8rZGlnEAcQwmmpHjwLyl4Ihv
	oNclHuNe8ekJBbKK/9Xn7idfKzqFjQfQg9vyZe5Q7YAAV333VedRuNVp41uxUcTq8nn7p5xuXvk
	d2GzDnFxj7GW6Bts3TppJdqvk1UPx4TiOoPKmH/HlSJFC1e0ryRH/Slq+naWTbc6LpMwpNVu1MM
	VbrVJtfKF1W5vaQbvwYKeILoBlqfX5vl1e9qmHHl2+/b7acSIS64NwpMTVSsKkOcBqV6grgDnD5
	ODrVvojc1feY2ZzCZGj2kstWgBodmvMba3A6+BoeWXRx7s=
X-Received: by 2002:a05:600d:82c8:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a01ab4ea39mr86969215e9.0.1790859377704;
        Thu, 01 Oct 2026 05:56:17 -0700 (PDT)
Received: from env.. (dynamic-176-003-078-112.176.3.pool.telefonica.de. [176.3.78.112])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f9a7650sm68298735e9.15.2026.10.01.05.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 05:56:17 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	chengzhihao1@huawei.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [RFC PATCH v2 0/4] md: add a control device for array management
Date: Thu,  1 Oct 2026 12:56:07 +0000
Message-ID: <20261001125611.943731-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series adds a new /dev/md-control misc character device for
managing md arrays without opening the corresponding md block device.

Currently, md management ioctls are issued on the md block device
itself, which requires the caller to hold the array open while
configuring or stopping it.

This is a problem for STOP_ARRAY and STOP_ARRAY_RO. Before the array is
stopped, the page cache must be flushed, and no other task may have the
device open or be writing to it. The issue arises when several tasks
share the same file descriptor table, as they count as a single opener.
Consequently, one task may still be writing while another task flushes
the page cache and stops the array. A write within this window can race
with the stop operation.

The new control device is not tied to any md array. Each request
identifies the target array by name, UUID, or device number, and
carries a flags field. Unknown flags are rejected with -ENOTTY. The new
commands mirror the existing md block-device ioctls, with STOP_ARRAY_RO
represented by MD_STOP_ARRAY with MD_RO_FLAG set.

New 64-bit structures, including mdu_ioctl, are introduced
(mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,
and mdu_version64) to resolve padding and overflow issues in fields
such as size, ctime, and utime.

The existing md block-device ioctl interface remains unchanged.
A warning is emitted when it is used to recommend upgrading mdadm to
use the new control interface.

The mdadm has been modified correspondingly:
Link: https://lore.kernel.org/linux-raid/20260928211849.3602414-1-abd.masalkhi@gmail.com

This is an RFC because the new UAPI (struct mdu_ioctl, mdu_array_info64,
mdu_disk_info64, mdu_param64, mdu_bitmap_file64, and mdu_version64 and
the new command set). I am thinking about adding a new command
MD_NEW_ARRAY or MD_CREATE_ARRAY to create a new array. Feedback on the
interface is welcome.

I am aslo considering adding a command to create a new array
MD_NEW_ARRAY/MD_CREATE_ARRAY.

I am thinking of adding a new command MD_NEW_ARRAY or MD_CREATE_ARRAY
to create a new array.

Changes in v2:
 - Move the code from md-ctl.c into md.c and remove md-ctl.c.
 - Handle the new commands directly in mdctl_ioctl() instead of
   converting them to the old ioctls.
 - Use a dynamic misc minor number for /dev/md-control.
 - Drop the devname module alias, which only works with a fixed minor.
 - Fix the issues reported by sashiko-bot.
 - Take disks_mutex around the lookups, so that they never see an
   mddev that md_alloc() has not finished.
 - Clear hold_active only when a command succeeds.
 - Link-v1: https://lore.kernel.org/linux-raid/20260928201224.3602262-1-abd.masalkhi@gmail.com

Abd-Alrhman Masalkhi

Abd-Alrhman Masalkhi (4):
  md: add uapi definitions for the md control device
  md: pass struct mdu_disk_info64 to md_add_new_disk()
  md: use struct mdu_array_info64 for SET_ARRAY_INFO
  md: add a control device for array management

 drivers/md/md-autodetect.c     |   4 +-
 drivers/md/md.c                | 700 ++++++++++++++++++++++++++++++++-
 drivers/md/md.h                |  17 +-
 include/uapi/linux/raid/md_u.h | 119 ++++++
 4 files changed, 820 insertions(+), 20 deletions(-)


base-commit: 5c2f4115051d064ad79b0b4edac70a2b62528d9d
-- 
2.43.0

