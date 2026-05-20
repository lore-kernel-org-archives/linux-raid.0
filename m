Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B0334D3B2;
	Wed, 20 May 2026 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779265095; cv=none; b=NSJwMIXZfn16FL6Eu1HYv4ZB5ReS9ipXDT4aabEgCJMR7AhEQKRBKiAFGUtNQCIkoIP2fUoNs6NZZtXu4qNLlB8FjewE+K4tc4Qd4IQFNIlaofnTvL9Bvgh9v3DLyKItkM0bC0zzCAJC6wei69sBLzXDbhg0CRQ2jgKKKB7x7u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779265095; c=relaxed/simple;
	bh=nrAhJh8xxepHLcHtg2F03NYQlXZqQEdXXS280WH9zFM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LTf1cy5VtXnJVUCm0Wzj1N1+DVl4EDiG7qSfHIGdIyPY+n3cbIFCd/vwPY1QKf+3qQKj6/7afkLwbtuLSY7R9d7vN7nHQomv3orLa17dz9tspuoPm9wIyOofC7WGcVXiPD7AQ5j2zw//xOsfXjL9VyvIISEbSfUdcPNRLMI29Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9ri5DeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9ri5DeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9BB1F000E9;
	Wed, 20 May 2026 08:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265092;
	bh=apshO2Gk6uUHwWpZehDqtUzbXypXUwPFzFdzD5h7nuc=;
	h=From:Subject:Date:To:Cc;
	b=e9ri5DeJDu6smWKkkuWA9/JVU07vuRrQmItSGuyiHxhEov9UMn6KtCPXap/epira+
	 dAsHUB9dO6GU2ZXX4gBoyEt4UahW6+ag3tRvlDvsvvoMH3mpuJFSNPsA/mxF1Pbynj
	 CGW2t7siHHwiT04vBX/xmCWg47YlAZo6kH7g/O30UJbDbUaUHznP/lNjN+OtUkw2sQ
	 odiBSxKuxo3dSYf3PVLazc9sJI+OStm5uVSNf5l44x+HLMNJYncnbRQcZpf4tqmfeS
	 SGeW27dF/P9eZ1prmKmb8nPo6hq1TY2wRuYl+A/jRK4us793dp7AZRqAydR3dEm5DR
	 wz1hGT5fDW95Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] lib/raid: replace __get_free_pages() call with
 kmalloc()
Date: Wed, 20 May 2026 11:17:50 +0300
Message-Id: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC5uDWoC/yWMQQqDMBBFryKzNjRGW7VXKS4ycawjEkvGSkG8e
 xNdvs97fwehwCTwzHYItLHw4iMUeQZutP5NivvIYLR56LvRamZUjR2wNUVZlbqGaH4CDfw7X17
 dxfLFidya0mSgFVIYrHdjmrC6secVjuMPtpW0OYEAAAA=
X-Change-ID: 20260520-lib-8afb92134307
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=669; i=rppt@kernel.org;
 h=from:subject:message-id; bh=nrAhJh8xxepHLcHtg2F03NYQlXZqQEdXXS280WH9zFM=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW43NCEvsfHLGh8NEyK4DiUqQPwTwYFozaau2
 P27N28Ld/KJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uNwAKCRA5A4Ymyw79
 kX8xCACPOYmf5YXvGaf2g0SGz8xY2YcDsY4arf76o0ndd7o5AVb8jNhXqQzQJemBk451jMZAOd+
 roPl6Yj54BxyDRjZtB5sukmEMpiMKYVfFtqmaovGLCLzWEacxZKVU/stSUagdYp5Enc25dnEobW
 CE/pgs0fWFWcEvRjYgOPVM3EG/a+0aJ9XVnepV+7Ctjv0MmdJvTvzK0N8sm5/s5yFn/qmHJmCYp
 auqNW4F5jb/vxWfYl1234/c51gLYcNLEokqY7FQVaOYK5xkAbitGVhG9/iw+BpahL4Cg5PCaax/
 nmDTCYASjgywIeNMPROZyXFn25s7A5RaTMcNB1UyOF0A/m8U
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/lib

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (2):
      lib/raid: use kmalloc() in calibrate_xor_blocks()
      lib/raid6: use kmalloc() in raid6_select_algo()

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

