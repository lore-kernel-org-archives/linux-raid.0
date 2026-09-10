Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF6041A542
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027880; cv=none; b=Si/2kLoutI7b0LYtN/yynSquKnbvN6aXPRp0fn5pcDxJrShtmVsjavqgHhisxroQl9wE7u2s3de/acAsTs+M9TZYjWcDWu/KP1YupI8quFoKZ16Om6FP8CqpuE4BJbZcqCaOJ4seM4cEdEVzn25WzGP4yPZuNPYmAcrA+L0P2TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027880; c=relaxed/simple;
	bh=3gwQDg5/pRQMl/ZeRC2dW7FljbzBvJ81WHltDVFJAPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wh3i9O/l2X67rMU3SSo34XZ90eHiMCtv9u3ovB9yxyzU8OIYJtdxTRkfdZGhVry67MCn1rUrIN+zFTTFvvAdXGeIGKzlT5Q7EW/XER8+lHC/0GV0W4LXrp2Mut9dsB4Mk+pHuj36I6mebY3vo1yM/roBJifyvcIZc939TVLGcr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=cmZyACvv; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="cmZyACvv"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b0dd3e1d0so2385815e9.0
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 01:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027876; x=1789632676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2hP0ERLQ89AaL2POqDRKNFPqokF0N5w680U/ZWvBmc8=;
        b=cmZyACvvPAxoj//w3DDkacKFZvo+Bw31IGu+wTN/+r1KJibjv4oZd5fzU9IwZoLmxG
         5V7Wpr/K2b2QOkRgA8a6mdaZSmQLAS+EB73SKrPvX7qpxHkO4X5uTkChZnQSdsxjck8E
         iVIRvMRiv39wZIEZ7jwkW6hyeKFKb2xy/ne9PSd7FO1xHcTcUKB9nMaQNZ266SLmtrAx
         RlcSVp5FU8X6/sF7+HtG3JctFxCnHm9NjklBhn98Y9y7zFdvUO2d8HZ2rcTVf0Ko2jiW
         s9EDZFKTuhCQmUduyUT14Has/yuIhrc81xunUH2tOecsmUQCDhPngO+taKOnzu4J4SBX
         FLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027876; x=1789632676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2hP0ERLQ89AaL2POqDRKNFPqokF0N5w680U/ZWvBmc8=;
        b=KiD1oYXeeOu2rBVHB910FzbXkFpMx/A35bpGzzMios+nUxeBsI2VbyGkumNjFl4MwH
         CxMCO6uWumSldiC+uKihaUqUlf6/m8aPa2f7NK9QvX6s8U1MdLVi0ERb4isMRXilxNHj
         HQRwWLwuUX2zpp6FbvCmy717YVbeY+uetDigi41BtbLoTRP8Er3anGtBKuTo7gXH739u
         hHtWdTQOv5H/0qtMKdyksGxOa52t4AZDfu/is9kGXBmpfGkeEGgvhUGWA2+OiRI5FGzK
         4uePLymLeW99bge/Ius5MfkKTT0T5a00cvjA3VNRZ0ivPn3xogNyX/Pn/WgImuRfIKnO
         zr1A==
X-Forwarded-Encrypted: i=1; AKwUvByVYPZjM4xMENP7j4EyKCv4nNN1ZQx+UpMTMbZ6/trIl5Xz/5r+Vl7/rZA95KVveLp+MpIG4nQL/fD3@vger.kernel.org
X-Gm-Message-State: AFuF++l71S45pBTGltsripIvg9C/ARKXWt3NqmgA0jyLnVDKFPYenuh8
	MMXFjFcFtTSbQrB/s9BBVbdEGBt082wAAQNK7eqhKWIGWIF8GLg0PLCFWHd0RSwUjA0=
X-Gm-Gg: AYBFou2rD9SREa2SLfGNnCnOjLs7NDq2wv52tSwS2xvaPd/uce9al+SfblttRq1ZMje
	YUiRP9me4dD1xrR2DaRjMSG8Y7v9Va4QDDlp+RA049mgBrlRcJFxK+1W/JbYM6yrCFoKxhYLZkn
	Uq55Vt//xKb+G6dRGEok7N0F6vHsIJjgTZJcfHPKuJuPXsBSciok0TLArggB5jfA7GC6yAJ3SPK
	a3Z7byOwPy6Xu/Zb4aV5q1Oq/Z0Kgwj+b41+33eEa3y/qB3czrVxrDUw75N6lH5Zo863SYUCnLM
	uxMn76Rfcn0MnnNMGq6VnB9kIvHL+g3um6vYI3KQ8eSYJK5eBlzH0KfrUx+J1s5WLuD/s51JgHo
	7zOI80sgcokMlJatNdzJvw0gLZcw3lghgYVAhNAnlKP6sBvqXHSfLIc3T+d7h0d9UBfCBP4xJhM
	KvnVtMO3J33uMwRrSEhkDDMsHzBzXfczNNObGPJCBURxT9KvoDDfgEiRe+UNqG03xGFusdmEAdk
	T1EbvKoGALhxCegvqnukPwBpBiOvNJaYnp/Gera0IBF
X-Received: by 2002:a05:600c:860b:b0:49c:f9b8:bae0 with SMTP id 5b1f17b1804b1-49d01dd6b62mr265590605e9.2.1789027875742;
        Thu, 10 Sep 2026 01:11:15 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:15 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 0/8] md: don't wait for q->limits_lock while md holds back I/O
Date: Thu, 10 Sep 2026 10:11:05 +0200
Message-ID: <20260910081114.1605746-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Writing to a queue limits attribute of an md array while a spare is
being re-added deadlocks the array.  I reported this earlier here:

  https://lore.kernel.org/linux-raid/CAMGffE=heGA3y8FjQ0Sm1jj-kd-=H9Y54WozKASSEZhc9UNKjA@mail.gmail.com/

Four tasks, one array:

  udev-worker    queue_attr_store() holds q->limits_lock, waits in
                 blk_mq_freeze_queue() for q_usage_counter to drain
  fio            holds a q_usage_counter reference, parked in
                 md_handle_request()'s is_suspended() loop
  mdadm          suspended the array, waits for reconfig_mutex
  md_start_sync  holds reconfig_mutex, waits for q->limits_lock

The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Since
commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
sysfs store methods") the sysfs store holds q->limits_lock across the
freeze, so md must not block on that lock while it is holding back the
I/O the freeze waits for.  That is the same hazard mddev_suspend()
already documents for reconfig_mutex.

v1 kept q->limits_lock outermost where it could and used a trylock
everywhere else.  Christoph asked for the lock ordering to be fixed
instead, so v2 drops the trylock and the block patch that added it.

The rule v2 applies is that q->limits_lock nests outside reconfig_mutex
and the suspend everywhere, with no exceptions to paper over.  The two
callers that cannot own an update do not need one: check_sb_changes()
and md_check_recovery() only ever re-add a device that is already a
member, so its limits are stacked and the update is a refresh, and they
now take the no-stack path unconditionally.  mddev_update_io_opt() is
not an add and does need the update, so patch 4 defers it to a work
item that takes the lock with nothing held.

Making the hoists unconditional exposed a second cycle that the trylock
had been hiding, which Nilay hit with lockdep on v1:

  q->limits_lock -> reconfig_mutex        added by this series
  reconfig_mutex -> disk->open_mutex      pre-existing, md opens legs
                                          under reconfig_mutex
  disk->open_mutex -> q->limits_lock      pre-existing, sd_open() ->
                                          sd_revalidate_disk()

Only the middle edge can go, so legs are now opened before any md lock
is taken.  Patch 7 does the opens and patch 8 the holder links, which
take disk->open_mutex too and were easy to miss because the release
side only takes blk_holder_mutex.  Opening without reconfig_mutex means
the superblock format fields have to be snapshotted and rechecked once
the array is locked.

Patches 1, 3 and 6 are plumbing with no functional change.

Two callers still take q->limits_lock inside reconfig_mutex, both with
the array suspended, and patch 5 says why: ->start_reshape() from
action_store(), which suspends before flushing sync_work, and
raid*_run() -> queue_limits_set() from level_store(), which already
hangs on its own because it freezes the queue while suspended.  Both
need more restructuring than belongs here.

The patches are based on v7.3-rc2.

v1: https://lore.kernel.org/linux-raid/20260909063029.GC29874@lst.de/T/#t

Changes since v1:
 - Drop the trylock and the block patch adding
   queue_limits_start_update_trylock(), per Christoph.
 - check_sb_changes() and md_check_recovery() take the no-stack path
   unconditionally instead of trying the lock first.
 - Defer the io_opt update to a work item rather than skipping it on a
   contended pass (patch 4, was "md: don't wait for q->limits_lock in
   mddev_update_io_opt()").
 - New patches 6-8 to close the reconfig_mutex -> disk->open_mutex
   edge that lockdep reported on v1: pass a queue_limits through
   ->run(), open new legs before locking the array, and link their
   holders there too.
 - Rebased on v7.3-rc2.

Testing, on v7.3-rc2 with lockdep (PROVE_LOCKING, DEBUG_LOCK_ALLOC):

 - the reproducer below, 20 fail/remove/add cycles with fio in flight
   and a loop writing queue/max_sectors_kb, where the same test wedges
   the array before the series
 - array start at raid0, raid1, raid5, raid10 and linear, spare add,
   fail and remove, the rdev sysfs stores, ADD_NEW_DISK, array_state
   transitions, a level change and a raid5 3 -> 4 reshape to
   completion, which is what exercises patch 4's work item: io_opt
   goes from 1048576 to 1572864 once end_reshape() runs
 - HOT_ADD_DISK of an undersized leg, so bind_rdev_to_array() fails
   and patch 8's release path runs

No lockdep reports, and debug_locks stayed 1 throughout.  Every patch
builds on its own.

A blktests case covering this deadlock will be sent separately.

The reproducer, for anyone who wants it:

  mdadm -C /dev/md111 --force -e 1.2 --assume-clean -l 1 \
        --bitmap=internal -n 2 /dev/ram0 /dev/ram1

  fio --direct=1 --rw=randrw --ioengine=libaio --iodepth=32 --numjobs=4 \
      --time_based=1 --runtime=180 --filename=/dev/md111 --name=repro &

  while :; do
      echo 128 > /sys/block/md111/queue/max_sectors_kb 2>/dev/null
  done &

  for i in $(seq 20); do
      mdadm /dev/md111 --fail /dev/ram0
      mdadm /dev/md111 --remove /dev/ram0
      mdadm /dev/md111 --add /dev/ram0
      mdadm --wait /dev/md111
  done

Jack Wang (8):
  md: pass a queue_limits down to ->hot_add_disk()
  md: don't wait for q->limits_lock in check_sb_changes()
  md: pass a queue_limits through the rdev sysfs stores
  md: defer the io_opt update out of the sync thread
  md: take q->limits_lock before locking and suspending the array
  md: pass a queue_limits through ->run()
  md: open new legs before locking the array
  md: link a new leg's holder before locking the array

 drivers/md/dm-raid.c       |   4 +-
 drivers/md/md-autodetect.c |  38 ++-
 drivers/md/md-linear.c     |  30 +-
 drivers/md/md.c            | 661 +++++++++++++++++++++++++++++--------
 drivers/md/md.h            |  56 +++-
 drivers/md/raid0.c         |  16 +-
 drivers/md/raid1.c         |  26 +-
 drivers/md/raid10.c        |  37 ++-
 drivers/md/raid5.c         |  54 ++-
 9 files changed, 741 insertions(+), 181 deletions(-)

-- 
2.43.0

