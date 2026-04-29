Received: from mail.bitfolk.com (use.bitfolk.com [85.119.80.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2087E3115AF
	for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 23:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.119.80.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504143; cv=none; b=ROMKoPq4rgqhZnH6xptyJhykEygH3x9lIqSsXYwEND4t3lTHZG1Oi5Urp2qdVvrCviGskiuknUCyvhKQpqvG9Qm1gvbMhm2jtkm0GKG3iev8Dgsc/4SN+D9lH6r8LkrPKNCYdUaivrgDNi+vcaG3nMa/4u8P6x4gsLv/9fZ3WP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504143; c=relaxed/simple;
	bh=hQj3kN2TKIhj6q+AwRt0jeWhBt6RO6FYgQsA5Gu4tcQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qr//GJz9q6KK3LiL7+qudrhap4tA6kyzkcEHE/IRyx/yRZoGxxRQ9Z3Bz3raRPZDl0TchOLRcsw+RWz6038ZpDTWt1unUrfom6fxKI6bfoq9ZDUw0lyKx7cJoB1SkxzpoyyHlRNS0Jv3SczyfollaYR2j0PmfcWHTHj8M+yhXAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net; spf=pass smtp.mailfrom=strugglers.net; dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b=U62gl8MQ; arc=none smtp.client-ip=85.119.80.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strugglers.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strugglers.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strugglers.net header.i=@strugglers.net header.b="U62gl8MQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=strugglers.net; s=alpha; h=Content-Type:MIME-Version:Message-ID:Subject:To:
	From:Date:In-Reply-To:Content-Transfer-Encoding:References:Sender:Reply-To:Cc
	:Content-ID:Content-Description:Resent-To;
	bh=iGjtgJtD4HK2cKFMHakfHSaRiZZ5ZBm5DnykWqWJvwE=; b=U62gl8MQccenM4TjwiVly9iTI2
	5xb75rrlNetfb5MbplYqTMjiObS/nxvCi80m9ouq1hOqitJN68W44dOiby7VCx95ELPbxZHuJFBeA
	6SVzFxNVCBq2tLYDt01vLrrjkou/D413l99VcsxoFQPW63sz9eq5AMPYT5wNlwrXhiHclwXavKtO0
	RE2kilD9VkJa3wVAbEk5Wg+NskCH+qVoTh+Z17uowWTjkz+Lqs+bZOkEwaTpR7WdFavquDb6Jcbao
	c6Rt7ScOnebniLLlPtXaI7o/xvhl7yum4+gEscTVvoFhhOek/5fRtgjM5HzSMKRMIAskecItMApWa
	ve29Lbfg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.94.2)
	(envelope-from <andy@strugglers.net>)
	id 1wIDlK-0005oQ-CH
	for linux-raid@vger.kernel.org; Wed, 29 Apr 2026 22:52:10 +0000
Date: Wed, 29 Apr 2026 22:52:10 +0000
From: Andy Smith <andy@strugglers.net>
To: linux-raid@vger.kernel.org
Subject: Suggest me a cost effective SATA SSD?
Message-ID: <afKLmiyhEe4Om0Nt@mail.bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL: http://strugglers.net/wiki/User:Andy
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false

Hi,

I've inherited a system with a pair of these:

Model Family:     Crucial/Micron Client SSDs
Device Model:     CT4000BX500SSD1
User Capacity:    4,000,787,030,016 bytes [4.00 TB]

Their write performance is terrible. Struggling to get 20MB/s sequential
write. Their TBW count is low so it's not an issue of excessive write
cycles. I've searched around and established they are just really bad
SSDs. They also don't support SMART self-tests, which seems like a
really cheap thing to do.

I'm further confident that the problem lies with these SSDs because
there is a pair of much better SSDs in there and they perform as I would
expect. However, the use case for this storage is for lower cost so it's
not an option to just buy more of those.

So, could anyone suggest a decent low end (consumer/prosumer market) SSD
model that is known to work well without terrible firmware bugs under
Linux, preferably with power loss protection? Low write endurance is
fine. Capacity of 4TB ideally.

Thanks,
Andy
