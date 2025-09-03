Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1665B28BABA
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756914744; cv=none; b=j9M2RoQcqOx+SdQH32uuyYLSQCk0zgSTW1rEdLZaFghmCFDAUy5ohZt+ZYFJMvMLwBTgDnEA3FYKraEq8xFtGjOlZN2FazBgV7sqGH6ePE8w12BeC9ixSP5+VhWbdljHDCvnRo9fvLV/nEHFz7us4sK0Fm/LTbOeRGnDaI4nclA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756914744; c=relaxed/simple;
	bh=npdI0/QZp9tKLvddebyhgchPbqE+TWwYO7mSr5tXoHk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEqRmfGws5/UmB53L2043ifr/nY4rx7bOl1mu+qn9wytJo33TeM5Yr9b0hSNCT4WrScpY8Ayqowa4X1guUdu//QFxPtGbbSAlhKlidzNiuYnuFmQBpxIjjI5ucoly0kNkQc2DhQMAcNiLYCWc4Jc2l3Qj0ifcNehIkwFd4sncOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 113904082F;
	Wed,  3 Sep 2025 15:45:21 +0000 (UTC)
Date: Wed, 3 Sep 2025 20:45:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID 1 | Changing HDs
Message-ID: <20250903204521.44e91df1@nvm>
In-Reply-To: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Sep 2025 13:55:05 +0200
"Stefanie Leisestreichler (Febas)" <stefanie.leisestreichler@peter-speer.de>
wrote:

> Hi.
> I have the system layout shown below.
> 
> To avoid data loss, I want to change HDs which have about 46508 hours of 
> up time.

Do you have a free drive bay and connector in your computer (or just the
connector)?

If so, the safest would be to connect all three drives, and then:

  mdadm --add (new drive)
  mdadm --grow -n3 (array)
  mdadm --fail --remove (old drive).
  mdadm --grow -n2 (array)

> I thought, instead of degrading, formatting, rebuilding and so on, I could
> - shutdown the computer
> - take i.e. /dev/sda and do
> - dd bs=98304 conv=sync,noerror if=/dev/sda of=/dev/sdX (X standig for 
> device name of new disk)

Very peculiar dd line you give as an example here.

  - calculator tells us 98304 is 96K, but why? Usually one would just use "1M"
    or the like here for performance reasons, and shorter to remember and type.

  - noerror is "continue after read errors", but do you want it to? I don't
    think the regular dd has the logic to pad output to an exact amount
    of unreadable data on input errors, and if not, then the result is useless.

    If you expect input to have read errors, "ddrescue" should be used.

But that's all beside the point as I don't see a reason to rely on offline
migration with dd here either.

-- 
With respect,
Roman
