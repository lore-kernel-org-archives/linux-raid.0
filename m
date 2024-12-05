Received: from sonic312-22.consmr.mail.bf2.yahoo.com (sonic312-22.consmr.mail.bf2.yahoo.com [74.6.128.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F3182BC
	for <linux-raid@vger.kernel.org>; Thu,  5 Dec 2024 00:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.128.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733357959; cv=none; b=tPfLwdErOTPli+gn8ERGqdrirZrRjrFGRgaf6ynXVjrjmIw4OgauUY9YBi1QLhNFm01DTXt0ewhnQIRLRQKJSHscf/DKqJCd9h6rCVajzncC2hhNSnRDhLCaYy5y/KMaEzGujUOtI+LnhG3qTvY4bzLeWHKQneDO5KkJo1ZUQZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733357959; c=relaxed/simple;
	bh=P1LSe09GELuQLvvqBjOCFODiAOXfEfOJD6+CLZ+cugQ=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=JOY27lnsJRegE23iEziEfPrMfwqXZ7PvDgdaUocdDB4UdB3PrqKkY0u2J8VR185L+o3LrQnCtC4rkkIRsXPhVP/GSziuwm+2OhygYyUGz96A8//4wy10ymf4MDNc+EXBqpqixNzSvZldcaoejkxjCZfFzzZ4kRbabLAGauWXxso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=RTbVAozx; arc=none smtp.client-ip=74.6.128.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="RTbVAozx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733357951; bh=P1LSe09GELuQLvvqBjOCFODiAOXfEfOJD6+CLZ+cugQ=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=RTbVAozxZNAWdkZJVs5XMJM/mDoRd8tI1Pc8Cg9KVVCCrDZNTDjo/3hQB2SFyJ5kQybRB7aeLbEZZXchNwhV9S+5SsH0qcauvgWxFPkou9KCCXxd0RD3aY6Y6wmoeIwRezNYnocSaaFtJ5NEJmMUFgv4RxAhYIlAp1aREWSrS1Y649KXEcToXWwhH7zarkcalTniMBhHbbMtcnJdXtIuikBVx1qLU2ldpBqlW0VyCJdZOpUC2CI5/oeR1/4+cVI6q76E1b6zZ7AwgKvb0SbMHzq2ZIfV6INR9nYsAn60TotBdO/p7Eat5qkpEWVRPOJsc6HvjIlWRcLl/hj/LeGtmQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733357951; bh=iEJVKv3OseUIlWa3IS9o2keAfyUCRKoC+s8tj7GwxUh=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=CwGidiF1+39q7Kv+rAp021nR/eSjBQP/lp+rcHHNjmzxJaCblWMBg/3bakUq5TigAhN01vSrC3YK7+Cw+Fj+N2HYp4P+S3z/KmzlLY9ymkzSTqPY8mu+epiC6Lzv1YSx+LXstLZhkU4gMr80nffNm7xJfmzr6Fik6bp/0NzZlehQD/pWoRLCumnQaFoisiuKrQvHLJPNfAe0Dy6sItOzVFiJOLqDE4mbqiARFQB2DqSwTTrk6a4pIHYdvOND1tj0LtPKGmSxmAiy/OAt/wzcWgP4fQLNClHoI4/7AG/oEiw/WQJKUAAc/lWr9HuFZsWVddhTcqVY++c+WvUHJ3/I3g==
X-YMail-OSG: Z6_DOlYVM1mIfGWprJ8JiAxAe3K1K9HrLtMv9ylNpizVO0tXXx6.YScO1N.wsxV
 4.Fht2b5IQG9BZ6HCp_CZyb8mG.PFLJE4GdADEfpSlNSuHPlYo3AZXqapSiZR.GmH7WxHmVq6tPj
 erqVtooTuvHt5AXpRd0TtM0wYVjmmWvy3wEvwdwuW8Eb4iu8FiXVD2rGMzNTTJeQM9eDlKfc0Owl
 ddpIr40hCugBLsCvOrziZGGokEHA6Z5.2sTNtpfYlcmr_O8arMc3hSUqUsJ4IYe0YBKoQR7hVSqc
 vzZoQiHuERL6EjHanuwvJZrVjNiQkybMxxUzAYfA.jKO2V4WqZpQOHSmPYlvW6X7DXpvcB4sMSqn
 3ACLd7jnw0Q2WgJq48Qw6QkIk2iLP3eUhi3Nw_3C_2BRwGVtpEf15aJs3IKm0DrFtslegVV1BKXO
 U8.Ogo3LYZfXRisgmZiZoc5VZI9dxIXos.ZetRBSm_Nsy5N6FhuJQgLNHhE3rUluJDgz8au62T6R
 2GT4ydcFdDQaELbq65suqDZAMvSKS3wAI4MyrVtwPTDMaTfyCkr4OZIY_zqprzpXI6dHY7g51ANi
 Hphaj2ZtX3777HevdkkE_753qiJoeQAu08Qa.qcb9u5CTmpjGhPC_vmEF0patWeY4AkSLU.2zK7i
 AT22oeXoNmRsBULYtfS2xB6fdoqZV0MtwCpIlGuAb8RAyCUy6W8rjXodjg_6UbfVstxl2rJK.HUK
 w9zfBMiUuiP8Urk7vDdORI_SMOzsgCiIgBGvsXS4DDNL9B7Cn.yamxf854Lz0C2Z0tzwtZ43xAn5
 K7FLHwR_OYAqm23ZcuYpufJYz6zDRh1v.q8f.EFraHm6lH_VHkXoznQwZifpSFkbGb4PWFoUzJlT
 L0PGl_ipVpnGgrjGJIvWFl7PQCcMpr_9tuq3aFCQkNZ_f2qF39fv9LzFRggIuf952LnY__JhhjQM
 VQnmz5MyQyJLsZbQ5_1RqB_9QRExdWG0ufsjGJJC_17CrRjZI2SYC8SmCCDgxR_pGJj7EctW6MQZ
 6KPDXXWmejXtpD_EdDe.VaPaQzwRRMGxWNnXCEIAUTQ.mB.B1AUVLgYUxuoHEoDbtRZ88FOrggGI
 I26bL.dQE3WtCltnzF9XnDqVIm8t4bkFhrow8xJgj6bZO23GtPcXZvuZQK29VoVpO77LmCBsAEl1
 ay.fNgnaaEid8h_2Jcf5he63qNifa2hhge.hjjbsmEsLQcyODBaa679k.Fq35GK8_rQBxyOkTkDG
 arvWTFIMOQy12SWgs2e5I0BUS82gmIioVxRYhwagxnSdmA3_Y64uNpkW_ogdO7tksbhdfsCDiw4D
 nbSe7B007nja1A8EYoEKK_s6TBp.8XIDnJvjgxvx1vKwBWCU2Cko6hzU3fE39OqLNTY.KegX8kr1
 XyYKL7e9yzDZS2GCzdHrJSYMEDmKVj6lX5OULfpyJz5jgNMEQwmmjtZiNyluO_hWuAiwj4zM.5H3
 cxSo2.Sb9kwSRJHK4RlfoK85tlzc1c0p8QElgZnRlLPYGut9V9DOsQkIhm.ThjGURxLFk6bJBZyZ
 8b9u.S8SDyeGZxCZiLpodqwlTmJ5rLJRhUSQNNB5yDQAHbcxMsBo0RXA6LbcDClNNSj0WMCjsa3F
 uMnqimGS4QamAdFa_9IU1xGSjUHscP6miVrfjl4vKPjfVL6b80xk8c3pLaQSMi8xTX6XjreHZR5B
 m0cemazRgRXY6B8_aU2.oQpq__WOrCHHH7JKYAlA8MOu8RfeX_GC.8ap1i9xQ1I0vP3fp84LJvC2
 1lXVOkzE7Z4paeJLZtJKCtJ4BT4DNOaU3395bteTA8s9nLBVD1eivFUuh9JrXDzxYTFAr4iG5Qlz
 o1n26rvRDH9j399X1wMWN4NJWunL_XEMAhSamOE2bgJkFvU25FwfP9np3lzL3THaoc1RDcNyQZAc
 QFAuwP7GjRF1AJeY6NWk.L.OhM2P5EODpHRtA4mcSBgpWzY7nvoYvGEM9dqV7e13TBCbLQYkIL0u
 NVKOkgZgE4TUF5eDvVmD8GT9owb0oCeJ2ExubQOM_cQwUZm13YPajBhozliY2okDIpiGiux4atzk
 9xKy2mFXLV4_qILg7By.xsJzWextpeI.xBpyT7JrzP3nWr_iC1kl1A9HlQLs_tYUExtOiZRAwIyB
 fiaeeOnUZRrdorQPpmIwS0Fgb_.1uC.MmNZ_bN8hK_08_8Rd_vVsql4t_wmXdu7zOWoyIGTbuAHW
 f74Rtsz96x9z3KGYiqqmONicRfsC2LNhSTE3ENCQ2aw--
X-Sonic-MF: <jbumslist@yahoo.com>
X-Sonic-ID: 3a29f219-60d3-47de-826e-7ebcc2440c99
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Thu, 5 Dec 2024 00:19:11 +0000
Date: Thu, 5 Dec 2024 00:09:02 +0000 (UTC)
From: Jbum List <jbumslist@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <1552948949.3399643.1733357342509@mail.yahoo.com>
Subject: Resuming mdadm reshape on a different system
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1552948949.3399643.1733357342509.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22941 YMailNovation

My current situation:

1. Raspberry Pi 4 w/ 4 disk RAID 5 array
2. PC for general development and test.

I had a 5th disk I wanted to add to the array and in the interest of making=
 things go faster, I decided to temporarily hook up the raid array to my PC=
.=C2=A0 I brought over the existing mdadm.conf settings from the Pi and the=
 array was brought up successfully without any issue on my PC.

I started the grow/reshape operation after adding the new disk and everythi=
ng is going well.=C2=A0 However, I noticed that the rebuild speed isn't tha=
t much better than what I'm used to see on the Pi.=C2=A0 So rather than wai=
t for the operation to complete (in a few days), I wanted to move the array=
 over to the Pi and continue there.

Can I pause/halt the reshape that's currently running on my PC and resume o=
n the Pi?=C2=A0 I know you can pause/halt and resume on the same system it =
was started on but wasn't sure if that's possible across systems when both =
have the same configuration settings for the raid array.

Thanks for your help.
