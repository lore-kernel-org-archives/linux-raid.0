Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C2A13E021
	for <linux-raid@vger.kernel.org>; Fri, 16 Aug 2024 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801135; cv=none; b=UL35+BbDSCwgEANNvF9NHH4VpLjuEsbbrCTiAtYLVw9rUGZybVKpilsfhkz5arnMMhOWxXHlg0nKA+YX1S4TlziIjDxHSlpqdyqt+WIJutBG+5824PnboAhv2nfdbyb/2F4SLfq9mM7plfn5GtEbAf6VFVln2qFInH5Emop6tsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801135; c=relaxed/simple;
	bh=TeEpNZyow8wJCZ9FhOT8HPrf4A1S7bwDSYAB5KX7Jd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FvgwabOqabU1n0fgQ55lP0Fa0xWyQDJy68HYdOBvoMBg+m09+1YAmjKlH8iSAyusfa9qukzVkanMmu95u+eWF6TVRIQk/Tpdrqe5nlbLhsTrGoco37848Sini9exkVZVL1Dyh/uiIW5OARArKe1CsO7dhikRdaJefXHeWbhvVBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1setPs-0000HO-94; Fri, 16 Aug 2024 11:38:40 +0200
Message-ID: <1ce73b33-9b9a-4525-91da-5dc57d070d03@plouf.fr.eu.org>
Date: Fri, 16 Aug 2024 11:38:37 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
Content-Language: en-US
To: Reindl Harald <h.reindl@thelounge.net>,
 David Alexander Geister <david.geister@outlook.at>,
 linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
 <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <1be185e9-f8a1-4e92-bb8d-8b6170ddcf07@thelounge.net>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <1be185e9-f8a1-4e92-bb8d-8b6170ddcf07@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/08/2024 at 18:21, Reindl Harald wrote:
> 
> ALWAYS use partitions and be it only if your replacement disk in a few 
> years is for whatever reason a few kilobytes smaller
> 
> * partition the drive with GPT
> * make the patitions 5% smaller than the disk
> * use the partitions when create the array

5% is a waste of disk space. Size differences amongst disks of the same 
rated capacity are much smaller, and the RAID superblock already 
reserves some variable space to adapt to such differences.
