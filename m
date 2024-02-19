Received: from maiev.nerim.net (smtp-151-monday.nerim.net [194.79.134.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8B61F18D
	for <linux-raid@vger.kernel.org>; Mon, 19 Feb 2024 20:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.79.134.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708375690; cv=none; b=A3waiRlgW7jZg4xjx3xgBgU0WS4c6dE2TERoOaYuoq2eEtbFRR6r65m1r/sVikU5+RpAyRkDpFIyG9cvU109ck0/r7C4CxH55M95k/vEd1kvhm8ZBbgUQ31hQGdQAzealLDW1hO6/xvH9NpsOQ+/OKREg/ReSU3gsyXfL1+WjEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708375690; c=relaxed/simple;
	bh=kT3ZtO//aKAAeMxi6QFR3XaedPzR+k68cM4w3W2a6sM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=TvX4Jb66NZ/DO/H0jnMOeTKBs3+x4I/VXKYGmul8eVMbt9Qf+UmHW/DIqFE3LELJcxmnfsnNQOSLXdJbe4Uvj9DTKciCudG3Gh2fG+7PFNYDv3pJmSNXd2/zUhlW+IUb1YtuihXb4hNQ2uaZ9IxmimVeanzef1K3ZTJTmqlia7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=194.79.134.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
	by maiev.nerim.net (Postfix) with ESMTPSA id BF59D2E007;
	Mon, 19 Feb 2024 21:48:01 +0100 (CET)
Message-ID: <acea415c-36fa-4f5b-97d8-48c656cd8ad7@plouf.fr.eu.org>
Date: Mon, 19 Feb 2024 21:48:02 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com>
 <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <5112393.323817.1706145196938@mail.yahoo.com>
 <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
 <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
 <1822211334.391999.1706183367969@mail.yahoo.com> <1700056512
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
Organization: Plouf !
In-Reply-To: <1795235772.837302.1706312745369@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello RJ and others,

On 27/01/2024 at 00:45, RJ Marquette wrote:
> Quick follow up:  When I rebooted, the partition tables got munged
> again.  Definitely a BIOS issue.


Today I came across a similar issue with a RAID1 array of two 
unpartitioned drives where the RAID superblock on one drive was 
overwritten with a GPT partition table at every boot, but the superblock 
on the other drive was not affected.

It turns out that the affected drive had remnants of a GPT partition 
table (protective MBR at the beginning of the drive and secondary GPT 
header and table at the end of the drive), whereas the unaffected drive 
did not.

After deleting the secondary GPT header and protective MBR with wipefs, 
the RAID superblock was not overwritten any more. So it seems that 
something, presumably the BIOS/UEFI firmware, found the secondary GPT 
table on the drive and decided to "restore" the missing primary GPT table.
