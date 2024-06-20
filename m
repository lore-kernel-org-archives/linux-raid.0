Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0149B1ACE6C
	for <linux-raid@vger.kernel.org>; Thu, 20 Jun 2024 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888165; cv=none; b=EaQbk0muhs22kC9eSWXhQfi4rhT0E2M7R8y65Oq4OK0vBvK0BPLB+avUXXcozQz1W2MFk68IGhx2CxJ8GTYdvxHAUfsblpXIER7lryAwDjOZH+nzKJ39q6EBYFSsu3p0b4c2VGJV0Ngxnm2MaNRKC67xq19aWZBbQ/Lhq1i/+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888165; c=relaxed/simple;
	bh=RuJyc/vh7rRo84AoGK79y+sVnZDtFtSGukVmP5Nu3Mg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=thWhLkje1DdNhCwlTQplwH/LIQZezSYSxyVKJhfbE7un1hUe0tpdREXExkA9F1GAeUI98Z3jHSY+I/QEKU1t7rZSFOXCalG0/ImZA5nopI4bc7RX1QCaV0dm/NddRP/tQKAOgCJ02AsAbU2foUdeCAsW7aJUs/8noJhWfcUV3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s4Aic17J; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s4Aic17J"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-6f799fc5af3so90273a12.3
        for <linux-raid@vger.kernel.org>; Thu, 20 Jun 2024 05:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718888163; x=1719492963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+GpvSy/VWf2OfE/fuIXNKg0MDOOI+VCks5t0p/pcdM=;
        b=s4Aic17JGwtSch1sGqAGQb4YJhknw18r8r4NSw8u+6elAp3u3dDa6taWd/nNYKMKoJ
         sxeR8BAJUTMMlvtmN49Nb8YNlG2/hJRSbOGmyAt+7/Zfx5RKgkzSIjzohp05JDGeRLWs
         XLTl7ApNBwni0Ijr7soq82r16w8NCu7n+o8qG3eB/ayCHm62C0W7VxuYTMIndNjbaoCr
         i6/N4CikULg+lBFcB4K7MptsGbrF584J27WNAzUYcaNHxq3ohC9nTq9OP0KGGxEWxqbf
         Cczf4Ik3IrYqRi5KqIuGEQqTvVO/izLEgcgFMDNHEcL4eLyNbn9jbPoNCgWto+FvojkD
         IO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718888163; x=1719492963;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+GpvSy/VWf2OfE/fuIXNKg0MDOOI+VCks5t0p/pcdM=;
        b=q7atJlZjBbj6hIQ/4roBiXOnMM6SRSumb2WJvhF3fQ19V3BCB5JhIB849avx2xdeJW
         iidQIuBEE9GoDh9XSuwjCopbtdAouwc8zIS3MoEwX0z40UetnsmtARjQ9GM+ooB5WSET
         jqcqVmS9MZtPffyj7tdqSGKwZllGa+GQMBh49IZ0bG0Vhv4gwBzUMUdV0/MvT2gxceG/
         gFxgZXFOjtX1W6jiurOVacXycBvhJTNw4FOgtXRNe/NCtraTuzGNxIcKawipZlGoYLW5
         l6Js0VpG4yzjAcuK1RW5/JgjtQFfnnWFeYnKaqUhacaGZ1T8Z44/4iApYFQEv6n4hB81
         u14A==
X-Forwarded-Encrypted: i=1; AJvYcCXHk+5RrNmBDzI1dXKCP/vVSq4oODq0pxo5/WCQlqybmf++kf2GTAsmRjOJnQgzivGr+5wVTTHuuFzV16H8UFGI4jsExGvN8EJ4Ew==
X-Gm-Message-State: AOJu0Yw130dIeXGvgm8EYZByY1MXWpESTV8KW8arKBFQY6E8A1dXOD7h
	7KwkC9GJX5Xyd05WunyTkpDyO5x94HPYrW+TaJwqhKqFk+C6Gw1rAYzl1VGyGOxGelDGwUuoUg9
	c
X-Google-Smtp-Source: AGHT+IGaFjmmqS8/vXfhaKJBvkqfuC0AIKhlPKIXJ/sieoz+3d1tNx2iS4ZjGF0ndyA+Z+pRDmp3zQ==
X-Received: by 2002:a05:6a20:3c9e:b0:1af:aeb7:7a10 with SMTP id adf61e73a8af0-1bcbb586da9mr5418200637.1.1718888162785;
        Thu, 20 Jun 2024 05:56:02 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8eeb4sm12207576b3a.205.2024.06.20.05.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 05:56:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org
In-Reply-To: <20240619154623.450048-1-hch@lst.de>
References: <20240619154623.450048-1-hch@lst.de>
Subject: Re: misc queue_limits fixups
Message-Id: <171888816188.139187.12750497286159297974.b4-ty@kernel.dk>
Date: Thu, 20 Jun 2024 06:56:01 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Wed, 19 Jun 2024 17:45:32 +0200, Christoph Hellwig wrote:
> this series is a mix of a few fixups for the last round of queue_limits
> fixed that I had prepared for a rev of the queue limits features series,
> and a bunch of imcremental conversions that I didn't want to bloat that
> series with.
> 
> Diffstat:
>  Documentation/block/writeback_cache_control.rst |    6 ++--
>  block/blk-settings.c                            |   34 +++++++-----------------
>  block/blk-sysfs.c                               |    6 ++--
>  drivers/md/bcache/super.c                       |    4 +-
>  drivers/md/dm-cache-target.c                    |    1
>  drivers/md/dm-clone-target.c                    |    1
>  drivers/md/dm-table.c                           |    1
>  drivers/md/raid5.c                              |    2 -
>  include/linux/blkdev.h                          |   25 +++++++----------
>  9 files changed, 29 insertions(+), 51 deletions(-)
> 
> [...]

Applied, thanks!

[1/6] block: remove the unused blk_bounce enum
      commit: f6860b6069b92559f5cdb65f48e2d82051eaebca
[2/6] block: fix spelling and grammar for in writeback_cache_control.rst
      commit: 4e54ea72edd68d074be2403f3efc67ff0541e298
[3/6] block: renumber and rename the cache disabled flag
      commit: bae1c74316b86c67c95658c3a0cd312cec9aad77
[4/6] block: move the misaligned flag into the features field
      commit: 5543217be468268dfedf504f4969771b9a377353
[5/6] block: remove the discard_alignment flag
      commit: 4cac3d3a712b5c76d462b29b73b9e58c0b6d9946
[6/6] block: move the raid_partial_stripes_expensive flag into the features field
      commit: 7d4dec525f5fd555037486af4d02dd3682655ba1

Best regards,
-- 
Jens Axboe



