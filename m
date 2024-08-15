Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67D61684AC
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730620; cv=none; b=LP9LKgNf7mLEO66lkVSCTh+lBcNwPPVNvUkYDtTKxxEFlHhWFiw5bpFfOfg3biQoB78oBZfajHnEReAT9LfpBeuqnYdTaOxYdHIcVXIYmORWe3U44kOZFMJq2AQRsZFM2I/x1RfqKS1ZyJx+y7Q4RroeI4VozuiAVUe86pYmTxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730620; c=relaxed/simple;
	bh=GF1LlS+F59lge+vG0VsgHTqw2M1J3nEQ98Y4QcpLlhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J5lTK1RaFUdLQj9Ya9oRWWFkwxoPJQIMfBh8eROMkTfUd4CshTkqrAx3eaRxO7w+Z17Y9PQee80ZI3smesqCzGw2zELRgkn24X2DuYevywk4sQnR8yMj055nFXGzmo5z9YoqQLir7iVaEZ7jJmOzM8DhNq5iJzRLv57zrH9Zk00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1seb4f-0007q8-0B; Thu, 15 Aug 2024 16:03:33 +0200
Message-ID: <8a372a15-5b10-4fa9-bac1-06fe435ef09c@plouf.fr.eu.org>
Date: Thu, 15 Aug 2024 16:03:30 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID5 Recovery - superblock lost after reboot
Content-Language: en-US
To: David Alexander Geister <david.geister@outlook.at>,
 linux-raid@vger.kernel.org
References: <AS2PR03MB99323D8FD38A563E4D7DE14F83872@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <5419d297-ed97-455c-bee8-969b0d70de27@plouf.fr.eu.org>
 <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
 <7a05ab70-2b1e-4477-a8c6-56be1989a96b@plouf.fr.eu.org>
 <AS2PR03MB9932638D9F2804E7511CB29683802@AS2PR03MB9932.eurprd03.prod.outlook.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <AS2PR03MB9932638D9F2804E7511CB29683802@AS2PR03MB9932.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/08/2024 at 13:51, David Alexander Geister wrote:
> 
>> There have been reports lately which seem to indicate that something, 
>> maybe the BIOS/UEFI firmware, "restores" the primary partition table 
>> from an existing backup partition table at boot.
> 
> I did not enter or actively interact with the UEFI of my mainboard in 
> any way.

The GPT "repair" seems to be automatic, just like mounting an ext4 
filesystem automatically replays the journal if needed.
"The road to hell is paved with good intentions".

> Is there a list of the reports where I can check if my mainboard is 
> affected? Is there something I could do/contribute?

I only read a few reports on this list and do not remember that the 
mainboard model was mentioned.

>> Otherwise, I suggest that you erase all GPT metadata on each disk with 
>> wipefs -a before re-creating the RAID array with --assume-clean. When 
>> re-creating the array, make sure that sda, sdb and sdc are in the same 
>> physical order as when you originally created the RAID array (check with 
>> the serial numbers).
> 
> There is indeed data on the drives that I would like to access. As I did 
> not change the physical order of the drives, I'm going to give it a go.

I was not clear enough. /dev/sd* device names are not guaranteed to be 
stable and may be assigned to different physical disks at each boot.

> Is there any recommendations from you, 

After you re-created the array, I recommend that you check it with 
e2fsck -fn first then mount it read-only and check the contents in case 
you re-created it with the wrong disk order.
