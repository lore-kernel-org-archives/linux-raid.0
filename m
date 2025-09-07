Received: from ente.limmat.ch (ente.limmat.ch [62.12.167.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733401DA23
	for <linux-raid@vger.kernel.org>; Sun,  7 Sep 2025 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.12.167.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757268478; cv=none; b=U/o2aghGxfRYuPukdM3HhYxbV6arPiNc92b5s55UwH0u994oQjuHjOtnlQYzU3dMQU2H88nxFxSQRlqoWaH38659w9s+jFO688bB016NItx8rkPM463SUJhNCjL2FKTwr7myZ/h35sK3L3iaefyUweJM1LDA8ob2TsYP52RwR+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757268478; c=relaxed/simple;
	bh=Tpu28VCvKvkSq9tTZkKZkwsjxVDCW5TriU81YoUsT7E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Alw1qSTlY7MTveSeXfTJpBCdkYtkGrVufRiTS4rxDqzgKDzzE2V1ZxfHgC4bidBjWhIafvgIGooYCEpTFQuooo421qiqmTtJlld4hZVKqkRU17mNXbNpnVWxh3HkLCLnZfa5wmyt3IHJpCjdYs3ttixZZz0d62BYA5VEiqjkWcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mailgurgler.com; spf=pass smtp.mailfrom=mailgurgler.com; dkim=pass (2048-bit key) header.d=mailgurgler.com header.i=@mailgurgler.com header.b=alLbprZS; arc=none smtp.client-ip=62.12.167.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mailgurgler.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailgurgler.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailgurgler.com header.i=@mailgurgler.com header.b="alLbprZS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=mailgurgler.com; s=main; h=X-MTA-Admin-Wish:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Message-ID:Date:To:From:Cc:User-Agent:
	Content-ID:Content-Description:Content-Language:In-Reply-To:References:
	Autocrypt; bh=GPxUitLaH8LRUYTJODp281VXSDNOML6deDlgD+qltW0=; b=alLbprZSZ3gHD0x
	KYloVIXL04QiHZXrMABhe821VnXPE6eOXGDlFC47cinFz0hVyfOsR8ysnUVR8SrtNiX6jTSKfa+Wv
	VGMrvryYeeab7luw8uMzgSYCFIs8eHUJSzIQHOM0EfmONdW07QNaoTjREVzrqBrpBe/vNsc3WfVzP
	JkJYsRooxaAPP32nnngSCKb4Kpjw0ABzhgdqO0egePY8RhJvsix13afEYyeqVUzzBbMN5WGg3gth3
	av78wCLLMiEc0OlTN2rA17mBG59cntdNXX4yaadf0RINaeHN/ccYcopNQv7GimxdCHaypSNnJaV7z
	zKg7MJp7Fp21p2UqIvw==;
Received: from yoghurt.3eck.net ([62.12.167.105] helo=pave.localnet)
	by ente.limmat.ch with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <vger.kernel.org@mailgurgler.com>)
	id 1uvJns-0004l3-99
	for linux-raid@vger.kernel.org; Sun, 07 Sep 2025 20:07:52 +0200
From: Adrian Zaugg <vger.kernel.org@mailgurgler.com>
To: linux-raid@vger.kernel.org
Subject: deprication warning using -a mdp
Date: Sun, 07 Sep 2025 20:07:52 +0200
Message-ID: <4892474.rnE6jSC6OK@pave>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Welcome: ente.limmat.ch
X-Virus-Scanned: ClamAV on ente.limmat.ch
X-Spam-Scanned: No. Real men don't spam. (user authentication succeeded)
X-MTA-Admin-Wish: Preserve the environment, save the climate.

Dear List

I just saw a deprication warning on a new system creating a RAID1 with 

	mdadm --create /dev/mdX --auto=mdp ...

Could you please tell me whether support for creation and handling of 
partitionable whole disk md raids will stop in the future?

Regards, Adrian.



