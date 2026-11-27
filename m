Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739564;
	b=39dtHHEtWSmZadqPJKmq3mgDyZoK9VD/M9CvM8CdXGmaVoJ1uKN+O2NluUm7TWQF8C32
	 ea/rQ3kwovEIhrbl6CeJQ44dbXGV4tNVFpfN0yfPSJD6uzn8dx+DAEOg5U4h7HYVeiIoN
	 dSm15Nrj9mh1aNfHvb0meSXAexj1wz91/KlGCFPu0He+WHWXbC/8shIa1j5w39c6qE4HD
	 Semw6c+4YP8Gls0RVJvPELIQyzsMqQMTc9G5BLqTgbmt23NGSC3yRawnqIlxCEo8w8gIQ
	 lqnCNxi8J4c3kS3g4IW90EIwsOTnVBvTwDmxZPNuwXd8fpsHVWw6MpxxJ551lR/XHdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739564;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=p3UGcK/Qihu9tLy9k3dYKcdr4pLFzlCh9vcNGRGlWeY=;
	b=X8qLiNsyZu1qM/eQ1Ja+jv6XnvYuMIuIzwIX6lWp2l+nBgeE3RjanLiXu38nrBPCgIRU
	 MDKWkba1ynxPmLw3KRuvU8BHQewHHvOKCjVK7wIKJ8FZUs6UCL7y3FHPXFjI7LPEkIm2z
	 6ZwESjs16rxI8ujC3Lp6UpTGG6Psx6eZuQYAOxombKfp3AZtfQcm7QxIQsr7E5NbAQ3Iq
	 iwSll1CfevXpbgff5fpeOSBia8yl6JScVIiWzrbnpFecByk7DANACYRRxcFeNJiGc2zVg
	 YYp7O4/wdKZSz0ny5NKPwaeBndHCJ96Ffb/puy3JlAAdfUcNx3pCHadTiXWHASSrBYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=OQZjEAqW;
	arc=none smtp.remote-ip=185.70.43.172
Received: from mail-43172.protonmail.ch (mail-43172.protonmail.ch [185.70.43.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4242A606A31E
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 00:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4242A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=OQZjEAqW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739561; x=1795998761;
	bh=p3UGcK/Qihu9tLy9k3dYKcdr4pLFzlCh9vcNGRGlWeY=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=OQZjEAqWLNu1PebKQnB46ang+ZKqoyP275QALI68uXAFGT4hw92i12jr0tBZJJx+2
	 8fYvsNzgM/6gCMeTas6Icosl3+Ds7CAnkZIxeVqmWLNgVr0vMUgQ1bMVHRvwocjUKn
	 tLaC955oGY4zrUX97oiPDCCvfVJtA1R8LPK6tUombj2yaV5/8ewNl38lhPSt5wAuY3
	 LGx5Cn+xQMYlS/tW7Ci4O1eqlMoZwSHE3md3ZoniPxUaclLI9uXrBU5QtNYJg2BYMK
	 ctBSsfao0Aytyi+FsduASMoGqmtlki6EmX4cMZHQKwUu/+BmDW8hoC+SCYgyvy80Lg
	 Gp4MU/IQmBOcA==
X-Pm-Submission-Id: 4jbDs16WP4z2ScQG
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Kenta Akagi <k@mgml.me>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] md/raid1,raid10: fix writes acknowledged before a failure is recorded
Date: Fri, 27 Nov 2026 00:32:23 +0000
Message-ID: <20261127003231.1180197-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
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

raid1 and raid10 hold a write that failed on one device until the
superblock records that failure. This series fixes cases where a write
still completes with success, although its data is not safe:

1/8: the superblock write fails on the last working device, and reads
     can return old data after a restart.
2/8: raid10 waits for blocked devices by copy index, not by device.
3/8: as 1/8, for a write that waited for the superblock update.
4/8: with a bad block log, the device with the only good copy fails,
     and reads of the write return EIO.
5/8: a write whose copy fails on a device that is already faulty is
     not held at all.
6/8: raid1 can release a held write after it marks the device faulty
     and before it requests the superblock update.
7/8: a device that fails between the wait for blocked devices and the
     selection of the devices for a write is skipped, and the write is
     not held.
8/8: with write-behind, a write whose copy failed on a device completes
     once its write-mostly copy is done.

The MD_BROKEN checks skip dm-raid, which does not reject writes when
MD_BROKEN is set, so dm-raid can still acknowledge such writes. I have a
fix for dm-raid and a follow-up that drops these exceptions, both
tested, and will send them to dm-devel on top of this series. The other
changes apply to dm-raid too.

Patch 1 fixes a bug found with FuzzyRAID, a fault injection fuzzer for
RAID implementations. Patches 2 to 8 fix related cases found while
analyzing it. I used an LLM (Claude) for this series: it found the bugs
fixed by patches 2 to 8, drafted the code of patches 2, 4, 5, 6, 7 and 8
and the changelogs, and wrote and ran the tests. I reviewed everything.

Tested on md-7.5 with RAID1 (2 disks; 3 disks in controls) and RAID10 (2
and 4 disks, near and far), with and without a bad block log, RAID1 also
with a bitmap and with write-behind, and with failfast: 30 fault cases
in which an acknowledged write was lost or read back old data now fail
the write, and 20 controls give the same results as before (some now
wait for the superblock update). The cases for patches 6, 7 and 8
compare with the series without that patch, those for 6 and 7 with
delays added only for the test. All others compare with stock md-7.5. A
raid10 smoke test without faults (4-disk and 3-disk near, 2-disk far and
offset, with discards) passes too. Not tested: the race that patch 2
closes, MD_FAILLAST_DEV, dm-raid, replacements and reshape.

Miroslav Cimerman (8):
  md/raid1,raid10: fail held writes when the array fails
  md/raid10: wait for the devices of the write in wait_blocked_dev()
  md/raid1,raid10: fail writes that waited while the array failed
  md/raid1,raid10: fail held writes that no working device has
  md/raid1,raid10: hold writes that fail on a faulty device
  md/raid1: set MD_SB_CHANGE_PENDING under device_lock in raid1_error()
  md/raid1,raid10: hold writes that skip a newly failed device
  md/raid1: hold write-behind writes that failed on a device

 drivers/md/raid1-10.c | 12 ++++++
 drivers/md/raid1.c    | 83 +++++++++++++++++++++++++++++++-------
 drivers/md/raid10.c   | 92 +++++++++++++++++++++++++++++++++----------
 3 files changed, 152 insertions(+), 35 deletions(-)


base-commit: c526b7cd32f75fea6021ffdab287b81cf38ddeb7
-- 
2.53.0

