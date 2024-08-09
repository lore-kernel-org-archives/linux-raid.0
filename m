Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5F5168487
	for <linux-raid@vger.kernel.org>; Fri,  9 Aug 2024 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723243795; cv=none; b=uCosnDJclzzDChZTooE8y6cmBO5Qa7oMf7TK2NBkHcBDiXCzLXqF4T1Ee+C+7QU6xY7OXS6ozJBz2mM7Lpl/Fxvhy9x+f5FWs1gaDNvbFf8rFNftTYAb3npAoAsv5ctcPoKKt+Tk/0j3+P4fkQOClBu4mD94a667f9QJ4A163Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723243795; c=relaxed/simple;
	bh=MmzoxrCCyNX87034pak9hagAzYcVUjdkEcblK76P/Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VG6u3YhdpyIrfmYjcS6rBRzEHOxKFTalgAEnsZu/YuQ05Lc3/wq6+be6Yo6UUrbcbstXPDkZCHTzwOgSg2LlANDLe9sXSti49dP9OpUXZs6Su0VlkiOcmK5vy/wECeke/K8Bec+7F9o0Z5u50EHLQw5REJRj2CsAy/A4swHXfpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1scY5n-0006Wh-Ml; Sat, 10 Aug 2024 00:28:15 +0200
Message-ID: <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org>
Date: Sat, 10 Aug 2024 00:28:10 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID missing post reboot
Content-Language: en-US
To: Ryan England <ryan.england@lambdal.com>,
 Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
 <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com>
 <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com>
 <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com>
 <CAEWy8Swxj-RFZ=kya=ECYJLqX3a1-HysRRDXNvw70Go8v0Ou4A@mail.gmail.com>
 <CAAMCDefBkSsF4ZPOtWmsT2UieM-Obvovxud1U7-DbAk2CMx-SA@mail.gmail.com>
 <CAEWy8Syh+eMq_5-gTsLoXkT5LqVE4AUJWMGzVpRjS3pzF+YYyQ@mail.gmail.com>
 <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/08/2024 at 23:36, Ryan England wrote:
> 
> I was able to set some time aside to work on the system today. I used
> parted to remove the partitions.
> 
> Once the partitions were removed, I created the array as RAID5 using
> /dev/nvme0n1, /dev/nvme1n1, and /dev/nvme2n1. Including my commands
> below:
> - parted /dev/nvme0n1 - print, rm 1, quit
> - parted /dev/nvme1n1 - print, rm 1, quit
> - parted /dev/nvme2n1 - print, rm 1, quit

If you are going to use whole (unpartitioned) drives as RAID members 
(which I do not recommend), then you must not only remove the partitions 
but all partition table metadata. wipefs comes in handy. Else some parts 
of your system may be confused by the remaining partition table metadata 
and even "restore" the primary GPT partition table from the backup 
partition table, overwriting RAID metadata.
