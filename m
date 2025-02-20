Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF47910FD;
	Thu, 20 Feb 2025 03:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740020759; cv=none; b=lR48uQHpu4A7sanEqy6W3QZbBxRgdy2TakECXrzVwAI/ympqjPaGkBNJr1X8Dj91hbuvUOCtjp2w58WWdJADA+x3bzLopeI2hAI31hRkuDokI5RCeBuTYcO30MlpNzMPBx3UK4abiPP+3zQdyxAjZYbNCWk/9VojPC1UZ0ZokVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740020759; c=relaxed/simple;
	bh=gLcUWzCuqcBIs963ZirCDgcZ246XTVr9ptFAbXAP7y8=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=fEjUeF+xtQ48ZwNN+CEHkEgmJBM5lBFRQ/aJjOM3x2wq53veK5b0qAsouXi05mxA9e2X+qdqI3y1dbheaJus1fnx7qfdtRzSFbgfDK+cd0E1FMJtKx2Rix7xYj4QVdiwiRptCZQGXpCJOd81gEReJ+X+1uXK0kAfgpEYcSA9pzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org; spf=pass smtp.mailfrom=morinfr.org; dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b=K7hMZLcr; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morinfr.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b="K7hMZLcr"
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 1FD2B20039E;
	Thu, 20 Feb 2025 04:05:49 +0100 (CET)
Authentication-Results: smtp2-g21.free.fr;
	dkim=pass (1024-bit key; unprotected) header.d=morinfr.org header.i=@morinfr.org header.a=rsa-sha256 header.s=20170427 header.b=K7hMZLcr;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=To:In-Reply-To:Cc:References:Message-Id:Date:Subject:
	Mime-Version:From:Content-Transfer-Encoding:Content-Type:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=b9iwwgNjnUKsZjvuBTSw2mTc1uDqLUwG3TRTK52nBig=; b=K7hMZLcrMw/Ix5bfh9JgyAzRpG
	h6/xE+WyY2s5yzdcHwWgrX5xCReIrOhePfwfsjrmauHCSpmKpRKEr7vPIUZlFMaNnOfGeGUdgbCuP
	NudSY5lF2iyBLKVjsWLzk2WukzFAiGG7c9iBVCxe9fnxg+t9vpMp54EQFY+pi562pk6M=;
Received: from [216.103.176.130] (helo=smtpclient.apple)
	by bender.morinfr.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <guillaume@morinfr.org>)
	id 1tkwsm-000DF6-2k;
	Thu, 20 Feb 2025 04:05:49 +0100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Guillaume Morin <guillaume@morinfr.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
Date: Thu, 20 Feb 2025 00:05:33 -0300
Message-Id: <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, yukuai <yukuai3@huawei.com>
In-Reply-To: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: iPhone Mail (22D72)



> On Feb 19, 2025, at 10:26=E2=80=AFPM, Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>=20
> =EF=BB=BFHi
>=20
>> =E5=9C=A8 2025/02/20 3:43, Guillaume Morin =E5=86=99=E9=81=93:
>> There seems to be nothing in the code that tries to prevent this
>> specific race
>=20
> Did you noticed that mddev_get() is called from md_notify_reboot() while
> the lock is still held, and how can mddev_free() can race here if
> mddev_get() succeed?
>=20

Yes, I did notice that. Though it was not clear to me how it was guaranteed t=
hat mddev_get() would fail as mddev_free() does not check or synchronize wit=
h the active atomic. But i might be missing some logic outside of md.c. If t=
here is guarantee that mddev_get() fails after mddev_free is called this wou=
ld definitely address the uaf concern.=20

However  the main race we have reported is where the item pointed by the *ne=
xt* pointer (n) in the loop is erased by mddev_free().  The next pointer is s=
aved by the list iteration macro and afaict there is nothing preventing from=
 this item to be deleted while the lock is released and then the poisoned va=
lues to be accessed at the end of loop when the next pointer is used.=20

If this is incorrect, I am not sure how the crash would  happen. I should ha=
ve mentioned that originally but it is reproducible so it=E2=80=99s not a on=
e off issue. Do you see  an alternative explanation for the crash?

Thanks in advance for your help


> Thanks,
> Kuai
>=20
