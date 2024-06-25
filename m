Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E493A25774
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719281442; cv=none; b=dvXrI7KEgA8grm+ikbbn7NG8JUCtVj9534ABeGTJ2n5PAdataq+YVQN8+kN/NaQQfH1tGqFn6mPn6mFehQ5C09mOhQ9wEYhIi6DA4VpDIAKerwo1jqkgbl0MAahkw/skNEozrslrreBQEOGeT28hRL30pBPOKAL45aVOMqSeO00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719281442; c=relaxed/simple;
	bh=fgodG8mK8lJtOMXiwxowTVDCzV0ZsNrEpPjJsByAbxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O8xFLwuG1NiNQR7KCdbgo7pgVV8bX5YUwY08acdlnySRdk3DUxd1Q01QD3JHhS1WYIoe224ghZPc3dsGMIY65E7npWl2RZ6AC/sxsRxgGJEkHgFTFKegZ9XHeVDMrRqWXb25S49hI2O2mr/t0Bk0PyhNufyRDgZuseJ7afvcNAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qoc5KePk; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qoc5KePk"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ebeefb9a6eso56052161fa.1
        for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 19:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719281437; x=1719886237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uicJAUOI+sHcfDomMG6rYTuZ1ocl+zW+edmj8AKPfXE=;
        b=Qoc5KePkCow5QNBCnqx8153LzWeiUO98/KFk31cuBVv03JhnAD/cqpEAzyfUOrvmJs
         JmHQWcP1NtuRC7z//GmXMS9ayeTYlS+ya/H5qc03UD61UO6DqLS/ZBhQdIKN1SjBEiY2
         jeHmHY+1fURUwjqDSvcygMt7ADeF5/4G9M9A69O9hXD9DXBzuDeWL4rFX+/KfWMFzjWg
         PnMHS9lui/8X0mD4rFqERmjI76VDlB+32+LasIjts/8TD6CZv/RioVCVZqTBoUijXcQQ
         dCAJJ1Kc3zGpQ2IKxOroXBHY6Kos5l2eQcZF0JFT7FluTQn5w8rK37Z1l6MRQAaFWE2z
         7f8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719281437; x=1719886237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uicJAUOI+sHcfDomMG6rYTuZ1ocl+zW+edmj8AKPfXE=;
        b=ZHEFu06IJVBeFx32B/hDQtDRR0iYJugn9Z/NtwQwDN4VUPo/QfhOVwrSIzEfjrG+jM
         RFOYZMR//MLc2eWfgNPoN3o7jIb0/a+h+BzjUyRuMpJZHzwZ6kUWqNT+dNNT9k9WEDGU
         VrZ9+yOxR3M+RT1Pjgn2noxRi1FOl8XmeSNM/6iAHMr8UaQ0tY2lVb9UPiFL52EVXS9j
         g//JesFUSgXydm+zAWqiYL1gX+tBpMFtcrVNNUQ6Fq5QW7ZquyWguQ1mKIDNOM7Th0jU
         6cV5bZcqgElXu6dULCv+UOUW2fcuyY5o8LkjRV8j3HBvRtBCxKgOrOP76GU6Q9YGRe7h
         PR9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXO9UoBoBr9UcFiURDAjo9iH78RGwwuEVuL4FoTyHzAIMPpoPkspCU3zKJ2EdgJYV99+zUbN5xXFbZJpbLquf2w2+xBa5YKL/MCTA==
X-Gm-Message-State: AOJu0YyW5CwnP1oCvQPbrN0t4XZ8jDAidoKyv0FgEzsOypakDZ9yuymM
	7wm6VfrWx6Ppl1HDASDBMfAnvwZOcWBzizDiS5UY05mRGLUbEXRdR0N1PSyePvw=
X-Google-Smtp-Source: AGHT+IGAAEWbjCvWlZzEGx5VTy8FXKL0my6uuJzhfztxzY4UnyQq7Kz4jS+kRrHngg3MEKwYqVIQOQ==
X-Received: by 2002:a2e:8e97:0:b0:2ec:1708:4db2 with SMTP id 38308e7fff4ca-2ec59584e72mr32876781fa.47.1719281437054;
        Mon, 24 Jun 2024 19:10:37 -0700 (PDT)
Received: from p15.suse.cz ([114.254.79.228])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065f3b9ed9sm5734427b3a.51.2024.06.24.19.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 19:10:36 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	xni@redhat.com,
	glass.su@suse.com,
	colyli@suse.de,
	yukuai3@huawei.com,
	yangerkun@huawei.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] mdadm/clustermd_tests: adjust test cases to support md module changes
Date: Tue, 25 Jun 2024 10:10:19 +0800
Message-Id: <20240625021019.8732-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240625021019.8732-1-heming.zhao@suse.com>
References: <20240625021019.8732-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[heming: Please note, this commit for test my kernel patch, it's not the
final version.]

Since kernel commit db5e653d7c9f ("md: delay choosing sync action to
md_start_sync()") delays the start of the sync action, clustermd
array sync/resync jobs could happen on any leg of the array. This
commit adjusts test cases to follow the new kernel layer behavior.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 clustermd_tests/02r10_Manage_re-add   | 3 ++-
 clustermd_tests/02r1_Manage_re-add    | 1 +
 clustermd_tests/03r10_switch-recovery | 4 ++--
 clustermd_tests/03r1_switch-recovery  | 4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/clustermd_tests/02r10_Manage_re-add b/clustermd_tests/02r10_Manage_re-add
index 2288a00866bd..d8764667ca83 100644
--- a/clustermd_tests/02r10_Manage_re-add
+++ b/clustermd_tests/02r10_Manage_re-add
@@ -9,7 +9,8 @@ check all state UU
 check all dmesg
 mdadm --manage $md0 --fail $dev0 --remove $dev0
 mdadm --manage $md0 --re-add $dev0
-check $NODE1 recovery
+#non-clustered array also doesn't do sync job
+#check $NODE1 recovery
 check all wait
 check all state UU
 check all dmesg
diff --git a/clustermd_tests/02r1_Manage_re-add b/clustermd_tests/02r1_Manage_re-add
index d0d13e53fc0c..811df87be81e 100644
--- a/clustermd_tests/02r1_Manage_re-add
+++ b/clustermd_tests/02r1_Manage_re-add
@@ -9,6 +9,7 @@ check all state UU
 check all dmesg
 mdadm --manage $md0 --fail $dev0 --remove $dev0
 mdadm --manage $md0 --re-add $dev0
+check all wait
 check all state UU
 check all dmesg
 stop_md all $md0
diff --git a/clustermd_tests/03r10_switch-recovery b/clustermd_tests/03r10_switch-recovery
index 867388d04ad8..7d0b88125f46 100644
--- a/clustermd_tests/03r10_switch-recovery
+++ b/clustermd_tests/03r10_switch-recovery
@@ -10,9 +10,9 @@ check all state UU
 check all dmesg
 mdadm --manage $md0 --fail $dev0
 sleep 0.2
-check $NODE1 recovery
+check $NODE1 recovery-remote
 stop_md $NODE1 $md0
-check $NODE2 recovery
+check $NODE2 recovery-remote
 check $NODE2 wait
 check $NODE2 state UU
 check all dmesg
diff --git a/clustermd_tests/03r1_switch-recovery b/clustermd_tests/03r1_switch-recovery
index a1a7cbe71b66..d8483c458297 100644
--- a/clustermd_tests/03r1_switch-recovery
+++ b/clustermd_tests/03r1_switch-recovery
@@ -10,9 +10,9 @@ check all state UU
 check all dmesg
 mdadm --manage $md0 --fail $dev0
 sleep 0.3
-check $NODE1 recovery
+check $NODE1 recovery-remote
 stop_md $NODE1 $md0
-check $NODE2 recovery
+check $NODE2 recovery-remote
 check $NODE2 wait
 check $NODE2 state UU
 check all dmesg
-- 
2.35.3

