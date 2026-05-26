Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A572222A9;
	Tue, 26 May 2026 12:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779799846; cv=none; b=ujPcD7K0/UA7wgpHlZrm1Wt6N+rt0jTPmZB9Oe6n81RPdX6YgA0QE7CK6pxcVwwQcdAPeQABECEjX7pvSrHSHPFxaBvcryW2WJIH6SjbXPZ1HbMscZ0H4HYH+tzXmn4LhVuF86vKuGhDW8DUyR3s3hJrDn0KTr8ko1zkfX1Mh+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779799846; c=relaxed/simple;
	bh=ejVtaH6AdQoDXFCEg9bQ+j9z4Z8Fti+7Nr/QXGssyyw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=uLEzT8xdKcTk6hCgnOridObw9yZkzD3838lv8EPHiH+213xpavEIDsd7qgXYFD0psSbiKTgnljTe3fAWd0wWOR+HBXWGu95s5Ux12ncl3rOp7qp/X/uHspvay+uxSPuKfQwCGEC+OgpcCih8nrXP3jsK1jvrk76b2w/tfI7SeJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dWqZVU54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dWqZVU54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6C31F00A3A;
	Tue, 26 May 2026 12:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799844;
	bh=219z+BDksYR9TcZV2QFuw4jLlAsViJqU3lt1lm7RVNw=;
	h=From:Subject:Date:To:Cc;
	b=dWqZVU548wiXJRd0+EH8cd6qHs/0bKwbd4Fv5fVBTkVs88GKjnxKpyExRAWFBfmva
	 O4AK96zJ0S5b7oJl3NGp/jRshlrnLsgDjQD5+rjVFKbUrolYb8fySwu1g0QCC4F2dH
	 1HMPxqWJhILkftPX0ck/H9bW/N7NjBeYpM8mX5v6ecb8CATZQaPOs6UFRwHrd7T+xp
	 jb8p3a4/h4NGHV7VrZXATgvmZukgF4ni989Shrm3avmwdkHrwjrtd/BSm1SRi+pK1W
	 ioEz/MwxyRv5r74PICbjnG1I0BZeyVwGamHD8SFL17dS6V3abd4oTujr1T7qi9B0xE
	 SryGvoavXBX0A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Date: Tue, 26 May 2026 15:50:37 +0300
Message-Id: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB2XFWoC/1WOwRKCMAxEf4XJ2WopoOjJ/3A4NCVAlClOiowOw
 79L8eTxbXY3O0MgYQpwSWYQmjjw4FcwuwRcZ31LiuuVwWhz1IXRqmdUpW3wbNIsz/QJVudTqOH
 31nKrfhxeeCc3xmh0oA2kUKx3XZQwP7DnMV46DuMgn23AlMaG/19TqrRymOm8QGpMXV4fJJ76/
 SAtVMuyfAEoTHZGwwAAAA==
X-Change-ID: 20260520-lib-8afb92134307
To: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>, 
 Xiao Ni <xiao@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2

This is a (tiny) part of larger work of replacing page allocator calls
with k*malloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/lib

---
v2 changes:
* replace kmalloc() with kvmalloc()

v1: https://patch.msgid.link/20260520-lib-v1-0-cb3045bef2d8@kernel.org

---
Mike Rapoport (Microsoft) (2):
      lib/raid: use kvmalloc() in calibrate_xor_blocks()
      lib/raid6: use kvmalloc() in raid6_select_algo()

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

