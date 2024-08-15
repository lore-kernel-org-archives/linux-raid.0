Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC441990DB
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 09:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723712578; cv=none; b=VmORUDFjyZcFvJc96nSsTYtV9n9bRkToUSCrZrqgdns4VKDEiHj3/mf9COqMydIKxRWeOFtNlsTFGJQHRyvQa+ECbCqrNgv2ehVsFBTiEX44249N1qiZUT0sLY6vJP/OPDAgmsqaCWzfqfW+E3upOg1bdy/+ICwfvgx1QbVdFnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723712578; c=relaxed/simple;
	bh=L9E8bs+yo5bdu3UQ/R+zi/r4HRNLqae4E6SPvYgyVlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AlBebt8hSPhmX5liW4hrJ0f0qy3aRyzhZppSfYj1uzLm/L+NjFPNpdRSsXDciZ9N/gdtdbgVXMAnldJYWA8IC8krGaOeMa/YvmpCHTE7KWnIdMXwyFdf65u755Ymv6lfY//PYCV+8cSgrUq8ijP0+juotTmfotbJe3ovNFAlbIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1seWNd-0005rR-QI; Thu, 15 Aug 2024 11:02:49 +0200
Message-ID: <7a05ab70-2b1e-4477-a8c6-56be1989a96b@plouf.fr.eu.org>
Date: Thu, 15 Aug 2024 11:02:47 +0200
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
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <AS2PR03MB993231A87C17935B96DEF3B283802@AS2PR03MB9932.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/08/2024 at 07:39, David Alexander Geister wrote:
> 
> I created the array with: sudo mdadm --create --verbose /dev/md0 
> --level=5 --raid-devices=3 /dev/sda /dev/sdb /dev/sdc

So you really used the whole unpartitioned disks as RAID members.

>> It looks like the disk has a GPT partition table. Is this expected ?
>> If not, it could be another instance of unintended GPT "recovery", 
> and a reason against using unpartitionned disks.
> 
> Yes I choose GPT intentional as each of the HDDs exceed 2TB

This makes no sense. A whole disk sdX must not be used as a RAID member 
and have a partition table at the same time. Either the disk has no 
partition table and is use as a RAID member, or it has a partition table 
and a partition sdX1 is used as a RAID member.

Besides, the GPT primary partition table and the RAID 1.2 superblock use 
the same location at the beginning of the disk.

Did you create the partition table before or after creating the RAID array ?

If you create a GPT partition table after creating the RAID array, the 
primary partition table will overwrite the RAID superblock.

If you create a GPT partition table before creating the RAID array, the 
RAID superblock overwrites the primary partition table, but not the 
backup partition table located at the end of the disk. There have been 
reports lately which seem to indicate that something, maybe the 
BIOS/UEFI firmware, "restores" the primary partition table from an 
existing backup partition table at boot.

>  > wipefs /dev/sda
> DEVICE OFFSET        TYPE UUID LABEL
> sda    0x200         gpt
> sda    0x74702555e00 gpt
> sda    0x1fe         PMBR

We can see that a primary and backup GPT partition tables are present.

If there are no important or unsaved data in the RAID array, I suggest 
that you create a RAID partition sdX1 on each disk and create a new RAID 
array using the partitions instead of the whole disks.

Otherwise, I suggest that you erase all GPT metadata on each disk with 
wipefs -a before re-creating the RAID array with --assume-clean. When 
re-creating the array, make sure that sda, sdb and sdc are in the same 
physical order as when you originally created the RAID array (check with 
the serial numbers).
