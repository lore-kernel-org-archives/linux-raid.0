Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F64A156F57
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526705; cv=none; b=JEFE/rcNkQByCahFIYeDsCcnO+iVrcj2sxSxSZLc54wu4blr4DjOiqBqTqijpi5mMkp6CBPdmINyajueSV8CeNY48jz0Hro4mJb7SpVpUN6fRlqhiWDdAIYxPDOhApqQHUc82BLxcur1NXjuPKXZd07dkwGi8loiyQlF9YHPQgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526705; c=relaxed/simple;
	bh=FwTA6yxSsatnVeutBJnBWXvyJRwIcD1u2vlSVuxl5Jc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J6kUyObtiHKpRNdLoIxVsmYi/rarC1PJeyRayCmFqa98m5uTQep+3BMEzVI+uyY9dZ9gecywJoFemk6ke87HpWJoWe5fWX5b+ELyifRlB0qVKoYU3iUuTi6hRX1ySHyutCpTcO5meOTQDIUXfgXD+AK5E2vuqOJ6YFmHv32OmqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eell7pss; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eell7pss"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52caebc6137so3576128e87.0
        for <linux-raid@vger.kernel.org>; Tue, 09 Jul 2024 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720526701; x=1721131501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+C71aHaf1aAQjkVXk1oy5ZZg7tWIUxbuw7i++PEBSc=;
        b=eell7pssEGR2urKTArAzID8Z0aWhX5ydJK8QjcFSxsFUXewapBaBRz78fqz3ppHOnG
         G80pH/ywFsOg8XEMQsYBh7tsLcIYJYDev+bOHJ8U29AH2+Hg+vQlusZQ4JoIDh+NBR+I
         PXBwSZwk/kP1NnB/UvPe1CdiH6Pqp1Ky8zbXi16pJfHRP+ZcL2i+3gseGkh7lJD4nREM
         z+CLMrnrGRDQssuyAFVYw8ktyEX9dGNn6zKJrK5M31/WsLdH1RrM5h8FhNZiEjwYdqy+
         zTdAguvJhVdTxLZJmQRyaFFupTbqKjKzH1LyDbM8m/Ja6XG+ei4mSx7ZDa9MCSKR0KK+
         ZsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720526701; x=1721131501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+C71aHaf1aAQjkVXk1oy5ZZg7tWIUxbuw7i++PEBSc=;
        b=ESKLE9mmiNv+w9jQPcA9yfvsQFX9gp158rJRxjHujQkixkMr8/RboWLcJg+2f6Qj8c
         c+9/pgskoToqef9EV3anI/yk1YJX2TRpLtgL0eleGYsPu2VJziCyUboXrQOQ3O+D9y8j
         KXK1JTt5I8m3VGavLo3Utl7zmje3zzREEyWzp5fMndJfJ1ei3lGLVkC0BpZvz8g0F8Tn
         KdTUcG5qCYlqM/9cXiXsJ00IrCVq5XlUOXFazJOd9UXoY83CGanoZ867jdszSbp9q/Uo
         DUD6rpBkH+ERTcb03v5GPCRL+bVkCIQ3fqsJu4Jh1wtB+DfgnirH7IOGrtXAIUTh2X3M
         QHeA==
X-Forwarded-Encrypted: i=1; AJvYcCX5ytJ+FWhjwx7aCaPPQJk8A19EdBIYcqGKlqjcTSnrIAZ6BuO21M6zm3XfXVhojY4ZOZ7yCMluchDnFHYArfaEoXlk9pyyXxu4cQ==
X-Gm-Message-State: AOJu0YzmaB2+FDqj1ogxBMBo/iyQWSBTm6cxzLY5qibiXsCEkMUzmgiI
	Q2Cv29OcJtvn1oTf68xHtbeLVTpJq+s0TaU4UrU8iS0kCs4gBd1IhZghm4u/Kpk=
X-Google-Smtp-Source: AGHT+IF4oLb3OPHIUprFGKi67nZAGfJHOW0mKwWIBeM2DwggHc1icFbeZnvd/YtVsgSsrW+XQrU2+g==
X-Received: by 2002:a05:6512:3e28:b0:52e:9b4f:cfdc with SMTP id 2adb3069b0e04-52eb9994387mr1327269e87.26.1720526701429;
        Tue, 09 Jul 2024 05:05:01 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-77d6886f92dsm1072314a12.90.2024.07.09.05.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 05:05:00 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org,
	linux-raid@vger.kernel.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	xni@redhat.com
Subject: [PATCH 2/2] mdadm/clustermd_tests: adjust test cases to support md module changes
Date: Tue,  9 Jul 2024 20:04:52 +0800
Message-Id: <20240709120452.25398-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240709120452.25398-1-heming.zhao@suse.com>
References: <20240709120452.25398-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since kernel commit db5e653d7c9f ("md: delay choosing sync action to
md_start_sync()") delays the start of the sync action, clustermd
array sync/resync jobs can happen on any leg of the array. This
commit adjusts the test cases to follow the new kernel layer behavior.

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

