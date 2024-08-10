Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F220D142903
	for <linux-raid@vger.kernel.org>; Sat, 10 Aug 2024 08:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723277523; cv=none; b=UDgFjKkURFDO1VgUhBurfxJID/HqOW5LyxJpOFOMCwBPBxHgw6pOLi8stFBT4CwGAhC7WS74HMPirLVkrx1FwFynsz2yWO2hQVDf3/R8hPmwf6VTJwNxaugWN5ksr/7kuMTnZ0XviFoOhaFtTajIy77hhZ+R0shscNCM/jd3XfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723277523; c=relaxed/simple;
	bh=qYXdG1ddn1VzJny9ewrKdJk0vR6qmQ6oGiC9PWn+rrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRmoXqzRzcM51e0xCSUr4aPmQinvjYcyBOqEuZrBpjA+Nl5CDGlTL7EWQsHibkVwVeRvA/AZPvl6Vu1jPHZaz7IaigFflf21aHAPHVUAbHnIKRUHPMorBlniPtDt9RNwgocC/eYu3yIaSa1gRLsfJ2kiUMc+Wwz/IXJwGh7J06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1schCe-0000vR-2d; Sat, 10 Aug 2024 10:11:56 +0200
Message-ID: <e00600a9-7f24-42c2-8848-b980516785f9@plouf.fr.eu.org>
Date: Sat, 10 Aug 2024 10:11:54 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID missing post reboot
To: Ryan England <ryan.england@lambdal.com>
Cc: linux-raid@vger.kernel.org, Roger Heflin <rogerheflin@gmail.com>
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
 <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com>
 <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com>
 <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com>
 <CAEWy8Swxj-RFZ=kya=ECYJLqX3a1-HysRRDXNvw70Go8v0Ou4A@mail.gmail.com>
 <CAAMCDefBkSsF4ZPOtWmsT2UieM-Obvovxud1U7-DbAk2CMx-SA@mail.gmail.com>
 <CAEWy8Syh+eMq_5-gTsLoXkT5LqVE4AUJWMGzVpRjS3pzF+YYyQ@mail.gmail.com>
 <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com>
 <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org>
 <4E85ED2F-4B9E-4E82-A006-A4BFD66DBC87@lambdal.com>
 <CAAMCDed-pHOvLQzHKKtwumT_LY5k2BSvC+0zTTiZ+eqjUejT4A@mail.gmail.com>
 <6C9556F9-2915-4680-AC81-FEE0460B8E71@lambdal.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <6C9556F9-2915-4680-AC81-FEE0460B8E71@lambdal.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

My replies inline.

On 10/08/2024 at 03:03, Ryan England wrote:
> Is there any good documentation available for md? I'd like to be confident we're setting this up correctly.

man md
man mdadm
raid.wiki.kernel.org

> On August 9, 2024 8:37:09 PM EDT, Roger Heflin <rogerheflin@gmail.com> wrote:
>> I may be mis-reading what a partition looks like on nvme.   if nvme0n1
>> is the whole device, then you probably want a partition.  I

NVMe naming scheme is a bit confusing. nvmeX is the physical device but 
is not a block device usable to store data. IIUC nvmeXnY is some kind of 
"physical partition" or "logical drive" defined inside the NVMe embedded 
controller and is a block device used like any regular disk sdX. I guess 
there may be several of them, but I have only seen nvmeXn1 so far. 
nvmeXnYpZ is a "logical" partition (not in the sense of msdos 
primary/logical partitions) like sdXY managed by usual partitioning 
tools such as fdisk or parted.

> How would you use parted to create a partition you would use for software RAID?

wipefs -a /dev/nvmeXn1 # remove metadata from the drive
parted /dev/nvmeXn1
  create a GPT disk label and a partition with raid flag
wipefs -a /dev/nvmeXn1p1 # remove metadata from the partitions
mdadm --create ... /dev/nvmeXn1p1

>> The original report showed that on nvme0n1p1 there as appeared to be a
>> gpt partition table.

And this is what puzzles me. I do not see how it could happen, except if 
someone did something extremely unwise such as running parted on 
partitions /dev/nvmeXn1p1 after creating the RAID array.

>>> You also mentioned using wipefs to wipe the metadata. Would you run the following:
>>> - wipefs -a /dev/nvme0n1*

wipefs does not support multiple devices.
