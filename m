Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F8540B396;
	Fri,  5 Jun 2026 09:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650964; cv=none; b=T6b6C6Sca2G7IN36rRb30MSivCLyyZg0yIZ+wEwhslJjmwyWW10lCKN2SlJtAOu6kwigvIJdNxVvkg/U8FRmyR/ybFVMxGIY3Ugfcl5I4f7Fog6t+SQCTLRkQ48MvM2r6HXPi1BMY1kKBrgjDX3ZjeEd5ue/C6m14berrDNVTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650964; c=relaxed/simple;
	bh=shilwQvEFJ84rQFLgDkjn3KMi86EbS7tOxlRxEEqjZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7aqWiaEIrBmlugQofAT8Cmcic8rxMAGmo3RNDjH6GYzaWSRyI+gnIpoEwhFtJkrrts/tbpl9xTgdBn1RGnrd5UH0KoKVrRJiXpYJR3LVdsW1ed5Uke5kiahDODVLb49GArLlY/UsC9nXuwDOx6t1RNEryl05NXDTol442akQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIzclj6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIzclj6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744421F00898;
	Fri,  5 Jun 2026 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650963;
	bh=xyuJ8a3FCNuIQM4PLGaJyjh1NaVaxwhMl/KKNrWQ3as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIzclj6uSj6rj5UIaoZ6gK8/da/kWad+odFefN38H70Fhb8/PLtulJz3oW/nIevVf
	 lAbAsFINZl6ykZ6LjdkRWS/CTjW+wdZaUikS+r56lUS030Q8/harlEqYdDjHhxNYaE
	 RunlAP5EPuNNFj68uxF1XmCgoa5cgTiBaFlMjiEraCk+sOmZ15E0fJ+6dDZ1Yx4npE
	 wuGuOJY9RZ8XfMKTngT/hKDgNb1Go8cq/0LW7pjS7TmrlodIZvu6hiw5KK7/YqVB0K
	 Fqh/M9qPZPBiluA1/SP7xdCuJFWgRrBoCZ4t9YeoJukg3pf3qa7ISlLcWLJTPAHCxL
	 yM35hK6mNcKgQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid10: reject llbitmap reshape when md chunk shrinks
Date: Fri,  5 Jun 2026 17:15:21 +0800
Message-ID: <20260605091527.2463539-15-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
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

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5bd7698e0a1b..c69ef76c89e1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4269,10 +4269,14 @@ static int raid10_check_reshape(struct mddev *mddev)
 	struct r10conf *conf = mddev->private;
 	struct geom geo;
 
 	if (conf->geo.far_copies != 1 && !conf->geo.far_offset)
 		return -EINVAL;
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
 		return -EINVAL;
 	if (geo.far_copies > 1 && !geo.far_offset)
-- 
2.51.0

