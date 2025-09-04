Received: from bsmtp1.bon.at (bsmtp1.bon.at [213.33.87.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D41528153C
	for <linux-raid@vger.kernel.org>; Thu,  4 Sep 2025 09:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.33.87.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756977777; cv=none; b=p5IA9W0/0t+dX71JxKGCOA9LzkvW/huJ8aRkNeVtggZZz3ZZ8+aYIZJlRBr6L3RX0G+KhiLos/oiXSjF1xkMObpmgXHFVP1sIuIcIsBY9jvcNQNEeYsdBg/2PhamkeKQaBM4oPo6Jni13gqEnwhTdwdSDpEWLD9HgmGecdxBzdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756977777; c=relaxed/simple;
	bh=elNHH07SoI0fmollA6HEvCF/oTl6sGd9QSRNHu9EH2o=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Duz7BxZJ8opbI5xVr/vlENxLTZ/DjmBfM8MUVBUddG6YKdMiyhipqgDnNvCHmQkFpwphvYJJogJFU1BJ6Ri3nCOocHvVBLwyIWUqfczBse/JnGdjKZt+OHySTmEfm7rpDQCf5My07AcyLr1bPn1SbuMVNf3hD37vFoc/bQEyQhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; dkim=pass (4096-bit key) header.d=reinelt.co.at header.i=@reinelt.co.at header.b=PC2Ftfs7; arc=none smtp.client-ip=213.33.87.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=reinelt.co.at header.i=@reinelt.co.at header.b="PC2Ftfs7"
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp1.bon.at (Postfix) with ESMTPSA id 4cHYsx5vZfzRmx3;
	Thu,  4 Sep 2025 11:22:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=reinelt.co.at;
	s=busmail1; t=1756977767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elNHH07SoI0fmollA6HEvCF/oTl6sGd9QSRNHu9EH2o=;
	b=PC2Ftfs7AI1RCh8gjy/HH/8CL9ezNcc3spn2Y7zief2KPDNXFwqvHZjkynZGp9cwDd27wn
	8M8W+ZLLgtC08CXWe0OMt1hW+IHEl5K+yewC+P3HPaYPsISTJrUOgNfNflptSmI9wFnu2R
	0/debHoWS8iUskFa9eCNMWaWbohBIJxcCm0c1NfMmpfumIwomxnRUBLlmlWMwx8ZhrnBez
	x55vLXouhq7KToBmJN95ypgnKMSzojrb78TYVsOY4JM8UwoVa94b3O4rzqAbBY+pu/d8Yf
	cqxCaBE5P/QkU4vLRsuXopV8VHwoAG8qbl5hI16odcPKENV/tO+nr4MahHt5G3EGYaCvxm
	U4Ql+kySFrGUXLSIu+8pQlKyBlYGVpTR2fhW8yIjA7mvZ9qXQaCGL4Vnh1HixnMyyPd3x6
	1/fwrF/o0oKX0lQcuiWzhCA01GabCipENuR3O0dW33CkF+PiflSz7VjLvQP2UJRxAPgq20
	kq+aHgqFG/zIiz3ttLGPkCpfVB9d1v0EwOBMKqZgmOISJ5aIu5eQkWnZurVhOqUWyCwiAO
	C0EeNJ/xkx8E3Oi8bLDHyqtBP21yFtia7MfwMRqixkutBOCsScSpDZEF0zA5nN/FnyTOBN
	RBrUVOCeols8QiiLBkSc5DMFE9GUHh6Ia7dXx/OzU3+1hua2Joo5o=
Message-ID: <8ee43601f46149b3d1fa48e5fa78f2c79cca23d8.camel@reinelt.co.at>
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
From: Michael Reinelt <michael@reinelt.co.at>
To: adam.niescierowicz@justnet.pl, Jeffery Small <jeff@cjsa.com>, 
	linux-raid@vger.kernel.org
Date: Thu, 04 Sep 2025 11:22:45 +0200
In-Reply-To: <5cfd2066-7ddc-44b5-92ef-28c3a2d2c12a@justnet.pl>
References: <109aahg$34jlp$1@dymaxion.cjsa2.com>
	 <5cfd2066-7ddc-44b5-92ef-28c3a2d2c12a@justnet.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Am Donnerstag, dem 04.09.2025 um 09:41 +0200 schrieb Adam Niescierowicz:
> What about:
> sda1 and sdb1 for EFI no raid sda2 and sdb2 RAID-10 with -f2 option (diff=
rent offset that gives
> double speed of read and single speed of write)
> md0: LVM and on top of LVM you can create partitions with XFS filesystem.=
 XFS allows you to
> realtime grow partitons.

Depending on the user=E2=80=99s knowledge and experience, I=E2=80=99d vote =
for keeping simple setups simple:

Don=E2=80=99t use RAID-10 with far: it can make reshaping/growth complicate=
d or impossible and mainly helps
long sequential reads. Just go for "classic" RAID-1.

Don=E2=80=99t add LVM unless there=E2=80=99s a clear benefit (multiple volu=
mes, snapshots, thin provisioning).
Otherwise it=E2=80=99s just more moving parts.

Use Ext4 unless there=E2=80=99s a strong reason for XFS. Ext4 supports onli=
ne grow; XFS cannot be shrunk.

regards, Michael

--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
