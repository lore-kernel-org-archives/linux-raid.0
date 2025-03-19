Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490754F8C
	for <linux-raid@vger.kernel.org>; Wed, 19 Mar 2025 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742404264; cv=none; b=UuYi0q52F6LpwN5Jdlw615yxtRH6ggWeg57iUqiceByrLhqhNSdQCSTO3ZMCakOcmJpdFEKGCmPq0nOlWKga9AA3/lNt2LnbyHlP5xMlPOBNUHZRC+47zmegJj36ndXfViFxNTjuDjqwgkxauUepe4meIvJuYyBXcRuAP1m2hvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742404264; c=relaxed/simple;
	bh=/1Am4Fjk5ox3Ve+Prb5ioR3bSWpiwzBRzd4lpyQwuvE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sXSaJrb7refvsDqCy1oM40NSGiYVlvITGc3HxHV1RzciQSkSOY6DRB1EKj/Z2mlX/rNgdI/3T1h2Y8Tk+KCNGBmkjy6LLbZV0vI1U7x+FIoesmR8MJ3BRC4r2ZVvYT72bC/OxxDsrqYPGs2SfzPtjtvwIf9i0MIQktGdQngnYCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InGj/KYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InGj/KYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F026C4CEE8;
	Wed, 19 Mar 2025 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742404264;
	bh=/1Am4Fjk5ox3Ve+Prb5ioR3bSWpiwzBRzd4lpyQwuvE=;
	h=From:To:Cc:Subject:Date:From;
	b=InGj/KYxcRG/ZD3YWNY33YeV2H5sbBgWF4Dr7xYsZws9JTBW6Szt0p2YZ+/y0f04s
	 JqxENS4GYTHh9tpIIBLAiFHb/IapDbm1QFYP5hwKNBXcYQsiYUicQ4/TQN/ZWJw7hs
	 kqXu24yOaYuJO2o0m9H2WJCs77TGkiq2p1r1BuYdvNENE0d4NuQSVUEAFI3POH8FTT
	 XHofDOhyvxgEHANIitOtjt9FfFZUXK/wsvL2rRRLWUU4i9OjvNWom82E6wCqzM1FBE
	 7ZsNutNeTHuo/RTvY/A9mOghSSs8CDoWcquNSfKFSiLx8UyeLJc24hRZWYb+XCdZyC
	 qNrj2c7VoNOpw==
From: mtkaczyk@kernel.org
To: linux-raid@vger.kernel.org
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Xiao Ni <xni@redhat.com>,
	Nigel Croxon <ncroxon@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v0 0/3] mdadm: Use kernel raid headers
Date: Wed, 19 Mar 2025 18:10:55 +0100
Message-ID: <20250319171058.20052-1-mtkaczyk@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mariusz Tkaczyk <mtkaczyk@kernel.org>

Sending on ML for wider audience. I would like to confirm that there
are no objections to remove klibc support.

Kernel is exporting md_p.h and md_u.h which were newer used by mdadm. This
patchset integrates them with mdadm. There are some missing defines in kernel
headers, so they are redefined in ifndef blocks.

md_p.h includes asm/byteorder.h and it provides endianess casting functions.
These functions are also provided by klibc. To fix this, I removed klibc
support because I determined that mdadm is not compiling with klibc
for at least 3 years.

I also removed uclibc because it is not actively maintained, on other hand we
are working to enable musl:
https://github.com/md-raid-utilities/mdadm/issues/76

Thanks for review and feedback.

CC: Xiao Ni <xni@redhat.com>
CC: Nigel Croxon <ncroxon@redhat.com>
CC: Song Liu <song@kernel.org>
CC: Yu Kuai <yukuai@kernel.org>
Link: https://github.com/md-raid-utilities/mdadm/pull/149

Mariusz Tkaczyk (3):
  mdadm: Remove klibc and uclibc support
  mdadm: include asm/byteorder.h
  mdadm: use kernel raid headers

 Create.c    |   2 -
 Detail.c    |   2 -
 Examine.c   |   2 -
 Grow.c      |   6 ---
 Kill.c      |   2 -
 Makefile    |  34 ++------------
 Manage.c    |   2 -
 Query.c     |   2 -
 README.md   |   3 --
 mdadm.h     | 108 +++++++-------------------------------------
 mdmonitor.c |   2 -
 super1.c    | 126 ++--------------------------------------------------
 udev.c      |   2 -
 13 files changed, 22 insertions(+), 271 deletions(-)

-- 
2.43.0

