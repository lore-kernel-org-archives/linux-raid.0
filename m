Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F366296BD3
	for <linux-raid@vger.kernel.org>; Fri,  1 May 2026 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777636025; cv=none; b=bsRS27hDWf+KywN4Hb7KZn/8svqhULwC1eHbnLYqK90OmWhADnNduFConbe/kSQja8XPVEZmQzRDdJNVUGAvmFqhWMPQbw+tn+kjYerQpu4js6G4HZMfWjo8E22KrCVTugc2RLTmHYY1yHPj8VxHdUB1huxJQSXNDZiRfiWOYwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777636025; c=relaxed/simple;
	bh=rTowFu/ufBjrWjGtXEPAIvD0nUWtqTXgMILIDeQRLls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Px6Eg/C9GEDHvPk08Cp4hP+4NCA1V118U9ZnJd9DFXKl3gpN1RCtGv7+yB9rhbhen2iLwDN/CQfvTGDKjhNVDrMnGddGU0pSsXWnnkGXRjiLPug3Vd8mVFrt6fFj7D0/OEgLMAiRYDv0qj87cuPmaagmtbIq47H2f+RWGzIJ/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwJpQ/ob; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwJpQ/ob"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b0046078so15280025e9.1
        for <linux-raid@vger.kernel.org>; Fri, 01 May 2026 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777636023; x=1778240823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7+F9KrcqkNOlg88GFhvcMRaxxFuRjKMs3WpEfPMm25k=;
        b=CwJpQ/obvYygTx0xXNi4fj6AEhX8I9lCugntKa6K+I/zJ8uRIwHyjyazSz8jDthqTF
         wyJQHXzAvRbovXfTiM1ws3gGlJ8HSbmiaV+XOVVhoEl6uMGlYFg42ZvnK1K3jnvqzkOA
         ug6fca7aGzZY46cb3T0g9FVkLc6BmGbERYDq4ZR3APBC+UV5g/Uc4esuEUHfBrM0B5jm
         bKtZmQ1X73/rTriWhFN+Etmxk+ngTpdvKmiHZt1LqrhBuEXzPNq4h7gZd0G+phXumIDM
         XLpSBQBSm0PhmXC3Ts02ng84ePEhtdOsYA4ekhDO6ZWJeTRwRFm+aVtSZyuNZZakgi0V
         RLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777636023; x=1778240823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+F9KrcqkNOlg88GFhvcMRaxxFuRjKMs3WpEfPMm25k=;
        b=jNnRif4X9K2b5b6I6klhxDlQZRKYWBvYpYWm3kzTw3Set7ojkxpeGY8OxuGC3wxoCX
         3jIuOMplZG2TyKCnOpAB5UjeF0jjPC0ghttXIUieA5Ams1Ah8s2Qmo4cGC6ON1FiMRqr
         tp6hSqVQY2HkLMEWIG3F441JgsLR4lXdcIBqPDxfBeXDqBLErN6h4qu5ZRB0rygQDz/7
         t8GGk954XSnko1MMY8sf+VC4djOvQlEOARpJZU8flz9gT2ViMAMLzW7EiWM/cEUZ9Fg7
         FG0xKWGxh6DOc3bqz+wk4XhsstZiS5odcWT18OfAjmP7MMl6D4vQH9nbH8tj+uOu/oxg
         GBxw==
X-Gm-Message-State: AOJu0Yw2Do6VAxB1HTCxvFMSaN4VdNiBt3GLFyjeQ5dq9kc+1VR0rYMC
	zqsGMqqkhwMW8IPTty9GKZN6cu/RswOtIBtW4pERxym2AdMCUhx6L/mp7Fjrnw==
X-Gm-Gg: AeBDieteAiZLi/n5rJoTjzNFCiyczN3QOins7k7VepeX5ZE+WxjWu3zZafAl2K0HDPx
	pnZF+9iSZ5m3UoOKbGeeskPz29Gnn+GOZB9DerUoMnts4MqUwE/yYCcdpD9HGe0nQ8QD3MI3XHj
	VvIDolULNOnMsvllWDdVhMZT1RujQ484agxrZcYEFvv3k971bVHN3r97npabtkyu25JRXjnBUMD
	KTqk/Z/4uDRwfIWBeSwKa/y1E2Rss9b28Mv35uZUGSUKv+abXuGwbmBerJ9F2QFS9CjdT5N7L4Y
	3E9BMtYe+FWj4TI+7abL0nBvF1ytYOMwCfx7fdJjfMGYOvWEXvC5HAtcXvvFTxgNAyx4jBhokWw
	RQqj3eZhzFyOdgPqHZi7+DCKSXqWh+szZqdFU/IiXATWhDE5+VkFnuOyTl7gjI0llrtfEPRfKbz
	ODnVMwm8Cp3Q7TLSzej/927U9aTOIVGbFpTg==
X-Received: by 2002:a05:600c:a316:b0:48a:58ae:9933 with SMTP id 5b1f17b1804b1-48a8eb8b706mr27491095e9.18.1777636022866;
        Fri, 01 May 2026 04:47:02 -0700 (PDT)
Received: from yocto.. ([2a02:3037:621:7039:f080:d03a:2ee1:37d9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fee5033sm11797005e9.22.2026.05.01.04.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:47:01 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	neilb@suse.com,
	shli@fb.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 0/3] md/raid1,raid10: fix deadlock and bio accounting in read error path
Date: Fri,  1 May 2026 13:46:48 +0200
Message-ID: <20260501114652.590037-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series revisits an issue in the read error recovery path for
raid1 and raid10 when bios are split and resubmitted.

In v1, the approach was to avoid splitting bios in the raid1 thread
to prevent recursion and potential deadlocks. However, this was not
ideal and too restrictive.

As suggested by Yu Kuai, this series instead handles the problem in
md_handle_request() and allows bio splitting.

Link to Yu Kuai' email: https://lore.kernel.org/linux-raid/m2lde74dtw.fsf@gmail.com/T/#m714020a38b60fc5f84b9a24f0c46acbe5d7342d6

This series fixes the above by:
 - handling md cloned bios explicitly in md_handle_request()
 - using md_cloned_bio() to reliably detect the error path
 - fixing bio accounting to avoid double/missing accounting

Changes in v2:
 - Split fixes into separate patches for clarity.
 - Use md_cloned_bio() consistently to detect cloned bios.
 - Recognize that raid10 has the same issue and fix it in this series	
 - Allow splitting bios.
 - Handle md cloned bios explicitly in md_handle_request()
 - Link v1: https://lore.kernel.org/linux-raid/20260427103446.300378-1-abd.masalkhi@gmail.com/

Abd-Alrhman Masalkhi (3):
  md/raid1,raid10: fix deadlock in read error recovery path
  md/raid1,raid10: fix error-path detection with md_cloned_bio()
  md/raid1,raid10: fix bio accounting for split md cloned bios

 drivers/md/md.c     | 25 ++++++++++++++++---------
 drivers/md/md.h     |  5 +++++
 drivers/md/raid1.c  | 15 +++++++++++----
 drivers/md/raid10.c | 28 ++++++++++++++++++----------
 4 files changed, 50 insertions(+), 23 deletions(-)

-- 
2.43.0

