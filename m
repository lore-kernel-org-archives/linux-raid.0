Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43636281531
	for <linux-raid@vger.kernel.org>; Fri,  5 Sep 2025 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757052241; cv=none; b=C4kjkI6IVugelflXhlomfKUtjLZu04c3dgHHjQfcIN7bxTW/AOdggqOEiEiB3eZhDKF39tH+vRjKrgrJVcjrEv2Zu6Hz5UeqCgMrpJQuUO14oWRsMifpb9FvJTBN7o3yRkaaNWT99cnoPMHvx4O44WfxuEttPT7vCbH8SSRRywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757052241; c=relaxed/simple;
	bh=5JMjunjiFhulmLSEq53uQZBV31KYC0kKio2ER/0e5tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sSqhwW/YB3zhZ06BMTyYR7oaEu4HLQwDfNq/Ca59KqB+uqC2EkbMzZUI9WOeuhg613c6n27m7XBbEHfOJcG95INgTI7XoQYyqoIe+AEVrsF90zd2Dp6YnWqs2CVowhhYehC6Q6Yetyc0Eozdvd4mXpLwoPpYy8wkf2kv8sU0/48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.247]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1uuPY3-0000G4-Hk; Fri, 05 Sep 2025 08:03:47 +0200
Message-ID: <c530b2d6-e85c-4bb0-8aac-68d0262986a0@plouf.fr.eu.org>
Date: Fri, 5 Sep 2025 08:03:46 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
To: Wol <antlists@youngman.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
References: <109aahg$34jlp$1@dymaxion.cjsa2.com>
 <37f99719-4bb1-489c-8246-e6dffc8b0bf9@youngman.org.uk>
 <109b62i$e2l$1@dymaxion.cjsa2.com>
 <d8fdc2a3-ef96-4e18-a0de-f962f6dfca57@youngman.org.uk>
Content-Language: fr
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <d8fdc2a3-ef96-4e18-a0de-f962f6dfca57@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/09/2025 at 00:55, Wol wrote:
> 
> 0.9 is an old layout.

You could say "obsolete".

> the difference between the 
> 1.0, 1.1 and 1.2 formats is simply the location of the superblock. And 
> it's always somewhere at the start of the partition.

No, 1.0 superblock is at the end.
