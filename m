Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7814E2E2
	for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 22:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745534184; cv=none; b=gNg4e+JytmsEJsUX7PpzFXe7EyriXzX+fkfSmyU+l4UeLrXLNkXlurdKfgO9allebwphst/4s61x7YUMFNR4sRKUxOhcvyaS2Tn6dG1aBXbB5UVxwmnhfow1yZPA+Q4QSKhxzwzsnUbMEYOy+bEdyVx+Wk9pQa3cGO5PWdvLvGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745534184; c=relaxed/simple;
	bh=nZxtvf7YL3TM6g9sHjPOQE2jLLEnO0Hq2WqCQB9GP/s=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:Cc:
	 In-Reply-To:Content-Type; b=migJt4ypX6mu1vUoF7SCSlSGjYfhbQFeqb6ye3pPiwM6UBsVmXy5Iu5QjzMCs0aJOiKDIV7x3WC2HEZ9aGqGej6Psmc6yU9wEvpNN5RyRCzbtYPusgABE+o/nboTnZ/gjxLIU5L3uOmKCJN0P5fqh1cDDvoyiRRmakp7PMuAxao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kva4crsv; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kva4crsv"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-acacb8743a7so268337466b.1
        for <linux-raid@vger.kernel.org>; Thu, 24 Apr 2025 15:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745534180; x=1746138980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZxtvf7YL3TM6g9sHjPOQE2jLLEnO0Hq2WqCQB9GP/s=;
        b=Kva4crsvW48JStYkCIZKbgayO4FqWVNMHUvShqfdmt9aXxxJ5xO0l5/JFNF2DLFdTh
         B1UH/CY0n80+M6fPgoDYnICs8rpo8yXbeYF5fKVKhdci15oNaNlPwapzmO/YEqKIJLOk
         I+8nwH21j1QhgjcaQQsX+pbKcNCsClDyTfXTtG8COaDhS0Nq9Dr5ROJFQZEqjC7lAP+K
         mS/iV84WNWAME6qgL6/Rk0rhEJv3lVU2FbSQ1pxrKVSMaRFVTh3OlTr4A0H6S/9x29GL
         cx7qc6V3PC5Q28qI5jfyfGtNeJcE3l4Gte5pMOH5mqqIvm75biEh6jbwVfvw82qv5eek
         GKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745534180; x=1746138980;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZxtvf7YL3TM6g9sHjPOQE2jLLEnO0Hq2WqCQB9GP/s=;
        b=LV6/CaJvUDyWwbpEyxOhLaZ6DaZCKb2WhIpzKEPE6XD/5xOJ52M83YnnA8TsEZDN42
         9ZsG4AqpLGVaQmvGRbLZ582dim6sTm9j5tFEj93zN2Uiihajzp/0ZXdpQRADK7zmjE/z
         4PO8921bn5nXzKM7I2sw7hKl2wGK30Ly/ISnS2gupIJeYg07IYC9qk8fRnlhXgtpLpbv
         BLOj7I3J66NTW4U9qeeTq9Ba2W70k3hbaP1uFIDyJVAZhVuC/YLXTnaGqm8DaiS1ceaM
         IlGSBpTF5Y7CF3flnadsOqDf/0CoolMYrem8HmTjX9pn72pW4D4BZvMdQXDvHq1Yr0n3
         Zq4A==
X-Gm-Message-State: AOJu0Yw+Z20toVu+Im5C7sfYwzi4bdFhaR0uiZlao5Uj11XhXdkzfZfU
	OzDuzk6M2FBC2+mdpTptBtenRjLKR5RQFJrM33CTsOyeXnQdSVWpZuDqFA==
X-Gm-Gg: ASbGncsunMEfQDrWZWqS7tQ+V1w/Oms1ztHlyy5+ByYpxo8ubh5q/smdFIK1/5pXKXf
	coS2oF9ee05eaRkn6mbeOL7STlLABjac8hbd0h01rMBSa/i+lZXh3J3b+m7mZs3EhhwO54ydYE6
	uZG78CiEwKj8W3LotJmi2aKxocIsMOY86qjQ08/NHXQK1aSpB4tH6RjQKNK1KpRSw0iiObE0bEd
	ihWYuNPxmNcUp4q4ODzL33fVCjjYChNsuSHLkrX7coGcWM/+ynBSfnSSoVV2PdoFUcNVSD/Ip0f
	cZVNvcMAouS3gpHjhLotkAhjuResjvpdN3Jn7HPf9BJiIJo9Qv5ZQcx83zvw7qQyBGCzy3oi9MX
	Tfoxs9Q6XuqdxpM67j8ZDb3y2uWyf5n9lFqsQTdLIqNvBctzz7ncYZw==
X-Google-Smtp-Source: AGHT+IGdyzij3lBU/rBoSOubZwosvrndGSswab7aCp+9G2cDF0AmY3BsVeZur4xl3dDSRP1wfFcDXQ==
X-Received: by 2002:a17:907:6d0c:b0:ac7:3028:6d67 with SMTP id a640c23a62f3a-ace5a2e0f9amr410868966b.16.1745534179997;
        Thu, 24 Apr 2025 15:36:19 -0700 (PDT)
Received: from [10.13.37.142] (dslb-088-065-113-200.088.065.pools.vodafone-ip.de. [88.65.113.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed49c2fsm27850666b.124.2025.04.24.15.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Apr 2025 15:36:19 -0700 (PDT)
From: Philipp Steinhardt <steinhardt.philipp@gmail.com>
X-Google-Original-From: Philipp Steinhardt <steinhardt.philipp+vger@gmail.com>
Message-ID: <3458af1f-a7ae-4b9c-8629-a06a113b3f0d@gmail.com>
Date: Fri, 25 Apr 2025 00:36:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: raid5-cache / log / journal hung task during log replay
To: linux-raid@vger.kernel.org
References: <0aef13fe-0356-4803-9f44-182c327d2dbf@gmail.com>
Content-Language: en-US
Cc: Song Liu <song@kernel.org>
In-Reply-To: <0aef13fe-0356-4803-9f44-182c327d2dbf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
> May be able to test on 6.14.2 on snapshots of the disks tomorrow

same issue on 6.15.0-rc3, debug log attached below.

The culprit seems to be the call to raid5_recovery_alloc_stripe with noblock set to 0 in r5c_recovery_analyze_meta_block (raid5-cache.c:2155) right after the stripe cache size is raised to 32768. The call to raid5_get_active_stripe unsuccessfully tries to get a free stripe and spawns the reclaim thread and waits for the R5_INACTIVE_BLOCKED flag to be removed (which never happens).

With my limited debugging skills it seems like the reclaim thread never does anything in r5l_do_reclaim, because reclaim_target == reclaimable == 0.

My attempts to reproduce this without including the member devices (by zero mapping anything but the superblocks) were not successful in triggering the same issue. The relevant part of the journal device is ~12GiB, so uploading the journal is possible. Including (the relevant) parts of the raid members may be more difficult.

@Song Liu
Sorry for the unsolicited CC, but you seem to be the only main contributor to the raid5-log, that is still frequently active. If there is a better place to issue bug reports like these, please let me know.


Linux ubuntu-raid6-recovery 6.15.0-rc3mainline #5 SMP PREEMPT_DYNAMIC Mon Apr 21 18:00:22 CEST 2025 x86_64 x86_64 x86_64 GNU/Linux
md: md127 stopped.
raid456: run(md127) called.
md/raid:md127: device sdf operational as raid disk 0
md/raid:md127: device sdj operational as raid disk 9
md/raid:md127: device sdi operational as raid disk 8
md/raid:md127: device sdg operational as raid disk 7
md/raid:md127: device sdb operational as raid disk 6
md/raid:md127: device sdd operational as raid disk 5
md/raid:md127: device sdk operational as raid disk 4
md/raid:md127: device sde operational as raid disk 3
md/raid:md127: device sda operational as raid disk 2
md/raid:md127: device sdc operational as raid disk 1
md/raid:md127: allocated 10636kB
md/raid:md127: raid level 6 active with 10 out of 10 devices, algorithm 2
RAID conf printout:
 --- level:6 rd:10 wd:10
 disk 0, o:1, dev:sdf
 disk 1, o:1, dev:sdc
 disk 2, o:1, dev:sda
 disk 3, o:1, dev:sde
 disk 4, o:1, dev:sdk
 disk 5, o:1, dev:sdd
 disk 6, o:1, dev:sdb
 disk 7, o:1, dev:sdg
 disk 8, o:1, dev:sdi
 disk 9, o:1, dev:sdj
md/raid:md127: using device sdh as journal
get_stripe, sector 7183404032
__find_stripe, sector 7183404032
__stripe 7183404032 not in cache
remove_hash(), stripe 0
init_stripe called, stripe 7183404032
insert_hash(), stripe 7183404032
get_stripe, sector 7183404040
__find_stripe, sector 7183404040
__stripe 7183404040 not in cache
remove_hash(), stripe 0
init_stripe called, stripe 7183404040
insert_hash(), stripe 7183404040
get_stripe, sector 7183404048
__find_stripe, sector 7183404048
__stripe 7183404048 not in cache
remove_hash(), stripe 0

[..]

__find_stripe, sector 7200159744
__stripe 7200159744 not in cache
get_stripe, sector 7200159744
__find_stripe, sector 7200159744
__stripe 7200159744 not in cache
md/raid:md127: Increasing stripe cache size to 512 to recovery data on journal.
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
get_stripe, sector 7200159744
__find_stripe, sector 7200159744
__stripe 7200159744 not in cache
remove_hash(), stripe 0
init_stripe called, stripe 7200159744
insert_hash(), stripe 7200159744
get_stripe, sector 7200159752
__find_stripe, sector 7200159752
__stripe 7200159752 not in cache
remove_hash(), stripe 0
init_stripe called, stripe 7200159752
insert_hash(), stripe 7200159752
get_stripe, sector 7200159760
__find_stripe, sector 7200159760
__stripe 7200159760 not in cache
get_stripe, sector 7200159760
__find_stripe, sector 7200159760
__stripe 7200159760 not in cache
md/raid:md127: Increasing stripe cache size to 1024 to recovery data on journal.
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive
+++ raid5d active
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
__get_priority_stripe: handle: empty hold: empty full_writes: 0 bypass_count: 0
0 stripes handled
--- raid5d inactive

[..]

get_stripe, sector 7200204176
__find_stripe, sector 7200204176
__stripe 7200204176 not in cache
remove_hash(), stripe 7199919696
init_stripe called, stripe 7200204176
insert_hash(), stripe 7200204176
get_stripe, sector 7200204184
__find_stripe, sector 7200204184
__stripe 7200204184 not in cache
remove_hash(), stripe 7199919704
init_stripe called, stripe 7200204184
insert_hash(), stripe 7200204184
get_stripe, sector 7200204192
__find_stripe, sector 7200204192
__stripe 7200204192 not in cache
get_stripe, sector 7200204192
__find_stripe, sector 7200204192
__stripe 7200204192 not in cache
md/raid:md127: Increasing stripe cache size to 32768 to recovery data on journal.
get_stripe, sector 7200204192
__find_stripe, sector 7200204192
__stripe 7200204192 not in cache

