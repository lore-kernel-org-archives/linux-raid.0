Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDF71474A9
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372580; cv=none; b=ZjWlelxi3U5iLy1+kamZg17cQ2sti77te3puevqne3D/tk8Rp/dCPplasRWtZJReudeaJMJQ/QdE5EPjLVGhKU5MY9riMTTeFw3a76JgtZ6uugczk/sCNBvhNicwQiMO1GbwZ3dLpjssOt+7I8Iv8hFM4XU08kbgP5vkCnCEg1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372580; c=relaxed/simple;
	bh=75C4sPjYMkN78u0+xQ9pyWBhMe74/QsvLjl8JGu65+Q=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=a39QaqAcalzlvdOZAR2wRn6eXJJi5jCbUzTMwEVaEKlOkceJnkU1eotpF2z+AukbHFxNhEVS72ubc76kmTHkWUCnQgtobu2Dify8UOtUjA+BUpok+SUjXxVvxu9aZNCwRHt1Cu4pVucYWhI8j4/ea4zJVgGZnYuoc7rPX5J1OaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=oZNecsHB; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="oZNecsHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1741372575; x=1741631775;
	bh=75C4sPjYMkN78u0+xQ9pyWBhMe74/QsvLjl8JGu65+Q=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=oZNecsHBw5jDI/mRseEI2HpZVPSwLmCbhFlFrR68EzWASiS1sx3nfrZoq1KJXQra1
	 JqEgGWzW5O6qlY0Nemk7d8e/EYw7+ZIW5qiyntFMWWe3CYKJ9Nzlwv7I8H+x+m7my8
	 yxVXvNdzaO/Eq4j2qKof5IcNSBo0icF/UuEfPAp7mIIgECE+CUecUOf1OYvYfCy4jg
	 UBbpR5S7NAgLtdefeAtU4ahaEXdvbYJZdpgPgxn+8WhzHx9FznjKjppmk80TnPRiEn
	 eDFKQy6xO696c1P81thXR9yD1dCvaaMLTnte4qzAL/Cst83ru2jVMHd83d6QMxDy8D
	 qau2rQEANDqZw==
Date: Fri, 07 Mar 2025 18:36:13 +0000
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: David Hajes <d.hajes29a@pm.me>
Subject: RAID 5, 10 modern post 2020 drives, slow speeds
Message-ID: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
Feedback-ID: 111191645:user:proton
X-Pm-Message-ID: 6f4033aed387c6966b18bf4d6a0455664f15cedc
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi guys,

I have issues with RAID5 running on post-2020 14TB drives.

I am getting max writting speeds of 220MBs.

If I understood properly docs, RAID5 with three drives should have 2x write=
/read speeds.

Single drive tests running 190-220MBs, no issues in SMART reports.

RAID5 with 4 drives...same speed.

RAID10 should have 2x write, 4x read...still running 220MBs max as RAID5

I have played with chunk size...default 512k-2MBs...no difference

"Read-ahead" set for md0 virtual disk

NCQ disabled - set 1 for all physical drives

I have basically tried every suggestion on famous ArchWiki.

I have tried SAS2 HBA...same results.

Initial resync drops to 130MBs

Debian 12 running on SuperMicro 10 series MB. 32GB RAM, cpu max 30% load du=
ring tests/real-life copy.

Is it possible this weird issue is linked to HDD timeout described there >>=
> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/Timeout=
_Mismatch.html

Any suggestion, please?

Array should be doing 260-560MBs with ease

Regards

Hajes
