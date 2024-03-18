Received: from bsmtp1.bon.at (bsmtp1.bon.at [213.33.87.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804F84C84
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 05:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.33.87.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710741458; cv=none; b=pCdh5NijZZylXPC9rK0jZS0KGCWDCOCi17a7uy+uXXLtLjKF1ni4UoXt9RtPEGTk7MaMyubxGoqmBXBetdVc5Zg38tkDd6uji3LO83WDJUD3icpnVCGGNaLcdK7CtoSVLSaAXNoVZbwRSli2/enfLtKiV0Urk6qM7B8+eYmmmZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710741458; c=relaxed/simple;
	bh=0qBKWCeqXen8DZWE0c1ga7p1tOx4bqGVfvH1zxfu9Fo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PSGoPvxgKdfgaOnGMB21ORxKCGxXxC3g9KPzEvl81eOYyILkLqFYS4WGv/6sjUSAKND8hFfmVqbuyAHKQE/7pTOzmuzo081cV87ASWAVDcV7GX0FBmSyFnklTUgNzbEylqv8B2A7Qnss24mrD9jgDoROhN3Jh5pTKAXTNaEhsEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at; spf=pass smtp.mailfrom=reinelt.co.at; arc=none smtp.client-ip=213.33.87.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=reinelt.co.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=reinelt.co.at
Received: from artus.reinelt.local (unknown [91.113.221.42])
	by bsmtp1.bon.at (Postfix) with ESMTPSA id 4Tykf50SvZz5tlC;
	Mon, 18 Mar 2024 06:57:32 +0100 (CET)
Message-ID: <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
Subject: Re: heavy IO on nearly idle RAID1
From: Michael Reinelt <michael@reinelt.co.at>
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org, "yukuai
 (C)" <yukuai3@huawei.com>
Date: Mon, 18 Mar 2024 06:57:32 +0100
In-Reply-To: <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
	 <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Am Montag, dem 18.03.2024 um 09:33 +0800 schrieb Yu Kuai:
> you might need to learn some tools like blktrace or bpftrace to find out
> which thread is issuing IO to sdb1.

Thnaks for the hint, I'll play around with these tools.

Some other musings: as this is a RAID-1 array, and both sda1 and sdb1 are "=
identical" (both are
flagged with write-mostly), I *should* see identical write patterns to sda1=
 and sdb1?

If we look at my iostat output from above:

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read   =
 kB_wrtn    kB_dscd
md0               2,20         0,00         8,80         0,00          0   =
      44          0
nvme0n1p3         3,60         0,00         9,50         0,00          0   =
      47          0
sda1              3,80         0,00         9,50         0,00          0   =
      47          0
sdb1             54,20         0,00     26223,10         0,00          0   =
  131115          0
=20

44 kb have been written to md0, the md subsystem converts these to writes t=
o the RAID members (plus
some overhead like bitmaps and stuff)

The 47 kb written to nvme and sda1 is what I'd expect to see. But the 130 M=
B to sdb1 are wrong...

btw, when I run this tests on kernel 6.1.76, I get identical writes to all =
RAID members:

Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read   =
 kB_wrtn    kB_dscd
md0               5,40         0,00        67,20         0,00          0   =
     336          0
nvme0n1p3         3,40         0,00        68,00         0,00          0   =
     340          0
sda1              3,40         0,00        68,00         0,00          0   =
     340          0
sdb1              3,40         0,00        68,00         0,00          0   =
     340          0


Wild guess: the (external) USB device sdb1 is using a huge "transfer size",=
 so when only a few
sectors are written to sda1, megabytes are written to sdb1?

How could I proove this?

thanks, Michael

--=20
Michael Reinelt <michael@reinelt.co.at>
Ringsiedlung 75
A-8111 Gratwein-Stra=C3=9Fengel
+43 676 3079941
