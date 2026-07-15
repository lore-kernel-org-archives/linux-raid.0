Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB0F323417
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 07:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784100480; cv=none; b=rFGjLH3uSjIUEX8ua96r1/f+KELLSzzrLqtGQqPfERKTEdHHOGPeySeRbZBjPio7TYLXk9xiSz2ahAnXzSThsDNL6Mq9/6cRZhwy3NvZrDo11gXGVlUx63JgyP71+POHz0l4LLRoZmv4M2CYQBIhjF5a5a2mBvYVjpdJdOWOGaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784100480; c=relaxed/simple;
	bh=7KJq2wEkXM55IyRqftB9PGeiEn5vXd/1BLr3rnkTemY=;
	h=From:To:Date:Message-Id:Subject:Content-Type:Mime-Version:
	 In-Reply-To:References; b=QUD0rXqYlVmE3U2ce3b1yFu8jI9mMiOXk1KQh8yg5srqOr9WJAn3tuEGwptcsieA4wuhrUbW/Fpbqc2vGA+Wp65u1f3BMmwXS9NWxX1yS6vLxUmPq/LACAp5j++TRX7p8HpeS5tlkEcLyL/QVzkvFw/MHwatnqUC8e6Bcieyc5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=d/ydUePt; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="d/ydUePt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1784100451;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=7KJq2wEkXM55IyRqftB9PGeiEn5vXd/1BLr3rnkTemY=;
 b=d/ydUePtfQPR6Qtncls95SNw8Uz3AlyhOxMaq7IdCP1qBTHOdaBRzxOFhjM3wzxgJa1SCf
 dTqc6/al97hRPbWHq1DpxSaPPLDV5xrpojquF9vBMNvNwNlUasXL0N/MrjU1XPfznJsjhO
 o5M2jcDZTB7VhSx4XSh7UMp3Im2JeIiSP5x3nxiLi012shgrANQkdLmSDxemgFsF2un9IU
 eXoPp7Ll2T7PxAtHSg7rTlnyIuAy8Zt8Ixqdj8lKIjSDewoTz4MlBTLbinLobyKp3k7TC9
 aYJJnYiIlz4Hw232Z+loJDStlLbMwWXio1qzRiULfcwmZ2QhsRL0q/8SkLMizg==
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>, 
	"Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Wed, 15 Jul 2026 15:27:27 +0800
Message-Id: <2718fd27-9453-4dea-9d1d-13cfecef4e6c@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.feishu.cn with ESMTPS; Wed, 15 Jul 2026 15:27:28 +0800
Reply-To: yukuai@fygo.io
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <368d1223-1d41-4227-af33-bd6bd00b5c3d@hunenet.nl>
X-Lms-Return-Path: <lba+26a573661+2b3bf3+vger.kernel.org+yukuai@fnnas.com>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl> <m2y0fcesbe.fsf@gmail.com> <368d1223-1d41-4227-af33-bd6bd00b5c3d@hunenet.nl>

Hi,

=E5=9C=A8 2026/7/15 15:10, G.W. Kant - Hunenet B.V. =E5=86=99=E9=81=93:
> On 7/15/26 7:27 AM, Abd-Alrhman Masalkhi wrote:
>>> In other words, the first successfully recovered read request could
>>> automatically become a repair opportunity. The repair could even be
>>> scheduled asynchronously, so the successful read is returned immediatel=
y
>>> while the rewrite is performed in the background. Unlike a periodic
>>> resync, this repair would be driven by an actual read failure, making i=
t
>>> targeted rather than rewriting the entire mirror.
>>>
>> Yes, md has had this for a long time. Look at fix_read_error() in
>> raid1.c. It is called from handle_read_error() on any failed read. It
>> reads from a healthy mirror and rewrites the bad region on the failing
>> device, giving the drive a chance to rewrite or remap the sector. If the
>> rewrite fails, it records a bad block. md does this synchronously under
>> a frozen array, so it is not a missing feature.
>>
>> The likely reason you didn't see it is that your array was already
>> degraded, so there was no healthy in-array copy for fix_read_error() to
>> recover from. In your case, you were likely able to retrieve the data
>> due to btrfs level redundancy, and md can't repair across arrays.
>>
>>> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where =
data may
>>> remain unchanged for years, latent media degradation seems increasingly
>>> relevant. A successful read from the alternate mirror may be one of the
>>> last opportunities to refresh such a sector before it becomes
>>> permanently unreadable.
>>>
>> And Check/Repair is the right defense for cold archival data on large
>> drives.
> Thank you. fix_read_error() was exactly the piece I was looking for. I
> had missed that md already performs read repair when another healthy
> mirror is available.
>
> My situation was indeed different because the array had already lost one
> member, so the successful read originated from Btrfs redundancy across
> another md RAID1 rather than from the surviving md mirror.
>
> One question remains, though. check/repair periodically reads all
> sectors, but as far as I understand it, successfully read sectors are
> not rewritten. From a media aging perspective this is a different
> problem than recovering from a read error. Have there ever been
> discussions about a true media refresh pass that rewrites successfully
> read sectors to refresh long-lived magnetic recordings?

Perhaps this is what you looking for:

[RFC v2 0/5] md/raid1: introduce a new sync action to repair badblocks -=20
Zheng Qixing=20
<https://lore.kernel.org/all/20260203061259.609206-1-zhengqixing@huaweiclou=
d.com/>

However, AFAIK, Qixing no longer work in this area and there will not be=20
new version.

>
> Best regards,
> Dion Kant

--=20
Thanks,
Kuai
