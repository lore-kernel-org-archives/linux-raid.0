Received: from sonic313-21.consmr.mail.ir2.yahoo.com (sonic313-21.consmr.mail.ir2.yahoo.com [77.238.179.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B0A5BAC3
	for <linux-raid@vger.kernel.org>; Mon, 22 Jan 2024 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.179.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705949157; cv=none; b=NU7S41EbNFQrYrnsOjiU/dOcuge4T6iGAqRyMhPrLymUlNy16ex1fLDUdNRnAzzAYfdXRdxu6+BVoiSXXfEF63fn1n8STMOoquxGUm/YW4gEgvfFZGG5X75fA/eLjnPWu9zpHJ7x+QI5frCFU6JEVIDtLu0LVx7JS9b8HCpmlhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705949157; c=relaxed/simple;
	bh=YgnaDyYV0chzGH+ZuxwHf2EehZHrjsIj3ZFQ6cGbSt8=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=ptBX1kOyG/QJYMuET45A1UmFTg/EczcdvTVMBq7CFbTZcVTiv17lymsNNveckw6RjkDTUU82QW08DM/pw7qlkKu6ZcH2L8wQ0ZrNxOJxJCYp5lO9oF+iLFPp8U1597FrD6w1XAh1/Yl8vh8pKa8FCFBPJAqmQh3BAGcaV3QTD6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.fr; spf=pass smtp.mailfrom=yahoo.fr; dkim=pass (2048-bit key) header.d=yahoo.fr header.i=@yahoo.fr header.b=mRerqdYU; arc=none smtp.client-ip=77.238.179.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.fr header.i=@yahoo.fr header.b="mRerqdYU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.fr; s=s2048; t=1705949153; bh=YgnaDyYV0chzGH+ZuxwHf2EehZHrjsIj3ZFQ6cGbSt8=; h=Date:From:Reply-To:To:Subject:References:From:Subject:Reply-To; b=mRerqdYUyLbvKhRjfgk5SeUDj/n7hnJ+HeiSQq1M1k15e1w/VQV5+S0TNH2cbShBNqfrDUi2xnXSduvkMvabLC0B2rSbYmB7z0FYEPZ/U79o33ybyMiz41N9BTV84jLF5oWCeM8hxDiUpEd8ghDRaKLufflLU8QRhzdfZhPFUIuWmFdKxFjxzUOgiOORjUfoGbn0i11QO2Dmhs7Na7XEuD6ii1Xmp/k6UQsaAmmz11Ya2WISZx4Dt3C4i3nsaAIVJwNHa8ybteTZhcEH1atrRPIv0oH6e/bE0IJC9+cj5f3H7YzDiNc6mFutd8ahDQzorGA7RrTKFCZyP51TtWWllA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705949153; bh=zgMmGFFzKgQLExDwO4xUclsordls9e5U++DeDUuJruK=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=RL/+3zvW93OdYDjamTkJELdh6jd80hLHr/EbaKq8w9eRvQwMqHCDepBxzvJi+4UsB3x8+sKwR0Hfqf69Q47DbAffCIz1Qsl7Sb60CkQHVVr5XbsLrB4wL781eBOKhNO2BacL0nYHzQ7HmwmbdfvbRR1BEu7xQjbgd4D/+rBW0ZdbMbwdtPlpTJb9DFXnNqXUk6tZQzBDlf6Hmqcol3Sn5Y3WHISWocJEJiW1T0SythRUb95KcX2o9KxoqXsnO4N2Df7AWUn01uLKEENOA2yoFoOkV29Ev8nbEFCsk4tGM/Cqv2t7Snf8q0EaYTSBQ7NlphP8BMTN2JN2uQThjnLxxA==
X-YMail-OSG: OqYWyPcVM1mZc23eEK.xsOYuMOVwVM9aMeeZ4cNsalT4..iXBa7JjnFtBQJMaHP
 Q5eEj9skTUX5OMXom1D8I4orFbserO6KTpnOanOtZNd17y9U9Ypx5JRCMoSIYVqNaBW5ya00CCKV
 9S34jbes6GHvebgBZPKewV0lpASJj18ztUXACMLdJhScDJ9qNmHQ9wRZsiYthE3QM4hBpqWhOGa2
 kgVtZg4jZ6ild4C.iic8gJEFi9hh0BDz9vELRHTIooozP9s._YORLWJ.74JBI_f33amBP1WF9nAu
 9eCiScF4BN4p9FVBfhryHnEkczRhUqQvUB.HIBboLA5BsZZ.CJwxjZHrYg97Cu4BB6n3raP3IlZc
 Sx_Pmz91c8DQPvkwWm2Fqj.NMJgwRG_s3cjQmH1A3g0E7aEuzybTlR4R5ODc_J7iCNrLZj469TjB
 6o00a2A8C4s6yJZefSGOm93hY4scDrfSKWO6f5FqwWTNJ5PyctO5cuEUyGGszuDCep70T_UHBtbd
 Aj5QKBLvpzgWaqX6Fts3nFCm62PmnIwRrS1eZX_uyEw_A0gXswV4hLqwt2DoUnaFOVdk.TLKG3iS
 wiRTzzChY4PU0OYfP8LgjhTPFvYiArYTpfigGm4eEvoQ8QJBWUJOS9Y760oM4fun8rzWEVDg3ZRe
 x3wk67fh5OQ8xNZ2MSjEm4ZzW8ZyNL5Ck8M..IJToMPZjbOnbJeBo.SKF4Cdhfk7GExl.2DUBIbL
 AJ_wZkndLvee_sm1iH8t2LJoe4cD79eC58clz7ZhIB0bUiYOn4.5xmtKwj66vn7PXgGHoRI5Gz6i
 AQuS4hKoBFeEq8sn9LZEk2hCXB.ufSRXHhCkdPBuQGvZ51wYQ5BVMVecG_Ug2gcCWhCjRrkBBC2S
 qLlv4B.waOg1Nw5eyejxXRwdeBLurTrGSwRsg_RVsWhHgEyfrAVzfnoZ8o.1n_1S3gdbmzVjv2QC
 CW65ek6cFHr.zlBbPFLNK_ZGQjoRWyDdGAUxIVarljdFVNODzjSZzkCA6.OoKcYDt9q2BW.rjH85
 w9SLzlo1nBdyjgTKVwmwSNriBvrPb5MWxasv9bgzpiddQHK23ntpMqu6Bui2qSYFR.3oAS52CDhs
 7H4VD6ddWi1EhcZHqZuLnW2udfYv_7v_3emFH_vTp3x5vU.Bg0adhLnfPh9Wht6KMpLDMcPTQ1fi
 33fod7M6cmi1gYCKV497npvk0GnjzdEOEiCOqpedgk3bw8tjtD1zVrCG.4uYE9kpJnFTSDFJdNas
 O7cAEatenv0jK_RXSC5DONkFSQ8QG8RHvEq.GCSCDFWyE7nQLtJCBWIXeD8IwttwYe.F5uC.6LoX
 Y8t76VvF8frFZQnswVvmkY7XTXZAPVH5ZLMknidnPmKTDjTgeHfUexFrEKmK.rxDbN47UqwMana1
 ogWdFrW4wyDuklA1oXowj855VEhn5I922MrXKzu6BnIWnRWQb7bLMBcO.8bIaUrbbJdg0kPhEdge
 QrPZZR0tsL8jd9DynZhwrIZvFNLH4__YKbk.GxhZiwukABNc8V28QriJdTSqwdCOA4YE9v5ryTP4
 LwzyspCbM8SYRXr3W6Zn.a9jIxbhIF51fArvtQGXZGlaBq845wYNr_sUbGoljAPAW53lMNdieedY
 gHzq3qvmF3_yPXs9gJ3Rg5d_I8kzmYhYQ9uslcP8f0z0j1U5PAFaneB_W_HGB.xUjAwaEEUAcB8B
 sk0Vc5JQRzetnLDSHf1bIFTh.rTphnC08Qch4iFlsWxA2ZCaiLD2AWc0k5G6MEWmsj_4.KAGtHxz
 Nw7OymKOVipzoXPrhY_Ajn_HrdrSZTUe7aUciWpvzGNrnRXIlmech3ZujQfJ2C75Yn1DpXmmgFpb
 K.vtEQEdInKxrAefqW6_NY1gGoj2HyjfmMpqt9ZUt7jgLVP.vIBWkAFbUMfeZC5cnBVgZ1ya4CXr
 zxwIK1eEDv9IINJfg5yOPQ0AuNC.39eWqD1MYy_ESCDjysdsBZs1szsWjXpanWaN8f.pYon6PEcj
 Dl6CGayReWgFGZuqAS9kUEgcFXYiiT8O3KNxMBL6E5ju8YApQYbG6WBqTRGlOl0Oz465Uk7Ulnrm
 oAR5rgCiuIYmBFmWcRndZMOSTESopAu.drU8QJAIDxaSEb8.m36cG_rQcEURwmTeKEYmBkOJ6ilk
 RZhuSFJWvROpkBzImi.qgccY5Ui5u6_p5GaozRrZljdKg9W726dswvQ--
X-Sonic-MF: <f6azm@yahoo.fr>
X-Sonic-ID: e66f2c7e-583d-40a4-82ff-01949d7dc2f1
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Mon, 22 Jan 2024 18:45:53 +0000
Date: Mon, 22 Jan 2024 18:45:49 +0000 (UTC)
From: =?UTF-8?Q?J_Mass=C3=A9?= <f6azm@yahoo.fr>
Reply-To: f6azm@yahoo.fr
To: linux-raid@vger.kernel.org
Message-ID: <576015710.2373821.1705949149866@mail.yahoo.com>
Subject: array transfer
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <576015710.2373821.1705949149866.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22027 YMailNodin

Hello,
I have been using RAID1 with mdadm for years.
Linux system and /home are on a SATA SDD.
Most of of my data are on two 4To HDD in RAID1 managed with mdadm.

In want to use a newly assembled PC with a new mother board, new Processor and Linux system and /home on a M2 SDD.
How can I transfer my two HDD to the new PC remaining in RAID1 without loosing data.
What is the procedure to follow?
Thank you for your help.
Best regards.
J.Masse
