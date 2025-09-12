Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF70313531
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 15:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691242; cv=none; b=Ij2QsqfOTN9MkDvMaYMBSP2jScixMgQtRCcZjtmKu7pMhOYCl5zLrdb/yQCrsbn+kK1JcAQU/iZqR4jI6PSXJyQp2p0S7MZbkoRMRGQCTYUNcZJLJNzoOK1FUT0rkxH14a+CfSl9eYABP2XbhoE+NpoIiZHirjC3yWVcvN2oxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691242; c=relaxed/simple;
	bh=uIZMX2+4HNCSSsazTDT43301Gx2f1koXqpGArN5bNPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKKUur0Y4STYR7wxRHqSu7qG31bnNN38cFjhAt0SKJ1OT9/wb2+5B3UMXcsWc77fa/3U3ZrBObEqZQALg4GkNWdtxJN18uHz/NcEIEY6eVb347QfjkRe5aSWYBdC9anNlyYNIXxc6wGrsOGwL+N+wX12vO6q2hzX0l1rqxOVG1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BRwB17eg; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BRwB17eg"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3e76766a172so729332f8f.0
        for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757691239; x=1758296039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h5/1COPZrUVSzUBImxDIlOpUenMg8TGJKXCfXzL6bo8=;
        b=BRwB17eg24GD4/mGnQxCYioPEbFL4b0Wq8pj8fQvA7zPs+elYU/26YlceCvy6p0vWG
         Sl7syF5a2gfJZYz/IQzI/2M7lha7KBR2fIXs5WSk8CJHqCDjtkgbV1FA2y2MgOcWuJXs
         14qSQ8eimNC4TBYTmAH5Z4uxQ05facOkjePYS9mnSWXce0/cI+eei1Rg5d+zouLpdp73
         SGQL8Mvrb2pwkKlDOwqFrZQ3OCO+TK8Lt2FwhUv7Yulan12BaqzxXDLgPpXorTZglCYj
         25Q8G6BgFojViy1NGiJ8vxNnlhCuik+2Yqptdj/w61JaiBXmEEc1CegbvXxm+nzxfzDT
         hrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691239; x=1758296039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5/1COPZrUVSzUBImxDIlOpUenMg8TGJKXCfXzL6bo8=;
        b=drb6WZFDjP1Mx46ZUa+AE9INGFi5r1YGibGnpkBI8/AlXDmLV85nNwDbCPstC17XX9
         Qhzz+7YcH3nJ/gpvFq+0gPKi24QUCpCxSuq5iHMpojpOFeaRrzYsYrEla2I3UG1FIlxY
         1B4xy6rnEerLLZvDrQwyWMW8KsGAc4wuDM8sm3Lbfpupvsxp/aj8F2v3GcNUOCvEZgrZ
         UzmBKbOgnQDXgONSkAqEAwTMOTQBcp/5UxIpBcFAjZPGomP9Hwv6coRIUBPjgk4HNM3J
         cBWDElRQicXo4xPpwJghTmqgHPi/7EPpQeqiqIYrRgm9ydMrFgNbgC2t9PMhm7E4iNKw
         Z4qg==
X-Forwarded-Encrypted: i=1; AJvYcCXhaZshK2z5IDBMA6bf0BkZJqT8Gh27Sqi3gboCrDpSisr9zr8NXMRMCfGw6t6pAXUYxTtiMqoaT8ba@vger.kernel.org
X-Gm-Message-State: AOJu0Yww5q+8+gprRjhb5fgPacaH+XNgrMaVL/CXAFuUlAsKIu0q4ccw
	81BELD36YWnVPfEADzNzSt577EBtA1CoTQNMaGdmdAbq2dGF2CkXsR900V5K4lNZPCY=
X-Gm-Gg: ASbGncuLM4YsYeba+zMk1p7XKg8KCQTzzONV24lq1hUH8KDd+7nIK3hlMwDiISIJ4fV
	70C3AWZaHwaDj0SaF/hm2RsZYscNFXoaJMXGBWf7hM3i7MNioqZdbqbCfFjDBfDmzhXqc+H1q+t
	pXc8MrzsMY2c4nXEKC95OnIMpSPoHylVxMl2qyqeea4DaDAH1r5530cZ+WCIYgN767a+iYD1/k+
	t4apntZbO0Gpb1ITuXQexfo3oI7g9cZNzyWl3JIMD9D5cUJWpLqfx9fbu6O1CnrrwwDWL3deiId
	QUApngAlSK1ikU9EoduWozXcsGpcab62dbP0cWMyQr1xS7wOBNMuQDfYPoa0sdn07nmvI6SZaSK
	fDS/MijCEYTJGvANnqPP5yJoPrEtgU2IjmoQsALJOdrkakYRwmrxteiJhMOc3HosvP4us5YcGTc
	uz8HbWuYrd5tnYA7AYkm+gFN0yYEK/WLQm
X-Google-Smtp-Source: AGHT+IHc3HMul+Msc8Vvfgf38cxoX6mdK2IfXR7Yh+3135asYpJsqOrhDbapIK+LMlNN+pLYfSOggA==
X-Received: by 2002:adf:8b16:0:b0:3e7:6879:a372 with SMTP id ffacd0b85a97d-3e76879a674mr1792230f8f.55.1757691238830;
        Fri, 12 Sep 2025 08:33:58 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e760775b13sm7132069f8f.10.2025.09.12.08.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:33:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>,
	Li Nan <linan122@huawei.com>
Subject: [PATCH 3/4] mdcheck: simplify start / continue logic and add "--restart" logic
Date: Fri, 12 Sep 2025 17:33:51 +0200
Message-ID: <20250912153352.66999-4-mwilck@suse.com>
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

The current logic of "mdcheck" is susceptible to races when multiple
mdcheck instances run simultaneously, as checks can be initiated from both
"mdcheck_start.service" and "mdcheck_continue.service".

This patch changes the logic as follows.

* When `mdcheck` has finished checking a RAID array, it will create a
  marker `/var/lib/mdcheckChecked_$UUID`.
* A new option `--restart` is introduced. `mdcheck --restart` removes all
  `/var/lib/mdcheck/Checked_*` markers.
  This is called from `mdcheck_start.service`, which is typically started
  by a timer in large time intervals (default once per month).
* `mdcheck --continue` works as it used to. It continues previously started
  checks (where the `/var/lib/mdcheck/MD_UUID_$UUID` file is present and
  contains a start position) for the check.
  This usage is *not recommended any more*.
* `mdcheck` with no arguments is like `--continue`, but it also starts new
  checks for all arrays for which no check has previously been
  started, *except* for arrays for which a marker
  `/var/lib/mdcheck/Checked_$UUID` exists.
  `mdcheck_continue.service` calls `mdcheck` this way. It is called in
  short time intervals, by default once per day.
* Combining `--restart` and `--continue` is an error.

This way, the only systemd service that actually triggers a kernel-level
RAID check is `mdcheck_continue.service`, which avoids races.

When all checks have finished, `mdcheck_continue.service` is no-op.
When `mdcheck_start.service` runs, the checks re re-enabled and will be
started from 0 by the next `mdcheck_continue.service` invocation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 misc/mdcheck                     | 61 ++++++++++++++++++++++----------
 systemd/mdcheck_continue.service |  6 ++--
 systemd/mdcheck_start.service    |  3 +-
 systemd/mdcheck_start.timer      |  2 +-
 4 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index 5ea26cd..df4fd3b 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -21,15 +21,21 @@
 #
 # It supports a 'time budget' such that any incomplete 'check'
 # will be checkpointed when that time has expired.
-# A subsequent invocation can allow the 'check' to continue.
+# A subsequent invocation will allow the 'check' to continue.
 #
 # Options are:
-#   --continue    Don't start new checks, only continue old ones.
+#   --continue    Don't start new checks, only continue previously started ones.
+#   --restart:    Enable restarting the array checks
 #   --duration    This is passed to "date --date=$duration" to find out
 #		  when to finish
 #
-# To support '--continue', arrays are identified by UUID and the 'sync_completed'
-# value is stored  in /var/lib/mdcheck/$UUID
+# Arrays are identified by UUID and the 'sync_completed' value is stored
+# in /var/lib/mdcheck/MD_UUID_$UUID. If this file exists on startup of
+# the script, the check will continue where the previous check left off.
+# After the check completes, /var/lib/mdcheck/Checked_$UUID will be created.
+# Another full check will be started after this file is removed.
+# Use "mdcheck --restart" to remove these markers and re-enable checking
+# all arrays.
 
 # get device name from sysfs
 devname() {
@@ -40,24 +46,29 @@ devname() {
     echo -n "/dev/$dev"
 }
 
-args=$(getopt -o hcd: -l help,continue,duration: -n mdcheck -- "$@")
+args=$(getopt -o hcrd: -l help,continue,restart,duration: -n mdcheck -- "$@")
 rv=$?
 if [ $rv -ne 0 ]; then exit $rv; fi
 
 eval set -- $args
 
 cont=
+restart=
 endtime=
 while [ " $1" != " --" ]
 do
     case $1 in
 	--help )
-		echo >&2 'Usage: mdcheck [--continue] [--duration time-offset]'
+		echo >&2 'Usage: mdcheck [--restart|--continue] [--duration time-offset]'
 		echo >&2 '  time-offset must be understood by "date --date"'
 		exit 0
 		;;
-	--continue ) cont=yes ;;
-	--duration ) shift; dur=$1
+	--continue )
+		cont=yes ;;
+	--restart )
+		restart=yes ;;
+	--duration )
+		shift; dur=$1
 		endtime=$(date --date "$dur" "+%s")
 		;;
     esac
@@ -65,6 +76,17 @@ do
 done
 shift
 
+if [ "$cont" = yes ]; then
+	if [ "$restart" = yes ]; then
+		echo 'ERROR: --restart and --continue cannot be combined' >&2
+		exit 1
+	fi
+elif [ "$restart" = yes ]; then
+	echo 'Re-enabling array checks for all arrays' >&2
+	rm -f /var/lib/mdcheck/Checked_*
+	exit $?
+fi
+
 # We need a temp file occasionally...
 tmp=/var/lib/mdcheck/.md-check-$$
 cnt=0
@@ -116,17 +138,16 @@ do
 	[[ "$MD_UUID" ]] || continue
 
 	fl="/var/lib/mdcheck/MD_UUID_$MD_UUID"
-	if [ -z "$cont" ]
-	then
-		start=0
-		logger -p daemon.info mdcheck start checking $dev
-	elif [ -z "$MD_UUID" -o ! -f "$fl" ]
-	then
-		# Nothing to continue here
-		continue
-	else
+	checked="${fl/MD_UUID_/Checked_}"
+	if [[ -f "$fl" ]]; then
+		[[ ! -f "$checked" ]] || {
+		    echo "WARNING: $checked exists, continuing anyway" >&2
+		}
 		start=`cat "$fl"`
-		logger -p daemon.info mdcheck continue checking $dev from $start
+	elif [[ ! -f "$checked" && -z "$cont" ]]; then
+		start=0
+	else # nothing to do
+		continue
 	fi
 
 	: "$((cnt+=1))"
@@ -136,6 +157,7 @@ do
 	echo $start > $fl
 	echo $start > $sys/md/sync_min
 	echo check > $sys/md/sync_action
+	logger -p daemon.info mdcheck checking $dev from $start
 done
 
 if [ -z "$endtime" ]
@@ -158,7 +180,8 @@ do
 		then
 			logger -p daemon.info mdcheck finished checking $dev
 			eval MD_${i}_fl=
-			rm -f $fl
+			rm -f "$fl"
+			touch "${fl/MD_UUID_/Checked_}"
 			continue;
 		fi
 		read a rest < $sys/md/sync_completed
diff --git a/systemd/mdcheck_continue.service b/systemd/mdcheck_continue.service
index cd12db8..8eb97cf 100644
--- a/systemd/mdcheck_continue.service
+++ b/systemd/mdcheck_continue.service
@@ -7,10 +7,12 @@
 
 [Unit]
 Description=MD array scrubbing - continuation
-ConditionPathExistsGlob=/var/lib/mdcheck/MD_UUID_*
 Documentation=man:mdadm(8)
 
 [Service]
 Type=simple
 Environment="MDADM_CHECK_DURATION=6 hours"
-ExecStart=/usr/share/mdadm/mdcheck --continue --duration ${MDADM_CHECK_DURATION}
+# Note that we're not calling "mdcheck --continue" here.
+# We want previously started checks to be continued, and new ones
+# to be started.
+ExecStart=/usr/share/mdadm/mdcheck --duration ${MDADM_CHECK_DURATION}
diff --git a/systemd/mdcheck_start.service b/systemd/mdcheck_start.service
index 16ba6b6..c7ddd4f 100644
--- a/systemd/mdcheck_start.service
+++ b/systemd/mdcheck_start.service
@@ -12,5 +12,4 @@ Documentation=man:mdadm(8)
 
 [Service]
 Type=simple
-Environment="MDADM_CHECK_DURATION=6 hours"
-ExecStart=/usr/share/mdadm/mdcheck --duration ${MDADM_CHECK_DURATION}
+ExecStart=/usr/share/mdadm/mdcheck --restart
diff --git a/systemd/mdcheck_start.timer b/systemd/mdcheck_start.timer
index 1b8f3f2..8d09b3f 100644
--- a/systemd/mdcheck_start.timer
+++ b/systemd/mdcheck_start.timer
@@ -9,7 +9,7 @@
 Description=MD array scrubbing
 
 [Timer]
-OnCalendar=Sun *-*-1..7 1:05:00
+OnCalendar=Sun *-*-1..7 0:45:00
 
 [Install]
 WantedBy= mdmonitor.service
-- 
2.51.0

