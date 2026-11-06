Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793989255;
	b=Kgn2ANp2K67xp8LtiWsbuXOYI/5/cIgw2s6voxtcQR7i3s9oXDh4zjim4KnIhstAY3eU
	 rFWR8Uvcr40vb7A6CO9jx58bBqSUgUsz0yHy6c4kzot+MkSLBnFPpU629qDCmSrkhiIiF
	 HCBICteYUHkP8qighQalw6wUMLLL70oGFHXrFnLRfeuS/4wA2YP16iE5QbKM2P8FlMjpe
	 PRtq5vg0zeOH12Ae0b6xGylXEmUIqEPPYojQtscRdzhLOFfSFDAnRR+kl7rN1JFcevtFZ
	 KN02akaE8UQ6dciR6Ka1Ej1ClJbbrcJ/g6T9K6bjPxGhWA/m1WFbrvzZCxgRuD990mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989255;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=51begsGUfivuSorz69L8EKKXRls1v9NQ+e8dSf+Y5AU=;
	b=O1EgcwnI1gSW+giqthAWH4EfbRuUhbnX+wmJln2eXeIPXUnvKvSAnCI8EpsEo5p3Jqp6
	 jeub1M4j9jvvPxJtzmXeymV37fpZzErBuiHaZRTheG3odWI/PIRrRJpTu4ajugxmlRegf
	 5CIAOTodvsnXieKlZvntm+E/THTBS0ma8v48tSdeEkm2C2tKy7QxIvIfSVyG1MGN0rRoc
	 MQEZrD6ma23/Jwk1y/uF/imVmXcxI9SPqhfrC5L0OMkPp9OOmTazuvJxuf0ptnGT5+Agy
	 WyKClAac8km1ylvmCR28ycwjY3QmAkH3hYD2bxDZRub8M6QoCcv9H0hYEREQcd7d5OQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTps8VVV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A46606A32C;
	Fri,  6 Nov 2026 18:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BTps8VVV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793989254;
	b=JmW/gkOpw5uenbSgaUgmrJahefqZGC/ONX6TXUbh2x0hLnjOgrpNrN0+yZaGtBvMGPVH
	 b/8ci+3aDF0TamhUj3yH3YBWz0O0ShlirNLtdifz8d3iydJCj2qmNZQVlepTGKqARA69i
	 XOOE6Dvd3D10oMX6yNp68r/jLMFClJipc3Sfwu3kM7ivDyoQ5fyrr28SRCd9Uu6lGXe5s
	 CSIYGkZHz+HD2+ZRH0WFQH0yhwA2y9Fsk9jrGsb+nXCfULKy+f9QGp7XjAvDIW9PD9P92
	 hthr66ufmwnI4VlFljak0orE0tbiNySuoY7T8AspEmRTrQexwHxaiwr+tE8Og3ZF/Rg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793989254;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=51begsGUfivuSorz69L8EKKXRls1v9NQ+e8dSf+Y5AU=;
	b=QeZ4SMOM9tU7conema3onP39xOMHSD2+o4ZKJytKTXQy1ujW6MJoO7gGheGhuKaxnHdD
	 pzbT5MZmvIH2ZeCpuVfrcjl/fKJ1ki8nOFOBX/CqnZB+YnnuteDvfHjZ8yxcf9C0PnszE
	 +JcbPRXG8DZIShsn7n8CrFgLbOElImI7sB5DPwVsJSStM+kzbeTzmCItUPkTUKs4isu8S
	 izfmAq2leO48vaJOwQm1C/nm03jtZ+/hp5mzCAiQTRPUGlnYadedaZ8/15ERPEeUUeidd
	 10jf1gyESjQfTo+Z+lHPRv0hBQZ6mkA+6Va0VoGe5/CpxyPi79ltY+6gVLaF1K8TLKw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 323E11F008A3;
	Fri,  6 Nov 2026 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989254;
	bh=51begsGUfivuSorz69L8EKKXRls1v9NQ+e8dSf+Y5AU=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=BTps8VVVQkxxSu11kvfnR7JDC2M+AAh3gObFseLZWRat1nKWvlATKw28GA7WbUc1G
	 V8qOkywpdnXa+YYFTNwMbmgbdQGWmUNBoliVzTmkwDvP8V8wupFYBVIOnvGHhI/DkC
	 0NS0dDieB9oR55X66C59S1lEAbDTOaRZ+rbsHwPRzsmTTFOWcZ7IFp+f5ZhzRcYFDK
	 bVP82AswnnLBH/w9e6Ga5c42+SnTdIjXOIJUI/a2zBmiu2mYy5FutKAX1BOIwGgOrn
	 kVv8RORTzC3SqwiEnjMoYB3XhZPcS5jbQaMehXKqhzhOLEU4hUugVzK00jRSst7jfl
	 z+dxtLA8fXPHg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 940C945E39;
	Fri,  6 Nov 2026 18:20:53 +0000 (UTC)
From: incharilla via B4 Relay <devnull+incharilla.incharilla.site@kernel.org>
Date: Fri, 06 Nov 2026 19:20:08 +0100
Subject: [PATCH] md: dont warn about sb update on auto read only arrays
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
X-B4-Tracking: v=1; b=H4sIAFca7moC/x3MTQqDMBBA4avIrDuQqIzYq5Quohl1wCZl4k+Le
 HeDy2/x3gGJVTjBszhAeZMkMWTYRwH95MLIKD4bSlOStYbw49GtS0Rl5zGG+Y+pw91pwKavPFH
 dGqoryP1XeZDf/X69z/MCqaYV42sAAAA=
X-Change-ID: 20261106-md-auto-read-only-sb-warn-7c3d66490643
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fnnas.com>, Corey Hickey <bugfood-c@fatooh.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
 incharilla <incharilla@incharilla.site>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793989253; l=2603;
 i=incharilla@incharilla.site; s=20261106; h=from:subject:message-id;
 bh=+Wd6+KQm8viRtD/x34JdBjsIzmmj3vcZRVUKHpYuaGI=;
 b=ipL8t19JS3Mm0slekkicOmxJ0gwtSHfF1GGUH3z36OC+7GEwiABPyFZ3R6wIfsRRw+5JQ9BP8
 UGFQCnt/q1CANoKkBDYueW4IXWCsQM3WL9c2u9Zh5cFTno706XykKj3
X-Developer-Key: i=incharilla@incharilla.site; a=ed25519;
 pk=xE5D6YKyyCtab6ZeeJEA15KoJWTPKAxBRXCtRrslYk4=
X-Endpoint-Received: by B4 Relay for incharilla@incharilla.site/20261106
 with auth_id=1436
X-Original-From: incharilla <incharilla@incharilla.site>
Reply-To: incharilla@incharilla.site
Content-Transfer-Encoding: 7bit

From: incharilla <incharilla@incharilla.site>

Commit 8c9e376b9d1a ("md: warn about updating super block failure") added
an error when md_update_sb is called on a read only array to help debug io
hangs.

An array that is started auto read only prints this error for no reason.
This happens when it is assembled with start_ro set or when a degraded
array is created with start_ro set. md_update_sb already defers the
update by setting MD_SB_CHANGE_DEVS and the sb is written as soon as the
first write makes the array read write. No io can hang on an array that
has not been written to yet.

Skip the message for MD_AUTO_READ the same way dm raid is already skipped.
It is still printed for arrays that are really read only.

Tested in qemu on loop devices with raid1 and raid5 and raid10. Before
this patch assembling a clean array with start_ro set prints the error
for all three levels. Creating a degraded array with start_ro set prints
it in 5 of 10 tries for raid1 and 8 of 10 for raid5 and 4 of 10 for
raid10. After this patch none of these print it. On raid1 the first write
still makes the array read write and the sb events go from 17 to 19.
Assembling with mdadm --readonly still prints the error.

The fix and the qemu test were made with help from Claude Code.

Fixes: 8c9e376b9d1a ("md: warn about updating super block failure")
Reported-by: Corey Hickey <bugfood-c@fatooh.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222162
Signed-off-by: incharilla <incharilla@incharilla.site>
---
Found from bugzilla 222162. The qemu test script used is a busybox
initramfs that creates raid1 and raid5 and raid10 arrays on loop devices
with start_ro set and counts the message in dmesg.
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a80283032e317e037a749eca23ce170e..a0fc6028990530026404f0019a458dfabed02349 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2819,7 +2819,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (!md_is_rdwr(mddev)) {
 		if (force_change)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-		if (!mddev_is_dm(mddev))
+		/* auto read only arrays write the sb once they become writable */
+		if (!mddev_is_dm(mddev) && mddev->ro != MD_AUTO_READ)
 			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
 					   __func__, mdname(mddev));
 		return;

---
base-commit: a91337fb5e8e0127c8b5be87be9f3027f95b48bc
change-id: 20261106-md-auto-read-only-sb-warn-7c3d66490643

Best regards,
-- 
incharilla <incharilla@incharilla.site>


