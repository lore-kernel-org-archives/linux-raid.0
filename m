Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D5C1E5B8A;
	Tue,  3 Jun 2025 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748976039; cv=none; b=h2Ka23uYJhvt2NEc9d4mcuWbyEIkufcaNko5dmXiJrieDXyPxYMg9ir1Gk4B6I3m1LQdwLt861m9NqZiDH0ZHqfU7D503fotnpWv9VNDqa6n4UWMN/TDSolajnykVvLWqlYrMApLb75l1hg10xQ+wPLxqqwtsqMn265WXJrCfqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748976039; c=relaxed/simple;
	bh=A5uCvfqMH8V0O9TQhO/y9GstSvTUkLvakjDtT1bYCMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpDsgCfwfFZgcidvlyc3ipvdjsioT5kZSMM0AxJ4MJmFiqM78OKtxirMkR71Lw3knFZsTQDC7dXkXxQocd2cBtJ9+dGD0Khq35hPUdLIbnNLu33iMzTVCGrhV9KgE5rapwoxEYz1fj91aXH9etd9v7ySH5ukOEHHMD3SwEo/79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=pass smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=youngman.org.uk
Received: from host86-158-182-88.range86-158.btcentralplus.com ([86.158.182.88] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1uMUm2-000000009Sz-8ek7;
	Tue, 03 Jun 2025 17:46:03 +0100
Message-ID: <24815d81-2e4f-4ddf-b194-b03ea3232b91@youngman.org.uk>
Date: Tue, 3 Jun 2025 17:46:01 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Need help increasing raid scan efficiency.
To: David Niklas <simd@vfemail.net>, Linux RAID <linux-raid@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/06/2025 02:05, David Niklas wrote:
> So I setup the array into read-only mode and started the array with only
> two of the drives. Drives 0 and 1. Then I proceeded to try and start a
> second pair, drives 2 and 3, so that I could scan them simultaneously.
> With the intent of then switching it over to 0 and 2 and 1 and 3, then 0
> and 3 and 1 and 2.

BACKUP! BACKUP!! BACKUP!!!

Is your array that messed up that it won't assemble? If you can just get 
it to assemble normally that's your best bet by far. Trying to assemble 
it as two pairs is throwing away the whole point of a raid 6!

And make sure you know the order of the drives in the array! I hope you 
haven't lost that infof.

If your event counts are all similar, then you'll hopefully recover most 
of your data. Your biggest worry will be the mobo and ram having 
trashing an in-flight write that corrupts the disk.

Then once you've got the array assembled, I can't remember the command, 
but there is a command that will read the entire stripe, check the 
paritIES - both of them, and recreate the data. If that fails, your data 
is probably toast, and nothing you can do will be able to retrieve much :-(

Cheers,
Wol
