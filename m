Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A644201278
	for <linux-raid@vger.kernel.org>; Tue,  1 Apr 2025 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743511684; cv=none; b=MAPOZZ6+vJ0HnjE+K7dGf4LNkaNf05QL15WaI2yQhLgQXsP2rFxMUVC53un4LpScK3X5DPr4Lvl/fMv0u21lcwwQyJhR7HJV2+Q3khD86pAUrw5CHGvEdD7+ae4dSsmZMj5z/pT8tsSe93vurafjvQ5ohUGAFb1YjXU8Vls+YOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743511684; c=relaxed/simple;
	bh=d6tY78Zyu171A/ZXltoh5SiCKhTyFVN8c5YtzVmYf3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmpqGOVKrErs3FtoINXUigDcnMNP4BhRcOOHcQJgJ53Feb4GZl6e3S6z1sRgtFFzV+NuBRFecbqLbRtygr8X2W6jg4wm8DtMSv0jMrIrvD5W9YSroEuqmJkPjqvXbR1jIuesm58TtVX1NstbOXohxy/CFGAEs33+D0a9ua8U8AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net; spf=pass smtp.mailfrom=dev-mail.net; dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b=T/YPdRO5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lkx9Z0KE; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev-mail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dev-mail.net header.i=@dev-mail.net header.b="T/YPdRO5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lkx9Z0KE"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 6E42C254021F;
	Tue,  1 Apr 2025 08:48:00 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 01 Apr 2025 08:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev-mail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1743511680; x=1743598080; bh=Bu/ATi1LJM8+Mk9RnLAsPgMNXhS4exJ3gNc
	qf9TuCsA=; b=T/YPdRO5ugDSp5/r0ukl/IsRYksVOSLYQj2Kxsa4zcfKZko5wfL
	AI3tnAbKdfWvExgGWZDFyCTfuD7hXCR/niCS41msnN4tQqCDgDlfVfKH/SUrc4eG
	/aLFFjOhFnwUhV93F9wKPGvwkHud2Cl4MQ9ST1Ym3TyeEVqljQO5MO2AJa0AciBL
	POv2jXcf5SmfxIg2QU0g16rSyEHolgNXgurlpWfqUEKHM5q3nW73GJUiJ2Q5Fh1V
	wrKOBv+nNZwVgQrvm5yjvKYrBye0mMnAtM3YksnN/S2W6AhlOkcgz3sBMc1AAHcs
	00WeCOVf6VuWTcwyv9q5SNz33XXrR9ggstg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1743511680; x=
	1743598080; bh=Bu/ATi1LJM8+Mk9RnLAsPgMNXhS4exJ3gNcqf9TuCsA=; b=l
	kx9Z0KEaeSRbe/qv/1JVfpgL5ZIwt1dcGgMm0wB+rVceh7WnZwgc1UlQagAwmnkR
	EDJNVfFL+oMpQ/sxJI81cjX4sa2HVZx0Bm/ZejZhnW47tXjHJQlNgh2Xg3W2ACGA
	3SIHC9tbuCujvirxP9cjswJNh7QjENXRq8Gk7GsUYAOA2kOAmysUOuDvAP8jvC7A
	MgJt4qAIWeN5r3q8V8nJ05fxySxDowSNrHAQpG/6P/EKrszmHp3QUZSvYe0P3vHL
	1KsM5eNOwKIlEGP2gBjccg0gbiDNYb3QHv+NlEHT5u833CfgT60Q+fK6wWYyPDOz
	wA9RX12kadUpDiDWvDdbA==
X-ME-Sender: <xms:f-DrZ8V_ohxDENabVi0gGcl7XENHCwSbYfHL6rlnPBC3i3VHR_PJkg>
    <xme:f-DrZwmBjRfqwZ7ECnqdpPEvWe8y7AQAjMLq-zagAZvKG_omStuTC6ldfnyedGr0v
    Y8qDpgoCiTiDoxM>
X-ME-Received: <xmr:f-DrZwZf2uIg98B58YXLLXqOZXQdUihJ026_39dXI6K-aLvxILqMznFGQPszHuI5e-zLnZpzbVWRYxXq7yFCMyAt0xe7m1Nvr2tZ7rKh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddukedvkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkff
    ggfghruffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpehpghhnugcuoehpghhn
    ugesuggvvhdqmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpeduudejgeeuvdffff
    eufeehgffgtdfhkeekvefggfetkeegvedvveethfduieffleenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehpghhnugesuggvvhdqmhgrihhlrd
    hnvghtpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peignhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhrrghiugesvh
    hgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:gODrZ7VFxdpU7FLhiBqZiMLy6IDL-RLML_1P52uZzd-yrY3x3mibCg>
    <xmx:gODrZ2kQv9ez99D9X9HWuvgVBmAAjh5KCOeguVvVzDz-flqJruC2Eg>
    <xmx:gODrZwfvyjS03FWAWkHxyIfsq3-yFfDnlbTC78G5OHOApt85AdPz-g>
    <xmx:gODrZ4GhOaxJrHPwiDGv15bMtQe9wAhKPBhxJOx5WcMgUoHX8Gd48A>
    <xmx:gODrZ9vYlPkFI55TPEgl8YKK35RjT_gQFLYUTogDK50kpdFA3kyMQe8L>
Feedback-ID: if6e94526:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Apr 2025 08:47:59 -0400 (EDT)
Message-ID: <8f66809e-d27d-4b8e-b65c-2fd7a038ff4e@dev-mail.net>
Date: Tue, 1 Apr 2025 08:47:58 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: pgnd@dev-mail.net
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing
 ?
Content-Language: en-US
To: xni@redhat.com
Cc: linux-raid@vger.kernel.org
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
 <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
 <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net>
 <CALTww2-V8ADxpQ0+to+gyiUO-YELNwc+Fiw0vV+E-HM32L=mng@mail.gmail.com>
 <7a13feed-09b6-49ec-8071-6df3be84abd2@dev-mail.net>
 <CALTww284ysugf7dMqS6q3eSjkWSq4Upx7_u4GUzmKE9PbE1fdw@mail.gmail.com>
From: pgnd <pgnd@dev-mail.net>
In-Reply-To: <CALTww284ysugf7dMqS6q3eSjkWSq4Upx7_u4GUzmKE9PbE1fdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

> mdadm --monitor --scan is a suspicious place. Do
> you know why this command is running? I tried to start a recovery and
> didn't see this command.

it's the `mdmonitor` service ...

rpm -q --whatprovides /usr/lib/systemd/system/mdmonitor.service
	mdadm-4.3-4.fc41.x86_64

cat /usr/lib/systemd/system/mdmonitor.service
	[Unit]
	Description=Software RAID monitoring and management
	ConditionPathExists=/etc/mdadm.conf

	[Service]
	Type=forking
	PIDFile=/run/mdadm/mdadm.pid
	EnvironmentFile=-/etc/sysconfig/mdmonitor
	ExecStart=/sbin/mdadm --monitor --scan --syslog -f --pid-file=/run/mdadm/mdadm.pid

	[Install]
	WantedBy=multi-user.target

systemctl status mdmonitor
	● mdmonitor.service - Software RAID monitoring and management
	     Loaded: loaded (/usr/lib/systemd/system/mdmonitor.service; enabled; preset: enabled)
	    Drop-In: /usr/lib/systemd/system/service.d
	             └─10-timeout-abort.conf, 50-keep-warm.conf
	     Active: active (running) since Mon 2025-03-31 09:11:17 EDT; 23h ago
	 Invocation: 79247157fbfb4c369c1cc7899b4d79f2
	   Main PID: 2029 (mdadm)
	      Tasks: 1 (limit: 76108)
	     Memory: 988K (peak: 1.2M)
	        CPU: 1.626s
	     CGroup: /system.slice/mdmonitor.service
!!!	             └─2029 /sbin/mdadm --monitor --scan --syslog -f --pid-file=/run/mdadm/mdadm.pid

ps aufx | grep /mdadm
	root        2029  0.0  0.0   4176  2128 ?        Ss   Mar31   0:01 /sbin/mdadm --monitor --scan --syslog -f --pid-file=/run/mdadm/mdadm.pid
