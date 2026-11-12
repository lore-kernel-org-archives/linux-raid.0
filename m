Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491224;
	b=SnnBeIeWFCTmLq40+0FgH3kjvaMo0gkiEUQQCedDGlI2cp+kClEIpOw+u6VJKsemcwX6
	 euOdtfE89g4WfvzD3Yize4Z4AmJpFGp8ylKY9iX9lmNI91/28BcMd73Mv2gcymtzq98iW
	 hbiLKphW1Q/7uBHZajRYMhPRmdsnBfAsReCc3K/EGaMboGtK+26zmEGyRQsdPwu/ZJYg1
	 3NklIajPzFsrCLlt2HvnBkeNxA2eqovPRDuU7nwqkG+SvXXbBdoYrmeafX3JHT84zCu6p
	 popsI98a3mOdlfEBEJCVKjNo/Uc5q8xcSFePbghRW27e5IMIcOgd82eedebHVsqfcBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491224;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dERELiZSBaCRsX3GCJV7kxhJlGD+/7BqSxHY/qipGqI=;
	b=bjrqoN79wEeOKDdxnRD54SUVb44R8lbD7aSQ0li2Mp6qscnq8+NsfNrCCxaoDvG5amIi
	 TJ/Bpq7ZLAxwF0lnt8BIb3MexgzeCe3fDtdq1jB0qsWQXt8O2FsUcTXcEqW7uztym4ww/
	 +6dpPkqCo3IurupPAgePKnsMresxE2Xx6Q5Z9sPR1uj22c/EfuDQ3KqPzUf1GjnZtNt3p
	 bbmAKwIEDoPKjFQMLwQaLm2dmP7Vfmh0jPkqtT6FO4xcuZck3cS+Jfx54q047XNwOmq4l
	 Zv/nDwZHkq35ElBRzsU7bI2i3j9cvhW455k1+vga3bN2tqZ4tmeVudwB+9PYdWfp0Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b="bvlw/b/K";
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739A6606A31C
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 13:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 739A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=bvlw/b/K
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df4f7ccf4so94403f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 05:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794491222; x=1795096022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dERELiZSBaCRsX3GCJV7kxhJlGD+/7BqSxHY/qipGqI=;
        b=bvlw/b/Kno2uFKtJ+dXzbP/S8+wc8sflGs2KyqIU0upMpljHYo9DqBVQOR4XfDmCIv
         TQkD6s3vtpeVQzPPWheKAeZuiNU4NmIRFauGSGqUkEhY6ABkf7bzEhOU/FRSF2rbfA5C
         ug/E3vqmyE1MPj2b9qRq4lxmd6sairWVlygW/cVmXRPXih/ZOONUL8/yBPGymxujnhUy
         3RReL2rDPgQKCmxXVR1wlgYkbZzcLsVuHhYG/K1LWPd3YfbR4/1Mt68aJ6xoByINzmZw
         VNdp3JGEjqlOFEESHT0Bp6hRQ8/cnZadKdovZYYXMqOOYAaaumRqVVgeKPAxgXSa9Xti
         WdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794491222; x=1795096022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dERELiZSBaCRsX3GCJV7kxhJlGD+/7BqSxHY/qipGqI=;
        b=Zm5+ijdi0lH0J9qD1tSOs47FLL9xQk1yI98ExwdEvr+8rCL+pzWJBn2PzPHv+KgvZr
         CNzk1YgNKAWCH6ygQwMzRNioh/Vz1sGD6ahp5qUCa894c+ahZbTJ7JIBYMApK7yRusws
         Tpf4qJv6CcW+1+9j5ojVoXsbtYegJrPkQe9GwJXelJPv7QGiOn4p5mI9nfklSrSrVU9L
         OfkCB927j8cPdIB7vNdQz3CnQf+AgF0ibh4cpSs/wSToXDGROFaI4ZMeFsFRazwXJl5a
         BWUm9MgNJWbxnpmsgYkFrVstY0UiTLR1nzHHNflBJW67N59koKQb5wTDZIFbks9GL9Dm
         9SsQ==
X-Forwarded-Encrypted: i=1; AL+hErHhcRfVpBey6oqb0XZA5QkBtItyrZJhuOUugVtF8LLioMKIkcRwqzaAiL/PZcwnYhJkOBsVuFsAt8qb@vger.kernel.org
X-Gm-Message-State: APuU4Z8cux7V3tvBhluI/hY6i6rg8kQPv8bW8oNkM7qwLCCRephRHr2b
	koJnGGahpDx22MsGMvHrkMhjm8iSPDOTGCstDdR5pGv7uruB31tOhtfgWH5AR83Pt4o=
X-Gm-Gg: AYBFou2u1U7M5Br5gOFB7BANJ6c+w7k+v4itghb/zYVT/NUhXW4CKsOTBmBb91HugSk
	XXnRZxAnb3z7HHmDHsCmc+tT42zrhmjMVbnXMJEjzMTISseddj7dgFRg1SvmonXiSCNFsCPUtzm
	KZMSYWjVXSfUz4RD93NZXVoTIWwbITW1YxoKFKmyGz91TLkfE/TjOVR1iPCQO9VujywS+ffkoaL
	IrWtBfFTyTnN5h+ditr4918Qb4x+ppLxMSRF2IlEgLpfsnVgCcPwAuiF+QADovbQrSnaiVNA7RA
	jvgkxmaLYUpf5b36GsUcnKMnTjSTQHqFZRPnhsU1W4JkJ2K5HxPw5dSQdhTDsIFLT4H++LOZFK2
	1HBf3Eedv5jVILF1/XwdqF4hx6XzfL2mH7G1p+FZf85U4x+eX9LjsLXeUinxCCEry5RTLz8Ru/U
	kiOfoLKeDr3buMcQxoLhQ93aqIH3Y0tBy5VLapiRpYvCIjIgk1MyqjmarNI1a5rNVv3vWDxHZHL
	TeP27whezCSTqwJLq6LUmhq2obml31WQnu026AbGRgYsXKPZEbLuXOyN5SAxw1ozGFadTLP2+q3
	bopWDrXNKSCFT363vkxZJafNsx3eHByAHEKEAgzmc53pEYo9yLNthl8+cvm3ZEFGwRpGp1ig6Lj
	oF3jnRw==
X-Received: by 2002:a05:6000:4205:b0:491:9a69:5ad0 with SMTP id ffacd0b85a97d-499c7d06677mr11144611f8f.5.1794491221773;
        Thu, 12 Nov 2026 05:47:01 -0800 (PST)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498367b99bcsm17665990f8f.51.2026.11.12.05.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:47:01 -0800 (PST)
From: Jack Wang <jinpu.wang@cloud.ionos.com>
To: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] block, md: suspend md around queue limits updates
Date: Thu, 12 Nov 2026 14:46:58 +0100
Message-ID: <20261112134700.372702-1-jinpu.wang@cloud.ionos.com>
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
across the freeze.  A bio parked in md_handle_request() while the array
is suspended still holds a q_usage_counter reference, so that freeze
never completes.

v3 froze the queue in mddev_suspend().  Review showed this deadlocks
against raid1d/raid10d resubmitting a split bio and against raid456 I/O
waiting on an interrupted reshape.  Following Yu Kuai's suggestion, v4
lets a bio based disk suspend itself instead of freezing its queue:

 - Patch 1 adds optional ->suspend() and ->resume() to
   block_device_operations.  queue_attr_store() and the integrity
   flag_store() call ->suspend() before taking q->limits_lock, commit the
   limits without a freeze, then call ->resume().
 - Patch 2 implements them for md with mddev_suspend() and
   mddev_resume().

The order is suspend, then q->limits_lock, as in mddev_update_io_opt().
A suspend already held by another task only nests.

Known limitation: md_submit_bio() reads the limits in
bio_split_to_limits() before taking active_io, so a bio already there
when the suspend completes can see a mix of old and new limits.
mddev_update_io_opt() has the same window.

Christoph, does a ->suspend()/->resume() pair in block_device_operations
fit what you had in mind?

v3: https://lore.kernel.org/linux-raid/20261102154847.198472-1-jinpu.wang@ionos.com/
v2: https://lore.kernel.org/linux-raid/e2c36f31-d198-40a7-a18d-156e1fd6fbb2@fygo.io/
v1: https://lore.kernel.org/linux-raid/20260909063029.GC29874@lst.de/T/#t

Changes since v3:
 - Drop the freeze in mddev_suspend(); add ->suspend()/->resume() to
   block_device_operations, as suggested by Yu Kuai.
 - Also cover the integrity flag_store() path.
 - Rebased on v7.4-rc1.

Testing: the reproducer below, 20 fail/remove/add cycles with fio in
flight and a loop writing queue/max_sectors_kb, on a 6.12 based kernel
with lockdep enabled.  No lockdep reports, no hung tasks.  That kernel
had the queue_attr_store() change only; the flag_store() change and the
rebase to v7.4-rc1 are build tested only.

A blktests case for this deadlock was sent separately:

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

Jack Wang (2):
  block: suspend bio based disks around queue limits updates
  md: suspend the array instead of freezing the queue for limits updates

 block/blk-integrity.c  | 10 ++++++++--
 block/blk-sysfs.c      | 19 +++++++++++++------
 block/blk.h            | 20 ++++++++++++++++++++
 drivers/md/md.c        | 12 ++++++++++++
 include/linux/blkdev.h |  7 +++++++
 5 files changed, 60 insertions(+), 8 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
