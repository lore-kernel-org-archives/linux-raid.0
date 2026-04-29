Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5FC2417D1
	for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 23:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504856; cv=none; b=uo+KMGtGjwnOsbv+nP1lkCYHTWYEkCimEfqAB2f2C5EVRq/dP+fLmoQxz5jwEusnnMTNh7wZLs/c1SEztXrwChxs1zej/2GJvALGro6lLZpwAkLXMG5tUlL8ICK28cvRbvCTc3TlftDx4VVqK/JUoN0tWifJRUyRCyz8A8qIGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504856; c=relaxed/simple;
	bh=3ZMtjhtuRHP7jwixg6YVq8TWKOKXJ0ruYuLqEQvZOeA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nee35zEDGK9/xRQ6yIbRVDE7DuqoMa09oOJvtvDiP9eSZOIGI+vlxgfN8r8ppmAlLo0gASbI4CK7ByNrupzbMOVlryqKCG/pXbtg/O4trtX7LtQOEQSuQsbhsU91+Lo9iEhXoQCxnTl00GOyU4JXmg0vLCy5B7qFhh15sSosqp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id BC16E4126D;
	Wed, 29 Apr 2026 23:20:44 +0000 (UTC)
Date: Thu, 30 Apr 2026 04:20:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
Subject: Re: Suggest me a cost effective SATA SSD?
Message-ID: <20260430042043.1c0e5e11@nvm>
In-Reply-To: <afKLmiyhEe4Om0Nt@mail.bitfolk.com>
References: <afKLmiyhEe4Om0Nt@mail.bitfolk.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Apr 2026 22:52:10 +0000
Andy Smith <andy@strugglers.net> wrote:

> Model Family:     Crucial/Micron Client SSDs
> Device Model:     CT4000BX500SSD1
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> 
> Their write performance is terrible. Struggling to get 20MB/s sequential
> write. Their TBW count is low so it's not an issue of excessive write
> cycles. I've searched around and established they are just really bad
> SSDs. They also don't support SMART self-tests, which seems like a
> really cheap thing to do.
> 
> I'm further confident that the problem lies with these SSDs because
> there is a pair of much better SSDs in there and they perform as I would
> expect. However, the use case for this storage is for lower cost so it's
> not an option to just buy more of those.
> 
> So, could anyone suggest a decent low end (consumer/prosumer market) SSD
> model that is known to work well without terrible firmware bugs under
> Linux, preferably with power loss protection? Low write endurance is
> fine. Capacity of 4TB ideally.

Basically the main thing to avoid is QLC flash, and look for TLC instead.

Low write speeds and low endurance are all due to the QLC, which prioritizes
capacity and low cost in favor of performance and reliability.

Consult the SSD database at https://www.techpowerup.com/ssd-specs/ about your
potential choices that you see in shops, for what flash type they have.

Or conversely, filter by TLC: https://www.techpowerup.com/ssd-specs/?type=TLC
and then add search term of your favorite vendor to look for candidates to buy.

Keep in mind this info may not be 100% reliable, as it is crowd-sourced and
way too often hidden by the manufacturers, or flash type is switched back and
forth even within the same model.

Side note, I would not count on SMART self tests as being relevant on an SSD.
Sure, on HDD they can scan the entire surface looking for unreadable areas. On
SSDs, what they could do? Read out the entire flash? From the duration of even
the extended offline tests on SSD, they are not doing that. It is opaque and
proprietary as to what they actually do, if anything.

-- 
With respect,
Roman
