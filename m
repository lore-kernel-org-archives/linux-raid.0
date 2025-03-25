Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D619ABD8
	for <linux-raid@vger.kernel.org>; Tue, 25 Mar 2025 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742930289; cv=none; b=IGACMVShNPu51Qz/0mdp3ldjkn1DDFvFM2niY3ges6T082qeTtUXVebRxs4wjg+HdQRC3X6Jb1O8ePemsKj7blyu+g339VWCfMs0bIdBzXl35crkVUmlnOLId45/gKpG0Qoe1igQWVJN7jFfGaGH9WkNMnIrNu1u22BgnxP+JSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742930289; c=relaxed/simple;
	bh=R7wmRTwpXi6i/22pQsHheFTXZeweJaulqP1gBhHvAM4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lVIwEfYqnS2KloOjFXtZGA9wUVfylL3CWumZt0mYHkKfXpV6xueOp8w3tz/0wC5F5KDIDBSDaQDNQytuvvoefV9AE4WK8YL+mawYLEEgERlChzkzSrqXPt5caeh4hwNUwba1rdALQw3N4uBrU3zV38O02S0dw6EPPmAh0+6tedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TRXlAnFg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TRXlAnFg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742930286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fixOOObcgYMq2QJq/cl6d6DW+IudfL0sZ9Oixdn5PvE=;
	b=TRXlAnFgbfmknCSetSgng3yrfDGma/Z6J6adpWCtLUhfFYgPAfaYXMdLGQzqg7pp9awkz6
	6BVLvPRYchmqrket5UthbHTMpE/xqo74PEXMhxTXaBrzuuYeNjy7sjOXxGlPHv0rZOB1Sv
	Y4WaJfMX4ojCFVfhK6CpELfFHVBP6z4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-erI2oEpmNE-7wTkI-k3YwA-1; Tue, 25 Mar 2025 15:18:04 -0400
X-MC-Unique: erI2oEpmNE-7wTkI-k3YwA-1
X-Mimecast-MFC-AGG-ID: erI2oEpmNE-7wTkI-k3YwA_1742930284
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c3c17f91dbso937331585a.0
        for <linux-raid@vger.kernel.org>; Tue, 25 Mar 2025 12:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742930283; x=1743535083;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fixOOObcgYMq2QJq/cl6d6DW+IudfL0sZ9Oixdn5PvE=;
        b=BJB4gC0ua0uQRN+8qxrqjRyxwC8RGOh0M3iIoyNCqgjhq3PKI0j+A+vzP+yRS3NWQG
         zWH3n51YMCCJRERm+wYts6JceVIKgY6sjYu7tYKP9mhfmJvCS5K4h5/W7INz6h21/JhP
         YQ03SMBXMHXfNPydJEN913C4Dcpze5DqbieMi1iVxHo2xTTv+tGjlSL6piCF4PCe9qof
         +VKUr9h6lrzChLQI1g0gU4KFzpV5+HLYR1xd/h32HdgwfAqWB/eelRYVwf43v1SLBSzt
         I62+nvl11vxz8kDkxAk3Y3WEq0X9g9Qrt2OQ9Apqo0nbEQhrKRI+tMkMp/gTqM0nQ0d2
         Xo0g==
X-Gm-Message-State: AOJu0Yym99gi23YMpUUJhXtlBOGLUpCT8W8u5bEI+SjJBL4A5Kl6ngrV
	j8qw7U9ziBzDnDxU0jFIOPJBHz6Sh7rF03rGNSPb3Ap1VkpsFFI9B6s+rv9q0tlDtMtrIKaiugz
	TDtNtsHOcFWuphNb1N2KEJqNP0KW0o27qwZMOVgZuMIugsKmWDi8D4sCzQDnPZ3fJUmiP43gkJj
	p4HC9hHyNuvRDLHc6UeYD3Jl+Uaft59zKKjgTCayqJMw==
X-Gm-Gg: ASbGnctOn8FNtPCyrxGMLN42hbVOXnL+5Vp7h4F7P8j9Iup4BHNE4XjNeCvX+ziPRPi
	Ykjwa5n4r1DzraHxj6ljMiiVjnqIp3nLWb+Rt3WnML+voUCXlgiDnjZs66a/SQwGvh30trPIzTk
	gmhan8DpQc2t+YCXwqVdl9Egb2lo79/y0n6pEjc5K11EBBZdVaFh1TheScbo3nNQEqwOfI0e657
	qtPRkIyCsjI4dE5Wm/o8KtsHRDY75yKVbqGF3COynaoohxv2VSLrYfGTo8n3u8g38W4O81o0Qiw
	KYRD7ZvmkTavjG7PxES8xmhGxluwyP0=
X-Received: by 2002:a05:620a:44c2:b0:7c5:43c2:a908 with SMTP id af79cd13be357-7c5ba133652mr2837230085a.6.1742930282768;
        Tue, 25 Mar 2025 12:18:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqs/JLse1u4FSl2aIZft9dPeUfsKW4B/Z/x2GjV5DNwYvHoDe/QfkyktUYinUeLgJq7SqhKA==
X-Received: by 2002:a05:620a:44c2:b0:7c5:43c2:a908 with SMTP id af79cd13be357-7c5ba133652mr2837226585a.6.1742930282337;
        Tue, 25 Mar 2025 12:18:02 -0700 (PDT)
Received: from [192.168.50.111] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b92d5d86sm667894685a.34.2025.03.25.12.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 12:18:01 -0700 (PDT)
Message-ID: <ded3b88e-c0e8-4a66-89f3-43bc6bb9664a@redhat.com>
Date: Tue, 25 Mar 2025 15:18:00 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
 Xiao Ni <xni@redhat.com>
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] mdadm: Incremental mode creates file for udev rules
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Mounting an md device may fail during boot from mdadm's claim
on the device not being released before systemd attempts to mount.

While mdadm is still constructing the array (mdadm --incremental
that is called from within /usr/lib/udev/rules.d/64-md-raid-assembly.rules),
there is an attempt to mount the md device, but there is not a creation
of "/run/mdadm/creating-xxx" file when in incremental mode that
the rule is looking for.  Therefore the device is not marked
as SYSTEMD_READY=0  in
"/usr/lib/udev/rules.d/01-md-raid-creating.rules" and missing
synchronization using the "/run/mdadm/creating-xxx" file.

Enable creating the "/run/mdadm/creating-xxx" file during
incremental mode.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  Incremental.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Incremental.c b/Incremental.c
index 228d2bdd..e0d3fce7 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -30,6 +30,7 @@

  #include	"mdadm.h"
  #include	"xmalloc.h"
+#include	"udev.h"

  #include	<sys/wait.h>
  #include	<dirent.h>
@@ -286,7 +287,7 @@ int Incremental(struct mddev_dev *devlist, struct 
context *c,

  		/* Couldn't find an existing array, maybe make a new one */
  		mdfd = create_mddev(match ? match->devname : NULL, name_to_use, 
trustworthy,
-				    chosen_name, 0);
+				    chosen_name, 1);

  		if (mdfd < 0)
  			goto out_unlock;
@@ -599,6 +600,7 @@ int Incremental(struct mddev_dev *devlist, struct 
context *c,
  		rv = 0;
  	}
  out:
+	udev_unblock();
  	free(avail);
  	if (dfd >= 0)
  		close(dfd);
-- 
2.31.1

