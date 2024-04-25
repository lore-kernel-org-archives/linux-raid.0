Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171BB15250D
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714079657; cv=none; b=TQdh8sQvAYJXSFJHiSaCaWRNWjtAVPkRo3WTRzmHUd3HUVLMnVYzBxibN+cr9E4JANpHuN90qyjAfywrV7aI1EUCdsG12H0qTA8khQbbgJCi1oL4ZphyGiD/8kQle6wiV3kJWZIgwH5VRDr21tuZOdrnAKlg3rg/tx4TcZIzsdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714079657; c=relaxed/simple;
	bh=Zan+Yu+QNWJzqZG7Ren9JORYoNL+sEIJJmWVlWXqRL4=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=m1XicDrOa1uMfocDHsCLa3+7lNIubLLVTH61QNqOVB63AEEIbqpW+KzY9/8EABlOmtd8YAx1h6tCTI6qF3sOmPKQ84arKhC6Ttp90n79eFRXlVybZpXKUwT4Rxf4zbnW9eI5z8lhVkZb4O+2xGEFQ+9qoWFk0cxDFTv7r88avAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (unknown [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 2659F1E124;
	Thu, 25 Apr 2024 17:04:21 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id C76BEA0416; Thu, 25 Apr 2024 17:04:20 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26154.50516.791849.109848@quad.stoffel.home>
Date: Thu, 25 Apr 2024 17:04:20 -0400
From: "John Stoffel" <john@stoffel.org>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Move mdadm development to Github
In-Reply-To: <20240424084116.000030f3@linux.intel.com>
References: <20240424084116.000030f3@linux.intel.com>
X-Mailer: VM 8.2.0b under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Mariusz" == Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> writes:

> Hello,
> In case you didn't notice the patchset:
> https://lore.kernel.org/linux-raid/20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com/T/#t

> For now, I didn't receive any feedback. I would love to hear you before
> making it real.

I'm really prefer you don't move the mailing list.  I hate reading
threads on a million different web apps.  I don't mind the
developement being there, but keeping the mailing list is better in my
mind.


