Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794317892;
	b=GXrPjNWyWH2IOsokE8vf1ZbG3dqyG1aVsXFq5eYBbXOqfuuXp/D2WjlEC/dr1fqfZ6te
	 5iMcOfrQF25Ga/XG1qiwNTEQ755Ls6mTaij8JTLMCCBAf9F5VlLdMRxxdVnDedoHrIn8B
	 65eBAj2DrUVrhmPjg17iLT06o0D66h5OhTW4btkBxQUjoP83I5Uq2w60jlpYx3jT8PgNa
	 96SVTfpf2K8QmqoAWgPZbiv9HKsDHjOJLBeD8mO+paq2Axbkk8Gcrg1kW80dWMrQ5SmrK
	 uXgWWkjMqtJ9Wi3nI4mhoSSkS6ToUbuuE5Vg73ZeFy+7r6OIlElmHWUAkup+UrO94ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794317892;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WD14ABrOwh4dq3tAIvyCGMyLqZ8dcHwqnH9GNZBBs/c=;
	b=Oh8IIiTL7lnu5pmfpxS1FeRCiEflAh+AQBKCEDuzj+KUvoo1GI4JnKsuUlrpdNMO8WN/
	 5j5iTjX8LMtyifcOPWQZYKrJ9ngcCe86mbuX7XU7BteoM+1fJ7y2bRObD/oEJkE/FuyCT
	 IASeOKm2B40EHJ3YOx+VkrWG/0Uj3RaqAdvvFcb9s0aRvJHrc4rbv8Jz2/C4uByueZG7t
	 l27R9Lacs1KRmXEmoVW+8WMNUSAtX2C2npZSNguOU7vER4uJZHu1/zQ2AEVmDcHwmPH5g
	 mB0cq9/AIFhMvEiYsmXHhdGgylEDkyyZzIf2Uiz+yH/KE2YkjEZhmBHbHzPBkAUsQgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="E/nMBnPP";
	arc=none smtp.remote-ip=109.224.244.107
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B27E606A326
	for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2026 13:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B27E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=E/nMBnPP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794317888; x=1794577088;
	bh=WD14ABrOwh4dq3tAIvyCGMyLqZ8dcHwqnH9GNZBBs/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=E/nMBnPPYqv3aSVXz6qkL/V2oGnkh+e6ijJDqC8H7Bis2J6YDvbzd5jQS4tijdopy
	 OI20mQoQ1yAOW1HgXQHXyOPbNyicSaPw1M6kGKqGy6K4ybCC+uYPEb/iRaW/9az+Yu
	 6J7fGvsPIb3TVoj9IxWlAPm7UfZOuq+0WMAl9gx08olSTp4N1U+0dp/j3SXpuhCnnM
	 aVpre2sgh+4esHJSmY6O1xNsjCnEOpf8t1M3Cz289QFHGC9FGyGE6sNHHKot4FMFaq
	 E9gNQ15RQOU1UIS/rzktUTbYW+71YUhX2ZWqyTyLprdFuS0V3/25wwQ5krMCk78jKV
	 9xZNsHmXi3W3A==
X-Pm-Submission-Id: 4jP75B5BqQz1DDLZ
From: Miroslav Cimerman <mc@raidlab.org>
To: antosha20xx@gmail.com
Cc: linux-raid@vger.kernel.org
Subject: Re: xor_gen() md-raid6 performance improvement
Date: Tue, 10 Nov 2026 14:37:56 +0100
Message-ID: <20261110133756.63676-1-mc@raidlab.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
References: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
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

Hi Anton,

thanks for sharing the numbers. I recently submitted a raid6 patch that
makes read-modify-writes faster, at least on the Intel machines I have.
If you have time, could you please test it on your Zen 5 box?

  https://lore.kernel.org/all/20261109030805.25709-1-mc@raidlab.org/

It changes xor_syndrome(), which md uses for small read-modify-writes.
Your 2 MiB sequential test does not use it, as full-stripe writes
compute P and Q with gen_syndrome(). Random 4 KiB writes do use it,
i.e. --rw=randwrite --bs=4k:

  echo 2 > /sys/block/md111/md/rmw_level
  fio --name=test --rw=randwrite --bs=4k --filename=/dev/md111 \
      --direct=1 --numjobs=1 --iodepth=64 --exitall --group_reporting \
      --ioengine=io_uring --size=100g --runtime=60 --time_based=1

rmw_level=2 is needed on a 4+2 array: a read-modify-write and
a reconstruct-write both need 3 reads there, and by default md picks
reconstruct-write on a tie (1 is the default).

One job at QD64 should be enough. md's single raid6 thread should be
the limit. If the md111_raid6 thread is not near 100% in "top -H", try
--numjobs=4 --iodepth=32.

If md111 has the new lockless bitmap and was created without
--assume-clean, md uses reconstruct-writes in regions not written since
the array was created. Adding --size=100g to fio keeps the writes in
the start of the array, which your sequential tests have probably
already written.

Also please make sure that no resync is in progress.

My numbers were measured without a write-intent bitmap, so the
difference may be smaller with one.

Please make sure that both runs, with and without the patch, use
avx512x4:

  dmesg | grep 'raid6: using algorithm' | tail -1

The kernel picks the implementation by gen_syndrome() speed when
raid6_pq is loaded, and the patch only changes the x4 versions (x1 and
x2 already use normal stores). If another one is picked, reloading
raid6_pq with md111 stopped runs the benchmark again, or I can send a
two-line test-only change that forces avx512x4.

Either way, sharing your numbers would help, and a reply with Tested-by
to the patch if it works for you would be very appreciated.

Thanks,
Miroslav
