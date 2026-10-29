Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305340;
	b=GyS6Fe5grbKysSP9crN4bWdvXxpzYFAKRhf7n3/OTELZD6l/VFuPTOdk/I9odPQjKefC
	 LO8Y16zcBm1NxLIB8Sqg6xrXFqLwOc2BA+cjT4thH0Tc+Ks/ItCUl/sWja+T8yXOBQlQ8
	 UPWKgg/jGyS7tyE4vw6fgh1Fq2+nb3fPTJVfPqQoW5VnBe4cf9A6x2MqqQ7TOzaJhGlAl
	 pH4VwEFVzMbMYKHJvAZkornQutthPU9NH07TnEoLzAjrDa9WSvsxgOayk4XThpJjI5Yg3
	 DZrwKxOtiT50c9eKUBZ4a6pDzDR502pDTmOmDTUR5xdaizrEcYZuYafBQAs6tcNs4hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305340;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=jtjfIBbhrXcQw07LO7LLkfCOUNpLRHqt1ZTu9/7Vuvw=;
	b=5olxX64NQaXoLfvSRox3W1SFbi7+tBMH2q5l+dw98uDj129kCmnlfwrJUPeLV+7p8Fzg
	 /aX0OOTaQB1m1jbavjhILatv5V8xlY73aoG2/sCeoWBkeveGxkL95A8SQD2dg9cGE1KBs
	 0NRbwdhSbEIBDY4+StQxdjG4xOdS9Tr2D2CFARsO39MDS6NcRHiPwHpCJFGHkF/xug8K3
	 sOJycegaEbUphHG1rkQqZJRvLJ/6i3PgtKdVop+ndvKtX1+oFM0A/hGfvO7CPEiJPsnB8
	 yMl8CFYB73ASHjtv2F2XZc4ZZLCFbkj8fR9ffEgazzg7YAWUZ4QTEmI9r8HbIbLumUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n4bDVmpd;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA880606A31E
	for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 20:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA880606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n4bDVmpd
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso22414305e9.1
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 13:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793305337; x=1793910137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jtjfIBbhrXcQw07LO7LLkfCOUNpLRHqt1ZTu9/7Vuvw=;
        b=n4bDVmpdvvREMJFAlhI5coCv63QeUDbnpriBmqF4CAUaOOe7rNO14zOuljEwpKITjH
         sT7hdK4TztCoxmS7nigjVZlJSF9jIQygyzpwFo6xAg2/n2MA1YXkZ1wxCa5LoKBBjLmH
         248yTNAj8Nx+XhDt5fteA0CX+TwTDayiAdQcu8xEwl92uWNIKoK1fBRzSmKXVoCZutq2
         0QETRyfwj5i0fjdQJplXPKgmfBUel73gVuQzE9zjc095bKmDt2NdYFwPAG2yx/JcBsd8
         IGUQnQkj0IPxHcl2Pq+WKdMH3/Wpen/LJw959uPh2+qriVCb0SI5MN0rt3Zf71dwWrcd
         apQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305337; x=1793910137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtjfIBbhrXcQw07LO7LLkfCOUNpLRHqt1ZTu9/7Vuvw=;
        b=drn00KI/ao3qUls1HpxBTkR5u0m2/THx8D0inMA8HdyHdxgbSimCiCsVkAhWyMb5B+
         lrWBrKOVaADOdiIjIDnsfNfJN/p1XHQe+MEQQMPa2BSp7Vis6yEIVuIMr3CedWNwKH96
         dtXvcv58vg1jJL8xsUFuiKUShKp2TBMM2CWSnNw49vgGzAa/c4Fvm1K0TzHRwki+T6Yy
         G+AcrI3AtMtmoxkLbHzSZXjI5ueKcSMddVkUjAanYYvvgvwFIb0icNoLSMzFOHBpU9z6
         5BjPfPQb9ur8yEGM92CgIuyQhxlQFVwyktkZ6bWlFNvu59OkjN1SAPxytcmg/kfKIdSD
         +4kQ==
X-Gm-Message-State: AFq9FYLDwlPwbOqrsC182bqXnZseAG9ShhnVwxM7l+OY3S3gF1niFQVy
	mXMZe9vmXYiiwRT+pxQdhKAcotMi3DoG2evBRclvyq3E424anowTlnfs
X-Gm-Gg: AYBFou3f6PD4gCdbi3wDauzFym2jWaE1GBXmeroqabCrJmsnQW6JPP1F0+dpRjbuUR4
	GkIbV4tAL3VoBeGgGrsKMwrRfMUx24fFybmJgv1x2V//5i1zjq6tZANVTIFSWOotQ1pySt0iSfV
	pVWlYz3h111DoRB9amita+Y9wRK2yrULi2/Gte3fkAt2ivmNyBytPjlfo5cWsjaUdVcSoRhxk10
	TVYH7WkfTYZM3R6oodHHHXoOQa2kvVdqyaiwS6pIXbmA7bQZTKNFlqX2mz5ZfXOSpl7wGEX85Hk
	pE4BDh0F0Bfbp4xUfvotj1q2cCoD+CceMN1r0aC6JRnmXVazoLyCqwbQ0XSUYgeuIJiIGHE1oZ/
	EL4pHzProOrdm0qhzPfB2z2MVROifn+FANeGBW3th2AJ6Ts1SDQcRE4bWc5LROizORD9hI5s5ef
	hC4LgJ+qt/O2dlMR6CflndGgc6A1C06SGZMoQNkXSBi1sj+2CDB/1Zo1L8Vm6NAUZ3Ie2VBC7zf
	gv8+61my0B/zYndfuNFqFfEFENT3ZCKBulKrH7LZYA3JBAMUo51iKQ3i8SFo9+HT6ngvOXFt3OX
	Ekj948yEY6YIINzPrpioPDwWopHFwVs4mnd4A8TodUX4VhJIdU6O5w6nNBonk04opCDx/GtWQaN
	unw==
X-Received: by 2002:a05:600c:3510:b0:4a1:dec1:4e1 with SMTP id 5b1f17b1804b1-4ac1765d674mr2101285e9.22.1793305336958;
        Thu, 29 Oct 2026 13:22:16 -0700 (PDT)
Received: from env.. (dynamic-176-003-098-140.176.3.pool.telefonica.de. [176.3.98.140])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf7146621sm9424335e9.13.2026.10.29.13.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 13:22:16 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	mtkaczyk@kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>
Subject: [RFC PATCH v5 0/4] md: add a control device for array management
Date: Thu, 29 Oct 2026 20:22:04 +0000
Message-ID: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
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

The solution was suggested by Yu Kuai and Zhihao Cheng. See the
following discussions:

https://lore.kernel.org/linux-raid/856a065c-38ef-08cd-7701-8f579212a1a3@huawei.com/
https://lore.kernel.org/linux-raid/12b0bc4c-5dfb-4936-8ecd-849137b597d8@fygo.io/

The new control device is not tied to any md array. Each request
identifies the target array by name, UUID (it is only available for
arrays with native metadata), or device number, and carries a flags
field. Unknown flags are rejected with -ENOTTY.

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

New 64-bit structures, including mdu_ioctl, are introduced
(mdu_array_info64, mdu_disk_info64, mdu_param64, mdu_bitmap_file64,
and mdu_version64) to resolve padding and overflow issues in fields
such as size, ctime, and utime.

The existing ioctl on the md block device is unchanged, but a warning
message will be printed to recommend using the md control node and
indicate that the per-array MD ioctls will be removed in the future.

This is an RFC because the new UAPI (struct mdu_ioctl, mdu_array_info64,
mdu_disk_info64, mdu_param64, and mdu_version64 and the new command set).

Testing:

mdadm test suite on qemu-system-aarch64 without KVM (Cortex-A57,
4 CPUs, Yocto kirkstone), using:

  ./test --keep-going --skip-broken --skip-bigcase

mdadm builds:

  - upstream: commit c940aae94ac5
  - patched:  https://github.com/masalkhi/mdadm

Test configurations:

  - Linux v7.3-rc2 (5c2f4115051d) + this series:
      - patched mdadm, using /dev/md-control
      - patched mdadm with MDADM_NO_CTL_NODE=1 (legacy ioctls)
      - upstream mdadm (legacy ioctls)
  - Linux v7.3-rc2 (5c2f4115051d) without this series:
      - patched mdadm (no control node, so legacy ioctls)

All runs give the same result with upstream mdadm.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Suggested-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

Changes in v5:
 - Add MD_CTL_LOOKUP_ARRAY command.
 - Improve the warning message in md_ioctl()
 - Rename convert_to_array_info64() to array_info_to_64()
 - Rename convert_to_disk_info64() to disk_info_to_64()
 - Documented the fields on mdu_ioctl in md_u.h
 - Link-v4: https://lore.kernel.org/linux-raid/20261015204640.1184848-1-abd.masalkhi@gatech.edu/

Changes in v4:
 - Drop struct mdu_bitmap_file64 and keep using mdu_bitmap_file_t.
 - Remove MD_RAID_AUTORUN, since the kernel has not supported
   the corresponding RAID_AUTORUN since v5.9
 - Rename the ioctl commands from MD_* to MD_CTL_*
 - Fix MD_CTL_CLOSING mutual exclusion in mdctl_ioctl, reported by
   Sashiko AI: https://sashiko.dev/#/patchset/20261007115104.13884-1-abd.masalkhi@gatech.edu?part=4
 - Link-v3: https://lore.kernel.org/linux-raid/20261007115104.13884-1-abd.masalkhi@gatech.edu

Changes in v3:
 - Fix the issues reported by sashiko-bot, Link: https://sashiko.dev/#/patchset/20261001125611.943731-1-abd.masalkhi@gmail.com?part=4
 - Link-v2: https://lore.kernel.org/linux-raid/20261001125611.943731-1-abd.masalkhi@gmail.com/

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

Abd-Alrhman Masalkhi (4):
  md: add uapi definitions for the md control device
  md: pass struct mdu_disk_info64 to md_add_new_disk()
  md: use struct mdu_array_info64 for SET_ARRAY_INFO
  md: add a control device for array management

 drivers/md/md-autodetect.c     |   4 +-
 drivers/md/md.c                | 694 ++++++++++++++++++++++++++++++++-
 drivers/md/md.h                |  17 +-
 include/uapi/linux/raid/md_u.h | 119 ++++++
 4 files changed, 814 insertions(+), 20 deletions(-)


base-commit: 5c2f4115051d064ad79b0b4edac70a2b62528d9d
-- 
2.43.0

