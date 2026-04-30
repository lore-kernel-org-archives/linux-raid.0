Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A262C08D4
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 15:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562535; cv=none; b=S3JhUvCe8hJRV6RpQF8IEi4t7y3razqBwD7rr6eAZBjeADfQGKR6SJcHocQe5fMAbRrSI5+eMmWts9mMi5s6Pp84GzCyrSUH5IB1paVJldadodLVMqGkINrpxeHreKsJynegsTmbw2+4yy/TY3aSrAYsiRlaJ8rXeJ+Bomx7Iow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562535; c=relaxed/simple;
	bh=aNzJtW5zQoxVXpH3yGFKKpwWAs1dJx09kUQ+zcMttVY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=mKISOSmWRPf/OLNffX40Z6Gu+9sJpsAlHknrZFpXtUIeR9R96urGEaeE83mEJ8UbjVO9RTFtKFRZKkxv5WKxCF2RuZnARRGutkb2TErhrzBiCDZV8/swKoB98ZAZM8FW+FyR4AA84EU0r6bnOk+buDFIrR93FfG9PxY2crqaIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7DDBC4C2C37F03;
	Thu, 30 Apr 2026 17:12:51 +0200 (CEST)
Message-ID: <92bec712-6b16-4ea8-bb7f-3cf6b06d0a00@molgen.mpg.de>
Date: Thu, 30 Apr 2026 17:12:51 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Yu Kuai <yukuai@fnnas.com>, Song Liu <song@kernel.org>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Why is mdraid not listed sashiko.dev (review by
 gemini/gemini-3.1-pro-preview)?
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai, dear Song, dear Linux folks,


Do you know, why this subsystem is not listed on the sashiko.dev [1], 
where Google’s gemini/gemini-3.1-pro-preview reviews Linux kernel patches?


Kind regards,

Paul


PS: LKML is listed, so patches sent to linux-kernel@vger.kernel.org are 
reviewed, but cannot be filtered according to the subsystem.


[1]: https://sashiko.dev/
