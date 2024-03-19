Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5E72B9D7
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871870; cv=none; b=tgMbNdIZ3dQMdzqwVAgFDw6m/0ZLzxcaxXLzR7Geo3BhxpgNObCpC4xx0yLJi6JIquuPS5mwahzA+evOYdmo2V+kMZ8wMk/5NOEnB3Hnzjlg1R1Gs8wghGzSD1Dwg39Jwy+SzjGDNSnK5j21gA0/QFfbed4hEKT/skXv3Z7h1zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871870; c=relaxed/simple;
	bh=gPFiJ6pcY9oVNaMeq03Zqh+804Xe4x27Q2fXVXlfv5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLUNbVnoOkA9++7lHVdOi91yy29dI0lVjfiUF0eWAtfVBI6yyWOeNFTIFh7CeMp4RST5AOID6YJgRpFRyc7gHDy4iOzxOPsTPk4pMPutQFEeDexbG6cOn6863ldKR8DNT9gct28OrhWDnWfHKr6rsg08GEAvckL6RZL2/2zh1O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
	by shin.romanrm.net (Postfix) with SMTP id 4A70B3F4CA;
	Tue, 19 Mar 2024 18:05:51 +0000 (UTC)
Date: Tue, 19 Mar 2024 23:05:46 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Michael Reinelt <michael@reinelt.co.at>
Cc: linux-raid@vger.kernel.org
Subject: Re: heavy IO on nearly idle RAID1
Message-ID: <20240319230546.6ff409ca@nvm>
In-Reply-To: <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
	<abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
	<d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
	<ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Mar 2024 15:08:57 +0100
Michael Reinelt <michael@reinelt.co.at> wrote:

> I think I found at least a workaround: the strange behaviour disappears immediately, if I disable
> UAS, and use usb-storage for the externel USB drive.
> 
> options usb-storage quirks=04e8:4001:u
> 
> I am sure that UAS has been used with kernel 6.1, too, where it did not cause any issues...
> 
> Ideas what is going wrong in kernel 6.6? I'd like to re-enable UAS, because UAS is about 200 MB/sec
> faster than usb-storage

I think it might be related to discard or write zeroes support on 6.6. I had
some issues enabling USB TRIM on kernel 6.6, compared to 6.1.

What do you get for "lsblk -D" on both kernels and both storage drivers on 6.6,
are there any differences?

Aside from that, trying "blktrace" was a good suggestion to figure out the
process writing or even the content of what is being written.

-- 
With respect,
Roman
