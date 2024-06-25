Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5DC25774
	for <linux-raid@vger.kernel.org>; Tue, 25 Jun 2024 02:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719281437; cv=none; b=C7ehm+yjkHHghZNkais/5CGjYjwnzNWFodDLu3MkXPp8cl0+H3PR94mjUtENqgF57z7MhQlBPUwAeitLI8faGJ2HUVs8Y0/O6KsJ0UqwqUICr7sgF/d0SkkBNFl2ROd95/Xb1AhonnCERn05EUOKhiJBtz7nfaksVL6cDM2MZLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719281437; c=relaxed/simple;
	bh=mlOxFEJxAl4FsomEDaQpix9s7SPQl2q5GfiuEhv51kw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dl9nbSnYA4h8gLcAZtLrCohdrIZ0t9QRFEVP69L/VU8Ig5jed1X7TfhFKO3FrMRos7wTyp345dxxXaOEqLb6msR8CL7QSiEG4kJ6TcNkqzbJvgXL3XNRW+2rLpMldlUCgksQIznS4LB7F1FjnYpco+IC072kCQ646Qspn57EPO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g6PaCVCf; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g6PaCVCf"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ebe0a81dc8so64189591fa.2
        for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 19:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719281432; x=1719886232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nuFPlYSpJPUTEu+46vNGgZybtBgC2zeOXL1FYDySXGw=;
        b=g6PaCVCfKpkXDVdQI5r9a1c4dPrDEu1vsK/nlyPWOzyjap0lq+NkIuFcqyELMU+HZh
         hmJCyZBNnOU22qiE5b0xuycKfAvnhxP51RsBa7mtKva2EZ0tA24tMjLN4tJik1f0hLhd
         49en+//aSY9++jw+apQZkpTnS7Ar7anSJl6N4hlsKfTuMbLVChQiPBKLoMRDob72H+L+
         yeDOwQ/5oe+LyK3Hkazm3jm94E8O3jy9u6j+7LSSXos3JV1TWYuUKU8iKV07jMxJqPXj
         eBjp7RWTjPDDiqa3U9DbqkKywDsjDKPvJY2aO2KPzPrdiW6jKtmDs7K58f70rTRKOkZ3
         N20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719281432; x=1719886232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuFPlYSpJPUTEu+46vNGgZybtBgC2zeOXL1FYDySXGw=;
        b=NXtt3NViaRDnYd6MYf2vyaU6UuQTbgGRNFX+JDAlNsB10aOM25ljlU1aS1ygQyXhTK
         Eeb+7ZxP47RZ4F9CAyhH4d2K/kpkLK3tpYN4wInyD+atKaH45FS/E+BWmN59ABTZcdS+
         PsOgAmmGCKwx/n2l0ZlQuznD2g5PvA0U8Twv7NZmDkvo3QBEBogf69f1NGmhln8ap83+
         KFQZc76OgLAkvL0DOglRqObYbcsmKKbdftUu8MLOq6cDkD9wGZUAQ+C3XwgvIarmDPJY
         mXJqPsTlxK3ey3ldr5xSRF8fdrp3JKrJ1ICeMGn1ADxQJp/O0vMx2o6vdd7aAnEbRmAK
         DKLw==
X-Forwarded-Encrypted: i=1; AJvYcCW4C9ROjBhHrJ6R+K7m8Olaj4aszcg0cFLUSJjTYqoiW+9HB7Ou/0xwR/DV5UakNnhOWLj7FQCYkvosLP+xcWYVgqyhCvtZenRSeA==
X-Gm-Message-State: AOJu0YwnriuVlISEOKjh8QnY7X5My9bi5O7pC5DoY80dRL0nYeM6iDOA
	HGVAKQOTWKQkTIvgb76Z9clfTo/K2FwUTnMzghrKPeRr9ESBtmV9M29lc7iTvvg=
X-Google-Smtp-Source: AGHT+IFpk+HFTkf/4qiyDG/CUtrAieLCGqVvvSftZjSiAqJM84xzPmXb46LfJtUspG8ueVJyKAMysw==
X-Received: by 2002:a2e:9596:0:b0:2ec:55b5:ed50 with SMTP id 38308e7fff4ca-2ec5b2fd2d0mr44592741fa.5.1719281432052;
        Mon, 24 Jun 2024 19:10:32 -0700 (PDT)
Received: from p15.suse.cz ([114.254.79.228])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7065f3b9ed9sm5734427b3a.51.2024.06.24.19.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 19:10:31 -0700 (PDT)
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
Subject: [PATCH 1/2] mdadm/clustermd_tests: add some apis in func.sh to support test to run without error
Date: Tue, 25 Jun 2024 10:10:18 +0800
Message-Id: <20240625021019.8732-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[heming: Please note, this commit for test my kernel patch, it's not the
final version.]

clustermd_tests/func.sh lacks some apis to run, this patch make
clustermd_tests could to run from test

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 clustermd_tests/func.sh | 58 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 801d6043de61..0e26b43fb84b 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -1,5 +1,22 @@
 #!/bin/bash
 
+COLOR_FAIL='\033[0;31m' #RED
+COLOR_WARN='\033[1;33m' #YELLOW
+COLOR_SUCCESS='\033[0;32m' #GREEN
+COLOR_NONE='\033[0m'
+
+fail() {
+	printf "${COLOR_FAIL}$1${COLOR_NONE}"
+}
+
+warn() {
+	printf "${COLOR_WARN}$1${COLOR_NONE}"
+}
+
+succeed() {
+	printf "${COLOR_SUCCESS}$1${COLOR_NONE}"
+}
+
 check_ssh()
 {
 	NODE1="$(grep '^NODE1' $CLUSTER_CONF | cut -d'=' -f2)"
@@ -151,6 +168,31 @@ stop_md()
 	fi
 }
 
+record_system_speed_limit() {
+	system_speed_limit_max=`cat /proc/sys/dev/raid/speed_limit_max`
+	system_speed_limit_min=`cat /proc/sys/dev/raid/speed_limit_min`
+}
+
+# To avoid sync action finishes before checking it, it needs to limit
+# the sync speed
+control_system_speed_limit() {
+	echo $test_speed_limit_min > /proc/sys/dev/raid/speed_limit_min
+	echo $test_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
+}
+
+restore_system_speed_limit() {
+	echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
+	echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
+}
+
+record_selinux() {
+	echo "record_selinux() does nothing "
+}
+
+restore_selinux() {
+	echo "restore_selinux() does nothing "
+}
+
 # $1/optional, it shows why to save log
 save_log()
 {
@@ -240,6 +282,22 @@ check()
 					die "$ip: check '$2' failed."
 			done
 		;;
+		recovery-remote )
+			cnt=5
+			for ip in ${NODES[@]}
+			do
+				while ! ssh $ip "grep -sqE 'recovery|REMOTE' /proc/mdstat"
+				do
+					if [ "$cnt" -gt '0' ]
+					then
+						sleep 0.2
+						cnt=$[cnt-1]
+					else
+						die "$ip: no '$2' happening!"
+					fi
+				done
+			done
+		;;
 		PENDING | recovery | resync | reshape )
 			cnt=5
 			for ip in ${NODES[@]}
-- 
2.35.3

