Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E994F3CAE69
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785415302; cv=none; b=hjtGsbXBstXXTdBbuE2wx5XfTVgk2wCAuvKxG+lB2kKOZu1fVZL7T391cw3Wlmbyit59rfWbYhU/78OPb2uR4iCsVHekvefsnsW7CxB6T56h+ZfHjJ9FChCfhA4I8N9+hYVCBuzDYyYl4iaBgbFvesXVaNjX9cyCxjEkHtrD83Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785415302; c=relaxed/simple;
	bh=7FKAud3RJkS0WUSbn56LdaDVHDmQ9sqTrG8i3zJGSx0=;
	h=Date:References:Message-Id:In-Reply-To:Subject:Content-Type:To:
	 From:Mime-Version; b=VQk5Atup2WRJikNnd+C0/oKGMstaLqwHIz4IbPb9LfRshQ1445V/IcaHnlef0AyIhiG6SCzRsLHbHWjbKs3tLhwxolOaVtmxxg74YIs26BTb0hAueW3NoqM0swxKRj0ZnQUhhyaxnCmnuMzxzckmUDRfiKP9lErcaI/w1gu3Lt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Wtn4Jc1o; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Wtn4Jc1o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785415287;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0D/sfNQQZ3XP8CzRqls+X0+1/mjRctG/tGZ5+xQohlg=;
 b=Wtn4Jc1oplkhlEKsZUbr/WvxksPbNUAvNg86uOsnPMnE0ryyFzGNhrZtaHc1KOnQli343g
 2SM+aTF8hBuXX7qyi2wAtsxpgQh0WFY329/kuuo7L3mo0Aio/Wg1BHQgxVcDdtVRh0d1bc
 a/i0plR0BPapYFlIn1Unv3Zc1X75RCP13j9hWX+dB5KNTTnU7R35kou2rH8K+fv2WnbQQT
 6h3zDrRvBex+chVOjdj4JFiJfuG3lq9RiE3Od8Jg8vPUCFE9XS5Zin775UguEMJPmH8pK9
 sL4tKkbe8zJ1kIMfd5oQrYLl0aHpUhx6/lIADiGKvf/GOgf5SjloHpp9P4p9SA==
Date: Thu, 30 Jul 2026 20:41:22 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260628142737.1051059-1-abd.masalkhi@gmail.com> <07b0887a-e546-4d2f-b261-1fe7adb1d6e0@fygo.io> <86d67b99-0bb5-4132-b412-9bb68ee4ca8c@kernel.dk>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 12:41:26 +0000
Reply-To: yukuai@fygo.io
Message-Id: <4969f54a-7d45-41a7-b397-346b748ed9ee@fygo.io>
In-Reply-To: <86d67b99-0bb5-4132-b412-9bb68ee4ca8c@kernel.dk>
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH] md: remove REQ_NOWAIT support
Content-Type: text/plain; charset=UTF-8
To: "Jens Axboe" <axboe@kernel.dk>, 
	"Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a6b4676+bf17d8+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/30 19:07, Jens Axboe =E5=86=99=E9=81=93:
> On 7/30/26 4:50 AM, yu kuai wrote:
>> Hi,
>>
>> ? 2026/6/28 22:27, Abd-Alrhman Masalkhi ??:
>>> REQ_NOWAIT support in md is fundamentally incomplete. While reads can
>>> avoid some blocking paths, write requests can still encounter cases
>>> where one mirror succeeds while another returns -EAGAIN. At that point
>>> md cannot distinguish queue pressure from a real device failure, so it
>>> can neither record a bad block nor safely retry the write without
>>> REQ_NOWAIT, leaving mirrors with divergent data.
>>>
>>> Rather than continue advertising REQ_NOWAIT support that cannot be
>>> implemented correctly, remove it from md and its raid personalities.
>>> This simplifies the waiting paths and avoids exposing incorrect
>>> non-blocking semantics.
>>>
>>> Fixes: bf2c411bb1cf ("md: raid456 add nowait support")
>>> Fixes: c9aa889b035f ("md: raid10 add nowait support")
>>> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
>>> Fixes: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
>>> Suggested-by: Yu Kuai<yukuai@fygo.io>
>>> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
>>> ---
>>>    drivers/md/md-bitmap.c   |  9 +---
>>>    drivers/md/md-bitmap.h   |  2 +-
>>>    drivers/md/md-llbitmap.c | 10 +----
>>>    drivers/md/md.c          | 15 ++-----
>>>    drivers/md/raid1-10.c    |  8 ++--
>>>    drivers/md/raid1.c       | 91 +++++++++-----------------------------=
--
>>>    drivers/md/raid10.c      | 80 +++++++++--------------------------
>>>    drivers/md/raid5.c       | 13 ------
>>>    8 files changed, 51 insertions(+), 177 deletions(-)
>> Applied to md-7.3 with a few changes, please check:
>>
>> md: remove REQ_NOWAIT support from raid1/10/456 -
>> kernel/git/mdraid/linux.git - song's fork of linux.git <https://git.kern=
el.org/pub/scm/linux/kernel/git/mdraid/linux.git/commit/?h=3Dmd-7.3&id=3D3f=
e5b7c9fb72ccc29bfd0f955b124892af7e3674>
>>
>> - rebase raid1/raid10 with latest code;
>> - keep nowait for raid0/linear;
>> - keep nowait for md_handle_request, as raid0/linear will need it;
> What's the plan for making REQ_NOWAIT _actually_ work with md? Just
> yanking it wholesale is a massive performance problem, and it will
> regress workloads. Has any time been spent on making this more solid?

For raid1/10/56, if anyone is still using nowait they should stop, because =
there is
risk of data lost or wrong data being read.

And yes, I tried, but I can't figure out a solid solution for the case that=
, if nowait
IO issue to one disk succeed while another disk failed. We can't either iss=
ue again without
nowait from mdraid because it's against nowait principle, or record badbloc=
ks (which is
currently what mdraid did) because data can be lost. Hence, the array will =
have to do additional
data synchronization in this case, while nowait issue failure is not a slow=
 path that performance
overhead can be ignored.

>
--=20
Thanks,
Kuai
