Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3928B357CFD
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 10:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705605; cv=none; b=J9zcNgJ77f56qIM746sDtly5UMBU5o7s//IFEa2IL9AvXaB7vEa9ETxhdmjH1Eo+55cf1IFRIX3m9wR2vq/EZ3Za1HuDwh3n2n2+6Uhcz7emMYfxzftVyCjFhVYviSnYwfqaATeNiWkgBPQGfJ4oyLZrTIfktp1h5teiqQ6ZLnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705605; c=relaxed/simple;
	bh=1WQxn63NIXtnCgMXywNRTdDL967YTuGaNIhWaIgrmvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZN/kr9ZEDxuev9D38Dj2ogpTUDcClozq+xwWx02TC6799lzrIkUdepakH+FwYihnBxUgvhWL8ddNutG/ZeZknmtlJEi3SKBjewXRdmloHd4bBL+9f1kmt5q5nj9W7ncrcWKFc3d4AUXCzmXIqIeSnZxfyuaMxArf8vd+swjIyao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LTk1mCpV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LTk1mCpV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49056b9f04aso21354435e9.0
        for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 03:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779705602; x=1780310402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wAna2ci1WHhIvRqtMxw+zCNowh//V2ruxkoScYbJVwI=;
        b=LTk1mCpV40QE3SjiXexXB1QcmN9pyD+AnePJcS80eNFEEbCQ0z2qr3H46oHaRES+/J
         vbjidfv5D1QxzqglvbGJXuFoQbJqVP7e+/OH78cjjrtmJ3s5e+3tVUl/HCHJ9Jty041x
         aWRh6+1IOhgAAo5O3EbcSvIH16HGc1e/1/pDEOH39HGO77n4GORfa6iBClqfZZHiVLCm
         vuiUOBScuvhbo8FgW3EXXDT35kPtBh5FnxzRfKuLxD6ng/VUkYExBs/LAd3qDwrzi/vg
         IKVebBbrObu9XUi7dX9PsKv1jpP2tScEfVtziZWzvWiU+S8KvBtGcnJGTUgjvJFEwrEP
         EC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705602; x=1780310402;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAna2ci1WHhIvRqtMxw+zCNowh//V2ruxkoScYbJVwI=;
        b=qjRwyYgO7QwuYW7fth+9IfZN995wmF2NzWRnlQTEZntRQkXRlhL3lCU/zq7GO4CEOv
         9c7GybM9VijsFnpka8x2a+Qfjg9sWPmF1Jh0JQzH5prFepBAlH1/8Rk545XAHUCashU7
         5MCpoVCXyIysJRKzWZrFvxA1y0iSfeExD6VHHlc9MfVgWkYo5dkMXTk0jFUFFuMEv1jy
         DqvyIVJTZhFO2qJck0Kvevy2MtJBjo2d25a2LPfUdk/WTa6mpC1YWGeOpNLEKlgHTf3N
         aqlQDVyN8vunrcPU7v+ZrDoA2W5e2AYRnUdDZ0cEE5CNPcUMYaF+bk7zPlwU/vqcwO7L
         F81w==
X-Forwarded-Encrypted: i=1; AFNElJ+YEJ7mof3OoFY567hk/CZr6Bqs0l5br38/i67HfdBrCHOfjzbxTVSH/oQpR3VRkk0uEfgmD0bY7GqK@vger.kernel.org
X-Gm-Message-State: AOJu0YxuDxS6++7iWAV2LscCunCT06/0XXyNh5nj608PMzZ0h/RFJ5v9
	LNZCs3oP3jvrFkJSIdhZeQlziC4Arue5Mj2JesB10zZEAUAWGqzjxNEmsoNVMbn6wfg=
X-Gm-Gg: Acq92OHlEaCUPB1en5tA+pwRoNtmh7b9bi6iyFbrKTVIg4XiAr7KTDgVdVOgDRUXMVK
	F/sHZfksWVxH3QO2Mdt18EEFr2wHF4TRe+2/B8lvlfVBsyjGmwdv8Z8fFXV4d7EHC/XWpDHZfBs
	BsSzLu0yknrPruOdTr2Lcdd9jXKE7uyP8tJZ5WsjR1R42qjU9wmz1Hh29vN9Bph52v1stRLd0/N
	KGTa5igYgDnI89TRtSK7eOLEO5dt/spvxzkSTQN9dAtKR9rvXmvbAaYB6ZGx+ID0YwykSWkAcQ8
	+k2daAq1wGvCXGrj5/L5/2o7jn0JScPiZR21xjqSy6ZMDK1VoFR8LY7wb/h1aGIc/zJkGGk/qES
	DStQRzIziQu56lTdJBnj5W4Sf5FbNuZtHL/Uk/eLqqHO73kHdLo+ji7HDMImbKzgYYLHgUuzYje
	vtYY/1iUmFF5or3qKcjNkJL3nLu0XP/lKlNqD66Qm05DXuYeKlJN4nfLE5ZjgVkRK1qirHBpZZU
	tmypoe6jQafbT7NC+xP+zwKxoWonuLfyUdJu62WnohojfBR3rBr8E7uug==
X-Received: by 2002:a05:600c:4f91:b0:490:6e12:a40f with SMTP id 5b1f17b1804b1-4906e12a673mr7412805e9.12.1779705602494;
        Mon, 25 May 2026 03:40:02 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56b19f3sm121469395ad.18.2026.05.25.03.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 03:40:01 -0700 (PDT)
Message-ID: <e5eafd64-2704-42de-ad7b-e4f170c451e4@suse.com>
Date: Mon, 25 May 2026 20:09:54 +0930
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz> <20260525060030.GB3370@lst.de>
 <20260525101707.GV12792@suse.cz>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260525101707.GV12792@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 19:47, David Sterba 写道:
> On Mon, May 25, 2026 at 08:00:30AM +0200, Christoph Hellwig wrote:
>> On Sat, May 23, 2026 at 04:23:44PM +0200, David Sterba wrote:
>>> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
>>>> Recently kernel RAID56 lib is trying to remove the unexpected
>>>> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
>>>> btrfs still supports such setup, which means in the long run btrfs has
>>>> to handle such corner case by ourselves.
>>>>
>>>> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
>>>> P/Q stripes all match each other, rotation also makes no difference.
>>>>
>>>> This patch will disguise those single-data-RAID56 chunks as
>>>> RAID1/RAID1C3 chunks.
>>>
>>> I don't think this is the right way to fix it. Calculations are an
>>> implementation detail and should be done at the time of the xor_gen or
>>> raid6_call, not touching the upper level structures related to format.
>>
>> It absolutely is.  Adding fast path workarounds for this is completely
>> stupid when it can be trivially handled on the mount side.
> 
> It's a lazy hack at best and fix on absolutely wrong layer. The library
> should provide the support for the edge case. But we disagree on that.

I strongly disagree.

Firstly on the layer to fix, let me be clear, if something writes like 
RAID1, reads like RAID1, repairs like RAID1, then it's RAID1.

With that mindset, changing chunk type at read/add time is exactly the 
correct layer to fix.

Or let me change the title of the patch, ENHANCE single-data-RAID56 
handling to get rid all the corner cases.
Do you still think that's the wrong correct layer to fix?

So the wrong layer argument doesn't stand. If you're so focused on 
fixing the problem in the library layer, then all you can see is to put 
some adhoc fixes to emulate the library fix.


Furthermore, we are already doing all the warning about 2-disk raid5, 
now I'm providing a solution that is as mature as RAID1, now you're 
complaining about the simplicity but wants all the complex striping and 
reduced read performance?

I don't see any point in this.
