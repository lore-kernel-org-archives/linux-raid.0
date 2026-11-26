Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795681438;
	b=j++6yGwD3iTxwS/VdZ0HqTZRkUD6wMDuOwxIrMlo9t2yFqHS11Lhjw52UfVNvJw8Jauf
	 KTOVlDODG4n6sXxKyNJ/vx9flkRJp1NkWPx5DFqtsV2Kzk1QEPWtb9FvzsSZD8ZXgz0XC
	 kxbmGS7MWUr++fDtUbzYsECGj2IvaEn/V+0EXjZziH2EkEiTHcVZepv8GOvJBepHTePnE
	 7nkGQAiRqr/GwdfIW2uWjm+wR3D7NrZn62JafU8kcx+UCn+HAGnNPWaAQ3qTzWeM96Rpj
	 BtC5rffCy5AHlbZaIRRvYjQjLkuN+5wyR+2e7lTbvK/VpdaJMVeu9if5k+uwucGvBxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795681438;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=nMb0vrZtB0rCGRBMD5Szuw+BH4dPouiVXcf115w+KNw=;
	b=rnzB2KjG2xbFC7cjIvFYAZybKG67cgWVs9+C8jd6pcgwdxwgM2lvYOl7o2kiItA+Y8BH
	 Ljet+GViU6VT2PA36Mswoxup6RBQAlF3K5BnVg9G7rGYSU+Vi/7ur0PoI+L6W/na/EAdr
	 mz8y9CW0uSv2zKKJL+4Jq/9/bP5/ep095OBTtw+nDeH/ehRgrYSGmtxHndIXc48D4IHzx
	 NQddW8dQ0whiqnjODvZWnBF7raXitINYhNncbD/xzBqqFsmBahOqLQ3o+uxLYgczLroro
	 yIPkEAD6T0BHL64297ikuGsJAEwU7AQXJDmElTNDCRiBWQfz9sTw8+Qb/q39lkChmXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=hA8HOQkU;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39004606A334;
	Thu, 26 Nov 2026 08:23:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39004606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=hA8HOQkU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=nM
	b0vrZtB0rCGRBMD5Szuw+BH4dPouiVXcf115w+KNw=; b=hA8HOQkUV2bGT03qz6
	UTMo1Yrd6/sxE4atV4Ebztcxkaax4U6dS34a27FmLFw535Yysj+L2hJhmvHX1Lfm
	25t7uinc1rLbnYp/tQZ3OKfUpJOuiX6tn4FtCsVP+wZjfNVdHkbN/X7NjP0im7ih
	g4GRcVPPXr5O2aL7vewfrRfxY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3H+V57AdrIumbJw--.34892S2;
	Thu, 26 Nov 2026 16:23:21 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	liyouhong@kylinos.cn,
	magiclinan@didiglobal.com,
	song@kernel.org,
	xiao@kernel.org,
	yukuai@fygo.io
Subject: Re: [PATCH v6 0/2] md: fix sync_work vs array teardown races
Date: Thu, 26 Nov 2026 16:23:20 +0800
Message-Id: <20261126082320.185482-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261126080821.144057-1-dayou5941@163.com>
References: <20261126080821.144057-1-dayou5941@163.com>
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
X-CM-TRANSID:_____wD3H+V57AdrIumbJw--.34892S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYCJmUUUUU
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3Rn1pGsH7Hl5MwAA3m

Hi,

Sorry, this series was not sent correctly (the patches were not
posted as one continuous, dependent series). Please ignore it.

I will resend a corrected v6 shortly.

Thanks,
Li Youhong

