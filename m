Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B071A7346D
	for <linux-raid@vger.kernel.org>; Wed, 14 Aug 2024 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723672002; cv=none; b=cgy30pjqwxqgMhy0R6hBKLDHJJEtLBnYXA6nc42aRqeBmvAfwKmUDTnkb4/92s2NoUOZEl9wzrBUJggR2xYKEn3dePMTW88JiVCvY8z07smzolSXm04TDdjFeCxdxnxjpPiNwJQ11GQBgx4JoP/fSiSiZCgzWInugUbaEROikKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723672002; c=relaxed/simple;
	bh=yRZPxIB1ngJK8Soodcqdbz7QTMkMaQTabzxTMFBNwvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZOBxYdJgJYrzPUwVcuJc8+GhO4vCD1TvtkvsutiVfUAiGcWSXcq1C6PT+PxP6+f8jmNnjUFLf69ynXT1lxgtOfOnm+HKuoCvkMbQjBN73GX+EQZsfsHdSAFhYgDtJj7U1wSDhLhnwzmf2hEx4FJ08NSr3CHk5KCyYQYCBelxzBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1seLp9-0004Oj-0j; Wed, 14 Aug 2024 23:46:31 +0200
Message-ID: <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
Date: Wed, 14 Aug 2024 23:46:27 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
To: David Alexander Geister <david.geister@outlook.at>,
 linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/08/2024 at 21:09, David Alexander Geister wrote:
> 
> I'm not 100% sure but I did save a copy of the commands from the time I 
> created the raid. Am I correct, that  recreating the array is my last hope?

What were the commands ?

> --- sudo mdadm --examine /dev/sd[a-c] ---
> /dev/sda:
>     MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)

It looks like the disk has a GPT partition table. Is this expected ?
If not, it could be another instance of unintended GPT "recovery", and a 
reason against using unpartitionned disks.
What is the output of

wipefs /dev/sda
wipefs /dev/sdb
wipefs /dev/sdc
