Received: from smtp-c9.witbe.net (smtp.witbe.net [81.88.96.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A2832B99E;
	Tue, 25 Nov 2025 17:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.88.96.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764090070; cv=none; b=KTgtEUMw0VrD4Hp+PLks2kRjqAHH67DHkwdH7mTodHYOskuTYk0sgksTqgDy4pKJXheEUjFoPih1uhD8Y1lge4RA6/dyLu1sfL0FPzkdoA5Jl+rm9gS90Le1G7n4R8WfO7Z4PLqMXixDzCLunHdcfPXFsglj2RLTH8G5UHtc7yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764090070; c=relaxed/simple;
	bh=7eKUbEQxuZZ81A2bCWYhdxQgXMpUbzIZ0U1MPP5CWqI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mu7BXMPTSIHdMOWO5zkbR+GqYAV9FOQAtOCGtWpky6JJkSkuFOF8N/z7z6n35mb4OeJVrHcBkYLJgH4J9eFRaM7UO1YwahnTo4ahicc3Zn3NcyRuFTBaClYWVaSHcmocMh27keOUtBvEIPjYdRymFkt1TLVfgjoKMsuvl+wkEW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=as2917.net; spf=pass smtp.mailfrom=as2917.net; arc=none smtp.client-ip=81.88.96.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=as2917.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=as2917.net
Received: from riri ([81.88.96.247])
	by smtp-c9.witbe.net (8.16.1/8.16.1) with ESMTP id 5APGv5Nn025269;
	Tue, 25 Nov 2025 16:57:05 GMT
Date: Tue, 25 Nov 2025 17:57:04 +0100
From: Paul Rolland <rol@as2917.net>
To: Dragan =?UTF-8?B?TWlsaXZvamV2acSH?= <galileo@pkm-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org,
        linux-raid@vger.kernel.org
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
Message-ID: <20251125175704.2dc57a76@riri>
In-Reply-To: <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
	<CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
Organization: AS2917.net
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, 25 Nov 2025 16:19:27 +0100
Dragan Milivojevi=C4=87 <galileo@pkm-inc.com> wrote:

> > Issue/Summary:
> > 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
> > drop out of a NAS array, after power cycling the device, it rebuilds
> > successfully.
> > =20
>=20
> Seen the same, although far less frequent, with Samsung SSD 980 PRO on
> a Dell PowerEdge R7525.
> It's the nature of consumer grade drives, I guess.
>=20

Got some issue long time ago, and used :

nvme_core.default_ps_max_latency_us=3D0 pcie_aspm=3Doff pcie_port_pm=3Doff

to boot the kernel. That fixed issue with SN700 2TB.

Regards,
Paul
