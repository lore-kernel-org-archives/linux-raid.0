Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49146168BD
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 12:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.10.76.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709380998; cv=none; b=ONDKR+KERmM37g/4e+1uTPFWZ3/GuV4aiGF2vU8VRP7AFnmENfp5mHSE7XLdmcwg3Q67LS6YHlY7jEn06hD+ZnW8SC8sagcMYzyIg/tYNsR1LzPyWB0nYu2g0YiqNSppZTMcb2qdppqeQuu05jjoelR7xf6I8izJguRbUMVtwfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709380998; c=relaxed/simple;
	bh=mYpaZGHoxnh8hJTOKfaRX2nB5gRR49vTva+wnRd79BA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Kvy9HbrdVQ9tGU0z4CxPGAmU7I1EOAXg8VLvb1ANouPTTX9aJO/x3fpVfVrGVmvt/lmUgbeOJzJdfjb3Xvn+EV8rmnw8pF2HtSzUqtoJyJajDp/AjS8Pw+N3CutYfEpfkIFdUj4q6521D/y5M0INiRRHPm7mMY6oz4tajvRxT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au; spf=none smtp.mailfrom=eyal.emu.id.au; arc=none smtp.client-ip=203.10.76.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=eyal.emu.id.au
Received: from [192.168.2.7] (unknown [101.115.15.116])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailhost.tip.net.au (Postfix) with ESMTPSA id 4Tn3KB2887z9R4m
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 22:54:22 +1100 (AEDT)
Message-ID: <7453a03a-33e2-414c-aa06-b71d71d2ad5c@eyal.emu.id.au>
Date: Sat, 2 Mar 2024 22:54:14 +1100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Requesting help with raid6 that stays inactive
Content-Language: en-US
To: linux-raid@vger.kernel.org
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
 <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org>
 <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
 <bc3475bd-cdf7-4698-b21a-236e4d055537@plouf.fr.eu.org>
 <CADC_b1fhFm61QcQd_xud+fS=_068cnf=Hv99SGAeSms-Z-9igg@mail.gmail.com>
From: eyal@eyal.emu.id.au
In-Reply-To: <CADC_b1fhFm61QcQd_xud+fS=_068cnf=Hv99SGAeSms-Z-9igg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/24 20:55, Topi Viljanen wrote:
> Hi,
> 
> syslog entries before any problems:
> 
> Feb 18 19:52:53 NAS-server kernel: [    5.755150] md/raid:md0: device
> sde operational as raid disk 5
> Feb 18 19:52:53 NAS-server kernel: [    5.755158] md/raid:md0: device
> sdb operational as raid disk 0
> Feb 18 19:52:53 NAS-server kernel: [    5.755160] md/raid:md0: device
> sdf operational as raid disk 3
> Feb 18 19:52:53 NAS-server kernel: [    5.755162] md/raid:md0: device
> sdg operational as raid disk 1
> Feb 18 19:52:53 NAS-server kernel: [    5.755164] md/raid:md0: device
> sdd operational as raid disk 2
> Feb 18 19:52:53 NAS-server kernel: [    5.755166] md/raid:md0: device
> sdc operational as raid disk 4
> Feb 18 19:52:53 NAS-server kernel: [    5.757272] md/raid:md0: raid
> level 6 active with 6 out of 6 devices, algorithm 2
> [...]
> Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdc [SAT],
> ST4000DM004-2CV104, S/N:WFN14WVT, WWN:5-000c50-0bee83a77, FW:0001,
> 4.00 TB
> Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdd [SAT],
> ST4000DM000-1F2168, S/N:Z305RJAR, WWN:5-000c50-087ccf402, FW:CC54,
> 4.00 TB
> Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdb [SAT],
> ST4000DM000-1F2168, S/N:Z305RFDP, WWN:5-000c50-087cd03a5, FW:CC54,
> 4.00 TB
> Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sde [SAT], WDC
> WD40EZRX-00SPEB0, S/N:WD-WCC4E7TULA48, WWN:5-0014ee-2b5d93dd9,
> FW:80.00A80, 4.00 TB
> Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdf [SAT],
> ST4000DM000-1F2168, S/N:Z305RVDW, WWN:5-000c50-087cc5e98, FW:CC54,
> 4.00 TB
> Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdg [SAT],
> ST4000DM000-1F2168, S/N:Z305RTB8, WWN:5-000c50-087cc9d0b, FW:CC54,
> 4.00 TB
> 
> Isn't that quite clear how the order should be? I have added those
> disks to the create array in that order 0,1,2,3,4,5
> Should I try something else?

What is meant by '0,1,2,3,4,5'? You mean some order of /dev/sd{x,y,z,...}.
Now the disk names may be different from your old setup. This is normal.
You need to use the Serial Numbers to have the correct order.
So in this case I see
	0 sdb Z305RFDP now sdx
	1 sdg Z305RTB8 now sdy
	etc.

Or maybe you already did this, so ignore this note.

> I was wondering if the problem is unused space? The only disk having
> it partition table have this:
> Unused Space : before=254896 sectors, after=7856 sectors
> 
> So if creating a new array starts from the wrong place? Can that be
> somehow inspected?
> 
> Topi
> 
> On Sat, 2 Mar 2024 at 11:46, Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
>>
>> On 02/03/2024 at 09:50, Topi Viljanen wrote:
>>>
>>> I was able to get the order of the devices from old syslog file
>>> (smartd) and then created the array again:
>> (...)
>>> Running fsck caused so many errors that the mounted ext4 was empty.
>>> I reset the overlay array and now I'm running analyze with testdisk.
>>
>> Then I am afraid that the order was wrong and testdisk will not be able
>> to retrieve much.
>>

-- 
Eyal at Home (eyal@eyal.emu.id.au)

