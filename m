Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794359837;
	b=kYpjqGcjsGEwx2P4I1Bm+cNcbwEeclxYd51dmrMW7hgSIT6KAPcdxTOpvVpZGpW2n1EG
	 3SOIMGgLGMRZhjZh20s4DCuoLThArFuOElsRYyYNlFPZb/aQAigPS28Pyw/jNKeje6wiz
	 jf7uCqQoMnaQ+3z43kkbqHHPBCnDeun66avlpw4pSzm96KvYWw7ryToUFLIuWLBWUeyHl
	 Jqk1ZSq8mSdPy4XzJWpTealfB1EgznYMvuHWVm4hTO9vXfkJ3KE1yKZdRFiiLde0cpiUY
	 lz5qt6CyyModpkjGR9BYFPrjtA+QXv2oNu0nvJ8nnrxiLPRJ1ekOSiwGW1g8SpHTPZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794359837;
	h=DMARC-Filter:DKIM-Signature:To:Cc:From:Mime-Version:
	 X-Lms-Return-Path:X-Original-From:Message-Id:References:Subject:
	 Content-Type:Received:User-Agent:Reply-To:Date:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=FRQiyK5wJHX+Y1daTLJ2LKb8Axz2eA5lQft1YdiVGfc=;
	b=aRePPW25I1k74S0R0zJXru69F01w84aWJ+vq0DvEdysOKbCF1/6polkrWZROJW7YFn9b
	 3e0W6bXTySAW0ncVMN71v76QwxF5wTru+rUhnWltQIt0Kdk2unZrjwfoGJsvTHYxDbnEQ
	 SBqu23zQLC1blnnu3UNWP1T+nYllOsrF6LtZwaMhDbVjZobK45WA78UNi45ZDHQMxKoMl
	 +mKacZLeRmHIaY9ay6ulWWYJ+XE1gKyWfNc6Sj99/SROljsAdjHNBT+8zR0pTFm+Tu0Ta
	 A2HpTtwOk9jnu9Py8YGubupcw5mLk0XuTYRs1g7Qm0ZQbttHAKxpMhglbN8SA5Tfh3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b="lU8v/vS+";
	arc=none smtp.remote-ip=209.127.231.58
Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A1606A320
	for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2026 01:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 973A1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=lU8v/vS+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794359827;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FRQiyK5wJHX+Y1daTLJ2LKb8Axz2eA5lQft1YdiVGfc=;
 b=lU8v/vS+pcnDDONS477kAWOk1BMnN2d2b3d6uQHecjlwuRBiFKhX3u9jvNFEOSNdum6V1S
 +9U7CxfQSfEgRR5tn17vKdEQta2Jy83xLrZAf+j7l57y+gQR70Ni4ia5MdYuhOYJk06pPd
 iHjGsyUlhllw7QlY6jQGi4p547QZsaztt6pWFGxOgcDVk+oftCeA2nmOC0mi6WaWwauIu0
 O0+EEHLdbrtQujJk+w2zYfFaUnEq2LEHmC0aVijFR70NfKUgufIqR+uOqCPYfqlHp2GBad
 eKMmljKN2segq1gd0pJ16JJJl2V0d2heE5mxsb3QFsKTdRdXnqBbUbbiox0OGw==
To: "Sajal Gupta" <sajal2005gupta@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26af3c212+c6db65+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Message-Id: <ec20137c-0261-4ef4-8b23-a21b2a129a6d@fygo.io>
References: <20261102122430.39209-1-sajal2005gupta@gmail.com>
Subject: Re: [PATCH] md: fix use-after-free in md_attr_store()
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Wed, 11 Nov 2026 01:17:05 +0000
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Date: Wed, 11 Nov 2026 09:17:02 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20261102122430.39209-1-sajal2005gupta@gmail.com>

=E5=9C=A8 2026/11/2 20:23, Sajal Gupta =E5=86=99=E9=81=93:

> md_attr_store() calls sysfs_break_active_protection() for a "clear"
> write to array_state before it calls mddev_get().
> sysfs_break_active_protection() does kobject_get() on the mddev
> kobject. If the array is concurrently being deleted, the kobject
> refcount can already be zero, which triggers "refcount_t: addition on 0;
> use-after-free".
>
> Fix by calling mddev_get() first. If the array is being deleted it
> fails with -EBUSY before the kobject is touched, and if it succeeds the
> array cannot be freed until mddev_put(). The -EBUSY path no longer
> needs to call sysfs_unbreak_active_protection().
>
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by:syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com
> Closes:https://syzkaller.appspot.com/bug?extid=3Ddcad997ed2b5bd95cc5e
> Tested-by:syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com
> Signed-off-by: Sajal Gupta<sajal2005gupta@gmail.com>
> ---
>   drivers/md/md.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
Applied

--=20
Thanks,
Kuai
