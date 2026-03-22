Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AE536DA16
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204098; cv=none; b=EFcVu4Ee0OTQByh2q5H9elc9v+uLUP+DYR1so88k5C6K7Uck17kT8ZHTWDiW0PBaF/6Ip3pKLFvGptNeUZGoYM7xgAPXN/v7LMmLvYDMlX1Qx3l5AJibvpjhCeUhHMOhJ7paFtZgi3dyxR4+1JhlQ+jH55JI9EOUQMooUx/oUOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204098; c=relaxed/simple;
	bh=RmNiJu1C1q5dQQaBp24vBnmptgHk8ZBRrUCaT4YwoSY=;
	h=References:Cc:Date:Message-Id:Mime-Version:In-Reply-To:From:
	 Subject:Content-Type:To; b=oEJe8U6cf9ptjCOaBtIh77DuP6jmeIKA6cXFwJ5GhZ/7GM5N9xilabsItcl/ig1bLi7MI7fRuSbkf3NqwozsxtPDGYe3jK4E547HJPtvTEWp8t7Yp+ZYCVVG0kEKfCItT4STqwWBiIqo7HpIi8xFUcmRX9q0M4Ae8nEytuKddmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GNdce0AW; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GNdce0AW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204084;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nr49dnLgX47iqFxHU9QoG32s8F7Bf5DF4YIpvcFVr+c=;
 b=GNdce0AWjy6lGprwkBll48x1IWPBjqO2GoCFxhJ0ToTRkOncX3yqqGpbEKOuGHsr6hNUjy
 rojNRAzK9WGLgjr2D8L5eP7xTunwqLxS25Qb1jjjUI1wFchQ2t1nZrYleEIO0RZRKfSuMs
 W8+0aaZyW5qaCunQEiwE/PkiRFxgENPI34S6PX/edQeHUyLpKbT+cn7h3F+ZtNSwBCr2Cy
 aCvlYNEpGMW4p15or+YbdeBgmxS/iVFBAaZqMLLaAXzQu1Hr1rkCZNAW5pFu5DceSFl8C5
 ySJlEtE0PJMm93qMK6GiqZ292DkyEPt23x35y7RmKjzKBDf5rKzsBOUKsH0hEA==
References: <20260305011839.5118-1-xni@redhat.com> <20260305011839.5118-2-xni@redhat.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <ncroxon@redhat.com>
Date: Mon, 23 Mar 2026 02:28:00 +0800
Message-Id: <dde40786-fc15-4592-a607-f2f90a8b8a9f@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <20260305011839.5118-2-xni@redhat.com>
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:28:02 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 1/2] md/raid1: fix the comparing region of interval tree
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
To: "Xiao Ni" <xni@redhat.com>, <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269c034b2+eaea48+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/3/5 9:18, Xiao Ni =E5=86=99=E9=81=93:

> Interval tree uses [start, end] as a region which stores in the tree.
> In raid1, it uses the wrong end value. For example:
> bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
> The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 and
> bio2 overlap which is not right.
>
> Fix this problem by using right end value of the region.
>
> Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
>   drivers/md/raid1.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

patch 1 applied.

--=20
Thansk,
Kuai
