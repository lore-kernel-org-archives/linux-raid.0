Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747341;
	b=cZWKeNjlfkoWd2YMt5iLrTlrBq+1jLnV1V6tzl2If/RTYH4DzmccwYZXI0qHGdqEljrF
	 6+9EfgbBchQGDtqx/z5CdVbULvmZSgo8hRQ8ovplXAfdiz+oKIPaiXnrvN1reB+O/Z4xD
	 8WKHlMjFjuMDtx+9ZdGGyytOBwz6ReQYoWdE/y2FC5uVKNQeDXYxjyzTAqyLJTp4aybDL
	 POgt7IVqIqql2lz8hCPmpNrRtQuDcOcOEzBJO9Z7d+VI5gZWaif1M2uMpdUMjGGsmoYw5
	 z6cOeMZH8AIknjExov7l9PkClwIThdt6Okqe78PtvN8CwzZ5WE5cQ00m80ncLB+iFXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747341;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=C72HozOP9ChGHV25Gjbk/dfVnjvNwFuPluzxe73xVgM=;
	b=vDvCXt3b0PDiprEkBopiTHBbscnQX6MkOyV/ia0m+OvqfCD9OYxScQeoUmHHdLXaM7Ze
	 he0lkEVe2Dxdrm4QVaGYu/A6zjnx8jjk6l9a3U03DxfXxbQWuxty35ukE177une4YYsXZ
	 oI7xf/TxNWja9myWVcWa7baTb5aXGIS7iJwKBx0ILdiorbfVa3YbvA7fT6lo4sxZLdgMt
	 5xA4Olbty855d9tTx6retYMgJh1jZ/l8Iws1a3iH62p8wP/Dyd+whJYBdYDvWkbSKLoAL
	 jlGWFu0rIh7bVHR78k03f8NfpVUuh9mPfTAeXofhhKyNchi4eXI5PEGXbaI7VziItRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b="KuN/0ExP";
	arc=none smtp.remote-ip=109.224.244.107
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68599606A31E
	for <linux-raid@vger.kernel.org>; Sun, 15 Nov 2026 12:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68599606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=KuN/0ExP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794747338; x=1795006538;
	bh=C72HozOP9ChGHV25Gjbk/dfVnjvNwFuPluzxe73xVgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KuN/0ExP6Y/Jhk8K9JYxhCXg+7z7n4GGni+9Jlcm/J0rLDKY8iU5c8ETPj+RkMDgG
	 pgzZYkMrYDjlamVEQBFrnqGa5u9cx0YsdnYtsYkwgC5M22TXRMn1IiFGceHF50But+
	 RinMIUQWZpUZeoGaT0H/wSAcc97+e3hi9X8DHUQq/WIHzv0jLG4HV6e2Vl4xRGtDbD
	 PoZq4C64z62Jgq9P7Lr/oYGYuS52zdSQdAp/gI8qBGJfXH2rmukUvBFYlt/FWgBEyM
	 zh8jacG99kbb3exeNbBfYwmusZXoZvPcH0h4gLNsB09eM99Oq4frBYSENHI3+B6Mb3
	 v4pBA3OlG9VuA==
X-Pm-Submission-Id: 4jS9vq52xHz2ScQ3
From: Miroslav Cimerman <mc@raidlab.org>
To: song@kernel.org,
	yukuai@fygo.io
Cc: antosha20xx@gmail.com,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	tj@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid5: fix write stalls when a write is queued during a drain
Date: Sun, 15 Nov 2026 13:55:15 +0100
Message-ID: <20261115125515.56112-1-mc@raidlab.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261114224636.34362-1-mc@raidlab.org>
References: <20261114224636.34362-1-mc@raidlab.org>
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

Anton Gavriliuk tested the patch on the same machine as the raid6
store patch: HPE DL345 Gen11, AMD EPYC 9455, 6x PCIe 5.0 NVMe, RAID-6
4+2, chunk 512K, no bitmap, rmw_level=2, v7.4-rc2 with and without
the patch, fio 4k randwrite, O_DIRECT, io_uring, 60 s, 2 runs per
kernel. Slowest write and IOPS:

  md defaults, 1 job x QD64:
    without  max 59.3 s / 45.1 s    128k / 124k IOPS
    with     max 2.9 ms / 2.9 ms    129k / 126k IOPS

  group_thread_cnt=8, stripe_cache_size=32768, 16 jobs x QD64:
    without  max 56.4 s / 57.5 s    472k / 474k IOPS
    with     max 9.2 ms / 11.2 ms   483k / 479k IOPS

Without the patch the slowest write of every run took 45-59 s of the
60 s. With the patch a few milliseconds. IOPS stayed the same or went
up a bit.

Miroslav
