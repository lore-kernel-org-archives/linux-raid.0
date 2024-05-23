Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF37AAD31
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.238.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481826; cv=none; b=HRcQyPh5N1amfwvHQD1Knc3ogBN2ZrY//3q/XCmb4CAYZo4iKwbyK3Tay0BUSeLNXNya8GJ+f+8pFhULaE/3+emBxjEIbTttCzPQbpowb4Zcz+kspSlml0lJb9XP0nCv9rdSQVK2GX/O4Sp++dbEvtPWb99hKjyvZFdxgJ11G3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481826; c=relaxed/simple;
	bh=GmcHN44JDQRr9k9tS2NRhnuwywVPIM37wfA4sCPwZYw=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oufnKb+UQsiLUFK9a9NbRm+a6fWnNDuWgntzOPC8fLkoiCWBaNwvR+sv8VXHF7ePXbyxbRzpuoUI5rFLWzK7U60rHEhyb04Mo1GNbiKmfVwjAVfpFy6h6AjLbbH7MBybCk/X62++KpFDHZT42NK2nzoEmiEQD4ORTWrhS24DqgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net; spf=pass smtp.mailfrom=thesusis.net; arc=none smtp.client-ip=34.202.238.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thesusis.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thesusis.net
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 97F5F37216; Thu, 23 May 2024 12:23:31 -0400 (EDT)
From: Phillip Susi <phill@thesusis.net>
To: Richard <richard@radoeka.nl>, linux-raid@vger.kernel.org
Subject: Re: RAID-1 not accessible after disk replacement
In-Reply-To: <1910147.LkxdtWsSYb@selene>
References: <1910147.LkxdtWsSYb@selene>
Date: Thu, 23 May 2024 12:23:31 -0400
Message-ID: <87y180qyyk.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Richard <richard@radoeka.nl> writes:

> I grew (--grow) the RAID to an smaller size as it was complaining about the 
> size (no logging of that).
> After the this action the RAID was functioning and fully accessible.

I think you mean you used -z to reduce the size of the array.  It
appears that you are trying to replace the failed drive with one that is
half the size, then shrunk the array, which truncated your filesystem,
which is why you can no longer access it.  You can't shrink the disk out
from under the filesystem.

Grow the array back to the full size of the larger disk and most likely
you should be able to mount the filesystem again.  You will need to get
a replacement disk that is the same size as the original that failed if
you want to replace it, or if you can shrink the filesystem to fit on
the new disk, you have to do that FIRST, then shrink the raid array.
