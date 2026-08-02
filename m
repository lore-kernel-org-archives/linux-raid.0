Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430E3002B9;
	Sun,  2 Aug 2026 19:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700331; cv=none; b=h1d3+6odtg98hmauGNb/Ji5Xa1e9wkh5a8EGcPW0BJv/5DotyA/AWr5vVv/GGXGlMulxZlO9vp9/FKF7rB5Tq8ybCQJOGTy8TtUxaaClBXZpLSwqVD8lYSbC/TBBBL3L7GZJb/v+hkGk+QURWcwiumnBqr/oZS0YYhvC+64ECq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700331; c=relaxed/simple;
	bh=lMhVaco/SDj4s/Zyd25s68j2bJCfLMQMZnOj6XaWJiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB8vT/dt5wRgGaTYru42s1IaLnCJIS/OytZeNmv8+NqNC2sxxiJSIQrnbklBBaVPCnK1pH7MOq7d0zksw6ns83BOhjR3QZ/435KnzQDBlHJl/xRU33+ef/8/rZBKYNIgh0h74FvyCFsK1e2u985/x9xngzaRRXcZ3OCLCA0lGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXO92nPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXO92nPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2165E1F000E9;
	Sun,  2 Aug 2026 19:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700330;
	bh=pVx/726z0oTAQs76I7NOHZZBH/dzptQlPlB6PmCSfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXO92nPHhawLH2NnRny0sy4J+/rOcXNDSbGsJ+wpkjU8tbiCag0+yFvHWDXM1zAeb
	 MVdO1WtBesDT4nIW9hP6ppC4FPtZmbmS1KOvkM02nhKlYpKd7QOcH8d5NZRdcQVlIW
	 H4+qYFtir1z04pUO29+hlmmlvFISHdXB16NkAUEwhignKt/oQ2i2skqwE4HB5hOvxp
	 xkxUUqFXGk9BpcIvz9jSmFFM2vQrYQqzQhtAhFRnJEAP4tEtuAlUxcLtSTyU8h8nYl
	 OQSwSYvFgPVe/tYTJ/8A/3AbgTG4Lle/xNFmhihQpM/B8YWxMPp4kasKzlA14gTqOK
	 UZexARfkOyBlA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 23/29] md/raid10: reject llbitmap reshape when md chunk shrinks
Date: Mon,  3 Aug 2026 03:50:32 +0800
Message-ID: <20260802195038.164272-24-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range.

The llbitmap chunksize itself will not shrink when mddev->chunk_sectors
stays the same or grows. However, shrinking mddev->chunk_sectors can
shrink the effective data range covered by each bit for the RAID10
reshape geometry. Reject that reshape while llbitmap is active.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ed3c6fbe65f7..1c3393467667 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4245,6 +4245,10 @@ static int raid10_check_reshape(struct mddev *mddev)
 
 	if (conf->geo.far_copies != 1 && !conf->geo.far_offset)
 		return -EINVAL;
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
-- 
2.51.0

