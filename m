Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2EE21D011
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005465; cv=none; b=OyD7egRunAss1nBWYaJPi3Ubb6NCoIjgLBJ1AjwkifPQIJZ0erE5bq9gv9YrLi0IPyyFjRVN+KnREDpBsb7PMSemx7TaePj+5VFboAnwGxfWfsFLOx9LJzssFzDSFvaMUN5UIjktwNRWTR10zoq5396Yk73f4hjAk8U99L0OP4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005465; c=relaxed/simple;
	bh=dtUx/84A4fXs6UIDUuTydtN/OhSRVrbXj9syJ5gA4FA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MbNoveCJPglDQcPrSEydcKvrzx7zqn1kTLCz2VVZc+JE068os2n+J+T9rwTX193cMiL/nqVLxMAiiyakEKFGEIAuTk6vU5FIfyeR+gz55nNEBUf6tQaorrjvyH6yA7z4/apxkeckkf8cKR49UehuBv2F6ZinDK1zflGLyOTfG7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 2888060FF9;
	Thu,  4 Sep 2025 19:04:12 +0200 (CEST)
Message-ID: <96d23dc8-c52d-4fe5-b6c6-825fbf6a648d@peter-speer.de>
Date: Thu, 4 Sep 2025 19:04:11 +0200
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
 <0e8576c7-fb71-4445-b203-eeff8a2c3003@peter-speer.de>
 <17253085-a177-4748-9df6-8415d7474953@thelounge.net>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <17253085-a177-4748-9df6-8415d7474953@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 23:59, Reindl Harald wrote:
> 
> 
> Am 03.09.25 um 16:26 schrieb Stefanie Leisestreichler (Febas):
>> On 03.09.25 16:00, Reindl Harald wrote:
>>> in reality you could plug the disk off while the system is running - 
>>> it#s the whole purpose of RAID
>>
>> Got it. I will try to do it with the system running.
>>
>> Do you know a way to expose the new hard disk to the system when the 
>> computer is not rebooted? And how about the device identifier? Will it 
>> be /dev/sdb again when it is plugged with the same sata connector? And 
>> can I make sure the device name is not changing when it is rebooted 
>> again?
>>
>> Or did I get you wrong and it is just a theoretical possibility to 
>> plug off a disk when system is running?
> 
> don't do it while the system is running - it's that easy
> 
> you bott with one old disk holding the data and system and will see the 
> new empty disk - one line of my script is there to recognize the new, 
> cloned partitions

OK, thanks for all your input!

