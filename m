Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC8027F171
	for <linux-raid@vger.kernel.org>; Sat, 25 Oct 2025 05:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761370009; cv=none; b=WECHjRgDemEs/+TjYa9faD5t6Ws2DmsRdQluFWY0Oj50e8hFF2H8T+YElbdbLnQVPNMlV8NFMhDyq46rvGyO8P3EZxBzGadxdTSj1b/LMFn8svjGQSE4qkoPxbyiwbiP05MF9Qr5e++UAvIdyS63+e7Vcyr2hDAPlng12itwJhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761370009; c=relaxed/simple;
	bh=/zQwfhMEJhTOa5/FV1euV1Dku1nFTDlTsbnBQjlqjDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khaVTYT4iyc5JProfXTnIpESp2jYPcfRMvrSglpATbG//Rezbu5DsqYth6y4UrINid4NJzDqrnN2o1p9LSwEQ4rJQQY1wvL+kxCqW42loMASyv668zLZRMPDr7tFLQ0+r9EE2UokQmdWcIh71EodlPIvDVdlG7syWso9JOPmZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pjvfa8SE; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pjvfa8SE"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso4506444a12.3
        for <linux-raid@vger.kernel.org>; Fri, 24 Oct 2025 22:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761370005; x=1761974805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=Pjvfa8SEZbxsM/zJR4PQ+NRDcthojbCwES9h0rerasc6DuX+QlbPq3ReB7mSmCwZzk
         G+RaYizITPByzjqWgNZCCdnHaJaARqKNOXhortmhpG6uojE+a0urH8nCO97GrZMm6zuO
         DdvtNpTMeHn5rWMFFQ7Ju4peQwzCN+8hsCog0MMBRSxOQ39Bv9ts+qL7kuXrPafx2mDp
         gsIImPcmgn6dRmfYObiegOz3nu/ZxylQPh2GOg8+npFQgjOqF89CdQqJEmYiltz2lDST
         DmfDH2jHtwgINimt1F9lgcm6fSLUUT2WEstjXw4+XuAN4I8VbQ5sjQS+kAyiVJ8caOWb
         zu7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761370005; x=1761974805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mV8buuSZQP0rHOq5S4b8K+cOmbjRvDVQwA71gPDHBAE=;
        b=VOAmnaZbOHBogo3tmnT6r5XWPbDtVjIkZuzPYb53rM1O4O3jnlCAa5VkFK9XaVwsjE
         qOGIrWAmJFvK5uwIJ/ljWm+flVPU2bQw112xCtXrPs44XWS20YejPL+8oig24Ojzv2ck
         m0+GNzTG4daBqgiAqL0D0OINjxAnjX9tI+wakMS7BeooQeZ0nU2AzynahgPo6bpImIMw
         wT1pmBQbNkj/8ykrmDMchlT23HECjW1ts0PiRf3jzlWzuopy3gtGlOc0ibfCLYp5HE4k
         pVYI+/0pPw8/b2rCa7etFJhvz1/BE+llNH2Ji2dL/2oafab4qGVDCVhpkrcIzxohuL89
         O71g==
X-Forwarded-Encrypted: i=1; AJvYcCWrIBd2dvvKlXr1CUSRJJbxLTsp0rBbB2PAcXTfYNeZ8byoJCEtOeF+5Smq7f34zLwsG2FyzAiCOFJb@vger.kernel.org
X-Gm-Message-State: AOJu0YwLAw5tlIZYZI9rsYC4/JZSWXdTVhAxE7wSTtcVc+Z1VLIYZF9V
	vgAQtYRmpvvgDvGQLNkTks9TSVG2HyMs+RWEH59W+6FM8hB5lRphojOO
X-Gm-Gg: ASbGnctkisGyxiSvudZGJpVGTl6H7CozgwLVaDD0m45qljoaTOH3WHgXoOqfvT6AxR/
	LCMXr4B+1UBSrPP/3k4nc0R7tz6Y3+W66IdLAhbZvOtkOYk75JzuJZICvphMJGNeT6VIOuJfic3
	R2v42+b0bjyuOxxoEJj3ZgnLDbIyCixwnKDN25uCnSR+ZZqI7Q4IULseAmioYccHoOOKmRnyQwG
	Sj2RQf250jGSHd+XPDSIej//Xs+r9poUMg/NrUsFkmT08GkC8JuXqF1EdE968mpeaCvC7ulne7b
	YH/B9gUYbR60OtuQ1Hc+5UC3x0FhG6HWm5ZTdRhiuOr6jbzGJjMLGA2zWG67MeranEIAuAgQa0A
	vYfir/LkY2rFiqhdem7gL5grgx0Cw39B1aYI9UzYT+GEE+huQkBxxwlT95amN18ZfmNlmIM7YUH
	CkKsq9LXESEC0=
X-Google-Smtp-Source: AGHT+IHk4JGeekekahtUg2k/EhAC9kyrxVTGjCsIExfHrDtgIcN62P8FCtHZWZXypDamfyJkpyvf/Q==
X-Received: by 2002:a05:6402:40d5:b0:628:5b8c:64b7 with SMTP id 4fb4d7f45d1cf-63c1f64ec00mr33191598a12.6.1761370005212;
        Fri, 24 Oct 2025 22:26:45 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e7ef96105sm880960a12.19.2025.10.24.22.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 22:26:44 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	gmazyland@gmail.com,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Sat, 25 Oct 2025 08:26:37 +0300
Message-ID: <20251025052637.422902-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024163142.376903-1-safinaskar@gmail.com>
References: <20251024163142.376903-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Askar Safin <safinaskar@gmail.com>:
> Here is output of this script on master:
> https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=
[...]
> Also, you will find backtrace in logs above. Disregard it. I think this
> is just some master bug, which is unrelated to our dm-integrity bug.

That WARNING in logs is unrelated bug, which happens always when I hibernate.
I reported it here: https://lore.kernel.org/regressions/20251025050812.421905-1-safinaskar@gmail.com/

-- 
Askar Safin
