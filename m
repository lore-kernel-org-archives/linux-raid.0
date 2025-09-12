Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3972313535
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691243; cv=none; b=GBdPTrkepDHZXyevp6H9TcO34dQMkjysiDPBVe5wLZBk1LCakOX7ORWV2igBjOGoMmOkPFlhJ0DfkcwWdTDhCfYjFV9NEhs+nYS9SuOL6jzDRc9CZZichGl+nyPVSJjgCqlZTk2e/7MBv+oRPzq2Nicepvzqc/53dmBIBor9VDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691243; c=relaxed/simple;
	bh=MddpZFIapHcSheqvF9ABuqWlK9qIgQKSwbYThDlkloI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQSXGLQEOOek8caNUW9h/qkC6n3V1AYOhsKI6e1QOYrVQGP10L3Tvf9+LHbRdcc4RNiKqvzLY457mqto2BlHx98v78SiIrKA2P/mCan2puIcnUhZmDVi213Oknp6g1mGQflYFql6zsJrBnPD39jvvARFiG0ztZQ5XY/6N+IvvoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H5fEWcQA; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H5fEWcQA"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3e46fac8421so1677400f8f.2
        for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 08:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757691240; x=1758296040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ag6dXM+eRf+9CbJ19sAyZoFa+NbtnBISTY9jmZZl8jY=;
        b=H5fEWcQAf5wnaRunU0nIMGb3ujIw4VcKAd8vXQYmzigNSh390+Mp2x7GAXCLQwadfX
         S31MHLFjBHA9BG7VZdKK2isJZ/HBR6ebakRSdck/r8g0Ijwbsz6oGdScBHet+wfcOXaX
         SlPCxP3LiVg3+/eOwVFWYfSb4mXRB1g1sJzqLYT9BA4ZiFeZ5N770d856XRAb4/V/3c8
         X2LtnJOtJkhpLaSm11Ta/i39aJon53lL6esOY51cLtSkoLbEdKZR0wKhgai1ycQZm/9D
         zpJNL6VJBSMXikWXN8K9gYS2iKh+6qFcAgLCW/odMoR7/Bn8G5tmN32BS4tVIydtRos7
         W+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691240; x=1758296040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ag6dXM+eRf+9CbJ19sAyZoFa+NbtnBISTY9jmZZl8jY=;
        b=hyH0mBXl52XU/lT0k13JRh4aEHbgpO47Xu3l/g1NtlPaKcq1wGxFbF5MzIe5TphdHe
         tETUyUVruUVy4LFt8neF4vsz2IOOTAmQ4mlul7L1COl9y5krgoI3W8VOKelMvy9WRAcC
         tNpmDXzWX7qY2TotToMN2i5oxbrJ/A/djk0Q003bEmNY9IJ3RlMd+2ozi8CKCdPtIxux
         oqKVtEzS51Upx9Cdgd9zVMeFI62O0OZhfncOa0XcL1XHpdn3h2u3JO/TsVqpbFVGTnrN
         hNb/14dxmKqqFgL1hYOjv3t8QfJt+laPambQN0RMBtx68z7pvzYig/37BWaJN8rxuJbw
         uGGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgEL7fE+cV9sirKzf3Q12Xr1KEDnN2jmrj+Nn7iPQ++rZPnClBFglO5O9SoIP7s6swZH7L5kn+5wzv@vger.kernel.org
X-Gm-Message-State: AOJu0YxX1LOBjbSuwZXk7jTpQL3IsGORsmrn+8+nELqFnxzsGhJ51G7G
	3chimaHhiS/tD6F4zFNGUhiQNm/1el0Ih3IL1W0FQ4tjM2RdsQuGa1DJO9uBOajdRV4=
X-Gm-Gg: ASbGncuxiMGm3EcIDacVPbUiifBenPs4Xbj2pnUJ6mZo45QWWkRuSGcEdLZfc1hJmDv
	aDYyp/SLjx2Ga9tBJjlZHWnNfTXipvdSegYkK9q9iP/rYl/h0PobZzQUs86OYhXt2rQn2Gx99sN
	jGY9vgYtdq9NI1pAk8XOsrBuc7oGLwg1TUGKK3vGiVdZUaBs1Ws4j99kae1FnMNi+V0g7YqODJo
	SsAAuuyzcFrFr2jh5L4T8cOc9o9EwGli7BvpylceMICTQM2l5oXQ8/gARkea4agOIhArDhtrc+A
	kCNcJ3x5TL5tie8HRwZyOAOmpZx7/ERDq4jvrS2xiaWI6zYlcJNpluW/IfUb23a46z6SBS15g0h
	ro0+jpl0lqadeyPDW4LqasBiNIKVzFaOpjjyA6C6rfLm2X0/lnw4Zqck4emSLvcb0ObR7sT/N1k
	NpfYM+5rYwiqHVHhU2cNH8ug==
X-Google-Smtp-Source: AGHT+IEMaxZy8SR9XSWerDlrvxdAhZm1PnGG01Hw/He4qU3qSuHeZP8J8WOzYvJPrLppsH7yRzDNaw==
X-Received: by 2002:a05:6000:24c7:b0:3e0:152a:87b2 with SMTP id ffacd0b85a97d-3e765780ad7mr3365701f8f.13.1757691239895;
        Fri, 12 Sep 2025 08:33:59 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e7607e1232sm6969316f8f.56.2025.09.12.08.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:33:59 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>,
	Li Nan <linan122@huawei.com>
Subject: [PATCH 4/4] mdcheck: log to stderr from systemd units
Date: Fri, 12 Sep 2025 17:33:52 +0200
Message-ID: <20250912153352.66999-5-mwilck@suse.com>
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

If the script is run from systemd, simply writing to stderr will
create more concise output. Otherwise, use logger like before.

Use the same logic for other messages printed by the script during
runtime, except for error messages related to the invocation.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 misc/mdcheck | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index df4fd3b..85d79a3 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -37,6 +37,16 @@
 # Use "mdcheck --restart" to remove these markers and re-enable checking
 # all arrays.
 
+# If the script is run from systemd, simply write to the journal on stderr.
+# Otherwise, use logger.
+log() {
+    if [[ "$INVOCATION_ID" ]]; then
+	    echo "$@" >&2
+    else
+	    logger -p daemon.info "$@"
+    fi
+}
+
 # get device name from sysfs
 devname() {
     local dev
@@ -82,7 +92,7 @@ if [ "$cont" = yes ]; then
 		exit 1
 	fi
 elif [ "$restart" = yes ]; then
-	echo 'Re-enabling array checks for all arrays' >&2
+	log 'Re-enabling array checks for all arrays'
 	rm -f /var/lib/mdcheck/Checked_*
 	exit $?
 fi
@@ -110,7 +120,7 @@ cleanup() {
 	fi
 	echo idle > $sys/md/sync_action
 	cat $sys/md/sync_min > $fl
-	logger -p daemon.info pause checking $dev at `cat $fl`
+	log pause checking $dev at `cat $fl`
     done
     rm -f "$tmp"
 }
@@ -141,7 +151,7 @@ do
 	checked="${fl/MD_UUID_/Checked_}"
 	if [[ -f "$fl" ]]; then
 		[[ ! -f "$checked" ]] || {
-		    echo "WARNING: $checked exists, continuing anyway" >&2
+		    log "WARNING: $checked exists, continuing anyway"
 		}
 		start=`cat "$fl"`
 	elif [[ ! -f "$checked" && -z "$cont" ]]; then
@@ -157,7 +167,7 @@ do
 	echo $start > $fl
 	echo $start > $sys/md/sync_min
 	echo check > $sys/md/sync_action
-	logger -p daemon.info mdcheck checking $dev from $start
+	log mdcheck checking $dev from $start
 done
 
 if [ -z "$endtime" ]
@@ -178,7 +188,7 @@ do
 
 		if [ "`cat $sys/md/sync_action`" != 'check' ]
 		then
-			logger -p daemon.info mdcheck finished checking $dev
+			log mdcheck finished checking $dev
 			eval MD_${i}_fl=
 			rm -f "$fl"
 			touch "${fl/MD_UUID_/Checked_}"
-- 
2.51.0

