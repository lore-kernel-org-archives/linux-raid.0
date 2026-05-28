Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806DA3B2FF5;
	Thu, 28 May 2026 09:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961991; cv=none; b=VlAMu0jytiA98MsuEZaFh4AEecUDoZf92uMXjovmJadDop8rsbWxZS61KNX/h01+1hn9zrJeophgx0bhWgQORZ1OfNzHoFAhgjsTwPSPl/p/MPDyO1MfEoMlz3GBi2WA5dVdq5fN+eCykGYnvha2KQAuBCg15+zlXH3ph7Pdmug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961991; c=relaxed/simple;
	bh=MhB+cet0LYjzyn9eJ5cBt4cflZ7jGkNw2iwl6ZdmEVc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jksekIOR8AzSZZDdkicjUCigLDSCeGWtawqWYr5BB01lOLAMs8D4TD2qHiNZxrTgg7knKiGaoZk4mZNsHpxHoyQ6R8l9nN7hHsBzikiU+x294JA+VpexVAKzRkzT6JZy6KrsRhwcHYwAZv4kl83NFNHKaIgAfr1erl2jqRXqUm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aco6Gx/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aco6Gx/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6749D1F000E9;
	Thu, 28 May 2026 09:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961990;
	bh=0tbtnOuHhIH4p/NZ7nvRGoECzQt7IqPJgxAKHDaqYjY=;
	h=From:Subject:Date:To:Cc;
	b=aco6Gx/GpBhsPG/P3VohKBtFNaTzZ98Ku0yJRh/58TyUNEpm5KJrSzFMpJuoeLMjE
	 9u/R8z90S1sXcgJnnhwfrueYDDVRoD5D+En37T0ibrdvFjdJzvifmAi796YjscyOOm
	 dJvUmikOKI6OHNAoRKiR60cYfSqLXCPGlT/l44L07VL9c7nTNK3jAlBahFqkKS59uX
	 ciXYGer7SEQjiAaD2bUBv70L27T59EBgqJTbXnmE21m9BRPBvLB73Pjcm998Ua2fBM
	 bL40igHYhpg6M5THEMgU17zuC5FDEvmJi/31eG0lOsjuoZF3W1CTP6yNsuLXDPqnP2
	 WpsNYaMQSOqFA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Thu, 28 May 2026 12:52:59 +0300
Message-Id: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHsQGGoC/2XOOw7CMAwG4KugzATyohQm7oEY4sShhipFSalAq
 HenoQuI8bf92X6xjIkws/3ixRIOlKmLUzDLBXONjWfk5KfMlFCV2CjBWwJe2wA7JbXRYsumyVv
 CQI/PluNpzvkOF3R9oWUCbEYOyUbXlBKYNUXqS6eh3Hfp+XlgkGXD761BcsEdaGE2gEH5+nDFF
 LFddenMyrFBfaNqRqogq4MIThmQ5g/pb1TPSE8ooHPeB+mg8j9oHMc3Gvoupy0BAAA=
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.15.2

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v4 changes:
* s/kvfee/kfree

v3: https://patch.msgid.link/20260528-lib-v3-0-feccddf1cb6d@kernel.org
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

