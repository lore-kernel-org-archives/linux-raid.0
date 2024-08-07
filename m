Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4C41E520
	for <linux-raid@vger.kernel.org>; Wed,  7 Aug 2024 05:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723008718; cv=none; b=Bn51Zy1SZmunza2mYMVuw0aeQQPUzP3eMLkX3Lnnw2Tf/L2nmiVsz6U8fmEI7jawVYTGrbD1T/ceSduJ3SbpZyNNX+ZGYuPAMqZ5xQdWWmaCndXpiT4V49XfFjj13Exr61R0pz3wWe3NAuYsS7eVyZKlo76yQiwZhzyjgUBBQvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723008718; c=relaxed/simple;
	bh=b4J58zSJZ/XUCE3wJMaF6LZagpoOck0P4TEzgUL1KIw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=u02fIwbLLb8ihvP7cwT9PPhi+t8aa3UwtMu3ZQJ4yFptX3u8QnEOw7hEhJwQmp08bH06mt5THO+gppQQyj+Hn9DtnEh8CIvH8GP2q68YowCFAwWPnhwroWEaewkrbwcZVEBJhjqvSGF3AgXqET31qURbAeVwLgtPPyknyKxMRGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=VtzuyknP; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="VtzuyknP"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723008711;
	bh=b4J58zSJZ/XUCE3wJMaF6LZagpoOck0P4TEzgUL1KIw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=VtzuyknP25JTIMUT6NQV7ngwiHCk6iTc40xMObPZzY5srHNyaPZbzkZDQBTrpPNPs
	 ud3AVBaFHGCIJgdwrahP/WPK+KzFKTst/LwmW3QUguGj12nuT+0qoDDhirVW/pFs44
	 9OUc+nG6oeeJsQCqDp41Gm4M/OaX9mUmVWr+nmvk=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
Date: Wed, 7 Aug 2024 07:31:46 +0200
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Sure,

would you prefer me testing on 5.15.x or something else?

> On 7. Aug 2024, at 04:55, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/08/06 22:10, Christian Theune =E5=86=99=E9=81=93:
>> we are seeing an issue that can be triggered with relative ease on a =
server that has been working fine for a few weeks. The regular workload =
is a backup utility that copies off data from virtual disk images in =
4MiB (compressed) chunks from Ceph onto a local NVME-based RAID-6 array =
that is encrypted using LUKS.
>> Today I started a larger rsync job from another server (that has a =
couple of million files with around 200-300 gib in total) to migrate =
data and we=E2=80=99ve seen the server suddenly lock up twice. Any IO =
that interacts with the mountpoint (/srv/backy) will hang indefinitely. =
A reset is required to get out of this as the machine will hang trying =
to unmount the affected filesystem. No other messages than the hung =
tasks are being presented - I have no indicator for hardware faults at =
the moment.
>> I=E2=80=99m messaging both dm-devel and linux-raid as I=E2=80=99m =
suspecting either one or both (or an interaction) might be the cause.
>> Kernel:
>> Linux version 5.15.138 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU ld =
(GNU Binutils) 2.40) #1-NixOS SMP Wed Nov 8 16:26:52 UTC 2023
>=20
> Since you can trigger this easily, I'll suggest you to try the latest
> kernel release first.
>=20
> Thanks,
> Kuai
>=20
>> See the kernel config attached.


Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

