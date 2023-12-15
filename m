Received: from smtpdh19-1.aruba.it (smtpdh19-1.aruba.it [62.149.155.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665A83EA70
	for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lucafacci.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucafacci.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="K1jUNDyZ"
Received: from smtpclient.apple ([87.4.50.76])
	by Aruba Outgoing Smtp  with ESMTPSA
	id EBTsrabrwZKRmEBTsrB42H; Fri, 15 Dec 2023 17:56:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1702659369; bh=e7lJ9NxI01OD3v82hMvPynHesJRCYIaAt7J3PPRhRzY=;
	h=From:Content-Type:Mime-Version:Subject:Date:To;
	b=K1jUNDyZK1SpRd3GJASbiLXcXfUaYXSdli6D5LO+vUoGffrqfon+2Ewmy/lPXzWCb
	 A5i2flylddUhbFbG4VfUjHcKGNqQBbCJL5XvHgZP2HMZezsUbXtsGlwP6IYffHRQTq
	 8L7T6Eb0l7Fkgjm8s8MQHQP7qKsLtGXn9l8suVh8hkP6VRHPkxt6GNx23BvA2qQdck
	 fpp9QCKgHrg1UmOtzvAoTjohzbA/dI1ndfEkMC5gGXIzLMvRRQpj4RvC89+x/Tli9x
	 sDhoX1xfyjHCarHUBkADD7K5UiU4pd7TVYLFVgLamwUE+lDSG7eGjwoXi3Z/RMd5VL
	 8HIVU4R9ydFaA==
From: Luca Facci KNX <knx@lucafacci.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Grow very slow and lost a drive 
Message-Id: <0EA69382-AABD-499A-9FF3-EC151FE5DD45@lucafacci.com>
Date: Fri, 15 Dec 2023 17:56:01 +0100
To: linux-raid@vger.kernel.org
X-Mailer: Apple Mail (2.3731.700.6)
X-CMAE-Envelope: MS4xfNarCfMVfQYtOvvwbvQ7jmWoNYm1sONWiX+Qs6qOXlL9Y6KEcwUw8ZbRoo/aa8ymHP8HgAIJJcoSA8uIs3DxDmFWTAHLgCbYO6TmZIE/8ZYFH/eMeJjl
 +6XxMbt+gsnfXYG0nsarEDiomh4dDuZC5Po69AHh4aXNj708xIXVSfjKK9BkjLxB+Kv+sMtjEWhSLw==

Hello,=20
I had a RAID5 with 4x 4Tb drives.
I added a fifth drive to grow into 5x 4TB. Everything was perfect.
Too bad one of the original drive went faulty.
The Reshape speed went to less than 100Kb/s and the server become very =
unresponsive.
Also kernel operation timeout went out.
I tried to shutdown system but it crashed.
Then I reassemble the raid. The old faulty drive become spare drive and =
raid went active with 4/5 drives(3 original + 1 new(1% reshaped)).
Reshaping restarted automatically but become slow as before and crash =
system.
I tried to assemble it as readonly and it works perfectly, all data =
still there.

How can I reshape without this disaster?

I have a solid  backup of everything on LTO tapes, but if there is an =
easiest way I=E2=80=99d prefer.=20

Thankyou for help. =20

Luca=
