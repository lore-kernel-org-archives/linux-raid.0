Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F019EEC2
	for <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738168785; cv=none; b=GgeRq+a53ganJuxLsH0KsvZgtafRYvmYrFUHGbwHXhhG/oFoC7D8IfymckE2WUD9xOiSOVVgOwf39PelQqxaVl98EmOPowyXmAPVpX8EZrd1yGcq3P+8x9mugrnFKn1qdd6Q7Dm3l+JyyprXgLjAuMM6+yJn0ttagRFihH2/hpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738168785; c=relaxed/simple;
	bh=KEscESNSfhgPzgn/Wum3nTqxlaXYFR86qqGMS7nqE7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIrnkBfRRtjGAHowD71nwB99mL2/PaSu9b8O4RNtFvs1GdSKFUJIVLuT7NQMdwvKeO2gk8Ivel1I5WCbSTo4IM5TlGPVdPZj8PHt+VkDtC9OX9e0Z3pd1V9p+qKg53RX6K9a+WtelYbHPVH0aJiTf5X7yRXW0POecmxCFmBVJZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id E04EB42491;
	Wed, 29 Jan 2025 16:29:29 +0000 (UTC)
Date: Wed, 29 Jan 2025 21:29:29 +0500
From: Roman Mamedov <rm@romanrm.net>
To: pgnd <pgnd@dev-mail.net>
Cc: linux-raid@vger.kernel.org
Subject: Re: replaced all drives in RAID-10 array with larger drives ->
 failing to correctly extend array to use new/add'l space.
Message-ID: <20250129212929.6449db3b@nvm>
In-Reply-To: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
References: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jan 2025 11:12:24 -0500
pgnd <pgnd@dev-mail.net> wrote:

> 
> 	mdadm --grow /dev/md2 --raid-devices=4 --size=max --force
> 
> 		mdadm: cannot change component size at the same time as other changes.
> 			Change size first, then check data is intact before making other changes.
> 
> what's incorrect/missing in that procedure?  how do i get the full partitions to be used by the array?

Did you try without specifying "--raid-devices" there?


-- 
With respect,
Roman
