Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044644;
	b=qYIGKLEbz8GbcjPM5gRH9nwOXze1Aw38WYNQHSdVald57R8ce0P/x9nWLvYxtPI+Wq+R
	 tRIm/XLS6Y3CW0Jjgnst+RZIrn4WRUKhifY8KVjALWbvsWlVSzKUubOEYCtubKn6kCS5Y
	 kMShJZPB6TWsqUgJMq+DAH1neqHPSGawTZV4/PXQL5iWEipRnI6zszhFdO3Z6xZPt58Sp
	 +QEkSkb9913sQmLTwb7CiO0rWbXfFo/mz46RhNEMyfZuK1DZHJmXMbyGc3sxAd+FpOeNj
	 MMiJvzhblCdzUj3gXrEaJP8jRlxDxeZyahDfbuFLs3LZ9vIGxSjVND8oPafFfKUp6NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SSRy3Kou6RgDcrMUYyxjRgI7Ddq5E6pjX3+7QfjGyUs=;
	b=kbyjIOe40FDiIDbfmz3TEQkGwkF/nlwmexgXCZvprq2c7uCunV5EMcvQL/ecCEyRxRaO
	 Rl5YKhGas/rpOSl+7SVtJ+Ycn7WMj3aicHUMwX+Z3SEBP8AcMAYXrWQnPaghgqbOl6j2h
	 Fr97A7oLO7qpqYrV3ZopIJWl2JTp+PYqWI4rBvVzyP2XL0/OElfv700E7PSjwSBGEvto1
	 0TVSJgguR4UMr+1wumcGgqvbSg38//8OR0SQ0Jv0D/8RAZ8miIA9BYj8IWImfH3UAjcSs
	 bVFrjVe+Pt5S35GJ9kWGp9nx4DFZ7OaDgsR3ntPDJfDLKvXUkj/V3Kux327Jr3MV0qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=sZbwU1Wu;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578AE606A31A;
	Mon, 26 Oct 2026 19:57:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 578AE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=sZbwU1Wu
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jD4Cl5tltz1XM30g;
	Mon, 26 Oct 2026 19:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1793044640; x=1795636641; bh=SSRy3Kou6RgDcrMUYyxjRgI7Ddq5E6pjX3+
	7QfjGyUs=; b=sZbwU1WuXE8ZoI14mGevFozIrffkzi2urdjb+Jes2ZIIKE6Ho1Z
	FUPxrNa6QpbY9sXk3ZeOhM8x0NReEfTJkdO3BdS6yBn+eUXHyG4JLvmtj9eCNAqB
	nMxn7Cu9HW0ZzL3Jtn2LZArQDQIVa8kxTISgxH3/YmYNygKP8BSpU2lEhE7bUnI6
	6BjNOJygPxpK3IsGTvAOkfxhLOy9m4w6NdKM/L6XFdiqE1ZFvW793MeMRLkGTNcU
	PaIZmgU7kCUZ2NhnusqE5iETegaWosI0vb6E78tSKjPy7wtWWvdVDwHOFfwfzMJ+
	N9DjldKeAWlT8HxtR2To4a4Z+I1Ux0UPeww==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K7JP1SGDI2wu; Mon, 26 Oct 2026 19:57:20 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jD4Ch2Zpxz1XM4Tl;
	Mon, 26 Oct 2026 19:57:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] md: Fix an unlock in an error path of lbs_store()
Date: Mon, 26 Oct 2026 12:57:12 -0700
Message-ID: <9dd41992e8b2d4bd63f74a245d34fa7850529bed.1793044632.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

If mddev_lock() fails, lbs_store() calls mddev_unlock() although the
reconfig_mutex is not held. Fix this by returning the mddev_lock() error
code directly. This bug has been detected by the Clang thread-safety
analyzer.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac03b99f6428..7ce527073be9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6049,11 +6049,10 @@ lbs_store(struct mddev *mddev, const char *buf, s=
ize_t len)
=20
 	err =3D mddev_lock(mddev);
 	if (err)
-		goto unlock;
+		return err;
=20
 	err =3D mddev_set_logical_block_size(mddev, lbs);
=20
-unlock:
 	mddev_unlock(mddev);
 	return err ?: len;
 }
