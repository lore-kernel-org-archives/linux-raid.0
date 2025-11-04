Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8D28BAAC;
	Tue,  4 Nov 2025 09:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248933; cv=none; b=ZxDlIAkiQl39wyB0ZsQ1TrzEQELamAXsk5WfWYt7Qg+R/ckQAT6qo4WhmgpHMEPDRLdQ01kUTAo+0/kCXJvpCnKDTc/Dq+yoHIFFSEedk4W7qH7YTPlu1o0HvDZmnvLmUsciPwmrvI6UVxOSzA/ociWyNSgsge2Stlu1bsgTmNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248933; c=relaxed/simple;
	bh=XMD8TANEtXECSKK9Ng8UgZR7axegP600gBgm5BHz/R4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f00KBxGQfZh+HD8LytD3i+WclXuZLVHJOg8X7gHjf7N2uvSi2yHd/9osjdsTjijfGimmyL1an+u8+OCMGv5M+ftQWiVc1V8Yr3VRjNs0eKVZAgNwo5gB4NzUpB8NLZTE0PZpQtpFinAnL2efnnw04mTowKgEBTGhSeWvXjzWVW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9656171cb96111f0a38c85956e01ac42-20251104
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:85259506-c26b-420f-90b3-57392c75403b,IP:10,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-25
X-CID-INFO: VERSION:1.3.6,REQID:85259506-c26b-420f-90b3-57392c75403b,IP:10,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:a9d874c,CLOUDID:335364dfa2d204c9802a259ee09630a6,BulkI
	D:2511041145562MOEYBME,BulkQuantity:4,Recheck:0,SF:10|66|78|81|82|83|102|8
	41|850,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9656171cb96111f0a38c85956e01ac42-20251104
X-User: hehuiwen@kylinos.cn
Received: from localhost.localdomain [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 955304947; Tue, 04 Nov 2025 17:35:23 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: xni@redhat.com
Cc: hehuiwen@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Subject: Re: [PATCH] md/raid5: remove redundant __GFP_NOWARN
Date: Tue,  4 Nov 2025 17:34:49 +0800
Message-Id: <20251104093449.1795371-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CALTww29GVOw3sk2=A_9dj5QMGtfogRjxRsunc1D74AqLFj_MyA@mail.gmail.com>
References: <CALTww29GVOw3sk2=A_9dj5QMGtfogRjxRsunc1D74AqLFj_MyA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Xiao Ni,

Thank you for your review and feedback.

The reason for removing `__GFP_NOWARN` in `r5l_init_log()` is that
it is already implied by `GFP_NOWAIT`. However, I noticed that
`__GFP_NOWARN` is used independently in `raid5.c`, so removing it
there maybe incorrect.

Best regards,  
Huiwen He
