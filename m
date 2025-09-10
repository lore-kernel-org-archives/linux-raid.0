Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA36274FD3
	for <linux-raid@vger.kernel.org>; Wed, 10 Sep 2025 11:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757503803; cv=none; b=MCmM6Y90R3axQ08COOiAydL6MiVmwhr0Oz1tyTvwmQEG7XkvV3qG9eosNCYcVI1YTD/zzaiJgVp0HF9Xxk6k3OrA0VtTXZNuiO2kDpNDS5yJ2iiPiMrMS4+ha/jgd7MyWHbfNrxMafpOl3SVeg1Ogi/UghOK5jBB4aYSIJb6KSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757503803; c=relaxed/simple;
	bh=Qc9ouAXEskfOMC2oi+ncx55YvT5qr8hhC366cFST6ww=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=mzTrhaVGIU3seqIxGBVcRVoh2iU9+ekWUT8Bq1J7jAGbMopMQybuFFcjdrAGTGqDGJx32UAKJB7o1znp5VI4cREWH2H+gNY9sDuePSegHsB11mdQTarGWyDAY+njvWPAtOZowV4h/Vj8wcvy3isWVxjAYMCMwkZFpxc0isV/M50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eA622EpI; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eA622EpI"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-77238cb3cbbso7030589b3a.0
        for <linux-raid@vger.kernel.org>; Wed, 10 Sep 2025 04:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757503800; x=1758108600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ga9+oP8GJMEvZEK47pxYW+xPRCoN8XvpDsIn4NoQ3I8=;
        b=eA622EpII/lw7KXH+sQLUXm/RKri5K7EbPSJDp9IolDskuAJzUcodBmrMCMndc2eIn
         fboRjx5UvE8BWvySlGtIubp7v2Fk8Fvo11Aivjr3Vm/gB9l+2Mbkn2o6IrdNzZS1ipOI
         dT+l2Eks6AdhG7ddkZVVgbC4sOPv7J7fCW2NHJgUMIl5a0qDALdyz/6hgMrBuXr6Y+gH
         qhP+zRWv7flCXnnhTBVHhsc+owqnnp9lxkO1WoZqMKsDxjOdIoHRKskKfVn1wZo6fdJA
         OBJ0qGq1YpS9Vz2616ex/grepkCVkXkZvz/swdAPjtCY+MJAQOdxEUbPXcSGgacBEdOP
         EHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757503800; x=1758108600;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ga9+oP8GJMEvZEK47pxYW+xPRCoN8XvpDsIn4NoQ3I8=;
        b=t0w2LYcGekI778XDjAwxwiFQJR2rAXp/p0knKKikkQLnRdYwovRfwGOv6rXAr8avp5
         FKmmDDFWAHvX7bIV1tAjHLaVQF2a/5VfNmdfd9egnolBrCnqq+zO6ITbcSuNv8S4dKCf
         BekzmDLMeSVY3As7vsDlcS31rMNmg7FBDd6tw3Ll+xT1K8HDgVVjEWqNrEncnncgGRTg
         8mzEFKI3sQ/+NWh+OA80YPsSTnMuzcjqY5ZM/LwDeeJhgU5fADrAJmoC5Wsu96d77uT4
         donRiVQo3vUoOD+6q8H5cTdOmI6WGMMvkau6nfCDdcIgIaIsywxMMb7EG0r2/078EofH
         9v/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbCENz8XkNWiR0ztNbcWxmxb0u2HsIpKEinOG7fE39sKSMRLwFQcIvUCkxBrB/+lPCuvkKSdjOfpjb@vger.kernel.org
X-Gm-Message-State: AOJu0YzzK4AQ9Ydd1NN4smTkbnfjd1AZvlB8z4GLJC2EBOcA42H+/jyJ
	kT4/CfijDLIMqXOqurCQ5bn+M8lap9Wl7vgJZzdI32nqB1X2dcijax2tG/TnrcJ5TIU=
X-Gm-Gg: ASbGncuFWdwJycpaPpysu73OEm+yUWkZKuUyYAb7WrYKxcZPzYkOGyXnxrENsCcoV5W
	e9UGBVDxikd1K5eojcgYA2dkeltzj8yh3LNm5MFx/0ySEc0dpSXYuc0QO0yyFSz4BUzQ6RVCaWa
	dU/mW58GyoLaVWgf7XvzYn7Wtx+ieb8KpFtKuLpXOc9w029by3FCHZeVes/xsYbcswn8qPVyaxQ
	A2gG5ESTVkHWwjiQV42ooPIA/25L89OKrShPUPpiFZNk6W2lIHnWzsOGXlOzOklrvkNH4IeYxrz
	y0Eb9NpezMjUXfix3716Y5FI0stNP8F6+bgDdDBHVdRtsCYz8qK9zomdhZ/ioLg7bNep3ruMIG9
	KMtQ2TUxoGhRQS/s=
X-Google-Smtp-Source: AGHT+IHmcYOon3e+vAK2exKd9NspHl41ZALs3u/nxenWGV2WwxtMrS9LQckcTVCeEJ6LUSVFA5o+mQ==
X-Received: by 2002:a05:6a20:2447:b0:245:ffe1:560a with SMTP id adf61e73a8af0-2533fab6247mr22677088637.22.1757503800180;
        Wed, 10 Sep 2025 04:30:00 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662920b1sm4964965b3a.52.2025.09.10.04.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 04:29:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: hch@infradead.org, colyli@kernel.org, hare@suse.de, dlemoal@kernel.org, 
 tieren@fnnas.com, bvanassche@acm.org, tj@kernel.org, josef@toxicpanda.com, 
 song@kernel.org, satyat@google.com, ebiggers@google.com, kmo@daterainc.com, 
 neil@brown.name, akpm@linux-foundation.org, 
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-raid@vger.kernel.org, yukuai3@huawei.com, 
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
In-Reply-To: <20250910063056.4159857-1-yukuai1@huaweicloud.com>
References: <20250910063056.4159857-1-yukuai1@huaweicloud.com>
Subject: Re: [PATCH v2 for-6.18/block 00/16] block: fix ordering of
 recursive split IO
Message-Id: <175750379870.204398.16969834521074103761.b4-ty@kernel.dk>
Date: Wed, 10 Sep 2025 05:29:58 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 10 Sep 2025 14:30:40 +0800, Yu Kuai wrote:
> Changes from v1:
>  - fix compile failure if CONFIG_BLOCK_CGROUP is disabled in patch 2;
>  - change the words:
>    fix disordered split IO -> fix ordering of split IO
>  - add review tag from Bart and Christoph
> Changes from RFC v3:
>  - initialize bio->issue_time_ns in blk_mq_submit_bio, patch 2;
>  - set/clear new queue_flag when iolatency is enabled/disabled, patch 3;
>  - fix compile problem for md-linear, patch 12;
>  - make should_fail_bio() non-static, and open code new helper, patch 14;
>  - remove the checking for zoned disk, patch 15;
> Changes from RFC v2:
>  - add patch 1,2 to cleanup bio_issue;
>  - add patch 3,4 to fix missing processing for split bio first;
>  - bypass zoned device in patch 14;
> Changes from RFC:
>  - export a new helper bio_submit_split_bioset() instead of
> export bio_submit_split() directly;
>  - don't set no merge flag in the new helper;
>  - add patch 7 and patch 10;
>  - add patch 8 to skip bio checks for resubmitting split bio;
> 
> [...]

Applied, thanks!

[01/16] block: cleanup bio_issue
        commit: 1733e88874838ddebf7774440c285700865e6b08
[02/16] block: initialize bio issue time in blk_mq_submit_bio()
        commit: 1f963bdd6420b6080bcfd0ee84a75c96f35545a6
[03/16] blk-mq: add QUEUE_FLAG_BIO_ISSUE_TIME
        commit: ea3d1f104db60f9d5074b33819ccea3c216e0bee
[04/16] md: fix mssing blktrace bio split events
        commit: 22f166218f7313e8fe2d19213b5f4b3265f8c39e
[05/16] blk-crypto: fix missing blktrace bio split events
        commit: 06d712d297649f48ebf1381d19bd24e942813b37
[06/16] block: factor out a helper bio_submit_split_bioset()
        commit: e37b5596a19be9a150cb194ec32e78f295a3574b
[07/16] md/raid0: convert raid0_handle_discard() to use bio_submit_split_bioset()
        commit: 5b38ee5a4a12cfdefd848f7ec09da3e9007ad55f
[08/16] md/raid1: convert to use bio_submit_split_bioset()
        commit: a6fcc160d6fd9b4ddd229e351518daee21eecad7
[09/16] md/raid10: add a new r10bio flag R10BIO_Returned
        commit: deeeab3028afebf2f13428f69dcba9f572f0463b
[10/16] md/raid10: convert read/write to use bio_submit_split_bioset()
        commit: 6fc07785d9b89255bba45fc84475bb32f9737a90
[11/16] md/raid5: convert to use bio_submit_split_bioset()
        commit: 9e8a5b37c9ea3ae9db9028ea756ececf221d9a5a
[12/16] md/md-linear: convert to use bio_submit_split_bioset()
        commit: 6529d41d87827f9a27f6c0c6d34c2b77b250b6c6
[13/16] blk-crypto: convert to use bio_submit_split_bioset()
        commit: e3290419d9be6cbd7a42c0691504dd66825cabf5
[14/16] block: skip unnecessary checks for split bio
        commit: 0b64682e78f7a53ea863e368b1aa66f05767858d
[15/16] block: fix ordering of recursive split IO
        commit: b2f5974079d82a4761f002e80601064d4e39a81f
[16/16] md/raid0: convert raid0_make_request() to use bio_submit_split_bioset()
        commit: e0ed2bca7bef9267da0928a8ed6d1de41f19ecf6

Best regards,
-- 
Jens Axboe



