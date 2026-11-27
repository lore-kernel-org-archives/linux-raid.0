Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739568;
	b=ZKMQ31R1QWBvVYgKm6LFa8fQDZKux82UBDl+AAOs+4elE6u70VUg4Ic8uY4O+vASOcHH
	 IHGqtKiuk59MjhreUV+ABtL7bWqB0gawewpRp4PQU1MI72heh0Oi6Mm+vi6IequAzoyhU
	 I6bS8F3dpRLY3XCk8AWcst39fDqIYNO6Y0cULNgpgSPyk8muSuhdmlCMIiURbHXnV4D45
	 9FtuzTVDQMpEZQIqd1ZKQcgg88iHFX9GIly10qACgpi63kQeeMAqPiZTeRFxtU1z/jHoJ
	 896jhog1SWKRPP9LAmEvUcVlUTzvmAyhg6cULUGsnFYYWWaMZzDBBHowMSgZ4QFwZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739568;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qR0WUMUeJHcRf8YlnPXpXVTgmNqYGXUdVyF1Ch990rA=;
	b=BJru/61c5BCYoAgsiT9WNAl/N2LDl+/Nxw/d1Um8jbZ2qjTrm1ar3EX6/IiKWXP9iO0v
	 X8aFgSKXhSqnQEbZgCVGwTF+g1+cbzdjugODWv/pKWrpSUYUliBzV5+36aU/b1SvIEJwf
	 eRQtg+gO8aOCKKjnpdfOnG6qnPYBtAL9JnYEZjJh0vIxYJl/Ags6X9gWk9LEHfS9xhwHV
	 uZOWCjSbxWzMcPjcV9FRkkwYwYJk7I4zUy2hwUttmQCULNK6fqwtnJdTSNm1Cz6khCdi0
	 t118rvn446P4MB1kV20VI76Ym8QNC2g4FNl9bnvUDNYfibxS/S3dTL+26FoGVzYZG8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=33FK9ZnN;
	arc=none smtp.remote-ip=79.135.106.112
Received: from mail-106112.protonmail.ch (mail-106112.protonmail.ch [79.135.106.112])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80571606A31C
	for <linux-raid@vger.kernel.org>; Fri, 27 Nov 2026 00:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80571606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=33FK9ZnN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739565; x=1795998765;
	bh=qR0WUMUeJHcRf8YlnPXpXVTgmNqYGXUdVyF1Ch990rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=33FK9ZnNRuyrYaOkxreAsqgU6xQc74iG7XunmPp1VCfGhtcwFVDaZgJe6mUz9fqKv
	 dJZq9VYhQScmylTZ2hWizkNpZaVw1MqwFlUCWScfZIlrY/AfIBgp3Cv+XZtufZza2p
	 +p/+rKghJEKQ3YEbj/Tt/RY2C4N1rj1RtbMtZhJ0ZqwvnYLpkERIotXUVLrx71HwUe
	 BVAO+qCGEryaOVpzoLHZ6US4D6mWuJhpDLVHXYuFehYoxgu3niqWWR5usbYHMmVwKe
	 9jgxB2C9TjPx/gZ5oXGi6f/9smiOQEnJGYRTmcJfdtXvZJJCkM4SYuyE2biYklsV0E
	 D7lYtNXmEIY5Q==
X-Pm-Submission-Id: 4jbDs66Rg2z2SchD
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
Subject: [PATCH 2/8] md/raid10: wait for the devices of the write in wait_blocked_dev()
Date: Fri, 27 Nov 2026 00:32:25 +0000
Message-ID: <20261127003231.1180197-3-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127003231.1180197-1-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
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

wait_blocked_dev() checks conf->mirrors[i] for copy i of the write, but
copy i is on device r10_bio->devs[i].devnum. With more devices than
copies, a write to other devices does not wait for a blocked device or
for an unacknowledged bad block on them. With a far or offset layout,
the bad block check uses the address of a copy on another device. The
write can then complete before md records the failure or the bad block.

Check the device of each copy. raid10_handle_discard() does not set
devs[].devnum, so discards still check the first conf->copies devices,
as before.

Fixes: f2e7e269a752 ("md/raid10: pull the code that wait for blocked dev into one function")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid10.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a65bd65ae7bd..a97831823c68 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1273,9 +1273,11 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 retry_wait:
 	blocked_rdev = NULL;
 	for (i = 0; i < conf->copies; i++) {
+		/* A discard (sectors == 0) does not use devs[].devnum. */
+		int d = r10_bio->sectors ? r10_bio->devs[i].devnum : i;
 		struct md_rdev *rdev, *rrdev;
 
-		rdev = conf->mirrors[i].rdev;
+		rdev = conf->mirrors[d].rdev;
 		if (rdev) {
 			sector_t dev_sector = r10_bio->devs[i].addr;
 
@@ -1300,7 +1302,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 			}
 		}
 
-		rrdev = conf->mirrors[i].replacement;
+		rrdev = conf->mirrors[d].replacement;
 		if (rrdev && rdev_blocked(rrdev)) {
 			atomic_inc(&rrdev->nr_pending);
 			blocked_rdev = rrdev;
-- 
2.53.0

