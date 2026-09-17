Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F93B0580
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634369; cv=none; b=dfrkS4ztlFM7Xlyh1+/tdUeYFbizNvz4ZZgVotwPtN+2+7PbFvOJ0gBSX6RXP36NDYKCIULKhvsrjJIV7RTGdvuAX7RaasU6GxzyecmVnEpiUgSIEOABN9I050ehvMQuPnhYODxYJadBznf5PoNUSXHpoTTmm+pObdHINZm6Pmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634369; c=relaxed/simple;
	bh=C4kFc9I6aVRIR23qveBzfUYCOoqafUcO8GKRY8IEUQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmqgB6zoQXm/F7Hs2+RfkG891m0OB69aw3ctfQWUDkPG1qyMnCUO/ADcA5iA06soRhLiiCCeFsqWXx0c4IAaD6pOP4SQTcYLQhPSCRGPbIhS/KO5oG5HIXuoHws7LebsSq7Y+w8m4i2v/cDlVlxXBtlfaW5YiDOd+zcjU5hN8jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEFu//zu; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEFu//zu"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d90ba1d807so6662195ad.3
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 01:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789634353; x=1790239153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRUmR5tq1gmAFewuT5+MHhVWDUO1ZXIe6LR8I7vNdgA=;
        b=AEFu//zulXtVjumPlHI7xvNGFCO7l90G+bFXk8ZSNrV19JDF+veQ4oHp01BZ+AA+FS
         UbheYbgoXWzCdesBt9Cxlq5zAGC/wKc0/YwB7PsOsqvJs4vJ7KG6l7Lh3Ldw4qAEoRMx
         kt+e+YOYThjHK8P74TTL1jE+LJMJ2gk22yHJG7eSWLTEtR6ykL0nrzoI0p71XfBI9yfW
         1SkYVVsAJmUm1HqGKF4TXKPEeJNkN3PNscPfSVrY1OhIUMZoPxxIHHBGT15AtyIZcZ+k
         B3Uw2B8BTrkckErw10Lxu0CbvKVLk3u8Hi3xwzIvKNfrNx1CKYnXfieTHkB/J55sK96X
         tSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789634353; x=1790239153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SRUmR5tq1gmAFewuT5+MHhVWDUO1ZXIe6LR8I7vNdgA=;
        b=JSj0Ommwsrb2n5BWX2oGoDcj9SU85cREz9Gk9knBlp/NwLVn1JSNXdG0hgENcl/Ss4
         mRaWI8SktCO/yhDsg4+6xKwq8ZAwr/USBJsWw17HRzZ6fK55WL7AUNRMzl8gY3UHxscA
         OV0K52Xic2seTwfP39LyNpkulJ2/n40nG0sVdKBtvZ0BhYUsAmc5qJaBtw2gF0WrMXZ6
         dSfv1nwpYarQnrczXZ0TItTSOFOs6y4oWev2iD0RqYSuLcHXJ9IlgaCYvYAbCrVXkf3P
         DkCIkO1aQWON9kOe6Tmv2OYdi9Q13oAkEthb7XSSpv1SBp6+W6vQOPrbBAPJbKwve2oL
         2YlA==
X-Forwarded-Encrypted: i=1; AKwUvBx3GAtOxvT2q44zNh7sUUFenBDCCONBJXG73muR4ajxSNj8O1d3ebgjdozffDTHPRHPugdoyTx4e7sH@vger.kernel.org
X-Gm-Message-State: AFuF++lFMRO8om6XFxHG6Xo9rkePo4oXvi6x/+huAkJcssrZS98WBvOG
	0ks7HUrO+zFWxYhpEi7KB+DCEavxUrQqqLqYMlFp/+Uf7VKTwJ0VNuKf
X-Gm-Gg: AYBFou3Le2/gwT5g78UcTrfVtWpKtStvivnj2iZlv+vDqbw56aeMHCYrOW0WDzu+Tjv
	R9Q6KcRbTqMATeFtsomfqQP3bCXKdKVtFDfuSWrXF1kI+mXQpF2dsX2xcPqKXiqoCNOun53RQQS
	3SmXZQ5cTX1d0q0+DNiglBLNCgXwSCJDQeoEXriwZkzaQwLsfC3ugbZr94WXYOOEI+m8TtvW5Q/
	6woS1yGqnhn4CNuflZDgccYC0PEfNC15Jroz/xnQ4e9NYaH9I1No/5t5O8Q3drssUkWhkjNPrEC
	JtwWLEg4CQiCrEfWtLanA4WgYdMes0F1FgPiFgaauOLQuQOAxEuaDemituGCC9gHxjcR2fbBuYz
	96dbevp/AhAArLn7Sceyc7C206TVs8gh6b8+KbCCK9gPNwhcZi0ATLurMPnuLNYAhkOXLYdDSDi
	09OYz7XoZnsq1C6oFhqusI56c9jpENbQn/KZVltvcJuE9/SOeCXKaJ/AHSK57BawBALeoTL8vSb
	GKy2gaLQ+7SBvzhyg1vjPo2a2vrtA==
X-Received: by 2002:a17:90a:1c97:b0:39e:1fb6:9659 with SMTP id 98e67ed59e1d1-39e1fb6994cmr8667721a91.22.1789634353131;
        Thu, 17 Sep 2026 01:39:13 -0700 (PDT)
Received: from localhost.localdomain ([183.194.144.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35e56298sm3871317a91.9.2026.09.17.01.39.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 01:39:12 -0700 (PDT)
From: zjamg <ndaugoing@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zjamg <ndaugoing@gmail.com>
Subject: [PATCH 2/2] md: add defensive bounds check for bio in md_write_metadata()
Date: Thu, 17 Sep 2026 16:38:20 +0800
Message-ID: <20260917083820.57091-3-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260917083820.57091-1-ndaugoing@gmail.com>
References: <20260917083820.57091-1-ndaugoing@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md_write_metadata() allocates a single-bvec bio via bio_alloc_bioset()
with nr_vecs = 1 and attaches a single page 'page' (either rdev->sb_page
or rdev->bb_page) via __bio_add_page(bio, page, size, offset).

Because the bio can only ever represent a single backing page, passing
a non-positive size or a length where offset + size > PAGE_SIZE is invalid
and can lead to out-of-bounds reads during I/O submission.

Add a defensive check in md_write_metadata() so that any oversized or
invalid request triggers WARN_ON_ONCE() and aborts before constructing
the bio.

Signed-off-by: zjamg <ndaugoing@gmail.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d2433cf41e65..3fda2965c631 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1142,6 +1142,9 @@ void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
 	if (test_bit(Faulty, &rdev->flags))
 		return;
 
+	if (WARN_ON_ONCE(size <= 0 || offset + size > PAGE_SIZE))
+		return;
+
 	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
 			      1,
 			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
-- 
2.53.0

