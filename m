Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9591FB4
	for <linux-raid@vger.kernel.org>; Thu,  5 Dec 2024 00:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.185.199.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733358834; cv=none; b=eIeZRXZA1TShIR1nG8dXgVwUrt7Jto8+5foWqRZUU1zKx5gmBI2e74pzub50UKMY34gJvkVAT2WGzGIMc9tputzgW05XrFcPJujXdNokqeM/8S6RWyzF1a8X9QRa16S6Ep5A50t7v+8XLe8aiuHIWsUPm3JV1XPNgdrxTmErf7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733358834; c=relaxed/simple;
	bh=0l6ZAjlhT5GjTntIDNr3Cel03pISd+d1CxiswNgqEsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VadT5S/olOjUudphEm3oT40bl1puZUU4snvrIRlcmsp6Td9wtcAJVURXvVRcyWDiqG+2kmPSfNG3rDAvpVOXCzARsSJ3a/PYwY0uV+GV8EHLfzF8sZEpc4OVKBAqplwUm0p158OOyzmXzS73QkkEVnLzq2cZqC7QZ35ygyrmuIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=146.185.199.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.39.romanrm.net [IPv6:fd39:a9b3:4fb1:1ccb:7900:fcd:12a3:6181])
	by shin.romanrm.net (Postfix) with SMTP id 46E1B3F201;
	Thu,  5 Dec 2024 00:26:17 +0000 (UTC)
Date: Thu, 5 Dec 2024 05:26:15 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Jbum List <jbumslist@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Resuming mdadm reshape on a different system
Message-ID: <20241205052615.449ce9f3@nvm>
In-Reply-To: <1552948949.3399643.1733357342509@mail.yahoo.com>
References: <1552948949.3399643.1733357342509.ref@mail.yahoo.com>
	<1552948949.3399643.1733357342509@mail.yahoo.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Dec 2024 00:09:02 +0000 (UTC)
Jbum List <jbumslist@yahoo.com> wrote:

> My current situation:
>=20
> 1. Raspberry Pi 4 w/ 4 disk RAID 5 array
> 2. PC for general development and test.
>=20
> I had a 5th disk I wanted to add to the array and in the interest of maki=
ng things go faster, I decided to temporarily hook up the raid array to my =
PC.=C2=A0 I brought over the existing mdadm.conf settings from the Pi and t=
he array was brought up successfully without any issue on my PC.
>=20
> I started the grow/reshape operation after adding the new disk and everyt=
hing is going well.=C2=A0 However, I noticed that the rebuild speed isn't t=
hat much better than what I'm used to see on the Pi.=C2=A0 So rather than w=
ait for the operation to complete (in a few days), I wanted to move the arr=
ay over to the Pi and continue there.
>=20
> Can I pause/halt the reshape that's currently running on my PC and resume=
 on the Pi?=C2=A0 I know you can pause/halt and resume on the same system i=
t was started on but wasn't sure if that's possible across systems when bot=
h have the same configuration settings for the raid array.

Should be no problem. The reshape state is not saved in the OS, it's on the
actual array drives.

Before moving it back, you could first try:

  echo 1000000 > /sys/devices/virtual/block/mdX/md/sync_speed_min

and see if this makes it faster.

I would also expect the PC to be faster, at least if you connect the drives=
 to
its onboard fully independent SATA ports with enough PCIe bandwidth to the
controller, and not e.g. the same USB enclosure.

--=20
With respect,
Roman
