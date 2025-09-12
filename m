Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFE83128C8
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 15:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691239; cv=none; b=MIG0hbYC8pyQeYcgco2jAjgusnQNKe5ygF30mTqwaCCYN7h1ukgTpfAPBvP6C4jV5Qayv5L0jlyG6yO/CoT2HB0ovJoAL1r/9W4J/MNN4Hek7NItcUaMuvnoJAZ8SEeg0n2Qg03EISSH0J/9SFDCQ6o4vS3BJ8/SosbR3ggyNEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691239; c=relaxed/simple;
	bh=QDLA8OMstBYw+AiXemliXwursskJz87Z8D3d8TaFpMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tRLncOjm9zlMy5OfS/vJRkwTmGv5kGgI3IS7KYOsUvHoZgoKJKi370OguSN+eeJxAotp8d3IFLrTKcQ4AmjSn/0bBRyGU3+Dsgf+1aMn72+IMRxuqd/LxA4Hir246aU/V3UjUmx04WW53MbTJjMwBk/fFpnSj49IBCG/4LmuAZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vezu4EYf; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vezu4EYf"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3e07ffffb87so1178097f8f.2
        for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 08:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757691236; x=1758296036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VI85/yuaJt1vCUZPq4BH2F+uzuPWqog1MSS1Sn49jOg=;
        b=Vezu4EYfuCI1AALV7i3GnfadYM9g3aPutngNYUO7KtQuGZDjihDw0y64xu1Yjsoxbd
         O0ntocOPR43TGz1q5B06198uSssMdxTULXfvLafveLLenvEd6J10wp2b2ubnequkVgWz
         wPnD1t8tuN0CmPV5d3tU3L9dx5FyHozHeCz0Gm4LXiUIcaTMKCTxwfmW9DMI6isiHO2e
         GPcYdVSlFUE4BLabGr18u5uOfmy7F/Cx3AzjVPpz2VBPzr7xwmPnErdVUrperLed0xJF
         ZrNKsu25TRnH1AJAW2q+Yeyun7JTvnMuxkdSSootSDAX+Wb/GhVr8Up5dW5LOBU4KqUp
         8wKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691236; x=1758296036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VI85/yuaJt1vCUZPq4BH2F+uzuPWqog1MSS1Sn49jOg=;
        b=ukd5snweypvR46lROPs6/GzX7WQslIE+sIx8uDg47B/bjAxASBgHV9wd9nhyoBJBf2
         M8EGrRLqf2C5jNfni4EijnGwdWrCsyQrkIPBuqE1gCtmdFr/BgeG+Xfx4E9kQ4F69ndW
         kK5RlQ3r5SPESrJ6Hgmg+mvDBhvWt+oG8MbiPUnlrluKfwJT2CybsNfTDne+FU6lY5kl
         JgUXmWVRnKQojjxFFvLYEWau+0AgQxO5Dxnp4d9CXTaWFl4EDuMZhTW2J3EAzQt2ChW4
         U/1QLvf3hL3kFsh0Bp9938vJKV88bmemK/S/3lpPIzn7T9OZx/j1ExSROB1IOMTATxxz
         2iTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfsy3h4Kuz7yUIf9S6w9abkIg4weniEiGHD/tKd/xws3SOQOXV6dGNtBJKR3Z7FZzdkVAgOMnsg6Eg@vger.kernel.org
X-Gm-Message-State: AOJu0YxxviY0uIiG8By0F37UzNwFRkwly3Xl+DxEm+55C6zX1R2JPfTQ
	Z1JrqlMU4epu1OVZAWWbrTRUrwo4Dg/oAh4brUHPQ5zivjmc67qHxTzXD1EH+eWkVd8=
X-Gm-Gg: ASbGncvLrYNF1mdNFc2KjaUW1TJLc0l+T9vPh7nztW3hZBUkeMhxaD9CBiEZ7cb2Blr
	G6FbNNeR5EKi2forddVefWpj69w3GzXqUGSzp6NzV7F3DhpAqsQOXngM55bREN4L9Jzo57OVPiF
	WCRPUXpIruv29f7Aj1JfAtEyR/5YVP3sZww7wIkujP0GiuT/9NIPscaHEY8eb5v72nnYgcO7A8E
	sabyKJA6BI8AGnKRM+qGDwS3glXlX4BsA4w0iYX49hBVgDzX8x9G8Y5gpgkHEhV72fdop0EFMde
	0S7WCQT4voHLG0SXQTopHn5guVArIn/TLat7rkk38Y7b4pRYI5s/L+vyHy9CDNoDLfiCgll27Ms
	/fS3279ICzGoc1pCnBGbidW07vIzDNjCe1tVqyHW8FpT4QHkxty0+8wiVzsyi3M2gkNBF7FhjrO
	Jgv9/1XA/lBkRHeSYqLFke5w==
X-Google-Smtp-Source: AGHT+IGC0MSiDmuMoMlweE8xIhEn4qMUCCxu6JYh0pzo64IpObWkhOLR7KdMOEmc6D2xp8BZ9x7hlw==
X-Received: by 2002:a05:6000:238a:b0:3d4:f7ae:bebb with SMTP id ffacd0b85a97d-3e7658c0f60mr3592361f8f.26.1757691235691;
        Fri, 12 Sep 2025 08:33:55 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45e032a0522sm65900785e9.0.2025.09.12.08.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:33:55 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>,
	Li Nan <linan122@huawei.com>
Subject: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
Date: Fri, 12 Sep 2025 17:33:48 +0200
Message-ID: <20250912153352.66999-1-mwilck@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This Patch set changes the logic of the "mdcheck" tool and the related systemd
services mdcheck_start.service and mdcheck_continue.service.
The set and related discussion are also posted as GitHub PR [1].

The set is meant to be applied on top of PR#189 [2], which has already been
merged in the current main branch on GitHub.

[1] https://github.com/md-raid-utilities/mdadm/pull/190
[2] https://github.com/md-raid-utilities/mdadm/pull/189

The current behavior is like this:

* mdcheck without arguments starts a RAID check on all arrays on the system,
  starting at position 0. This is started from mdcheck_start.service,
  started by a systemd timer once a month.
* mdcheck --continue looks for files /var/lib/mdcheck/MD_UUID_$UUID, reads the
  start position from them, and starts a check from that position on the array
  with the respective UUID. This is started from a systemd timer every night.

In either case, mdcheck won't do anything if the kernel is already running a
sync_action on a given array. The check runs for a given period of time
(default 6h) and saves the last position in the MD_UUID file, to be taken up
when mdcheck --continue is called next time. When the entire array has been
checked, the MD_UUID_ file is deleted. When all checks are finished,
mdcheck_continue.timer is stopped, to be restarted when mdcheck_start.timer
expires next time.

Before the recent commit 8aa4ea9 ("systemd: start mdcheck_continue.timer
before mdcheck_start.timer"), this could lead to a race condition when the
check for a given array didn't complete throughout the month.
mdcheck_start.service would start and reset the check position to 0
before mdcheck_continue.service could pick up at the last saved
position. Commit 8aa4ea9 works around this by starting
mdcheck_continue.service a few minutes before mdcheck_start.timer.

Yet the general problem still exists: both services trigger checks on the
kernel's part which they can only passively monitor. So if a user plays with
the timer settings (which he is in his rights to do), another similar race
might happen.

This patch set changes the behavior as follows:

Only mdcheck_continue.service actually starts and stops kernel-based sync
actions. This service will continue at the saved start position if an MD_UUID*
file exists, or start a new check at position 0 otherwise. Starting at 0 can
be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID. These files
will be created by mdcheck when it finishes checking a given array. Thus
future invocations of mdcheck_continue.service will not restart the check on
this array.

mdcheck_start.service runs mdcheck --restart, which simply removes all
Checked_* markers from /var/lib/mdcheck, so that the next invocation of
mdcheck_continue.service will start new checks on all arrays which don't have
already running checks.

The general behavior of the systemd timers and services is like before, but
the mentioned race condition is avoided, even if the user modifies the timer
settings arbitrarily.

This set slightly changes the behavior of the mdcheck script. Without
--continue, it will still start checks on all array, but unlike before it will
skip arrays for with a Checked_ marker exists. To avoid that, run mdcheck
--restart before mdcheck.

More details in the commit description of the patch "mdcheck: simplify start /
continue logic and add "--restart" logic".

Martin Wilck (4):
  mdcheck: loop over sync_action files in sysfs
  mdcheck: replace deprecated "$[cnt+1]" syntax
  mdcheck: simplify start / continue logic and add "--restart" logic
  mdcheck: log to stderr from systemd units

 misc/mdcheck                     | 105 ++++++++++++++++++++-----------
 systemd/mdcheck_continue.service |   6 +-
 systemd/mdcheck_start.service    |   3 +-
 systemd/mdcheck_start.timer      |   2 +-
 4 files changed, 75 insertions(+), 41 deletions(-)

-- 
2.51.0

