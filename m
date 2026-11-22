Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318186;
	b=j6EgVTs4g+1KZfrsFFoeaOy2hiRe9g8hhae1UubNjt4tzo9BABH2ZoaylqjMUItTk8VU
	 xJMchwTAmGqwlMO7r1qHxJEl/nYn+R0ir7EOfI2tb2O0BqpuCQgGkWmM3a+CyAoPDzMfh
	 8YiVz6cA1mtcfcvZvHoTb85A1eY6LWDR7xwQyoAa9Bbja3K7DEARn6mOaHezApxCS1NoU
	 k/I3GXhbbRzbEW8RHs1wT2OBiTuLe6ZnyW6aMV+O6alc3Bk0vWbpQjS+0ROg1T1ft0ZBh
	 QOln017LSMRJHKnlLumIu53Gdq5/h7UHUzoUdQMFHo1gO4ucE6lxDryFaKgBtwgAiaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318186;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zw0RFWxkK80ZDQsxTqIzOsK9ms1kIlwgwAxsFykNLbQ=;
	b=rX1tQ7yFRvR3Mc65FS51/TIPv935IlAampbxkMXtzp1d+RNgHjvkPRxDqiSgAPI4z1tj
	 e0KJhVCH/FpHbRqQg19NJqLASddemcp5UdTTkSGfwy5f24wvde10GhUqDEb8BDc3/ynMh
	 i1D7CuFClyRc68qn0rfN93gA/bGOT6Ig2aZK27eviOLg4TFhJUO9V2xD1JqQlheeGTByX
	 fnZL+zZ82AtQ/HIRVlmQb4wpK9HPWLUZc2ZkyCKSlVyuwix+JUGRehXvyfI1hFvuJBgQZ
	 vE7DyKvxI9iwIzE4ExywB2oIcwO3pGkOlgYqFU+9y0WTTIL4LO+aG/u3uvSk0PUjepw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Q65JK0UL;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07922606A320
	for <linux-raid@vger.kernel.org>; Sun, 22 Nov 2026 03:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07922606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Q65JK0UL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795318182; x=1795577382;
	bh=zw0RFWxkK80ZDQsxTqIzOsK9ms1kIlwgwAxsFykNLbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Q65JK0UL6eBWGjEOAdL6rgJAc62Wx8Si0vZTrbmyOGCofBm1yRVzBZi5opQWFDg15
	 6CgZ2vuyNureHVX4TR0NP56Cq/dZPoHvGs/0GM1Q3MNaT2zRnxZGr5ecBj0asP8E4Q
	 qZSBwY1GqrO/bm/g8ftd/dba38jFXPSwpkuHTaPo12AE2spdM7sibSNvh/hbNkmgW7
	 BG67MYrrqxVFJ6OezCmp2w7MstwmvmqyFPlNMjFsUHQzihstp3DvTidJ4Dpsw2h6hZ
	 P1ZUcDZ5kc4N1Z4tQTEipfSFEEtKa3dNOvxoypb6l437DrNgjXOYHBjqoQ3+JzqtvC
	 k4MsueUf58Zkg==
X-Pm-Submission-Id: 4jXF1c4hg1z1DDqy
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] raid6: x86: asm constraints, sfence and prefetch in xor_syndrome
Date: Sun, 22 Nov 2026 03:29:30 +0000
Message-ID: <20261122032933.2306875-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This follows up on the review of "raid6: use normal stores in the x86 x4
xor_syndrome functions" [1]. With that patch, none of the x86
xor_syndrome() functions uses non-temporal stores, so their sfence
orders nothing. Christoph suggested removing it [2]. Eric pointed out
that the AVX-512 functions list P and Q as asm inputs only and rely on
the "memory" clobber of that sfence, and suggested prefetcht0 for Q [3].
1/3 fixes the constraints, 2/3 removes the sfence, and 3/3 changes the
prefetch of Q.

Based on mm-nonmm-unstable with [1] applied.

Testing:
- Builds without warnings with W=1, gcc 15.2 and clang 21.1.
- With 1/3, clang generates the same code as before. gcc reloads the
  data pointers inside the loop of the AVX-512 functions (up to two
  more instructions per function). With 2/3, the sfence instructions
  are gone, and apart from alignment padding the code is the same.
  3/3 only changes the six prefetch instructions.
- The raid6 KUnit test passes in QEMU with -cpu max under KVM on a
  Haswell host (avx2x1..x4) and with -cpu Westmere (sse2x1..x4). All
  8 test cases pass in each run.
- In userspace, gen_syndrome() and xor_syndrome() of all nine sse2,
  avx2 and avx512 variants match a scalar reference (gen_syndrome for
  2-24 data disks, xor_syndrome for every start/stop): sse2 natively on
  a Core i5-2520M, avx2 natively on a Xeon E5-2699 v3, all variants
  natively on a Xeon Gold 6130, and avx512 also with Intel SDE (-skx).
  The AVX-512 functions were not run in a kernel. I have no AVX-512
  machine with root access.

The patches and the tests were prepared with the help of an LLM. I
reviewed everything.

[1] https://lore.kernel.org/linux-raid/20261109030805.25709-1-mc@raidlab.org/
[2] https://lore.kernel.org/linux-raid/avqegZd_W0kce0UA@infradead.org/
[3] https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/

Miroslav Cimerman (3):
  raid6: declare the AVX-512 P/Q stores as asm outputs
  raid6: remove the sfence from the x86 xor_syndrome functions
  raid6: prefetch Q with prefetcht0 in the x86 x4 xor_syndrome functions

 lib/raid/raid6/x86/avx2.c   |  7 ++-----
 lib/raid/raid6/x86/avx512.c | 37 ++++++++++++++-----------------------
 lib/raid/raid6/x86/sse2.c   |  7 ++-----
 3 files changed, 18 insertions(+), 33 deletions(-)


base-commit: 609cd6a5e6138620c16d8818bb585e8766064c23
prerequisite-patch-id: 0242f328222b644b2b329d90c8d50aad322b7655
prerequisite-message-id: <20261109030805.25709-1-mc@raidlab.org>
-- 
2.53.0

