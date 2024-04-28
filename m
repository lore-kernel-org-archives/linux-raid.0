Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14DD389
	for <linux-raid@vger.kernel.org>; Sun, 28 Apr 2024 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714343731; cv=none; b=hl5iBajfWsiCpVyiABvqdvEUvA+PdgFcJ15/OY3GjhcAJiufOywJwBEPtu+iHaHeKX2iXuc2+bh6J+2/3UAERNLl6kJ+U89fkhIox0wvhEgZDbfsJ83/svnU3A6CiieKAL9+Of6RlgGEpds4GSTuGoBb0zTkh3Fe6CepISeg5Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714343731; c=relaxed/simple;
	bh=MfduCKVmDvFwfUxVW/A/9qAweEzHm/8vjLTBc+R/Da8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QvJgRq49gnsujAymYQ0iDFlPFHG61noJa/L/6kCTdplKeYibxpsj0TSJfWXE8kEtiES4tQ0Cn6x+U6h0Qza58MfUSgvlftFTXU+oz9maU16l3ch450hSx61UusECs6cZlWDY2jDZAZSMu5k5wWsQY0wBiY7yqpM7Pszwz+nStkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (unknown [IPv6:fd39::4a:3cff:fe57:d6b5])
	by shin.romanrm.net (Postfix) with SMTP id 4728F3F272;
	Sun, 28 Apr 2024 22:25:35 +0000 (UTC)
Date: Mon, 29 Apr 2024 03:25:29 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Colgate Minuette <rabbit@minuette.net>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, linux-raid@vger.kernel.org
Subject: Re: General Protection Fault in md raid10
Message-ID: <20240429032529.2281222d@nvm>
In-Reply-To: <2322142.ElGaqSPkdT@sparkler>
References: <8365123.T7Z3S40VBb@sparkler>
	<4914495.31r3eYUQgx@sparkler>
	<20240427112219.1bf00101@peluse-desk5>
	<2322142.ElGaqSPkdT@sparkler>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 28 Apr 2024 15:16:27 -0700
Colgate Minuette <rabbit@minuette.net> wrote:

> I just tried RAID10 on the same HBA/cables with 4 seagate 4TB SAS HDDs, and it 
> is functioning correctly. Syncing correctly and able to write/read from the md 
> device.

With those 15 TB SSDs, maybe something wonky with the large size?

Did you try creating a smaller partition on each, maybe just start with 4, to
not redo all of them, since you say 4 also repros the issue. Test with a 4 TB
or even 1TB partitions as RAID members.

-- 
With respect,
Roman
