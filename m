Received: from plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8C87F
	for <linux-raid@vger.kernel.org>; Sat, 27 Jan 2024 09:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706346490; cv=none; b=ZlX5330Vf9jgOsRnX4eO404EzxUTtz92FKrlPDutZiipypp8XUh+YNJptoi5N4nPSQY6OlFdWa83imGc+Sp0R1Yd0NmSYqiAn3lPeCXCTvQKbqMKqaMuXWGI/SHBlqJ6pYpfCD+Y/WojdmWsNcOXqfInJVJnbe+PkNa3Ioqm0YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706346490; c=relaxed/simple;
	bh=sMPoJa2qt8hZ7DHv5C4anve1RMffvPcoBbMNn1ToDF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EnpGxp+LAMzftq30BmYM86ew883ytqW6wSdn3cHmL4d9g7LmQWEfgn3FcO49xPqUcYVMG/0h3MVd5yMe1YFC4dkJIhb9O4LOdea+tEFnyK9ZoQNGfkk1K+pVDmIlF69411o08bU/dYt1tt3yO6yc3XJB5Wo6t6Tbr6AosQ17YF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Message-ID: <6b65096d-3833-4aeb-ac88-7cabcab3d877@plouf.fr.eu.org>
Date: Sat, 27 Jan 2024 09:41:40 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help recovering my array
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com>
 <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <5112393.323817.1706145196938@mail.yahoo.com>
 <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
 <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
 <1822211334.391999.1706183367969@mail.yahoo.com> <17 00056512
 .428301.1706195329259@mail.yahoo.com>
 <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com>
 <1421467972.497057.1706207603224@mail.yahoo.com>
 <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com>
 <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com>
 <CAAMCDefv8XuxJqDOCQV+u80TT+Jnr8fVik+vzhc7NWy+NPU=Cw@mail.gmail.com>
 <394943768.706124.1706282116746@mail.yahoo.com>
 <277668438.720791.1706285018378@mail.yahoo.com>
 <1795235772.837302.1706312745369@mail.yahoo.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <1795235772.837302.1706312745369@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/01/2024 at 00:45, RJ Marquette wrote:
> Quick follow up:Â  When I rebooted, the partition tables got munged
> again.Â  Definitely a BIOS issue.Â  I have a 10TB drive on order, so I'll
> copy everything off, then rebuild the array in the recommended format
> with partitions, and see what happens then

You should be able to rebuild the array on top of the partitions by 
subtracting the partition offset from the data offset. If the partitions 
all begin at sector 2048:

--data-offset=$((262144-2048))s

Beware that /dev/sd* names are not always persistent across reboots, so 
check that the disks are in the same order as during the previous boot.

> (though one wonders if I even need an array when a single drive can
> hold everything...).

RAID5 provides disk fault tolerance. If you only need disk aggregation, 
you could use RAID0 or LVM instead.
