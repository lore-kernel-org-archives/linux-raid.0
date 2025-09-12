Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AA43128D1
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691240; cv=none; b=Bi9giGDoiAGKpFKniTaynToiAnrqo9mLHSM82+QRaHWX7FpQp7Is3DXNPmXSAKjPZBzBMNcBW2601ERHFz5OekzcDYhAtAV+3z8rBSSF/aPa88vH6jaqoeQbJw9oqPkiXtpnxjaDEIY+kPgChF4DKRlk9IdEdpM1IVDbBVlBO4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691240; c=relaxed/simple;
	bh=exgpXLfj63gYr51DCgGDnbv0rZpqANhGDx6Ju9sfgUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcRF7rJ1Xxu7AO/aTh3KWnk43HwVEKzZMXBXMhjUwIftpIfViJemJ7CWuuI3vCBcpwAWV5TIGlY2rF5eewmYyieZ8b1ElWSDM01NDsMBVTLGsQyCfdZmdtBlHTzPFrH7oXa6UUvl6Hw+ye2EbFOYfwuWOHLx6xZ+PJ8JIviSEPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RbdHJ/jU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RbdHJ/jU"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dfb6cadf3so18566755e9.2
        for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 08:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757691237; x=1758296037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SmTHMqz+SwQUWseiy//sWu2vIQEJyBXtA/5K8OoxrQM=;
        b=RbdHJ/jUNtGzJkgHwkX4lER6XyJgtpMrirCvby3WUoLhvrK0GRybSPGRCV2lG/+v6n
         4XO6r8NGnmT0FVl/hLfsg2qShxnfNI8sJzSuBvgOmu44TNcs4JnQS63nUajU0T8N7i7L
         d6i8EmM7joNaV35tfubdKERK4W0f/Y+RpbafjXIcjD5hMxA6lcZxnKD9UKZhexOpWppS
         l33nSjf/TkFHtpPlnSJJ5Qn4qrfFjwjK+fX7Vq6HS4O2hpERT4iuYg53qKeFvcO4Vn3A
         RwRqziRqWOS2lKcml35iLC1siiioEIGjTmKBz0d+fyXXhNT2/Sip+u/HKfssnK033szL
         80GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691237; x=1758296037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmTHMqz+SwQUWseiy//sWu2vIQEJyBXtA/5K8OoxrQM=;
        b=YFpZz7sWnkZx29+pGdskSTOh0HHoiLF5SU0Cmyvs/iCnI1LT48026btUt6ORBNsgd0
         pJJT+PdPLzTuCfpIpK261BSphn314p3CgP6ME/9ZHOvcMKW+4p5RVM3GaimLfdTZIgnH
         AYfI9fdX3WJncUOCMFJSAaC1lbFO/5A1j/WPhG9qlg6uiHCnEGhDDtB8ITUcKmzCHZ+w
         z7IEsCKyz/YTr30p7cMIxeqkdVhiUQxih4BbeSA1rK7yRNse9CmVSzNcKQm0e3EcUgI5
         2LTPspkVzWb9+LtGacBmyNJFOqpDXmcTJfJM+sSI2ZrZvx9OKzPpMhkZcdT8zRiTfcvZ
         FHZg==
X-Forwarded-Encrypted: i=1; AJvYcCUMsoJ33xe92T10KmeDPJeXIUuZvQL87HkqhztQI44HMlG59YOnRujo96S68nlPE46GhUJT/AC4FOmw@vger.kernel.org
X-Gm-Message-State: AOJu0YzST2Ejs20ggZ47u27qO1XA6ESxyo8nBx4JZUQpV0LH4wkHZUII
	OhnfNFF5tBbzp10kd4LB5174A9uhMoWS5HXf1he6w8pf3JdaA0OvAhdSQHTpRsVYb/E=
X-Gm-Gg: ASbGncvTYyD+AAvU9AUzrVuVh3hv8Tn967cdGN1zhJrSYb1GNngh9AV09o5SR6aKdGh
	jg+LnzESiFH/B8ydqvd9mm7IsqxlCxDxZ1/zhM/kRbw2ZkOwh3K0UgdWYSJGRSlvJJ4a3ps0i1Y
	g8oj1SAxQdTb0qeRsEiupsgZz2vDgSae4S7Z0Z+S4kcwtExmiJ9zZb4gs0iG74tW538KmcUrXlv
	AQzH74+pvQ2k+RSMtzANt6wxVN56ArA3T9w8TjG4uJX/vMmBqcdcCAPme7ja6paod1NpCJ4dcJ8
	LKfPaXKCm57+c46ts9HZYMx7BJg8qmGYAwJL60iUqzAM4XN4Q+edL1hlRGTxSzlV8KilWolslWj
	bzL4uImuW3XcsVFO8+KDoOeQRGyHkdW3lU5lYHCokRxMbMotVnL4d/tF1Msc5lfx+bf8gFpnbEg
	U5Xvb0dYh+VoM=
X-Google-Smtp-Source: AGHT+IGIL5TbutojGEl75X6AR8qLQ+r8cGWo5f5hphgqncjCk8y5H+pqQAOBTr7Ij4e4WLez4sltsA==
X-Received: by 2002:a05:600c:3111:b0:45d:ff74:3cfb with SMTP id 5b1f17b1804b1-45f211c4c14mr44239975e9.8.1757691236722;
        Fri, 12 Sep 2025 08:33:56 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45e03718eb1sm66020255e9.4.2025.09.12.08.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:33:56 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>,
	Li Nan <linan122@huawei.com>
Subject: [PATCH 1/4] mdcheck: loop over sync_action files in sysfs
Date: Fri, 12 Sep 2025 17:33:49 +0200
Message-ID: <20250912153352.66999-2-mwilck@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250912153352.66999-1-mwilck@suse.com>
References: <20250912153352.66999-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The way mdcheck is currently written, it loops over /dev/md?*, which
will contain RAID partitions and arrays that don't support sync
operations, such as RAID0. This is inefficient and makes the script
difficult to trace.

Instead, loop over the sync_action files which actually matter for
checking.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 misc/mdcheck | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 398a1ea..e654c5c 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -31,12 +31,13 @@
 # To support '--continue', arrays are identified by UUID and the 'sync_completed'
 # value is stored  in /var/lib/mdcheck/$UUID
 
-# convert a /dev/md name into /sys/.../md equivalent
-sysname() {
-	set `ls -lLd $1`
-	maj=${5%,}
-	min=$6
-	readlink -f /sys/dev/block/$maj:$min
+# get device name from sysfs
+devname() {
+    local dev
+    [[ -f "$1/uevent" ]] && \
+	    dev=$(. "$1/uevent" && echo -n "$DEVNAME")
+    [[ "$dev" && -b "/dev/$dev" ]] || return 1
+    echo -n "/dev/$dev"
 }
 
 args=$(getopt -o hcd: -l help,continue,duration: -n mdcheck -- "$@")
@@ -100,21 +101,20 @@ mkdir -p /var/lib/mdcheck
 find /var/lib/mdcheck -name "MD_UUID*" -type f -mtime +180 -exec rm {} \;
 
 # Now look at each md device.
-for dev in /dev/md?*
+for sync_act in /sys/block/*/md/sync_action
 do
-	[ -e "$dev" ] || continue
-	sys=`sysname $dev`
-	if [ ! -f "$sys/md/sync_action" ]
-	then # cannot check this array
-		continue
-	fi
-	if [ "`cat $sys/md/sync_action`" != 'idle' ]
+	[ -e "$sync_act" ] || continue
+	if [ "`cat $sync_act`" != 'idle' ]
 	then # This array is busy
 		continue
 	fi
 
+	sys=${sync_act%/md/*}
+	dev=$(devname "$sys") || continue
 	mdadm --detail --export "$dev" | grep '^MD_UUID=' > $tmp || continue
 	source $tmp
+	[[ "$MD_UUID" ]] || continue
+
 	fl="/var/lib/mdcheck/MD_UUID_$MD_UUID"
 	if [ -z "$cont" ]
 	then
-- 
2.51.0

