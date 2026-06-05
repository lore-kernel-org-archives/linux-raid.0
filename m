Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC6F478E23;
	Fri,  5 Jun 2026 07:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780644405; cv=none; b=BVar6ceF7yTKI4RmQU8KpqlMCwTfaTJ8OssvGb8eWmWR/VfXqDNFAlOhu0u+YdECriMHQ+IWKJSBUkOzLFRmKi0J2paO55heMpNYG6h7FgLrvjtTUpFvXrJLybd6MN1c4jtRz9CxIUBCfhN/M/gjs0ACerEiTDggdER4RfgqxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780644405; c=relaxed/simple;
	bh=7aTNcSBBFMcW7E7JpXDFYfPVrNMGI6GaXp6LQytR0OA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gh5libb1FEp/8/pUnEzVIwXkOF4V89IqBNKJXhDZ2WsJ5koe2nUr2l8z3eMdMcHLT3YbDZiNydQLem7AGCPCV8iEYUCBy94lTPVXloPHdQQeGZGk2pzDGMENCJaGq5VME0dnuFSLmAiy217sPU1vzUG6ddPGdxia54K4jVKXV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=likrt9dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="likrt9dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4651F00898;
	Fri,  5 Jun 2026 07:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780644403;
	bh=o69lYzBAHuLvryGwJjweQQKyBkaS2b5wXE+I0FQq4M0=;
	h=From:To:Cc:Subject:Date;
	b=likrt9dcSwgDqNkt7CFURbYLbpDvuDwbzhh71TxqIr9X3Sd6fqV0tzIPwcFRFZhfO
	 AIFoF3DKpWaHXD/w8n7UyNsbSYg3raOvhJCXgiveXEJgdKgZlr1krjTqtUdDtWNqoV
	 i0lbxl+wrT4/njtGNMfxVJuCgX/r03MD5qwYrZQxuKViMG6cMWz2m6C/dD7f8NzH8o
	 b2IgQWsyNdM6ddZQhjtjDXOY3wuLLHE0sa3FzYXnsUcRhiHYrSFZNlUGJ4CA8FnhFQ
	 LmxRSX+RAprgeZ9gcwv3L3jWHjtdC4pkN6ruL9m7v3yIReS85mQZ46tbvnsR5R9UNj
	 if7TjBVbP1HjA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] md/raid5: discard accounting and llbitmap support
Date: Fri,  5 Jun 2026 15:26:36 +0800
Message-ID: <20260605072639.2434847-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Hi,

This series fixes raid5 discard IO accounting and lets llbitmap arrays
use discard to convert llbitmap bits even when lower member devices do
not support discard.

Patch 1 accounts the full-stripe range that raid5 handles before discard
is split.

Patch 2 advertises a UINT_MAX discard limit from raid5. Lower discard
support is cached in r5conf when raid5 sets queue limits, and unsupported
discard bios are rejected before stripe work is queued.

Patch 3 lets llbitmap discard bypass the lower-device support check. If
lower discard is not supported, raid5 completes the accounted clone after
md_account_bio(), so llbitmap conversion callbacks run without issuing
member discard bios.

Changes since v1:
- Account the exact full-stripe range handled by raid5 before converting
  llbitmap bits.
- Always advertise raid5 discard limits and move lower-device support
  validation to the request path.
- Cache unsupported lower discard state in r5conf as
  raid5_discard_unsupported.
- Keep llbitmap discard useful even when lower member devices cannot safely
  handle discard.

Validation:
- QEMU RAID5 discard test with devices_handle_discard_safely=N:
  llbitmap bit conversion matched full-stripe aligned and unaligned discard
  ranges, md discard iostat advanced for handled llbitmap discards, lower
  member discard counters stayed at zero, and normal RAID5 discarded no IO
  when lower discard was unsupported.

Thanks,
Kuai

Yu Kuai (3):
  md/raid5: account discard IO
  md/raid5: validate discard support at request time
  md/raid5: always convert llbitmap bits for discard

 drivers/md/raid5.c | 74 +++++++++++++++++++++++++++++++---------------
 drivers/md/raid5.h |  1 +
 2 files changed, 51 insertions(+), 24 deletions(-)


base-commit: 717359a168bb66ac95f6161715d17e491ee86ca7
-- 
2.51.0
