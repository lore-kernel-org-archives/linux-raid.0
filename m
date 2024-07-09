Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AB212DDAE
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 12:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526703; cv=none; b=XfMPUn3uG2Qh7UpH5c2CVzcUNEH+eQRgocZokoc7afM49ZhjjJH3P6qHMpifN8WuINHZ1nY7QuHXdB2L+z+XToaEvEbPgvpl8wiLLWf8dOEgaVESOlE6DhbPa2MUkdOBu+HXPGgBPld9uEPuJegUloLB5C1qKnYoafhXQeiJ9bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526703; c=relaxed/simple;
	bh=mWD2MS2XLOV0JjtsaBbkRdWvKP0krqJ04Paq3EU956M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XPewS2SYzxWptwz/VkvoPInWpMk1aVkXJ2T4BONVwz/ElFZRg9buHV/2EPlapszfS9X6ms2riX8Bwnb++T/NmVKt9mqIkEfFnd7PolWRMpQRGxROaWjl9gYv5FL8CYxm9bcbO7xLut1oeTCzoWsGb+VLP3AIB6YRTpgULKZkTjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SR9jjZNl; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SR9jjZNl"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52ea0f18500so4801857e87.3
        for <linux-raid@vger.kernel.org>; Tue, 09 Jul 2024 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720526699; x=1721131499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s9Uy+6tkpkiI/xBy7Z2BeoVQ1BUqpcDvizjFuKYAFa8=;
        b=SR9jjZNlQwNKc9pi1/c2Qa27rP6JUip0zZePWmHiH2Xg8xLA4MkytyEOj+3+NikdM9
         sjWBFzVIl2MEkKj27X2m2ftZnjW9nZKFfOlE6GWsJFt8zxLZYeUeLexASaJk1V2WtJyZ
         ZGVHTwhDW+aCMSaLO1MwveD25bRE81JPERQXfJ7dXoOtkDgvhXsd04OBNM+uBEyz7dsh
         A6dwIa9Qrf6pQL9/4P+YNq+JcAUbVco3BB2X7NPmLIte6/h8eDZEz2pZh+N75RWhzeTp
         rVWAYAWBINvZ3XGs5GE5ehH5Iii0fDD75NaLqneBLCnHRY3NvXYDsGZ5c/ewG7G1DnOW
         XgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720526699; x=1721131499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s9Uy+6tkpkiI/xBy7Z2BeoVQ1BUqpcDvizjFuKYAFa8=;
        b=J4f1FlTup5MnysSiVf8e079ieZ+XGEx/W7/8KQ/GF6dzNmTFXDmie4mHKn2v9H6TaE
         HwyE+LVDdibGVVS1SMHW3Q+hgbNlSPKZgtL/KQZnqJbSvq5CjTFgcNySGFlYkqUz73kt
         u5Kid3pRpCCLOMRkAClhmaDs+DZl0f38G8Za5bzGHiuWnY+Qr8jncTsM4iYOm5IGiJP8
         /FKehYK5Xyqfd+6srj+Eym8GU7SVPBjafbwr/xjaEjhugnlmTlUMCUIYF+MyQr9dKjM3
         T5+GtTA649SY2P2NIDt8IFY9lANQ+qsOvfNFkE+CbIUSe2AFFR36hKw0b0iiSlnhqpg+
         YgrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZvWAW6SPq2SRiKmFIDhfgrmwEBPuDYfuUhtIy2IdRp9yQtv/h+G1GKPwV3Z0syVwoaBeR96FLeqAE4sEhDxI+VnmSs3FEcdV9fg==
X-Gm-Message-State: AOJu0YxO+mrBHWfEJ3yBEvrOoH1LymoJH80vrNZQB9IQsbeKSilo06jJ
	mLsVm/TPK1uG2VsvbSty/t/ZH4fMTprFmQBM2+pS6BPctSm9SgImV547updQkWk=
X-Google-Smtp-Source: AGHT+IH04p6Eh95/d9C9XpkKbkUK++/iwLjvGrAogqzGfGBEaL1RffSyZTmaSZyXLT8GQAQ+/jp09A==
X-Received: by 2002:a05:6512:114d:b0:52e:9ba5:9853 with SMTP id 2adb3069b0e04-52eb9994357mr1462835e87.24.1720526698936;
        Tue, 09 Jul 2024 05:04:58 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-77d6886f92dsm1072314a12.90.2024.07.09.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 05:04:58 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org,
	linux-raid@vger.kernel.org
Cc: Heming Zhao <heming.zhao@suse.com>,
	xni@redhat.com
Subject: [PATCH 1/2] mdadm/clustermd_tests: add some APIs in func.sh to support running the tests without errors
Date: Tue,  9 Jul 2024 20:04:51 +0800
Message-Id: <20240709120452.25398-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clustermd_tests/func.sh lacks some APIs to run, this patch makes
clustermd_tests runnable from the test suite.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 clustermd_tests/func.sh | 60 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 801d6043de61..e659c0ba4c74 100644
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
@@ -151,6 +168,33 @@ stop_md()
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
+	# empty
+	return 0
+}
+
+restore_selinux() {
+	# empty
+	return 0
+}
+
 # $1/optional, it shows why to save log
 save_log()
 {
@@ -240,6 +284,22 @@ check()
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

