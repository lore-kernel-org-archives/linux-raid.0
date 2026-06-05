Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752E635B12B;
	Fri,  5 Jun 2026 03:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780629732; cv=none; b=VQ2YUpsVJTnMQgD3RPas86HiR6CcfRB5JLbk5h37tTvnHPNMI4qyneDB9KuEK9bl6VtmggNa5gONkX02fjovgD1+jZb+fSbFMnJQtgRTr1uUfwGmNGovbtdWip6o4xwTIanuAukBcWXUbw8Yc8+ZsPzWTg1rg6UkPNbwHjrcVWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780629732; c=relaxed/simple;
	bh=tZnGToyKwTdOKRnPy7Tzm9R7dbBsR4ZKwuyC9v2f/S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZGDqlLE8nvc+v3tgm4QZK+nl1zTyxEINmbGqHPm3WhWhPqyGlN+s69Cf7+rcyaJTDQBN+Gmf+RyGOfBv9n38COSsNMfUzz65Kjfc6qNsVAsu7UX5d+eYxBG+W1EZYs0us8VgUfgoQHHICssaZUMVUt5WHMMA9/jqZhRFpGZ2Ig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmgdFPcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmgdFPcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D93C1F00893;
	Fri,  5 Jun 2026 03:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780629729;
	bh=ytazrPqN0+oYFTYcLsyjtt1uiJpVmjZxjogBPj2rBBw=;
	h=From:To:Cc:Subject:Date;
	b=AmgdFPcUBlzSRAZL05pCw2hE+BCtyGPmqvIe0xLmHPTVXkdnWWdHqhZvMNkPIAHPX
	 QnXfnCRVTj52Z17qqZzTzAqgw6XNsMDossV1srzuCiH5PYjqPuNNgXKgcvsxc4QpqO
	 Lu/z/WY130C3y6TSc8KfLafyUTHIC8lyfUlpZIOKIv8Nqo6JF+alkdUEr9KjUMu9ru
	 tdZT364AuTTlJu1q1nISVz1u1kRcIS3QSEVgll6pPy5CvUBthqbw1hss2k3ln6fuJX
	 Aag9w6wPsW/pm5Eh1f5R7G6bMOFP4gmFK9la5+E/Vr81j0MLNXjHVt/bHOP1R6bEF6
	 2ZSQM9LlbPW+A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] md/raid5: account discard IO and allow llbitmap discard
Date: Fri,  5 Jun 2026 11:22:03 +0800
Message-ID: <20260605032205.2376714-1-yukuai@kernel.org>
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

This series fixes RAID5 discard accounting and then allows RAID5
discard when llbitmap is enabled.

Patch 1 routes processed RAID5 discard bios through md_account_bio().
Since RAID5 only discards whole data stripes, it accounts the exact
full-stripe range that make_discard_request() will submit before
restoring the original bio iterator for completion.

Patch 2 allows discard without devices_handle_discard_safely when
llbitmap is enabled. Legacy bitmap cannot record discarded/unwritten
data and can make later partial writes plus member failure reconstruct
inconsistent data. llbitmap records discarded ranges as unwritten, and
RAID5 already uses that state to force safe recovery paths before
relying on parity.

Runtime validation was done in QEMU with a RAID5 array using a lockless
bitmap and discard-capable disks. Multiple aligned and unaligned
blkdiscard ranges were issued while tracing md_account_bio() and
llbitmap_start_discard(); the llbitmap unwritten-bit deltas matched the
traced bitmap ranges.

Yu Kuai (2):
  md/raid5: account discard IO
  md/raid5: allow discard with llbitmap

 drivers/md/raid5.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

-- 
2.51.0
