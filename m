Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50A3112C4
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756909611; cv=none; b=KnTC/fc66tSrnCA7gDeYLRmW9UtPkuyZcXof4DK9De3GKFAmIqt2fKEQ9uY502QAqVmw4W1jdAhF63ToDtkKSNq1FGz0VyFyNEmXqLyaG+cAj6IL5Tum8pxJuf+JnYraP8fZLzLugxjLigOFMQFEzunY3Roq3FpAX+qPRZMqe7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756909611; c=relaxed/simple;
	bh=nl7jO41kAO/XcMqBIfsCKHejaTc3kA1wOegcKaR5lok=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AMcJQw0i62kAgyTSKhKN8EHVDx+E2VHfOU29LwQePBZwQ87OacpB4xp0FTCQZkCd3CHXPwpcygYwEJ7U7Pp1m+4LcVQ1uCZ/2kCOdk6qtoYJQzJYlNW0EJXkaZC1qGoExEcAKrMD4b45jtXG58bTkzG5p9hlN2YGkFh+fcOq31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 7205A61356;
	Wed,  3 Sep 2025 16:26:44 +0200 (CEST)
Message-ID: <0e8576c7-fb71-4445-b203-eeff8a2c3003@peter-speer.de>
Date: Wed, 3 Sep 2025 16:26:41 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Reindl Harald <h.reindl@thelounge.net>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <f8117d4a-d0d7-46ad-95ec-1eb8374a692d@thelounge.net>
 <f5b4a63a-708a-40ab-a2c5-6dc348c6eed8@peter-speer.de>
 <6cedd78a-89bf-4231-b1f8-c4dfee0cad74@thelounge.net>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <6cedd78a-89bf-4231-b1f8-c4dfee0cad74@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 16:00, Reindl Harald wrote:
> in reality you could plug the disk off while the system is running - 
> it#s the whole purpose of RAID

Got it. I will try to do it with the system running.

Do you know a way to expose the new hard disk to the system when the 
computer is not rebooted? And how about the device identifier? Will it 
be /dev/sdb again when it is plugged with the same sata connector? And 
can I make sure the device name is not changing when it is rebooted again?

Or did I get you wrong and it is just a theoretical possibility to plug 
off a disk when system is running?

Thanks.

