Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792836774;
	b=Td8EOdiDAzJdwbcke6/SI6LpUUDJ9W9LEDrYL8lAO74JlZbaXWxceXgduWsCTlztzUxI
	 Rbm2uIRb2jy1P3HcsCmw4zMOi/7s2DHUPKrf+8FHzG0l4pr6e2+NyhTH9LCiAXXWZqPbB
	 FI+GIfnr57gyZf64B1r3pMo+5t9Xrwnb3keRar81cJHJYuuyAoxfMO9hhweBfGZb258Ue
	 ps2Df6AfEkJsXnohEzCk1DQsXqiSDlLC4TERROaMH/3KCNfRrkJMtfuN3x/BS7QLkux2D
	 9dFBdN2ok+wYGooJLXBfIx21ydduUQ7DaGB1seYXQ+77iK3o+1MEOfC+2Gq6FOPuUxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792836774;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ZaJsZ8O6xe1lvSBTvjf12TfmCncBFQ8LC7jl8pG3xH4=;
	b=2VHYeot5NDZ55yGZ2ilnc06gvWJfiCpmGDuVtzD42IcSaUdfQqemo9LRwmdr6Ve3xsOE
	 hIYunv61veadHAolh9ZgNG+dn8s9TgRlQVl0V0z9LnToiSKWICQf3HZReVGUmFJb/U+u2
	 HqOlqgdheGo8BiPZfjxNH+Lm44ym5orxDm4VveRbYgKGeea/a3Pid7Ho9Fly90qOyojv1
	 b/kk5t/bMtuYJP5KUZbiX4w+v9qVYk0Agn02WLN49gAipx6ToOfOTCMblah4XRxn120Ee
	 I+/MIp6wqaAT1+JkKP2B5hLIgQvrmrvVUowmeVO+NeZd3pTD5AgRryB3sBllcP4rP+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HLM2kmbr;
	arc=none smtp.remote-ip=115.124.30.110
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75706606A31D
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 10:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75706606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HLM2kmbr
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792836765; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ZaJsZ8O6xe1lvSBTvjf12TfmCncBFQ8LC7jl8pG3xH4=;
	b=HLM2kmbrFNQrJUeme4HR9TVpO5Aq92nA6H23Y/ep4G7MjGkA/7SGd429dLlVIqAnLY8CxDSmT3QJA+P5fx02K+28ERS/19WPKLJy83v1t5ZR2Ya9ttNqOYRPuGUTxYFZuefnhSTMj5RPYmTdTFbYo+FHZh3EU9rECkaC/HHLM0g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDO1FRW_1792836763;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0XDO1FRW_1792836763 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Oct 2026 18:12:44 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: linux-raid@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Jan Kara <jack@suse.cz>,
	John Garry <john.g.garry@oracle.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	YunyeZhao <yunye.zhao@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] md/raid0: fix data corruption when chunk size is below PAGE_SIZE
Date: Sat, 24 Oct 2026 18:12:43 +0800
Message-Id: <20261024101243.75028-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <a138247b-287d-4e5b-b6da-6337b0ec7272@fygo.io>
References: <20261013133243.42145-1-yunye.zhao@linux.alibaba.com> <a138247b-287d-4e5b-b6da-6337b0ec7272@fygo.io>
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

From: YunyeZhao <yunye.zhao@linux.alibaba.com>

Hi Kuai,

Thanks for the comment. I agree that backporting should be the first
choice.

I first tested a straightforward backport of 4b8beba60d32 adapted to
the 6.6 queue-limits API, by setting chunk_sectors before
disk_stack_limits(). However, it does not fix the reported
configuration.

On the reproducer, the RAID0 chunk is 16 KiB (32 sectors), while the
member physical block size is 64 KiB (128 sectors).
blk_stack_limits() therefore clears chunk_sectors because 32 is not a
multiple of 128.

This was verified on QEMU arm64 with 64 KiB pages and 512-byte logical
blocks:

        pre-stacking backport:
                queue/chunk_sectors = 0, corruption reproduced

        current patch:
                queue/chunk_sectors = 32, 6/6 readback tests passed

Splitting at 16 KiB remains valid because it is aligned to the
512-byte logical block size.

Mainline uses the newer queue-limits API and rejects this configuration
when the RAID chunk is smaller than PAGE_SIZE. In contrast, 6.6 accepts
such arrays, and they worked correctly before 319ff40a5427, so
rejecting existing arrays would be a compatibility regression.

Therefore, the current patch is not an alternative to a working
backport, but the necessary adaptation of 4b8beba60d32 to the 6.6
queue-limits behavior. Since stacking the member limits clears the
chunk boundary in this configuration, the RAID0 boundary has to be
restored after stacking completes.

Thanks,
Yunye
