Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76454211A11
	for <linux-raid@vger.kernel.org>; Wed,  5 Feb 2025 20:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738788147; cv=none; b=ctFqPKux/rUQeVWKjzbIN4nLFKtlhWvL4PyTxRhNQTKmNlCKeCoGA4Jo1cM7+QPTFDtFOyvuUh3khHhd7e6stvsed1+eNNsGgCwW5WCn0e1Xo3oSoQgKj+UmXUayVVi2xE6N89BGtiAn3s9Dws8kQ6JEjtI1xPHu2EbeG4E4WS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738788147; c=relaxed/simple;
	bh=ShFQEUuopGVHsGdozUnx5z6bRD6ezGo9Xj8m3T3/dWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mST8fc0ZlJOAEGdiJJoFUA1dB8oCKotGqP6QPNTdeneI2qzgQxnmApvYPjsjmE935AEUBQkamVRTI+WQopUcWkhFNtXnTDvvmGpteqs/NnOuGcriBpbI4n2hES1zGboEMHJ/nVvn7D0cT1SqJa4PA0v2TQKVFT56TLrNbnQQ6CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1tfmDv-0004AI-Fq
	for linux-raid@vger.kernel.org; Wed, 05 Feb 2025 21:42:15 +0100
Message-ID: <1826ee0e-ac29-4b45-bd3e-54ea81be684a@plouf.fr.eu.org>
Date: Wed, 5 Feb 2025 21:42:12 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with RAID1 - unable to read superblock
Content-Language: en-US
To: linux-raid@vger.kernel.org
References: <CAD4guxO5uyTZWuOxzMAj1WqAY1UHnfAqGgia1QZiqiaOQv=89Q@mail.gmail.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAD4guxO5uyTZWuOxzMAj1WqAY1UHnfAqGgia1QZiqiaOQv=89Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/02/2025 at 13:03, Raffaele Morelli wrote:
> 
> Last week we found it was in read only mode, I've stopped and tried to
> reassemble it with no success.
> dmesg recorded this error
> 
> [7013959.352607] buffer_io_error: 7 callbacks suppressed
> [7013959.352612] Buffer I/O error on dev md126, logical block
> 927915504, async page read
> [7013959.352945] EXT4-fs (md126): unable to read superblock

No error messages from the underlying drives ?

> We've found one of the drive with various damaged sectors so we
> removed both and created two images first ( using ddrescue -d -M -r 10
> ).

Is either image complete or do both have missing blocks ?

> We've set up two loopback devices (using losetup --partscan --find
> --show) and would like to recover as much as possible.
> 
> Should I try to reassemble the raid with something like
> mdadm --assemble --verbose /dev/md0 --level=1 --raid-devices=2
> /dev/loop18 /dev/loop19

If the RAID members were partitions you must use the partitions 
/dev/loopXpY, not the whole loop devices.

If either ddrescue image is complete, you can assemble the array in 
degraded mode from a single complete image.
If both images are incomplete and the array has a valid bad block list, 
you can try to assemble the array from both images.

In either case, assemble the array read-only.
