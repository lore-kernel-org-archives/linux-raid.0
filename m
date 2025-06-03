Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CDF221703;
	Tue,  3 Jun 2025 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982462; cv=none; b=PhaJvvXuEwSVdMwiR2o3Ml/DZBoBGq4u619Nwutsx3qnYznEdZ8dhCRdfyja8s5kVX8YXDg3omilIgyQw/wxVPJkc0ha0DDqw3DzelKoV2OPuiMdXCaUi7SxhfwTsGjJ5xZBtfEZvxAQoHXLG4APIkQRM0EdNyntVGu/XnaadY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982462; c=relaxed/simple;
	bh=CFN5r97BmjCk03+Y1LKtu0Hgmvt5GG0TdJzsWkiMK24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sh4n3Wx++VXzSusLlARqoh1565+kJWdIdNIQrBWtkJQqY3ESHBqKoEoGUrKrFmSK7sAN7/BYuMdYK2ZP05rTrk89RTlgyP6/Y+mAEbZiyDhxkl2jTKqsDJE8w8IJWONfTyWgl456108L/PirQyBh8cnQ4u8vOSSDNT+AcvXjF8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host86-158-182-88.range86-158.btcentralplus.com ([86.158.182.88] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antmbox@youngman.org.uk>)
	id 1uMYES-000000004ba-3d8w;
	Tue, 03 Jun 2025 21:27:37 +0100
Message-ID: <b23b6075-e177-4a85-b34b-e7f5feb95291@youngman.org.uk>
Date: Tue, 3 Jun 2025 21:27:35 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Need help increasing raid scan efficiency.
To: David Niklas <simd@vfemail.net>, Wol <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
 <24815d81-2e4f-4ddf-b194-b03ea3232b91@youngman.org.uk>
 <20250603160415.61c9ca7c@Zen-II-x12.niklas.com>
Content-Language: en-GB
From: anthony <antmbox@youngman.org.uk>
In-Reply-To: <20250603160415.61c9ca7c@Zen-II-x12.niklas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/06/2025 21:04, David Niklas wrote:
> Searching online turned up raid6check.
> https://unix.stackexchange.com/questions/137384/raid6-scrubbing- 
> mismatch-repair
> 
> But the people there also pointed out that Linux's raid repair operation
> only recalculates the parity. I would have thought that it did a best of
> 3 option. I mean, that's a big part of why we have RAID6 instead of RAID5,
> right?

 From what I remember of raid6check, it actually does a proper raid 6 
calculation to recover the damaged data.

Raid 5 certainly just recalculates the parity, but it doesn't have any 
choice. Because it can only reconstruct ONE piece of information, it can 
detect the corruption, but it has no idea WHAT is corrupted. So it 
assumes (with good reason) that it's the parity and re-calculates it. 
Where raid 5 scores is if you lose a block, or a drive, or whatever, it 
is told what has been lost and can recreate it. If your data is 
corrupted, however, it has two pieces of missing information ("what" and 
"where"), and can only reconstruct one, so it assumes it's the parity 
that's been lost.

Because raid-6 has two levels of redundancy, if ONE block is damaged, it 
can work out both what and where, which is what raid6check does.

I've done it slightly differently, I've got raid-5 sat on top of 
dm-integrity, so if a disk gets corrupted dm-integrity will simply 
return a read failure, and the raid doesn't have to work out what's been 
corrupted. I've got a different problem at the moment - my array has 
assembled itself as three spares, so I've got to fix that ... :-(

Cheers,
Wol
