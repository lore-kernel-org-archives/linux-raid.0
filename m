Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B62FB6
	for <linux-raid@vger.kernel.org>; Wed, 29 Jan 2025 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738168523; cv=none; b=tlZU7iy/1hj7Yt9BamWgDrUCXOfLTe2Jfcn/BGoaMzHOhSDXwnJ7gvK0dv9TYRJ2IL2B5Hs5Xtg1MYQv6/UHV+U29mfEUQURWu9p3kiFODBTT63JAvocSfxU0MGoYLxSeTXSaNwNQ5Z9ih6MobWPj4qh0k4cCweAzcpdNoQ4ZfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738168523; c=relaxed/simple;
	bh=pTXhUArpPD/ubKaTda8FFcIp4gv+cmGvlnT5PuY8jso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bbM3E+4B7kMRB1uyXtGY6PqIgedMI7Q04JHpXHCTXvUczbbj/CCLbNkR/DYAylswkTOiwtNdw/LQSrL7fP+go+PKfRZf+D3mTiWGyUfwF6gS50c/ci+Wmlb6lt99dfP2mqklWS8hnqHs2pSWOKS97rqeXkfVH0YjQWvVR5bkAOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=VlF0Q+lG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=N+P55xA+; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="VlF0Q+lG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="N+P55xA+"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 9245213801E4;
	Wed, 29 Jan 2025 11:35:18 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 29 Jan 2025 11:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1738168518; x=1738254918; bh=5Xyr10sz5EBqta1+WOev+nXucyT5+28nEaS
	VEOA2Cf8=; b=VlF0Q+lG6i5+vDhh31Ll8WQWh58atX1wWmEZf7WqFuz1kFeJGH6
	gGPJuiY2MpeeZQC6UJ/bVaFvL7/3IRQhaJv5491iBj4zNsMZT16KNFuTOTgosT6m
	uk0UWMBcCrNmiISbOAEQ4SfgVVbEu/nfNfd4nf8YRxhoYkfFp1oIGdlods1boIN2
	EQjaQNvagmzhD9rv5aRHeRmOSMhPcoS0X2su00C7XCP3TfCtNfW0oYI9qCI3ff1V
	oNtqyq08j8dTUc76CCPkDcZ7Vyo8zH1YxBKDfoy883TG0gCYpS8aSvRmM8iMuaeN
	Lp8wbxiwfqhl3+gho9fzsePbaKNVFJh5TpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1738168518; x=
	1738254918; bh=5Xyr10sz5EBqta1+WOev+nXucyT5+28nEaSVEOA2Cf8=; b=N
	+P55xA++3hQs0Gb5KvF7SKygbpDcBRLxQcbr72C9HhBdxFhEjLFgv5f6O5Uh4aiJ
	fZY7zK5C4BMjnG0jceekwPnscqgFeMqxGArPBYm8ur9tHglkjYoY8dN+Fz37ZKJ+
	xmWWq9Z8uHpC4kREshf5vRH2gLo91Imjl2IY+kCcJ2oUCBbxlPQmYO2tCETTRFjI
	LiA35iNC9bbA2RyzfYnNz0z0+9h9ti6wEVs3KJMDs8sJR7mv+TOrjqiqLWR2/mFf
	4NBS9lZdEe63N36Gd5WWUxmLwWuTTOsBzIZkjBpZ2f+gRLp/w36lgv6Tpf9O+jQl
	IHj4C2dVBWqYHsLdF/Q/A==
X-ME-Sender: <xms:xliaZzD7xFUxrmx6hTIEzcsJwxRj2u4CkgRnSNMBax4Cq3a3elQ9fA>
    <xme:xliaZ5gvwvZlRHR3pPBwYVih9r6D43muVJQlERKap2A_MxkfR1N6sel55qPNMOjF8
    ubYusMhCHbOkNE5>
X-ME-Received: <xmr:xliaZ-kr8S6jxwmj6oxn6Npe2VYXqoeAdTM2NBJgOd2PCFDgk17V6wAmVHfxX7PHPXx_1ufWqc9IHZk3GTrpnRx_t1BfbTe30aDbxW9G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdefgeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfg
    hruffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhnuges
    uggvvhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpedukeeiteeviedugfegud
    efgefgteejffefvdetvdehhfehfeffkeduuddvieefvdenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpghhnugesuggvvhdqmhgrihhlrdhnvg
    htpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehr
    mhesrhhomhgrnhhrmhdrnhgvthdprhgtphhtthhopehlihhnuhigqdhrrghiugesvhhgvg
    hrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:xliaZ1x00ncV077xm_EFXB-U3qIgtWQtdX5Jk_VE3tMhGbDkCXiatQ>
    <xmx:xliaZ4T3OWLYn0tFdNiqw3rM_ZNKzC8Dxpy21wwgbzHDWkpPFfmeOw>
    <xmx:xliaZ4aXpQ1P3HI0hEkqjRH99CuwyruBtIsW5v0NFTgTl7MkeMPP6w>
    <xmx:xliaZ5R5yevmoQGpK8gqK4N1th8pAc_7YH1s30NZ--sc1mMVw2XnRg>
    <xmx:xliaZ9J2inuPuIy8kqpkLNQwPDNIHflru4mtePyDKJweE0rMau-3o0nh>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Jan 2025 11:35:17 -0500 (EST)
Message-ID: <c1de7bb2-93f5-4d35-b226-cd924c727cb7@dev-mail.net>
Date: Wed, 29 Jan 2025 11:35:17 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
Subject: Re: replaced all drives in RAID-10 array with larger drives ->
 failing to correctly extend array to use new/add'l space.
Content-Language: en-US
To: rm@romanrm.net
Cc: linux-raid@vger.kernel.org
References: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
 <20250129212929.6449db3b@nvm>
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <20250129212929.6449db3b@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> what's incorrect/missing in that procedure?  how do i get the full partitions to be used by the array?
> 
> Did you try without specifying "--raid-devices" there?

yep.  different error

	mdadm --grow /dev/md2 --raid-devices=4 --size=max --force
		Change size first, then check data is intact before making other changes.

	mdadm --grow /dev/md2 --size=max --force
		mdadm: Cannot set device size for /dev/md2: Invalid argument


