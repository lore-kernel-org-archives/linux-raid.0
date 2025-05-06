Received: from mail3.out.flockmail.com (mail3.out.flockmail.com [18.215.190.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF49D24E4BD
	for <linux-raid@vger.kernel.org>; Tue,  6 May 2025 05:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.215.190.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746509103; cv=none; b=kubvtykIdFF7UAtjGbzgnCDy5pUffSg+ODsxvQgefTIeJxrSOtzfJ9pkYMbs7HgceFJv/aZCdVd0u7p8Zr8wwTqI3oS8/Mt0/9OW6ip6YkFAKV/14CSa1MhWVLpOffMMdDMTUsbT0bOhBqfnZPrwUkyXqLQ5tot2RBDKR64R9EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746509103; c=relaxed/simple;
	bh=fGtbSV+6c5HuS4D4pIdtUi31HdT9U4N+pghcPXmE4CI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=drl0IFLmIfsr5jIcNq4ldyP3wdEqNm+S8+Pfh5rupYU1EfIHVCys4lReg/Pa/79GInDM1GbKA78yV7bH6YE3duDMAQTnAFR+PsGt/wtDIsQs0wQqcQX0zgxXdhk89BPJWgLVN3zPVpf/cfi7yXJ81TRGj72iZvLv5/N1l+DMOQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=oCTGwW2z; arc=none smtp.client-ip=18.215.190.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="oCTGwW2z"
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 2C0A2E0035;
	Tue,  6 May 2025 05:07:31 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=us6NhXQSRVPdsJpufB5Iu78TheYmtg+AzO6RnVmqBMU=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:from:references:to:in-reply-to:date:message-id:subject:cc:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1746508051; v=1;
	b=oCTGwW2z9pxNlwdNZJaX2tY4iK0HiPv1DIbt/95Q5R1WbxDu7Gy2vqB8nixj9VBLRYY8+2VQ
	6ezdZP2fURwCJwZUbq7H6QVUkkaQtz7Oik6430u+YzL9GrikavZm9r+IVAL8vDxz7ZlcjGF89WS
	zTczkmfBHtewdToX6OKrkJdY=
Received: from smtpclient.apple (42-200-231-247.static.imsbiz.com [42.200.231.247])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 3FC88E0156;
	Tue,  6 May 2025 05:07:27 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [RFC PATCH] fix a reshape checking logic inside
 make_stripe_request()
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <65461649-c3a5-3cd2-3df7-71cab52dfbea@huaweicloud.com>
Date: Tue, 6 May 2025 13:07:15 +0800
Cc: Coly Li <colyli@kernel.org>,
 linux-raid@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>,
 Xiao Ni <xni@redhat.com>,
 Song Liu <song@kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <510C032D-D2C8-4D03-A819-7C5F4101EED7@coly.li>
References: <20250505152831.5418-1-colyli@kernel.org>
 <fgqrzhv5mbmrusocjkeybja6leaeeoi2r4hwihphi4lni2w3xg@meakhkiyuiab>
 <ba1a64b6-db88-077b-2216-3b34d2cc55b3@huaweicloud.com>
 <9E1AEF87-FF33-4F0F-A8A4-97A1E2EB9EFA@coly.li>
 <65461649-c3a5-3cd2-3df7-71cab52dfbea@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1746508051026972274.26132.4670298532544876800@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=RvE/LDmK c=1 sm=1 tr=0 ts=68199913
	a=1SoAjZNkZYAIyhvPV8pctQ==:117 a=1SoAjZNkZYAIyhvPV8pctQ==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=AiHppB-aAAAA:8
	a=PE5GRbGKWdJJCQ8UaWgA:9 a=QEXdDO2ut3YA:10 a=e4dt6nhxRu9UUAxnt3Nb:22



> 2025=E5=B9=B45=E6=9C=886=E6=97=A5 11:34=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> =E5=9C=A8 2025/05/06 10:34, Coly Li =E5=86=99=E9=81=93:
>> For the above code, I don=E2=80=99t see how only unlikely(previous) =
help on branch prediction and prefetch,
>> IMHO the following form may help to achieve expected unlikely() =
result,
>>           if (unlikely(previous && !stripe_ahead_of_reshape(mddev, =
conf, sh))) {
>> Thanks.
>=20
> What you mean you don't see *only unlikely*, for example:
>=20
> int test0(int a, int b)
> {
>        if (a && b)
>                return 1;
>        return 0;
> }
>=20
> int test1(int a, int b)
> {
>        if (unlikely(a) && b)
>                return 1;
>=20
>        return 0;
> }
>=20
> You can see unlikely will generate setne/movzbl/test assemble code:
>=20
> test0:
>   0x0000000000401130 <+10>:    cmpl   $0x0,-0x4(%rbp)
>   0x0000000000401134 <+14>:    je     0x401143 <test0+29>
>   0x0000000000401136 <+16>:    cmpl   $0x0,-0x8(%rbp)
>   0x000000000040113a <+20>:    je     0x401143 <test0+29>
>=20
> test1:
>   0x0000000000401154 <+10>:    cmpl   $0x0,-0x4(%rbp)
>   0x0000000000401158 <+14>:    setne  %al
>   0x000000000040115b <+17>:    movzbl %al,%eax
>   0x000000000040115e <+20>:    test   %rax,%rax
>   0x0000000000401161 <+23>:    je     0x401170 <test1+38>
>   0x0000000000401163 <+25>:    cmpl   $0x0,-0x8(%rbp)
>=20
> BTW, what you suggested is the same as:
>=20
> if (unlikely(previous) && unlikely(!stripe_ahead_of_reshape(mddev, =
conf, sh)))

I seldom use unlikely() this way, it is confused as well.

Anyway since the result seems to be similar as including whole checking =
statement by unlikely(), I don=E2=80=99t insist on this.
Thanks for the patient explanation.

Coly Li=
