Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367D89475
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 01:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770256111; cv=none; b=LlJXJF4MHuwwg21pQxFuv76aJQpqjEiKLceIQiZP0Bt186RV4EjjbF0ROEmEtBMemg9C49hH7pchAyfSMH+kobevrq1O+iDCpvK+z/+0X2AM/YbQkQGGFwdHYeZkHry7/JYt/u3+zM0H6gOyKbg/iPSDAkjpm44NoakrIkU8ae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770256111; c=relaxed/simple;
	bh=BW3bq4l3pksTeh3P54i+QTm+16BJWIqDB4pZYZu1uM0=;
	h=From:Cc:Subject:Message-Id:References:In-Reply-To:Content-Type:
	 Date:Mime-Version:To; b=M3xjnWwHgOBVfeRNbxX+Lw1kz1GZOKyLdvGWSsMhvO6E0NgH5Jw/iUvnUWGO42fCd/mVhK3i3KwmLCCsBvIJ9aXV5MT4JdqbnvidePocepnh6PqClQyhgKxkxT5A0sLmnwrLfKlJRVdVBd9xqxgRY8cJppP5Hr6vGqFwECoS4T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MU8UMRK+; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MU8UMRK+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770256101;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IMoXCkF3sxAfOU1Mc/X2LZuMot8BqeUYpDgg1nQpmuk=;
 b=MU8UMRK++2tDJF6JctTuWlKM0p3KBdubhqvHpt8EVAbxzFY/lsgLZgKjsDWNY7FSt2zcS1
 v62OgtA4jPV5cCqiJsXl3gOW986+sBNfTRxPQn6+mILuV6+P3pNRgjS6Lx2/5jJ8JM9Xsc
 tyhHRt+SXNjDIxQJNXlP8AtLkZCHZ4Ut24b3f/jCPxN1C2LtXd094yuN+GjTsLeFQQl6yp
 mNgaos3nv3986NdGtIlzwbKP8I0xm3SXL+6IMBxv/UrBsO6V9t7mYfUqd5ZKSKUnBNSrBN
 DwZIwI05vMH3WBZIl+XPsPZY+tLoQ3G+lwpIGs4WhtWQc6SK4usKp4bjLuJtxA==
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 09:48:19 +0800
X-Lms-Return-Path: <lba+26983f6e4+3914e3+vger.kernel.org+yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, "Guoqing Jiang" <guoqing.jiang@linux.dev>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
Message-Id: <9e56a1ae-05b3-48de-bead-386352e136ee@fnnas.com>
Content-Language: en-US
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com> <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com> <CALTww2_e_49Cy=WLhtZVWWtMK+=v8dErCSvxK9qpB0vmybsGyw@mail.gmail.com>
In-Reply-To: <CALTww2_e_49Cy=WLhtZVWWtMK+=v8dErCSvxK9qpB0vmybsGyw@mail.gmail.com>
Reply-To: yukuai@fnnas.com
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Date: Thu, 5 Feb 2026 09:48:18 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Xiao Ni" <xni@redhat.com>

Hi,

=E5=9C=A8 2026/2/5 9:06, Xiao Ni =E5=86=99=E9=81=93:
> And let me change to this:
> Setup: RAID1 with one fast disk and one slow disk. Two requests R1 and
> R2, each split into LO and HI parts
>
> Step 1-10: Request R1 Processing
>    - R1-LO: writes to fast disk =E2=86=92 completes
>    - R1-LO: writes to slow disk =E2=86=92 starts (slow)
>    - R1-HI: incorrectly waits for R1-LO (wrong sector range check)
>    - R1-HI: R1-LO finishes and wakes up serial_io_wait. R1-HI finally
> writes to fast disk =E2=86=92 completes

R1-hi should not wait for r1-lo, as they're not overlap. And as I said
in the first reply, if here are still problem with WriteMostly case, please
rebase and keep serialization for rdev.

--=20
Thansk,
Kuai
