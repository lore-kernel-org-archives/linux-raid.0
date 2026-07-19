Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D825B09E
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472171; cv=none; b=mQgotokb52k3eiy7ebqFSNawKLaLobmJ1d5RnOw463iw+CqJkngNJmtAuVd7ZQ61EgE/eD76XQJGA9PiVVgY470JL4PSiXl7Cl6hx2CcKPMqhVGuBAVFRgKgkissDkmnLoLzULboAussKNCcgkaJt094DSUpIpoZLbVJN+J21Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472171; c=relaxed/simple;
	bh=XuaBa49+cQqPM0oJc7NMlcna3FZb/VEew1uMcENuAwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l7MehWjn40hkR1wSh2h/cIztpNgSCICGjcIrIHWtMvws8lPe//wopTPSYVfn65CoLeqxLnxNU261czwUkLUzJls7rPmT+usO/a58oYla2jk+o7mbSEmmY2P4BTcRZ8ckpNdHUAOHeBUbqRCvbHcEI0+9IeFHyMsR7BxAfuPWmVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=YX37u7Vu; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="YX37u7Vu"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so5459414f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472168; x=1785076968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=odYwcfI2XZg4v/6lir2jQDfiLMr+m0gDRo9jrsyH0tA=;
        b=YX37u7Vuw4zXajdsxLVSPX6xs5Nhoe9i/T4HI4BAWhIEmtkqvE3tG2YJ3+hNTO7XaU
         uL8b9C0EiJTi5fbXFCvb4OYgJgp2UxNIpYOu4NVkwj5zMfl0RyfoFaJngl7qlb13vpR4
         WPr+hwL8BLIsnqqX8fZ+pUAOVbfOqLWCCnv3AiCX0D8BOWO9Qv2aQs0LWCdjNibAaBNY
         Dcnwx5Z5Rgat4FrpVE7+hqncngDfVZMafqO4VIHAVkD4iUoe+IT517kU9hSYDbdVuw06
         YfgiIfDLo/O/Qn6/b3vkeiO7J105kwjukPpk5OsHKzyn2jUdn+p7d+vUzk0wwHD75we0
         MqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472168; x=1785076968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=odYwcfI2XZg4v/6lir2jQDfiLMr+m0gDRo9jrsyH0tA=;
        b=LgIjkpLr0k4oPrCq63Piyyun/mfWACbZU+GpfRbbFDfNHuh+I7Lbve3VUf5Db5gPCf
         CTbVuZMR5CM5VJjosQOP+QjU6nRUurNdcQhZOJu7Xd9xGXbQj/hPtrFVcRcHJ8bYf5Tf
         UXMcCCzF0DYkLoym54RCDu4GbhZPDQeJHl5DBoIriMOY8CGmOfUfgBEIagYiEdgY6aUp
         88g17eDr2hfdGxk8NailxrIdvvIQ0OFgtIZCTW/4Wxw4uxx+1q/bmQ6AEdf9/SPMSmoL
         iXuueEKh4YkHJVtMXtWmnbGc7TVguzLYGTNSeKZ2nN7AQI8MkTO/h42+XaJLpiJimg3a
         qrKQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpCCbRNPL0AvKbDP7tdX8kmJpKbqzoOv5qMwd/PYPUCRy9sKfjbr2gjcr3JmXP09zzXf9T6Ngo+0IH@vger.kernel.org
X-Gm-Message-State: AOJu0YxTkAxczjPYpeChWMlGasAuECT/ODMFeeXe0aijPIR3UrZ71RzG
	2cM7YOjZKjO8xjfpAIbCZcNAGKCmsbq0FRZK5JOjNGiTVbQ9bkcs6QwDx9DUClEEzA==
X-Gm-Gg: AfdE7cnYK0p5EDM11/ALLM7MWYl60wDVRko+GPUb2CAnA31YtcuwuahvNVx8B7fFFF5
	y8G14zr9rgJ2EBp4zWWfjrg8jyRwDfbm22nwdQKcTxYOcyydk/m+v0pJakf89fA9uX31nccR6RX
	XhbMzWrrYJdRl2o0Ah20gy9zuqT5Md56PmZzhlKBBFY5ym/EBd2OnTBKiQuMTkip33m2gmxAiD9
	J9VEXxRj3ZPVbQBOpKCn459zPrAYK0Ex2e/8T1pUZfoLz/4TomxihFr6ODMlWeyf8J2nKA4rMcH
	VIfLIEW7XxT90cXaH4rSYjIE+nt2WARs0Q6FL+EaO9/iiJm+1AuDgAVP4/VbKTeWl+9fL2xpCGc
	3YA/u4uiQ7+fft27NWsWWUo0+NRsuJ8KxTBNCRUjUNguceVZUz1IUWrLSjxtlnA==
X-Received: by 2002:a05:6000:1883:b0:477:6874:5413 with SMTP id ffacd0b85a97d-47f6232e170mr10870492f8f.58.1784472168174;
        Sun, 19 Jul 2026 07:42:48 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7c69sm22668895f8f.17.2026.07.19.07.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:42:47 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] md: fix silent data loss in raid10 recovery and llbitmap resize
Date: Sun, 19 Jul 2026 14:42:24 +0000
Message-ID: <20260719144227.940444-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While testing llbitmap we found three independent bugs, all in
the silent-data-loss class.

Patch 1 is a one-line v6.12 regression (it reaches the 6.12 LTS
line): the bitmap_operations conversion inverted raid10's
still_degraded detection, so a rebuild on a still-degraded raid10
consumes write-intent bits an absent member still needs, and a
later --re-add serves stale data.

Patch 2: raid10 recovery with llbitmap consults skip_sync_blocks()
with per-device offsets the bitmap cannot interpret, so rebuilds
complete in milliseconds having copied nothing and the array
reports optimal with a stale member.

Patch 3: llbitmap_resize() indexes past the end of its page-control
array (grow crossing a bitmap-page boundary) or silently remaps
chunks (chunksize change); make it fail cleanly instead.  The
pending "md/md-llbitmap: support reshape for RAID10 and RAID5"
series implements real in-place growth and supersedes this guard;
patch 3 exists for mainline today and for stable.

Testing: each bug was reproduced on an unpatched kernel and the fix
verified on a patched one.  Patch 1: classic-bitmap near-2 array,
fail one member of the higher pair, write, fail one member of the
lower pair, rebuild a spare, then --re-add the first failed member
-- it now resyncs the writes it missed instead of returning
instantly with stale data.  Patch 2: near-2 and far-2 spare-add
rebuilds finished in well under a second without the degraded-era
writes (near-2 copied nothing; far-2 only the clean regions) --
fixed, a real recovery runs and the writes are present on the
rebuilt member; a same-member runtime re-add on near-2 was verified
the same way.  Patch 3: the out-of-bounds access was demonstrated
under KASAN; the patched kernel refuses the resize while shrinks
and in-bounds grows keep working.  Each series builds W=1-clean on
its own, applies to current master and to md-7.2, and the two apply
and build together.  The patches are independent of each other.

The patches were developed with AI assistance (see the Assisted-by
trailers); all code was human-reviewed and tested as described above.

Mykola Marzhan (3):
  md/raid10: restore still_degraded detection in recovery
  md: only consult skip_sync_blocks when 'j' is in the bitmap's domain
  md/md-llbitmap: fail resize that needs more bitmap pages

 drivers/md/md-llbitmap.c | 26 ++++++++++++++++++++++++++
 drivers/md/md.c          | 13 ++++++++++++-
 drivers/md/md.h          | 11 +++++++++++
 drivers/md/raid1.c       |  1 +
 drivers/md/raid10.c      |  2 +-
 drivers/md/raid5.c       |  3 +++
 6 files changed, 54 insertions(+), 2 deletions(-)


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.43.0

