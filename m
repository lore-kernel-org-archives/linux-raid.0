Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCB84DA545
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788375; cv=none; b=rRLZiewR/f05qwoPNhj6eleOlbBtammxPWwkTbumXBJeHl7BHhDdNMXQlA8+7cPjjrDhyaEacv9Hj7bYI935eLexkfK9HOCpQdn1Gx552/jdCTQOYypkJ6wBjAOYvsXCtRl2H1vbHKiaDGpqSAbqV2GD4FxgcqW3zMGj7PTL824=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788375; c=relaxed/simple;
	bh=cmVi4aq8DXQWjK02ev3GPuSIiIeaD444ZJrztvpRap0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RMbkzfxQI+7Yq3putDtCKAjjG272tm56B4ys7Aw2MvEjebf+boRlQ1xz/IZ6XoeGm/nBx/Xy/406ZNwKmXEfOzQg/O80insXXEqoPbTT9zwPzVL45QxlpSnfjgGI8ilqkNaNRQMdjFSixrZ9sB4h2236EK/8KToCJFvZaptJY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=MHtHF6kw; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="MHtHF6kw"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c250848d127so38185766b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788371; x=1789393171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nLSfrxZV8Si8x4R3riAt/ZpTl5FzcfkxH3dq+FWjKEA=;
        b=MHtHF6kwFVCsO0AzLDFwAYw1NBt8otXjm/9mWlVUUWCtPSFVtCHlE/VDDpy6JhiVBA
         fWdxRVDmUPPYEEm5/dHGoFFg9KMESgMc3luvRo8nQt9YwyCYIhf8C3WWfIpeO3bgAVJf
         WMRiSL6wZo2720wQffcXAMkRJMnsxz1QqqeGKiZhVhID3OKBsKGva+WmHxQJm9KLllHs
         4cp9ViXnuutJRZse9bWLIPfpZW3fqXgd6pD9AcXxlTQDrmRluHdYsG9s8cwHWLCwWQIr
         QEwQaLuLriVkP0POo6/yhj7b3fQaYUf/kYDpaPCvzFURX2p1IqoAHVArFLJ5GqipxtdV
         FwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788371; x=1789393171;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nLSfrxZV8Si8x4R3riAt/ZpTl5FzcfkxH3dq+FWjKEA=;
        b=NWEPUlgbIfO5ry8iQxounhMpPiRTCQCD9xNCJJmvih4GO/mBQiSH75qPg2VarGqXSI
         1JZrTDsJAiyvGO8v+mXBoajWIq0VbJWUfrilS3/iJx0eSsSrvRtQLALnPTqh/C/OzqQG
         SaoQVwi1MWPbSVewAD9/e3rbfVXZNcO3D7JP6387OothfHJMnAlMK2pmq8r5xV8rbzTs
         xQWYlMp4O8sf84tQDn9tm3Es04rMGYXybNoAgEFIg987Qu3Mio8aVTfcRHc1e+gIwlqo
         D4jT/DYGD1TRYAJ6O7GEc4br5vnoGE0Zl1gIRx3yV1GTTnXV38tVkW4xIep0n0xh2TWy
         WL4w==
X-Gm-Message-State: AFuF++mcoT0Ng/UNBAsUMdaNocAsTyLJNloyObzN476MmItnQCxTCFDP
	99YWjITiTx3Z8XiL83eQaS4o3Pzzus2UxvZzzi6fEzrrHczopi1x2nBWJpEteUPh1ng=
X-Gm-Gg: AYBFou0x7/5gWvk7qg4EVdIbyhR3sruxWhxzTt5lR2hIssbq4Sian7+NYVwmYUuKNCY
	8Top09fNXzClBDX2dDZWWi+CYYX405YSQ1SKwVyzWtSuTEZMKQsbVd8wBv7i4h5wrmgAMgPcf7u
	PWOHVTSA0LH2EfmpYE+pBfNJ6cnUoKx6IGIOyRHaJX3AgDpXTynlX5+NwY4Olon8nQRmFX5KpCu
	WgHNJoiawKQBmFD5EUeXUQ6XwcomaSTEbd+XUYxR6GWS8tDAKcL9FcBJQJw6P/3YveMFElWNrFw
	I/HCS1xuqksLksYegWRF9ju9YrggiPeFS7I95u4TlalkXhB0L2+ZbBhkYb7fWKyzOPnbCuYPfko
	IUBeQ7UnOVEGlcfPARqOeU03C/OOkEoEoGS+72gYAv3SsS2GkzIfJLYUnLcn7tLf50kNRREiOz7
	c6FLNyz/0f/LuhpiggxD3grpxOZUNmPhY7YxdrQ09M9daXNl94RemOkwFVO87kekrpzUNEi8mHc
	RLb75uhayLdQJl4Py+ozQb3NIod4UevwQ==
X-Received: by 2002:a17:907:9719:b0:c12:732a:fe52 with SMTP id a640c23a62f3a-c26250b9d2amr621126466b.4.1788788371484;
        Mon, 07 Sep 2026 06:39:31 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:31 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/6] md: don't wait for q->limits_lock while md holds back I/O
Date: Mon,  7 Sep 2026 15:39:23 +0200
Message-ID: <20260907133929.1081540-1-jinpu.wang@ionos.com>
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

The rule this series applies is that q->limits_lock nests outside both
reconfig_mutex and the suspend.  Where md cannot arrange that, because
it is called with reconfig_mutex already held or from the sync thread,
it takes the update with a trylock and does without one on a contended
pass.

Patches 1, 2 and 4 are plumbing with no functional change.  Patches 3
and 5 convert the two callers that cannot own an update.  Patch 6 does
the hoists, all in one patch because a mix of the two lock orders is an
ABBA.

Two callers still take q->limits_lock inside reconfig_mutex, both with
the array suspended, and patch 6 says why: ->start_reshape() from
action_store(), which suspends before flushing sync_work, and
raid*_run() -> queue_limits_set() from level_store(), which already
hangs on its own because it freezes the queue while suspended.  Both
need more restructuring than belongs here.

The patches are based on v7.3-rc2.

Tested there with a raid1 of two ram devices, fio in flight and a loop
writing queue/max_sectors_kb: 20 fail/remove/add cycles complete,
where the same test wedges the array before the series.  Every patch
builds on its own.  A reshape and a level change are not covered by that
test.

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

Jack Wang (6):
  block: add queue_limits_start_update_trylock()
  md: pass a queue_limits down to ->hot_add_disk()
  md: don't wait for q->limits_lock in check_sb_changes()
  md: pass a queue_limits through the rdev sysfs stores
  md: don't wait for q->limits_lock in mddev_update_io_opt()
  md: take q->limits_lock before locking and suspending the array

 drivers/md/dm-raid.c       |   2 +-
 drivers/md/md-autodetect.c |   2 +-
 drivers/md/md-linear.c     |   3 +-
 drivers/md/md.c            | 276 +++++++++++++++++++++++++++++++------
 drivers/md/md.h            |  11 +-
 drivers/md/raid1.c         |   8 +-
 drivers/md/raid10.c        |  17 ++-
 drivers/md/raid5.c         |  38 +++--
 include/linux/blkdev.h     |  26 ++++
 9 files changed, 315 insertions(+), 68 deletions(-)


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0

