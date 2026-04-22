Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414D037F75E
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776882054; cv=none; b=k601XbG5KShOf3vce1jnB1ltNV6s1d1h7/bLX+s8EyTf882LYoFhIKghSalmtWRYP6frFwLk2p50cRAFoSmtP2gY+7hE/tNNeBxOM6Y/xW1ljoEo/Zv11y6bxJ3Y7wfsiVfTUDR9ueCyCRyMdgehGiyZvoJw5SIXGytUwzPFX+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776882054; c=relaxed/simple;
	bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=MzecDkByOi4J1FmPFNMWVH6ZJGF1R47+eoh3X/aY87SxHDADrgRAi5tDUoGblIzxnJ0UHtuubQkXtfiSGay/ECs6IbBo3LmFTMQaI6M5AZ6E/bW6WwGsanQ7eDntgJIY1OLI3bI7ewxIa08ZJ6vWiQWTUy0Ab6KLKhPlvECy9vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y0sDBqcq; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y0sDBqcq"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so5297026f8f.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776882052; x=1777486852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
        b=Y0sDBqcqucVgqAD/+5b3CqsV8JEJ6WfNyHT/YPNCjaVRZCnhpkTbm+WguUrIdE9NZj
         1Z0RJ8A7cvqdbEgvSODEsjcS55e2PNSvsOq4GVZo2oT6LTeYtw9mD7hp2bjyznxan/wW
         qhBUNfejby1k0yYp5e7pmcJKNO9Jz40IjfXbwlWpxxtGK896jh1VfAz4lQmUVANvjm7M
         fRAbnlX5QnwhSzHyzHR6dZ2w20qiOET85p1ZvcuLQhMhU5+hb3hjd4tm6gXVyg3TLb+V
         aTvLDWVi0pQLuB7B0P68RTN9ct0dyHnBaWDKsZlBYpVJevNiCoPv3iP1A2xeURI3brgv
         SZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776882052; x=1777486852;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FOfqXcIW8PzAAJseN6kMVkrxS6YbtRJvZudF491F3qk=;
        b=koEo9of7wE8Bo/d++USJNyOIjopBfiyhsugBpDn2TG6oBU3ojdigOEljtg6SgmRSoz
         RqUvIa5kMhNZ5SG29P26dQ0DjJY8wllXTD2iBB46e9gulVe0biPJzZ6vi9zZ9OKyKCRo
         m0P4y02s2+CmCwXwXR4fOx5C+VfW8CbTkBCDnxjb9ONvEXOGtWeZOi3cA1a203aFfsic
         cCSzLLLQOYoCfvGp2N+EP2qee13t/bx2sBD7BGOYTi6j7uAZ3jqPSfU5ZEijiRHFYboS
         oVrIlbZ0LDa25uZRoJ35/eszHVAz3qlWE/tJS8ok94eG5a/K4kXSnlAgTFSb96swr0qx
         A8tg==
X-Forwarded-Encrypted: i=1; AFNElJ9TWvT7KAXCG3n+hvbJKzlnyYzhx1sS5BfV320dW7WdQGWw3dVV5SKg5In7s7BzGW+uX1djkZYbtIpI@vger.kernel.org
X-Gm-Message-State: AOJu0YznwwAu+fXy/+9j6QI4Lj3aDlWjYiedo+lgs2R5O0GCZyFFQ4AA
	3yrslKgqsXkjzW7bEuGfQpVyJ0+190+lTn0gOeD5mbAhcFZ4nNXXbvKD
X-Gm-Gg: AeBDiet0SMv7C4McHhiPvAWr0S9otAdDWgDmOdcyZeIed1ZtfTbtWqqtDxYQ3N4zQsC
	EhSYP+qCw5ebFvvV2T+XN29CT/vfHDK2IEOyFmu5RhzRHGysMGlF3032Jh+sj7DK5g6M+3WHNds
	VU2olVw+9W6azh6OFTFzIHKzOzGBgoqlTQojaIT2f8vaGvCA+Lymz/Sur48NDpqNdYwmjS/D5ev
	0rc/OI6kcOeuDmXkfrHmhkGX0q5N46CmDsLaXwB+yxLV2flzS4hPAaz9bp7ZbVxYmSQiAVKva8B
	+nX+kVrq/+Ze8YJnu6CXihH/gU60PnErv4SmCcYRJpZLfjc66RZOTnD7855nBwDYiYidx5GBbd2
	6/5VmI9Logffyq1luErky+wME3r6CEMNWvajErCY7QkluMEgEJeN5rmCZ+lWPh0dpJNqQNl8l/e
	ZBH0XrvX+qDSKEu+BmSdsQ+Jpf4CUHVqZXjsgA
X-Received: by 2002:a05:6000:1447:b0:43d:7b90:fa2a with SMTP id ffacd0b85a97d-43fe3db9c3bmr37137540f8f.3.1776882051593;
        Wed, 22 Apr 2026 11:20:51 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d112sm51676217f8f.29.2026.04.22.11.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:20:51 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:20:51 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_7/8=5D_lib/raid6=3A_Include_asm/?=
 =?US-ASCII?Q?neon-intrinsics=2Eh_rather_than_arm=5Fneon=2Eh?=
In-Reply-To: <20260422171655.3437334-17-ardb+git@google.com>
Message-ID: <A11B0E21-5ABB-4609-829B-D4F0896331B6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.

Makes sense here

-#include <arm_neon.h>
+#include <asm/neon-intrinsics.h>

Reviewed-by: Josh Law <joshlaw48@gmail.com>

This series is a good (and deserved series)


That's me done! I've reviewed your lib patches for you, have a great day!
