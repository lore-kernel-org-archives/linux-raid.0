Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173514;
	b=yQBfMaAa9XAJQbUerthOgJAxP6mfd37GzypE1LFvnahDmzS+Ui0nn11PhFUnM/a1wrd7
	 KcY5j7cHJWIdCJg6WQE43UgfFkDAM5V4yQo6aZgZqVfLQtFBr+0YMigpClDQ62EriMbZb
	 xRdjFsmPWhEJaNP7esRipp0Vfd4TvqCfGuLjjvtuNsn3zxsMr5ceWpdM83mpDPDw/63DN
	 6sr5YW+knP8vgBB1hJhswfkOaLriQiwZkccRUPLJ77vHUyjr60nTEef3jIalO6wgLSodb
	 J/MYufyctkYwNwYfpn137I9AB4djDgL/c0rJf+Z2CQZgbUrsXc07wNU6rp+1VHFvIKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
	b=nu3W7vSrQsMgAE7XGPqsrc1ZxE0ObURzLQYh9Vby4SXC68ux4kT3gmNVXXRT6osaX6kF
	 LcYCscxTMrQIGOqxZUcQ98/AzXuW6HZQiE2UW40MZlOmKmamTvycdd0xzJiFyeyXi9+r8
	 6sjAs4+HI2MwOaeTupbf8YTABWnnazFjYfvaCfUvFmKEsEOEzJeUH/SUwur2/t0uPWerN
	 TV9dnR9cgok8nrluDFnTtuZISKjr854UJtOGR340V1h4hX4frWnIOMwi7QYfy+ydYOchx
	 uVo0+railc/cWw2MZBD4iVQ5a+GJ5caKvuZZHB2530bG+vW5yNmiJtWQz+IlMzM0mMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k6ksLl8W;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB88D606A32A
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 11:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB88D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k6ksLl8W
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48e46e449e8so490033f8f.3
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 03:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173512; x=1795778312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
        b=k6ksLl8Wgr8uXVydDfgGczdMdtHhae7G2e4mHkti/xXNX0pXLzhmNd1u8OjFrLFblr
         cXQOmyyMUKxTbLAVYW72nAYfBxUzgL/2Zp/H90r3jQJDfZ330WatI/7V+RfTna2aRfkN
         Nq6Ahe1GiJK9ubZhwRVojV/a/+TZxT6PUThkkvNYP8PQv0vc55ZErsK2+pz1/R3JnX/2
         IrKhvM0Fhs9x1AoG9jdohDUz7GGV6iyghDjDNiLecB8NO0urveA+KNrrMkOcc5xHSWVi
         pYO6Bu/lSkPxlA0qzbjUa9iYQVYScVOkN09CozVKuM8qniLnwOFgHsDVoYE8TXTuA+1I
         FE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173512; x=1795778312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zpsVdJ3WbR6kE2v38VJhuAhS7jEKmVk9lGuvUfsu2RM=;
        b=xY3mG0Q0gJ7Pd6LdgViD7M+RsY3AWudogt5S2Sqm8nM6Q0eDxk3g02jhSXwhdsIq+P
         imlygy1okv3PJdYR8yc81ELcYlOQRI3xxJSalCME3aTtxwcPt6O9GzVKJAnn7fk8r4qV
         b8Qmit9kuCPUdtj5Fnm5bR7WK6sD+ki80xgu9ZuYpsQ6eua9EpfAwp8MQIN9FYMFII89
         j+M7Pv3seXZBmPIMZojNH43idaxfe5G3LRyzhurZuYrjU4xb4L623sWUS2+Do9smd7kp
         shQ8L40mG04Cs+rzh6jbwuEFkDTIkj1PdJ9kXrpsociRsMw2rLBNxzsu7Kgg8S/JQoY0
         oHlw==
X-Gm-Message-State: APuU4Z/DdcTHuVbLIxf43cQUI5jOle7vkbnE31tbSuXNH7/Zymht3fi9
	EWfWiyCa/xFW0sOuWv4rln6zOrbI/5q8pGFZaKU8E/oi1RHi67qd5izoZ9C8qzOXVL8rgSsx
X-Gm-Gg: AZFdTZfd1FMXUZVTFIQm3jdo4FdKAZ169RLceoQqM2KSiKkwKQk5UMFBrORo/2kVxFq
	Tfuvf4PbWXKsCMexJNLt3tffRy/aoJT9zJEGnz+N6hduOEFZ1dSL2JIHQwVoyt4jlTXUHfKW8a9
	ombFZ+YufohH10l+XnwgySirhggZze4RQy4YU4kwbOrgMeInfATCsyjPQNLFggzvs6ItuliYKVs
	eSrCBPY18gBDu4mzW0jNYlw47W5snwNCnf00Kpgx/YSFr/G+z/j4rKH1FrufnsV0y/l/D52JaIk
	vYy3VpAaIKz7pYi0IEKFtnmpMP533tI/t3YHs2AfLpTnA2+N+IyUqHKR92ywefcCqUKzQX0mk1M
	5nMI9GWsnv3Zdn5AroVdVzgHVZExid8tc1ji84RZJZ5fyLiH7LL+KgcPZu04WpB3xzFH5u1U2RC
	VoobnIqJwG3CMZYKVEaynMlnrn10UxiBWillQYuE5ouiYwSURFXjg9Vd9tRrpFe6hL34StNnsQI
	qWO3NjUZ2McIRALYbtzkNe7k/Og/f2IHH4GZdcblayksWbwWNdq5ublXWuXHGLtFuPSJCKATdta
	0YR5lmTV6zKou3SICj96Lv6nQEc0xJcYDeWwSwPilH8J64OctTLG
X-Received: by 2002:a05:6000:4705:b0:48f:c4fb:6bb6 with SMTP id ffacd0b85a97d-4abb400bb83mr5164503f8f.12.1795173512177;
        Fri, 20 Nov 2026 03:18:32 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:31 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 0/2] Fix recovery flags on failed RAID10 reshape
Date: Fri, 20 Nov 2026 12:17:55 +0100
Message-ID: <20261120111757.4705-1-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
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

From: Hristos Nenkov <nenkov2004@gmail.com>

Hi Kuai,

Thanks for the review. This revision implements the ordering you
suggested. Patch 1 clears MD_RECOVERY_WAIT in dm-raid on all three
reshape setup errors. Patch 2 removes the recovery-word reset from
the RAID10 abort path.

Checks: checkpatch reported no errors or warnings for either diff.
Both affected kernel objects built in WSL. Five focused userspace
checks passed for the dm-raid flag handling. I did not run a
live-kernel reshape regression test.

I used OpenAI Codex to apply the review feedback, prepare the v2
changelog and run the checks above.

Changes in v2:
- Add the dm-raid error-path fix first, as suggested by Yu Kuai.
- Keep the original RAID10 change as the second patch.

Hristos Nenkov (2):
  dm raid: Clear MD_RECOVERY_WAIT on reshape setup failure
  md/raid10: Preserve recovery flags on reshape abort

 drivers/md/dm-raid.c | 10 +++++++---
 drivers/md/raid10.c  |  1 -
 2 files changed, 7 insertions(+), 4 deletions(-)


base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
