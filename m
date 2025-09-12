Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A83128C9
	for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691241; cv=none; b=IZAwYRt4jqN6Jp3uvQC+V0SiM8Y66LgrBOSJvDd+Iu4BYWmWmVhOph6reTPe9O5J245QvXNFU6rBtybDIOJN2UbCgq3j7RRhoY6FDBUZG+aaVMkr/UqD6MVn+GlBY+BQ248pC9AszBTzyMqnEWhlV+WHanmax8ZqdcqMcCqLWLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691241; c=relaxed/simple;
	bh=weXr1ne1V7xXjrHTWH4e2sHicJhlM/oBDtkP9D0EfW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEkpiu7NH8jJD1thgHc+NeDpHBWkgyu8ffGk2VYq7Kf+SVzO7MSpOl/1tH4cmS13puSH6V4UExtdYEE2HEJXSir03xPQPRxsCMLbJAN43TTo4ph3DRN36ENZAIcooWnSI6ieHaiRaJlMrKNuBR3bAVMQ9eaPGALqZcSXKKALflw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I7M7XjGK; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I7M7XjGK"
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-3d44d734cabso1686164f8f.3
        for <linux-raid@vger.kernel.org>; Fri, 12 Sep 2025 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757691238; x=1758296038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8n3ql0uWu51yB+LH9Dv1eAAOm6n9sn9tEoLoCEy8k/M=;
        b=I7M7XjGKe4aeAqoSNFOQO3I4XQUxmm/jjdJhuZXSop0VoALULaV1963eibRp1JRa1H
         XjG4ztHDqRlATg6bEiNVZD2N3OOwyTfgmNGxVz6AVYDUe/FCZxrkTAspHVSSxgeoB31n
         o7UGWHlQW5r9XzzlR1n4V9AHxjxt2gTPUdF2GVYjfhePUCQHtgnLNYVctvC+r7WBLHh4
         pj0u0d9nH031d1FHFC4wX9CGhnPIJirgumu8u3HAwCipVivSyCKmD+L43/QI0F60gKLk
         ULV9XrcvePXOXgg7mnky7M9SBLS59maG4jlpbKzAO9ixrlvO13TwhONIqRBF0l37dehT
         1bGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691238; x=1758296038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8n3ql0uWu51yB+LH9Dv1eAAOm6n9sn9tEoLoCEy8k/M=;
        b=hyCj4BzKbOnt/HA9s7kzfAsHjVxZt30t42JCS+XrTr9/fuIhJGRvp+gIBMpScepVYF
         oXFK+tMEhbhTi+7V1svqIZrZY5tWCqg3kOW/MfaeIt0H3VVCcfRHJvhjDS+fGG3sXqbV
         Pf6mIC70gzPd1xdoc382nEQUciMGcby1AzeW3Uuq8PKntR+TteJv3sqOExADd+RuCH/6
         5qZ20VSLKdpIGnROfoqH5ZUAMo9uhrRSKQsk5q4pVyPztoSO3yO29G3BQSH9llPGCsnV
         S/098iUTm3aZPJa1OSjHu7KniLEwPrpwqpo07caXWUTFApSdlLkSo+yo4WruSuu5GXvt
         YnLA==
X-Forwarded-Encrypted: i=1; AJvYcCXE6/4UTFbwtSt4Uyy0v70LBbqhOVqwzsmO1qKu7ddAvYWI+H6xhyoO0YbZqO5HoGO6NK6Wz3Rdw00X@vger.kernel.org
X-Gm-Message-State: AOJu0Yx90/biMXckAj7OLJpIu48NZlcJUa4YGR3yJXrqcQ11jtnU3ZgV
	Tx5WS+Rjxgage+tVKNzoVv5Z9E8wwvtvqI1lE0ACDf4Me2UJC5emvkPuy+E/yul6uRnN71O/4DD
	oV+jBVZNUSA==
X-Gm-Gg: ASbGncu1K9z1fDn6KsoEwDjnUW9LXQ+vRJ5wFmnx9GCfXcYBtTzEr7sE0H40PDWDVgG
	C8QtxIJgueMyxaFvTUXI66h1ARvIEV78a7hOao7M//LSamBWKzkzGwfmkbJ5EENBMveEgbmwAhu
	oUnbW7IVpaJxS+qqGEydO2Yn8hUQ00rgOUP+l9nGhS5p8UJcGxG0G0tO7Dm1wvMN1XlnW1P8ZLI
	ioN7E6idt48AfEhpVa07dWjESvg3Icgr7wV7nAN+bwfAoDHmTnge2dW+qm+43VSgcXAVOB3mXYw
	bSrYQomxlMjGoYyl3cO89TCIVc7DHRSWYiMCpRoVEPK1VgyoqRsyCHaeO5lMqB13yDjaHszFM00
	jQ1tqf2MgxVKMGtlZO54yIuWk+13fqqVu0CmhNPbf4NgX4LtjcGXe5lxxTYSDU1aB5v/VsreUf/
	/5fq7JYwqy7W8=
X-Google-Smtp-Source: AGHT+IFM/EAEROOj3+GHWwzfLIpCFdKHmTWbR+dFHU3Afgjt+puxEth4+L0oyPHIK3sAe+z3zEG9ig==
X-Received: by 2002:a05:6000:24c7:b0:3e0:152a:87b2 with SMTP id ffacd0b85a97d-3e765780ad7mr3365541f8f.13.1757691237795;
        Fri, 12 Sep 2025 08:33:57 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e8237cfdddsm179651f8f.60.2025.09.12.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:33:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>,
	Li Nan <linan122@huawei.com>
Subject: [PATCH 2/4] mdcheck: replace deprecated "$[cnt+1]" syntax
Date: Fri, 12 Sep 2025 17:33:50 +0200
Message-ID: <20250912153352.66999-3-mwilck@suse.com>
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

This syntax used to be marked as deprecated [1]. In current bash
man pages, it isn't even mentioned any more. Use the POSIX compatible
syntax "$((X+=1))" instead [2, 3].

[1] https://stackoverflow.com/questions/41081417/difference-between-a-b-and-a-b-in-bash
[2] https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_04
[3] https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap01.html#tag_17_01_02_01

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 misc/mdcheck | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/mdcheck b/misc/mdcheck
index e654c5c..5ea26cd 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -129,7 +129,7 @@ do
 		logger -p daemon.info mdcheck continue checking $dev from $start
 	fi
 
-	cnt=$[cnt+1]
+	: "$((cnt+=1))"
 	eval MD_${cnt}_fl=\$fl
 	eval MD_${cnt}_sys=\$sys
 	eval MD_${cnt}_dev=\$dev
-- 
2.51.0

