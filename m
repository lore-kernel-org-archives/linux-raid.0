Received: from mail-108-mta91.mxroute.com (mail-108-mta91.mxroute.com [136.175.108.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3726227E92
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 15:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741014967; cv=none; b=oyRcefdVzUUbW5NyYk06sVbLc18WMkEq46knGBXk49duKyRGsr+VRqJbRkqISoucrIs54lXCJAcxL1m65ljmnH+Eh9MtEMoHkCxbUGba/Lrj4Wg6e1TU8M6rkPKHuKQv23X6H2BtEE/pGaLFIdo79jEJOsTpxSqmlHE1kIRcL+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741014967; c=relaxed/simple;
	bh=m3oTGnYxUuCHsLj1o1Q+Oj55N3HKpRShzNt3c5JvMfU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kr91U+t3QuAbsSt5THKgG4aAjgjoibpDRYc+jPFqmMb3eV85J1fHTYndYGkHAIH7yQQdpzxjsIXBfwcuhwDTe4fWGFy/IvIPii5GM72UaqdXBD5BGFdyqKA4UfJO6RoYK6Hwdag0Jkx1b4MrTZG1gL/gKpazNi84oLWSkCix1Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=XJpBgMMd; arc=none smtp.client-ip=136.175.108.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="XJpBgMMd"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta91.mxroute.com (ZoneMTA) with ESMTPSA id 1955c8f4d5e000310e.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 03 Mar 2025 15:10:50 +0000
X-Zone-Loop: f3eb83198879f417e6827fdd268114b133b3499a3b1f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2+edN7H6bmOfTLox3uYv85tHQhlhDZ3gALKV+Pxfzv0=; b=XJpBgMMdYBuED7K2ULBXVUeSdz
	iq1LzTTFVScJNRdIa5ePcShmCUNAcPusdrShceW+bFO8xQrunJnBPlRnxc7LXzcR8qYnGb5jAa327
	55gQxh3kwwPh1+vuL4rloy3PiQYzK14uvvnn67xsnoNzDhj+J1zmmftTQtcZpfgxlM7XpfSWlKAdp
	3D7AI3gYDnJJ3Y2xQ0Dd2P3eQy2L3PEZ7TK3t938nktA5X4g/eAS7DryQSoomGNI2OCDDX3+vRzFs
	yS2WKoINOHouNBs8ifA3vn1z7uapcUQtszY0Wth90NT8Cnk1BYfaxONpHFTPOPkzw/7zNDMDHMkeO
	FYYu+fvw==;
From: Su Yue <l@damenly.org>
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,  Nigel Croxon <ncroxon@redhat.com>,
  linux-raid@vger.kernel.org,  Song Liu <song@kernel.org>,  Jonathan
 Derrick <jonathan.derrick@linux.dev>,  "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: md bitmap writes random memory over disks' bitmap sectors
In-Reply-To: <CALTww2_BtecKOjJy+2xDAeAB26BgOhHF8fk-=ksjThebATdeKQ@mail.gmail.com>
 (Xiao
	Ni's message of "Fri, 28 Feb 2025 15:46:39 +0800")
References: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com>
	<8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
	<CALTww2_BtecKOjJy+2xDAeAB26BgOhHF8fk-=ksjThebATdeKQ@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 29.4
Date: Mon, 03 Mar 2025 23:10:35 +0800
Message-ID: <o6yip2tw.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Fri 28 Feb 2025 at 15:46, Xiao Ni <xni@redhat.com> wrote:

> On Fri, Feb 28, 2025 at 10:07=E2=80=AFAM Yu Kuai=20
> <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> =E5=9C=A8 2025/02/25 23:32, Nigel Croxon =E5=86=99=E9=81=93:
>> > -       md_super_write(mddev, rdev, sboff + ps, (int) size,=20
>> > page);
>> > +       md_super_write(mddev, rdev, sboff + ps,=20
>> > (int)min(size,
>> > bitmap_limit), page);
>> >          return 0;
>> >
>> > This patch still will attempt to send writes greater than a=20
>> > page using
>> > only a single page pointer for multi-page bitmaps. The bitmap=20
>> > uses an
>> > array (the filemap) of pages when the bitmap cannot fit in a=20
>> > single
>> > page. These pages are allocated separately and not guaranteed=20
>> > to be
>> > contiguous. So this patch will keep writes in a multi-page=20
>> > bitmap from
>> > trashing data beyond the bitmap, but can create writes which=20
>> > corrupt
>> > other parts of the bitmap with random memory.
>>
>> Is this problem introduced by:
>>
>> 8745faa95611 ("md: Use optimal I/O size for last bitmap page")
>
> I think so.
>
>>
>> >
>> > The opt using logic in this function is fundamentally flawed=20
>> > as
>> > __write_sb_page should never send a write bigger than a page=20
>> > at a time.
>> > It would need to use a new interface which can build=20
>> > multi-page bio and
>> > not md_super_write() if it wanted to send multi-page I/Os.
>>
>> I argree. And I don't understand that patch yet, it said:
>>
>> If the bitmap space has enough room, size the I/O for the last=20
>> bitmap
>> page write to the optimal I/O size for the storage device.
>>
>> Does this mean, for example, if bitmap space is 128k, while=20
>> there is
>> only one page, means 124k is not used. In this case, if device=20
>> opt io
>> size is 128k, this patch will choose to issue 128k IO instead=20
>> of just
>> 4k IO? And how can this improve performance ...
>
> It looks like it does as you mentioned above. Through the commit
> 8745faa95611 message, the io size(3584 bytes, 7 sectors) is=20
> smaller
> than 4K. Without the patch 8745faa95611,  the io size is round=20
> up with
> bdev_logical_block_size(bdev). If we round up io size with=20
> PAGE_SIZE,
> can it fix the performance problem? Because bitmap space is
> 4K/64K/128K, if it doesn't affect performance only changing the=20
> round
> up value to PAGE_SIZE, it'll easy to fix this problem.
>

I'm afiraid that the perf will drop if rounding up io size to 4K=20
for devices
optimal I/O size smaller than 4K. IMO better version of=20
md_super_write to is
necessary to handle bitmap pages as Nigel said.

--
Su

> Best Regards
> Xiao
>
>> Thanks,
>> Kuai
>>
>>
