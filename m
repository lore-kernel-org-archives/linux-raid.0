Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794492282;
	b=VK89++CKZq7J1Li2ZmJ+q0iNbRwOOrf4vVS5htum/HHeRR0/6IixGQwKSOsUB0FB4yXj
	 O1AjUEsWWjCNs6rP3Lw4kBWk/4V63QRWjy5IAdZUooK8ItnGqB3WK/LSvQ90Ti/KOAWGU
	 YN8/9icGRbIjYIFGuglY3XKFJOxDjewaFR2JnZbto95JUEa+fVK+R94Vmu2/G8kf5ZTZk
	 2WqWWXXOn/wUMh7OaPYjVf4iDxObT7838wYwRAGBBsCNITJufXsvPlGRL3uDf08DKohWQ
	 Zc7r047EgCFmXc1/D/Mf8OwhAXsHIPeSvMOwGseDsY530Z5dCwE39Es2VZqFk/HvBVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794492282;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sfjUCy4r7AoPENjVJCuMX68WvD7ial/s6ys+g30x7sM=;
	b=m3833PKwe5agtr/GpezP1ApwvMrFabL2TG1qT5+9cDG3ZOtVVTqa0vE2f6a4RAdWCR2j
	 SfTZ7wNy2NlAOsp3dDtb+07hoqe2X/MD5H/si9HKD6kNopAjQi7WiZR+KnUj8Pxb36r7B
	 O7GhAmEzkfZGWBvWEco2yJE2J8+E2ni/L5lxVISyZbUE6F02qiOSxlaq1gS88g8XhImXn
	 CjJPXHUOn764ZgJY65OlkCRQYZoDvK2jPW5H9kGc8p6DrO9o/GDZs3UwSpsRUTWVkdhdH
	 QWJqBeJsLD7RpsBWANyLXGSHWvZMaRlTaJ1EF5esGWWNh56nK44+2VADsDAGnYyD4mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1jqGYCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115A1606A8B1
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 14:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1jqGYCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1F51F00A05;
	Thu, 12 Nov 2026 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492281;
	bh=sfjUCy4r7AoPENjVJCuMX68WvD7ial/s6ys+g30x7sM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N1jqGYCQrI3I9rB3KHX8jS4EtmmGUlE/gRpJ/Rd3MD0fHrL1lFG58k15jD+aJdqSE
	 8+sqGIREqXGMX4x28ZcG1W+KTrJNnx9Prq+eYHGxYvhpcUgEI+FRsm9vRERfmZBYSs
	 NOLpkIz4YxKehNWEeObV+F4x3bqeDkvavdwrmSrfTTltlCe2UZ9DmUszHAyZCFwwqw
	 +VTIlmWjY6DE0p6jbP6k/8i/XfQ04A3KbCnow83EDBjPel1ZoNOXBxOv/8j0RUk+Ud
	 E5MNne/psen7mYqn65LNYIQaw8re3BlZ69qOnnB6d9r8ZVan9d12E66b4yaxfpiXZf
	 mSZWpiDYbdhuw==
Message-ID: <sashiko-outbox-211256@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] block: suspend bio based disks around queue
 limits updates
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@cloud.ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261112134700.372702-2-jinpu.wang@cloud.ionos.com>
References: <20261112134700.372702-1-jinpu.wang@cloud.ionos.com>
 <20261112134700.372702-2-jinpu.wang@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 14:04:41 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] block: missing __releases() annotation on
  blk_disk_commit_limits()
--

commit 191cb84f3b159c80a0741f7887d437ec63eb1187
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

block: suspend bio based disks around queue limits updates

This commit adds optional ->suspend() and ->resume() block_device_operations
callbacks and uses them in queue_attr_store() and flag_store() to suspend t=
he
disk before taking q->limits_lock and commit queue limits without freezing
the queue.

> diff --git a/block/blk.h b/block/blk.h
> index ed21724726223..1c214f0bc1780 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -661,6 +661,26 @@ void drop_partition(struct block_device *part);
> =20
>  void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors);
> =20
> +/* Suspend before queue_limits_start_update(), never under q->limits_loc=
k. */
> +static inline int blk_disk_suspend(struct gendisk *disk)
> +{
> +	return disk->fops->suspend ? disk->fops->suspend(disk) : 0;
> +}
> +
> +static inline void blk_disk_resume(struct gendisk *disk)
> +{
> +	if (disk->fops->suspend)
> +		disk->fops->resume(disk);
> +}
> +
> +static inline int blk_disk_commit_limits(struct gendisk *disk,
> +					 struct queue_limits *lim)
> +{
> +	if (disk->fops->suspend)
> +		return queue_limits_commit_update(disk->queue, lim);
> +	return queue_limits_commit_update_frozen(disk->queue, lim);
> +}

[Severity: Low]
Should blk_disk_commit_limits() have a __releases(&disk->queue->limits_lock)
annotation?

block/Makefile enables CONTEXT_ANALYSIS :=3D y, and both
queue_limits_commit_update() and queue_limits_commit_update_frozen() are
annotated with __releases(&q->limits_lock) to pair with
queue_limits_start_update().  Without the annotation on
blk_disk_commit_limits(), building with Clang and
CONFIG_WARN_CONTEXT_ANALYSIS=3Dy triggers -Wthread-safety warnings in
blk_disk_commit_limits() and its callers flag_store() and queue_attr_store(=
).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112134700.3727=
02-1-jinpu.wang@cloud.ionos.com?part=3D1
