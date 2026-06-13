Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFD2C3768
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781375298; cv=none; b=jS7E/t0/hFMAucFFErsrtHLJto1PbEIA3gShL7Lok093yaahGT2UZ7xust+YT8krZznN5OIy0lNAKulqE3YlWsG3xtCSsbHfiQNvonxYIKNUkIZ5cpuc5Fi6jyYdRyou2xk1tZjiIvvAt5jlrxVnKBf+iqIWtnwvanWmoYsgKxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781375298; c=relaxed/simple;
	bh=Q0GYeJmRUoKFB+N+RJ/NIHvd2+jMAzoEgLLBDCsydw8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qweFKClCCc8WXTcz+BOeZXCgBQiHZhVCvlFZY3fLm7TbF3DmndutBfv69tj1CdzeQ3OALg4XlJnWO6J4mfDqp1EWzaH+0qB+EUSLBPrbZ3ltz2VvvON/Qta7X1sTAFgXaEy24zgV8LerPDKfrGz7tliv8olrCJnvxhaP9+P0w84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdLgH0Ah; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdLgH0Ah"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45eeba68948so1479354f8f.1
        for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 11:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781375295; x=1781980095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O47NaPG6T229/D4oVnpkjOWn8TTRgLZzLm6av79AdGE=;
        b=hdLgH0AhdvPBj53HFAddgQzSkJo81Qk0C5D3EXz0HH5YwEULrhOK9sca89biqWE6ya
         6h45kwZYH9lzWUPMC/IyLRLJ+AhXvWJKwkBhxZC+8fF9ybynFaRM/Puvq3rG0UgI74GS
         SnCGnXgx9YxxeCV5N3m9DSvjNgfsmLplvZaoqusyfAJHeQgBBSwsrPlFCsMOMnJW1cab
         YX5x5tqthAMkZOE2sN6xo7N6luLVAaDxS5SzhIeD+6e6lVJugRHq7WdYvq/PAqdgMU4i
         4pDHhjCoDQ3Gfjxg/Tq0YNsNqSuBZ0wVJm3Jvw58kN2XkgxSoNZH9iD5ByKr2BZwGN9r
         vKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781375295; x=1781980095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O47NaPG6T229/D4oVnpkjOWn8TTRgLZzLm6av79AdGE=;
        b=o6RpfEgMPQBVc6ZBwHgB4Kd8wEFA+uEN1hocS0mXZxURv8orPq9VzTQvSJv4h3LSyK
         LU4GAmjYbLrEoRUs+jq40e+4VFwBUtBL9uwb9fm8LehpXaUz0nETgliDf/w6m2H9zRo5
         NfoZk/OpeJNWMeLkRcD+SHRoEoIbNTJ/MnFPnvJTWDOW+PXbeIQsyBoPHEiMI3r25L9v
         mimfDfCjv82Y78id9xL30wFrcpDPbHL1UsQU7FDlNjyU2rOnM4JBrcBLDYZvCwb0ztXH
         sxQ5k5mrDdM27uTnE/lEcY74EN20Wvq+U3zYQ+buH4jwYj0gprc2Uuge2ciA9dYoyol2
         YSyw==
X-Gm-Message-State: AOJu0Yz+s8YhOg9kcvXm9h/XOvDpi4hwBqfT5E5e7sUPBaUYJCy8gQz+
	YpnYBUynFCzpwAEliv0B93LUPG8Qpos64cy+6E+5BQ46+hYgPFKP6ha1
X-Gm-Gg: Acq92OHAVYnhabpK1xmdJ3z0O5KhNiQRZGcfGnSlqQ+mhdgdnVGpk6vjqmFycYWxwZs
	SxOvNI0ODSpqSE5Gz40rmtM3ZTeHNplK1YnnzyS058AnohLSciM8Alrp4D9fr2GPTW0Y0QB+YY6
	j27ab98ho+XsWggdCzqQZtS494blb40pyQB8ZAleG0WMX/RaG522u6t9mqfSOJ9V62de9SHV/TW
	jtHAMfb217dZi51lIvvZafh6VslBHMF6El0LJVhsGqn0H+KxplHg/R97qZ65cn/3V3nZPGb1VH0
	nfhjnm+QteurJHe9oYsvBZ2tN/bN9omjep1FkPz/rdRPwSwYaDrz6uPKXLDW1oNlb++fWUgEY8B
	43DmQWOEN8wZH4Mv6f4QKa0htEvtiFCx+2zb1AoEHKkuKC9epWtyroHTs6agHS0cljkM75Zt49/
	qVzMUS8wYBAgevoaudDrZY1Hxs3NxuOsLqkWmVXmilKT57dNefQX2SbRJP4NddPGnxTvRkRujqA
	Sz+q7F6JO2EDg==
X-Received: by 2002:a05:6000:41d9:b0:45e:f381:cd8a with SMTP id ffacd0b85a97d-4606da695a3mr10455274f8f.2.1781375294808;
        Sat, 13 Jun 2026 11:28:14 -0700 (PDT)
Received: from yocto.. (dynamic-176-007-197-181.176.7.pool.telefonica.de. [176.7.197.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c3782sm15353944f8f.25.2026.06.13.11.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 11:28:14 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	axboe@kernel.dk,
	hare@suse.de,
	john.g.garry@oracle.com,
	martin.petersen@oracle.com,
	vverma@digitalocean.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 0/4] md/raid1,raid10: fix write-path reference leaks and clean up error handling
Date: Sat, 13 Jun 2026 18:28:06 +0000
Message-ID: <20260613182810.1317258-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series fixes several write-path failure handling issues in raid1 and
raid10 and then follows up with a cleanup of raid1_write_request().

The first two patches fix writes_pending leaks caused by failure paths
that complete bios without reaching the normal write completion path.
The raid1 fix also addresses a barrier reference leak when
wait_blocked_rdev() fails after wait_barrier() succeeds.

The third patch fixes additional writes_pending and barrier reference
leaks in raid10 discard handling.

The final patch simplifies raid1_write_request() error handling.

Patches:
md/raid1: fix writes_pending and barrier reference leaks on write failures
md/raid10: fix writes_pending leak on write request failures
md/raid10: fix writes_pending and barrier reference leaks on discard failures
md/raid1: simplify raid1_write_request() error handling

Changes in v2:
 - fix writes_pending leaks in addition to the barrier reference leaks
 - add raid10 fixes for analogous write and discard failure paths
 - add a follow-up cleanup patch to simplify raid1_write_request()
 - simplifies raid1_write_request() error handling.
 - Link v1: https://lore.kernel.org/linux-raid/20260611132500.763528-1-abd.masalkhi@gmail.com/

Thanks,
Abd-Alrhman

Abd-Alrhman Masalkhi (4):
  md/raid1: fix writes_pending and barrier reference leaks on write
    failures
  md/raid10: fix writes_pending leak on write request failures
  md/raid10: fix writes_pending and barrier reference leaks on discard
    failures
  md/raid1: simplify raid1_write_request() error handling

 drivers/md/raid1.c  | 74 ++++++++++++++++++++++++---------------------
 drivers/md/raid10.c | 28 ++++++++++++-----
 2 files changed, 60 insertions(+), 42 deletions(-)

-- 
2.43.0

