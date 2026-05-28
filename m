Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D7E3195E4;
	Thu, 28 May 2026 07:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779953284; cv=none; b=QNTrmRBcp1nZdC3BhcJtf/wrXGsG3hr6MOdBJMeLLr6pkWki3H9l70xnhjfl9E7KhbYKj0kQwgRjzyEcUXNT2qFR6iJXITe/3VUHhIVFVb7g6J/GiXIjPofX8wt6y4YKkACgYt5RWZPkckd2rp45TZJuovXvyYdue0QUmJ+m4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779953284; c=relaxed/simple;
	bh=8SHcT+RqJaNPCkH8BfPxrUPrxlTa7VuR2n71cLWZHK8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LEEITKN/NXOMuN7T7ca92G5XO4BLMSUerMUitDodWHIkyMHS9YOYm8HZZTcBfZ6Zv/Ets4x5OfuqNVE/viO0mcB7n4QpL9qWFli/+HAEdCRRzNw7u4c/ywJ/Ima/xrZpD7aqtooa53gQ5Uoa6UVjaxQi+qDp3lWmIu3d0FECUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eA7c4CQC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eA7c4CQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A21F000E9;
	Thu, 28 May 2026 07:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779953283;
	bh=34mIzU/HK17mAF70IBteNDWQtmnNv3IMAkT2Gk+MBOU=;
	h=From:Subject:Date:To:Cc;
	b=eA7c4CQCCcbL+LFrSOiL7OpADj/sn38z/f+wwzPMWsajyyd+yM9nxlnsjO/Z6lDR5
	 2TCx8ETAIGXiIl9K+BMbs6PYBElYnMhW4jKzS9B+O4H2nGihd3ITgE6kk6f1KJPUL3
	 XZmprZBXUSBxcb4fPLF+7VFQqyp1kMxWWqX0qYtxg5NRRX4QnY1jQvjYBW+pwX2Jfx
	 1gXGmcpePwS9Ly2I9JDD0a20XUjhwJ4XzxOMdIZu5WvnAu+SPN7nNe9xab/aoSpvxa
	 /SJgx9bw59oaycFcEv/MT/kb59d/wjn6XG5wejS4S7L2y/yBGbs9Sz+5QGDc3+eXSq
	 3cvZF92pGTYXQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Thu, 28 May 2026 10:27:54 +0300
Message-Id: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHruF2oC/1WOwQ6CMBBEf4X0bLW0BdGT/2E8dMsWVkkxLRIN4
 d+leJHj7M6bmYlFDISRnbOJBRwpUu8XoXYZs63xDXKqF82kkKUopOAdAa+Mg5PMlVbiyBbnM6C
 j95pyvf10fMEd7ZDQ5AATkUMw3rbpBPpAnob0aSkOffisA8Y8JWy7xpwLbkEJXQA6WVeXBwaP3
 b4PDUtlo/yHyh8kE2SUE85KDbneQPM8fwGBDGQk+AAAAA==
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v3 changes:
* restore kmalloc() per Christoph
* update changelog

v2: https://patch.msgid.link/20260526-lib-v2-0-ca3f0fc24b14@kernel.org
* replace kmalloc() with kvmalloc()

v1: https://patch.msgid.link/20260520-lib-v1-0-cb3045bef2d8@kernel.org

---
Mike Rapoport (Microsoft) (2):
      xor: use kmalloc() in calibrate_xor_blocks()
      raid6: use kmalloc() in raid6_select_algo()

 lib/raid/xor/xor-core.c | 5 +++--
 lib/raid6/algos.c       | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-lib-8afb92134307

Best regards,
--  
Sincerely yours,
Mike.

