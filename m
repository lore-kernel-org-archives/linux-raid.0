Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9DD1DA23;
	Thu, 16 Apr 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358990; cv=none; b=FUhHSmgVulvZQWm0ockTHxro0qzl/ZEEZ6M6l6Y5EfEoqY9yJtb1B20ibeDkuC3+9RVYP5Z4g+7or/cTs/Vl6gbnCgBdMHAcnRfoCOBUrorFgy9RdYPCvIoMt+P7v3UHeoXOTWfrzO8SrfHWyMgyrPXQIJXT1OVSzthGkGNIncQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358990; c=relaxed/simple;
	bh=CkT2Mkvuq4h7knuFYjVS0j+7pcNunecYN1l472zFcBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLxi/yn1t87WZenzCPTIO4KA3x4rSMF4d85H8vqw1iRash67CAuIPNdTRklN2iXpRdO9sPK2kYdIrQG35H0xSAkD1s9dyd2GAfZ/HjxGiEhwoFYUoutsPqA8Vo3GB7QIFX14qpiH05Abbv0FKzOFV/TrTk4bUBXrQPfbyjpxdwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ioDzWc+s; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ioDzWc+s"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB91B24E9;
	Thu, 16 Apr 2026 10:03:02 -0700 (PDT)
Received: from [10.1.196.85] (e121345-lin.cambridge.arm.com [10.1.196.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D90EB3F7B4;
	Thu, 16 Apr 2026 10:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776358988; bh=CkT2Mkvuq4h7knuFYjVS0j+7pcNunecYN1l472zFcBU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ioDzWc+syAC3h6+Pv/+21Qijh7CWWtaL3WjagXKgMGHCPNhFYIBCfP2/1QvFa8/8m
	 B8wice+IBUrMmdb+VgUuF1kE9Q5j0Gm44XkEYbnY0QUk7x4WlC3rcl0ewRiBuPsTn9
	 TDEl21dtvFsHULTY/kZYlL/XWLa3zbJkWbquMKIQ=
Message-ID: <d2e44254-a61d-4429-8902-4f508cd5d90a@arm.com>
Date: Thu, 16 Apr 2026 18:03:02 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
To: Mark Brown <broonie@kernel.org>
Cc: Demian Shulhan <demyansh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Mark Rutland <mark.rutland@arm.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, Li Nan <linan122@huawei.com>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
 <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
 <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
 <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
 <acc15515-4c43-402c-9800-c9b5e3da9891@sirena.org.uk>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <acc15515-4c43-402c-9800-c9b5e3da9891@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/04/2026 5:47 pm, Mark Brown wrote:
> On Thu, Apr 16, 2026 at 05:26:08PM +0100, Robin Murphy wrote:
> 
>> Unless you've got a CPU with truly big wide vector units that _can't_ be
>> fully utilised by ASMID ops, then SVE is only really offering whatever
>> incidental benefits fall out of smaller code size. However, if you do have
>> those wider vectors, then the cost of correctly saving/restoring the SVE
>> state - of which a userspace benchmark isn't likely to be very
>> representative - is also going to scale up significantly.
> 
> The other case will be when there's some SVE only extension that
> accelerates something that's relevant for the algorithm.  That's not
> really a thing at present but I imagine that we'll run into that at some
> point.

Indeed - I was implicitly thinking in terms of things that _are_ just 
transliterated from NEON to SVE, where the primary gain is stuff like 
predicate loops, but even that _could_ potentially be enough to justify 
an argument in-kernel SVE (using a 128-bit VL to keep the additional 
state/cost to a minimum).

Cheers,
Robin.
