Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634531;
	b=arbCpehmjt3ZW2m0cv52QGPzWXdHDm4z6qKcA6zPAaeO16diynXlrudU9Yy3H+IroX5S
	 OrjwiSd7YU+vrp1mwUSewws2GR+TkifkYQRoycn5LoZpbuenQ+P3LoKU2tNXfeT5BSr26
	 kc1CdqzPPqg4pGSB/yhTOm+m9VqAHzJr3e1QyfisGqDX4R4OgNZnK1TJH2Y9d6wHPQMha
	 bGch+S/ek7f/Bdczs5c7qnnNL6lbFcIx587GruWYuvacRNfUmeFMjXEQJ2DBsPrNRzzEz
	 +VaXK0LfbXWiOSwDqivph7s6LIkM8kbNBLJO9gRhWYB8Oe2WUvgJ92FtP93QTBhfrZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634531;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=a/7HdddsrBGNDK6RARp0U8KGOn5itFvaqEt1f5qWc5E=;
	b=lEDILcLB094eFC516T/Mp4+XRSyoQyH8PVeh/377T+NlKFZeH83vkEXf/I2hBoMS8HFn
	 S1shYrMrN4cWXdl4QJTU8tjlR+aDvLcxNvmQFDhAluPuDFbo9G5ViEvlMZvlaLbitagAJ
	 8wNOmH1YNExzozk+h6EstpTANgbUBL29sV0TzNwZbNrWVIrBVAnEknjiHCDu6iFUmcoeL
	 2zVokf/As+kOjGeMCy6x1xUh+wFwr7zU24wRDcv7/KA1VO74xc8ro16h6Cse3H7p3lsLT
	 1HghVfE/pyH///CTfnZ3sEoBw/iXRoGo8ozBBvV8R0oixeTa3FwY8rAUM5E7rO0U1cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=eHEhq7tT;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98868606A32F
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 15:48:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98868606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=eHEhq7tT
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1f80b7bf6so5460635e9.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2026 07:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793634529; x=1794239329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a/7HdddsrBGNDK6RARp0U8KGOn5itFvaqEt1f5qWc5E=;
        b=eHEhq7tTHFXlJKul3sd9mxqbkZmljlDu7JBP0VeMLlVi35sXLSd4JXf5bHA9de2ljn
         iETS1SpCSHEj2rIYy8BZL4Z15wBQ9N6OEG2H5nZL3Aav3H/zEbMl2w76tO7tDgMTqSML
         YHTnrHHNDI9bS3NWn8/jFl/0vIlf29zv4NDrVKSZ1SvtMV6OYWSqAEgOMlyRqudio45d
         uxuZzaLi0oafcXZQJZwUwZmP2ZVVoKVMLhigYQbslcaaHT09SnANTT556mDr4ZCuJsbx
         Aw8c4kE+9xKkcIxs2GK4r7IUsu6rGifhERM4Dk9LrD6aJzeUZ+OMbwFSqcrnuIAFZJrw
         pH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634529; x=1794239329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a/7HdddsrBGNDK6RARp0U8KGOn5itFvaqEt1f5qWc5E=;
        b=01298STGDO0gZk7SsgUgmCYK260TbZ29CL3UFBxGlMM3jFk/91AjyZM9pZHf0IEKSU
         dJmISjgkhFrbe6btXBAxapTuMYZM4UNjq3O7l4FbPlnSBD7ecWKhJeW/nn+1cXdPlV4j
         mgTDJK6rUNwWTLRD1utpfQO/HxsPCYJYIKvpNF2IAuWiXOVsXZOpThSoqSsnBh02KpSr
         5ooaMKXgF1XQVo77JCzwxCqHc+Cn9aUMPeCHlxfhpXQ/QeE+1cTBnt/u6TZas1GtxKj/
         GCo7J49aSEz6hBsYRYLLeOpxylHL1HOJi50gHvOFRJMgD5Pxcx5csGh27G7BW+4S3Yod
         dBdA==
X-Forwarded-Encrypted: i=1; AKwUvBzIuP99BzAQeeedFDXQYlMqBdJH2ufrqsyKVtfwSFao8KlitsdRwrIJYUQ1JY5fRbRmalbu6mo7+jlm@vger.kernel.org
X-Gm-Message-State: AFq9FYKZ5QwsWFjiUDRcODYOz2OOMa4rIuimuAW5c3pO+H/oXebW4MZL
	ITneBZIKReVXm8HFcfdfsGrrChMqUn1ad4TylS9Igknw4FvH/hBTtx0GqCs+Xf3YF0A=
X-Gm-Gg: AYBFou1AQfQ31ammIGqwWgkhWs9sw+x2pJ+gIcdvodaaSYz9wHQnTmcSivyU5jrlD0a
	lve9ZX+yAF3hSahIrHr6Dn2YKvS3umUqZZKKJAUcc0sp331K9Ck2H7++wQThT8X0ik+epRIeGbE
	uDfH42ndcqNll9ZhYFRXmFkdt1DgvJwvQKGo+EBdrunPqJJl1YWiybkq8hfrGS6e3fQRoT5MXEM
	s6po7WSzNcXIPus2GwvAkB7Toz6x/5aVIrHBwd5LoHvtRDvFYRY7vMU/ofemFSVatCpETrjcY2f
	XHpJ6lxjEbKKK7V/8XSXwcK/2EO8g+JZ6ucjFr7jxinkvH9+i4AnHASAhH/TPocIlQgbGOBiYbg
	NNyIP13IAs2xM9UWMlN2z0fmQ+TrB/YI7UH5+KavjZxT0hJZgQoa66cPWugGHebvzgvEozxrcOU
	jkNMQOWWHNvAkH/aqOLml1liAgJpJKFzA1hKUd+oEnjkjeuhu9EW9QWahax0X06YAIACrNWwSVa
	VAUUc5bCJZaL1lppAH0zHLGGKqKgMhDIl6cc+5gSI55DkXG0PUB6gxqnCDKPIwELANvogf1Xa4c
	qgvbnXfBlIuZFn4SU12vCu1cZOJWFHSSUFABtjolf2qhmJa+kaBUrQN9zdeYK8O2ZV2bKc7ic3J
	6avaIfsA=
X-Received: by 2002:a05:600c:a010:b0:4a1:7dcf:be1f with SMTP id 5b1f17b1804b1-4ac166ee4d6mr239662965e9.1.1793634528898;
        Mon, 02 Nov 2026 07:48:48 -0800 (PST)
Received: from jwang-ThinkPad-T14-Gen-6.fritz.box ([2001:9e8:1447:4f00:8b7d:ec80:fa70:d638])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba4ac6sm22000850f8f.52.2026.11.02.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:48:48 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v3 0/1] md: freeze the queue in mddev_suspend()
Date: Mon,  2 Nov 2026 16:48:46 +0100
Message-ID: <20261102154847.198472-1-jinpu.wang@ionos.com>
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

Since commit c99f66e4084a ("block: fix queue freeze vs limits lock
order in sysfs store methods") the sysfs store holds q->limits_lock
across the freeze.  A bio that is parked in md_handle_request() while
the array is suspended still holds a q_usage_counter reference, so that
freeze can never complete, and everything behind it stalls.

v2 reworked the lock ordering so that q->limits_lock is taken outside
reconfig_mutex and the suspend everywhere, which took eight patches.
Yu Kuai pointed out in his reply to v2 that the freeze is of little use
for bio based devices on its own, since it cannot guarantee that
in-flight bios have drained, and that the deadlock is really a
blk_mq_freeze_queue() running concurrently with mddev_suspend().  He
suggested freezing the queue in mddev_suspend() instead.  This version
does that, and replaces the whole of v2 with one patch.

With the queue frozen by the suspend, bios submitted while the array is
suspended block in bio_queue_enter() without holding a reference, so a
concurrent limits update can finish and release q->limits_lock.  No
lock ordering has to change.

The freeze cannot always wait for the queue to drain.  A writer waiting
on the suspend_lo/suspend_hi window and raid456 I/O waiting on an
interrupted reshape sit in submit_bio() holding a reference, and only
make progress once the suspend has completed.  In those two cases the
freeze is started but not waited for.  The original deadlock can still
happen there, the same as before the patch.  dm-raid has no gendisk and
is not frozen.

v2: https://lore.kernel.org/linux-raid/e2c36f31-d198-40a7-a18d-156e1fd6fbb2@fygo.io/
v1: https://lore.kernel.org/linux-raid/20260909063029.GC29874@lst.de/T/#t

Changes since v2:
 - Drop the series.  Freeze the queue in mddev_suspend() as suggested
   by Yu Kuai, instead of changing the q->limits_lock vs
   reconfig_mutex / disk->open_mutex ordering.
 - Skip the drain wait for the suspend_lo/suspend_hi window and for an
   interrupted raid456 reshape.
 - Do not freeze dm-raid, which has no gendisk.
 - Rebased on v7.4-rc1.

Testing, on a 6.12 based kernel with the same change, lockdep enabled
(PROVE_LOCKING, DEBUG_LOCK_ALLOC):

 - the reproducer below, 20 fail/remove/add cycles with fio in flight
   and a loop writing queue/max_sectors_kb, which wedges the array
   without the patch
 - a raid5 3 -> 4 reshape with fio writing, which moves the
   suspend_lo/suspend_hi window while writers are active, and
   mdadm --stop afterwards

No lockdep reports and no hung tasks.  I have not yet run the mdadm
test tests/25raid456-reshape-deadlock, dm-raid, or an upstream kernel
with this patch.

A blktests case covering this deadlock was sent separately:

  https://lore.kernel.org/all/20260910100916.1638378-1-jinpu.wang@ionos.com/

The reproducer:

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

Jack Wang (1):
  md: freeze the queue in mddev_suspend()

 drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

