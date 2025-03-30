Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93114288D2
	for <linux-raid@vger.kernel.org>; Sun, 30 Mar 2025 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743350179; cv=none; b=YcfMN3wJvBxTa+R7CgGrigI0EVo3DrjcbmKrATUR/zypaczMSEUqAhYrT1GikdA1fANXXTBviVf4A0t0d9VrDyzQeaw4SZs+K66sZmTwx5P5ZolErs9r6p7QXHLYgJ4SipttJ49EqtoY8EPAx4tOLOsHaZnG2h6eFUlSJbmhsj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743350179; c=relaxed/simple;
	bh=eERrun1LflQ/rQqdrAxuDs4xbTfWCCJzu5KP9WRp5JY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=YffK4FdXBLUkggSkyN1YfizmElj8bkUdCKd7MY8Mx1TYDPaRIQQDe0shq8dy9eOAOjsQwwBfd9gr9WYSmDS//p8YsNeGrR9Q3V547Q2mfcTzdoljeD9fd/MCEnIcUIILALf4TWi3wqcAnNgaNVkWFdBQWBD2fNT1bYdcRHPlrmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=BY3oFPyX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=j14GGWLG; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="BY3oFPyX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="j14GGWLG"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9F8151140094
	for <linux-raid@vger.kernel.org>; Sun, 30 Mar 2025 11:56:16 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sun, 30 Mar 2025 11:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:message-id:mime-version:reply-to:reply-to
	:subject:subject:to:to; s=fm1; t=1743350176; x=1743436576; bh=Nn
	2XtHM+mzmy5r3aiH/bmYFDaPDtvBcQ2JLx72E3slU=; b=BY3oFPyXPJVVRYiCKm
	Hp4yk4kx9/cgDbAs1JKG57Hax3XBQMQE7IwrzJyzTkQh6LhqgLkk23fAym5DJ1R6
	4Iq6mTcNQzhBX9IweUserr9ug92JPT5n+NtaKefx8qF6acHAoz6kBTtIYokGdhA0
	I2vY6GyN6ZAg97ULLJLMBz4NuQcBBlFvqt5It1p7iKiD8RU4s0p3PZyHaDBpGX2I
	WQANXOY2LWTMFhjd3rE8sWf+ds41e95ySmLwlmD5dHIm4C9GC465Z7iY+qs20wIc
	IwAybvd2q3GqhkFUOBW3t46V1ayl+xCPa1r/P2yLvJ6pt41flrIasT2lBhfniTpM
	W/aA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1743350176; x=1743436576; bh=Nn2XtHM+mzmy5r3aiH/bmYFDaPDt
	vBcQ2JLx72E3slU=; b=j14GGWLGxDurVT6yVIH8D/i6YBKs978SA9SBJUQ0oavs
	XnmfonZLvrxruV/W1mh+cliqLfpcYNYr1nLRoqVOkNR2rhGa+c5sxlCPBs9AnZ8X
	02kjBY3op4E/vGMFnYBdlNoqiOz4MIXpWmRCnQ92tdP+h8rgcfjW43uyhE8Hm9Ov
	IupVUKOVCfrcsQhjFS8VrQEvTTZa5Y9zfxa7lrxtqroMzTxQ5rpo9RjRsJZNezD7
	xg+oiVYTcPsXem5JAlY3/467bw6UZFPFFbS4DHLvuTtiejE7QypkAHgOh+jMOEP2
	2c5xdXwEmpmzVwc15FUxPNr5UhflVQSY6USHn2GNug==
X-ME-Sender: <xms:oGnpZ6x4O_H38PTp3O5ZqW1a62ucjHn6TS_4xDTXVBVserQZ7E6h1w>
    <xme:oGnpZ2QFQ9MSkbo34TUGcvrO-MGzynEsHLeqmDPAdmocnC-vClWqg0juwfP3PIGJu
    266DiY6-nysz9I8>
X-ME-Received: <xmr:oGnpZ8V78dFt3ChUWNxnpuMwGqB_OrAwY93P_NSZRwrEriIm4zyG1uyzlvn3zJbJmgg5XzYVVaV2PWK9ag0zPMCkC9LaroACszsKLVkB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddujeejgeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfgfvrhfhufgtgfesthejredttddvjeenucfhrhhomhepphhgnhguuceophhgnhgusegu
    vghvqdhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnhepjeefgfegfeefueffiefhtd
    efueetueelkeejteetuedvjeekiedugedukeefieehnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepphhgnhguseguvghvqdhmrghilhdrnhgvth
    dpnhgspghrtghpthhtohepuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhi
    nhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:oGnpZwgdhI1BVptREaBOFsFZscZZi3kAXQ7A_K6UHDEFwDk3xsqKWQ>
    <xmx:oGnpZ8BQ-eKBKLCF7qgELAF_wm-BWk-1IbpYH-tBIjVFOWaubWiVjg>
    <xmx:oGnpZxJ-mhSUdvR-yndK1eO-V5_6y5D9NCl7OtpBy6stkpJ-AwIDkQ>
    <xmx:oGnpZzBrQdrliEDbiweIUM1GyraLCOMm6CMHdDZqFjLomzkjv09Hyw>
    <xmx:oGnpZ_8v42aHHRibam9mhh6aPsawsYiVsBiiYyYJDsrPRs_KARfyIqq4>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-raid@vger.kernel.org>; Sun, 30 Mar 2025 11:56:16 -0400 (EDT)
Message-ID: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
Date: Sun, 30 Mar 2025 11:56:15 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
Reply-To: pgnd@dev-mail.net
From: pgnd <pgnd@dev-mail.net>
Content-Language: en-US
Subject: extreme RAID10 rebuild times reported, but rebuild's progressing ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

on

	distro
		Name: Fedora Linux 41 (Forty One)
		Version: 41
		Codename:

	mdadm -V
		mdadm - v4.3 - 2024-02-15

	rpm -qa | grep mdadm
		mdadm-4.3-4.fc41.x86_64

i have a relatively-new (~1 month) 4x4TB RAID10 array.

after a reboot, one of the drives got kicked

	dmesg
		...
		[   15.513443] sd 15:0:7:0: [sdn] Attached SCSI disk
		[   15.784537] md: kicking non-fresh sdn1 from array!
		...

	cat proc mdstat
		md124 : active raid10 sdm1[1] sdl1[0] sdk1[4]
		      7813770240 blocks super 1.2 512K chunks 2 near-copies [4/3] [UU_U]
		      bitmap: 1/59 pages [4KB], 65536KB chunk

smartctl shows no issues; can't yet find a reason for the kick.

re-adding the drive, rebuild starts.

it's progressing with recovery; after ~ 30mins, I see

	md124 : active raid10 sdm1[1] sdn1[2] sdl1[0] sdk1[4]
	      7813770240 blocks super 1.2 512K chunks 2 near-copies [4/3] [UU_U]
	      [=========>...........]  recovery = 49.2% (1924016576/3906885120) finish=3918230862.4min speed=0K/sec
	      bitmap: 1/59 pages [4KB], 65536KB chunk

the values of

	finish=3918230862.4min speed=0K/sec

appear nonsensical.

is this a bug in my mdadm config, progress reporting & or an actual problem with _function_?

