Received: from bsmtp.bon.at (bsmtp.bon.at [213.33.87.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9617B2BF3E2
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.33.87.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756918695; cv=none; b=N35fImShKUcamhNmoLH68i10//fTz95q+5WQ/M53zWi3x5ahGGzg7QeSt4x3tOe4uak8n22+E9I2SIHcx2i1EWBERXzO8s4I/kITIOOClQ+8li00psE7J3Lhu7GOxYxwSRVP9USZ6GR+0hXxHSCxp5FaoNF74V/vhlixX/zwbmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756918695; c=relaxed/simple;
	bh=1Vz5ntzTP7YlKvI9ILoHB6aHbblj6QHvzZNM0814o/A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gVbl7B/ApM8ssjyj0ME2OS/xs1OSuH9VNN5X1gUF6GYbzbVdh+a09uZoD/lyaaKmEmBquoxOVESC9x7yegcyNhKI0XyKNTDlzUib0wGP1Egv06aXV7kZUvQB5aKWAVICEfr1E4BQSKiOSkRSvSEtSHK3Q5r1nMfOWSDMmbolKUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; dkim=pass (4096-bit key) header.d=reinelt.co.at header.i=@reinelt.co.at header.b=PaKQoXDm; arc=none smtp.client-ip=213.33.87.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=reinelt.co.at header.i=@reinelt.co.at header.b="PaKQoXDm"
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp.bon.at (Postfix) with ESMTPSA id 4cH81t5NfYzRnmG;
	Wed,  3 Sep 2025 18:58:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=reinelt.co.at;
	s=busmail1; t=1756918691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vz5ntzTP7YlKvI9ILoHB6aHbblj6QHvzZNM0814o/A=;
	b=PaKQoXDmB9WsfzXr5kTSR3nd3EWhKbURSMueSefjVS6SEQ5ky1j/vhKtUub4h7eYHcZ7ur
	SjVOyY+w7HF03OuZOUHnP36Vnr4hYuQlOA3iQUKUrg1wrcgxU0RrqCYOPWqV2HwJyDHW1c
	8ctTGbW1xEDCv5JDrPPs35+Eny+xUujNul9GI7t3QWZ5HxI/3nKSA73VrsfPtBZH+JgbTJ
	3C8mpaIvRqXRfkooPYF3ZsF2yza4Os1BTKrMybbPqvCWYD3SJzPWlpzHhEwVHJk5IQt+5o
	uzwLmAoD7vHYGdoo1Nhw7I/21pPpGd8w4pZ7IEr5amvqU3uZ1Tg/f8+H64+Sn+0NFjnNGP
	iy+vNTuG5J6084BaZGj7mIi/8sVfDeVnZbcja21dA9UHaM7QerQGMMExqQj45liGaJzkj2
	6DwTpdeIZ1jO/RWICOUWeZdTq5AX33CtjOJdKf/I+SQswFIde5uWd98CjbmUc+P6zap4+6
	10rjlvvxvBYmIwiRBREggQIrGXEfD0Dq4dCAtPx3F05jNeGV3TTtqrLS1VzdQabbdFpXql
	b1avsU+CN96vTiP7jVxPGYl54lP2xdtYkyhcCtQ39hDO+yvE+GfHZtL68jL7o4ttb+C3up
	Ng9aDAkk+g0bgC6XQkYbNr0Id/0CW08XNNcP+2fGq734aUnyZ8PMk=
Message-ID: <dcf4249e30d6a56821ac4cead431ebd4d5650056.camel@reinelt.co.at>
Subject: Re: RAID 1 | Changing HDs
From: Michael Reinelt <michael@reinelt.co.at>
To: Roman Mamedov <rm@romanrm.net>, "Stefanie Leisestreichler (Febas)"
	 <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
Date: Wed, 03 Sep 2025 18:58:10 +0200
In-Reply-To: <20250903204521.44e91df1@nvm>
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
	 <20250903204521.44e91df1@nvm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 3 Sep 2025 at 20:45 +0500, Roman Mamedov wrote:
> If so, the safest would be to connect all three drives, and then:
>=20
> =C2=A0 mdadm --add (new drive)
> =C2=A0 mdadm --grow -n3 (array)
> =C2=A0 mdadm --fail --remove (old drive).
> =C2=A0 mdadm --grow -n2 (array)

I do something similar about once a year on my RAID5 array: I replace the o=
ldest drive with a new
one so each drive gets refreshed roughly every three years.

The main difference is that I use mdadm=E2=80=99s "replace" feature, which =
keeps the array non-degraded
while the data is copied:

mdadm /dev/md0 --add-spare /dev/new_drive
mdadm /dev/md0 --replace /dev/old_drive --with /dev/new_drive


(not sure if this also works for other RAID levels)

On my setup the copy takes about 8 hours. After it completes:

mdadm /dev/md0 --remove /dev/old_drive

This minimizes the time the array would otherwise run degraded and thus red=
uces the risk of a second
failure during a rebuild.

regards, Michael


--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
