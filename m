Received: from sonic307-8.consmr.mail.gq1.yahoo.com (sonic307-8.consmr.mail.gq1.yahoo.com [98.137.64.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790C13DB99
	for <linux-raid@vger.kernel.org>; Sat, 17 Aug 2024 23:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.64.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723936198; cv=none; b=RaRwU/e3xr+QSh2NMnpgxcIJmpQljt3uFJAglSaNxJ16A/h/bzO+gBAYtzrs51YO6iFFjJlQU9g3E0+KccEciCMN4z/85AwealiTeIADmPQCh2PaM2t/JgQTXBPaSlu7liCG0si0xOiP6hdohcs/w7QWzuQaY+wnQtsuCrjcyAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723936198; c=relaxed/simple;
	bh=mQgw9icLT0W5XmyAAFY6W+/kZ4M0KqI/bQypWxp/PdA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type:References; b=uRgk13zAoTZRTdfnPJNP+V5OFOMqOPwJQV9bOA+ZvaY6dQOF6u0ac38HjUEjffDAXm0GDSOrebHMrrLm2hwdy5ZmimgXq2eYTJ9i9msW6Y92Mb+EX9WvL83aQ2jIYRDuu8G9gsQLizP7qPD65ThWgh3CueYAp8E9iPGvfcW0KlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=jvltx0Vz; arc=none smtp.client-ip=98.137.64.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="jvltx0Vz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1723936195; bh=mQgw9icLT0W5XmyAAFY6W+/kZ4M0KqI/bQypWxp/PdA=; h=Date:From:To:Cc:In-Reply-To:Subject:References:From:Subject:Reply-To; b=jvltx0Vzbd9fzM0lqrQBS0MPieN2I+0v73qb+3XrvITXQM1HvPPDi5xjYDwgzGZx9YiSGufWqM/7i6vE8wZcvUFULJLPaOptWMTXADUEix8RIxrTUt3o/IHcRO8nnJCryZ3sJtDtL80RwOapRZ5rSM7YRxUs3vhpuny2PVomCIjSnk0JEREFx4tFAPR/Bb6j9A9hNjwcwxPUHvnfDQKNMvpHii14gI494pxTAbQlOl60I81oilaH3ewGCsQnStarrXLKUqst7KKPYFIenhKSYwOBpYNeaI++cKFr3FVq7+rBeJzfwe8wOpWODFIqAEK2o4ZP6KsfDr+lKV553q054w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1723936195; bh=5vWziX/mKlviKO+n2hJa+4WwTNM/ydYxfMvTLOleI3V=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=Uh+Nn1GB7zH4ZgxX8wAm/vyqATfcrHQed4CP/H9rOiX3QBB97+aoF5/ytwsuJTPXci2rkW8WjW/FDs3aHwAl/C2FgdQsmuZhkrdrXlP8kQigdfM69WjUeWDGrE4spJoGWeXVj3nGxWuB4ZRml83zGlMy7Uvdwhm/xCPPQ0KeAAwS7J4JM/9APai+Lyn9O4jLAapox72i/tDtIRcj1Xm1UtYYUqkJ1gUnAhBf6BxCyoqw6NbwLtlGqaa6AxGVsXTJOZvnonltnfiJDgCizL5ZZGsVsm+2zKyZhvBxpqTFFZkjkButnDXDu17J06uwCyzcSKlzXY17GOJ86w2K3hqaJQ==
X-YMail-OSG: lE.Nc3YVM1kYRiMwOUT7aTVBpm3zB92Rcd1qoh6Rfm9O6F21iIRcsgYkIO4XazV
 1sPSRPdE2HMMbD850xFlVwm9a7XrD1m1M9YEq9Zz0vsAbqh0swUCnT1J2oSv2Rfx.1nwFYPJ1tZY
 nwGiUduOPqPsF2Lsg9HxcKBI6tnqlAkrEpu_hYLbk.oKk5cGkkrksKoBOkTLDgQOVPnvl1MvTVS8
 WXUdHWaDjJ9FDzrX25CuWgK5ziIxQlXwcqojQXmljJZCV0CL.MVhe3Wy8hzgobGuN_MZJuAxdV36
 ZcyGw2uBth94yXZOdapckdNu2vH0T5zFornlG7dEr2RQERQKgFWWtBlNHw2bofH3Z5u8CyUm2hRx
 CGDsNnrJluCHs1CQ8KhmzE6zbXUPpmd8pW9lMiuZeC.YaTeffyvUFM7Z40kKmiwh3fgBXnRkxY7C
 HbcGoGzQDc10ia.dqs9jZKplRsAdnQdis.9MMfKHZOIojn3Mbix8lVPkNAIboSMGi5O9i1IhOKlu
 deGC5lOudimkjuqd5fE1b6SdNohXfH5KWWoheAbUIlikYO3B14f9J5txSE82OJOCAU0mmixrV99t
 MWe19siPwW7nWIEQzrIH1e_VZmzSmvt0KkGAfJquejqD1P3sRNYN9pwDNHpcGHUNqbk.EBzrhXDI
 QF3OxiiB8qVQms7ugu8YxI4XmHffGOgv.UmFoqJzVCyDVYYmXcrnh5EZ9ajv9bVe7c0Rix9fp7r1
 t_dOPxDG8Fcp3GKWugBXjFu9WpooFEdbybzi.33K5yoePXdh.xF5RTLuYTdj0F98MuF8ojGvNmXV
 mufg.HNNQrT4Ob45mgEnEJp.dajQx5A2CK24LSVirIgMago7AYcxRbVpP24YuQsp5r8NEReuO5d.
 VlnvPLIwHOrqaTmdMBOpwyAjfq4.f9.rCjpzs..Lsq809fzr5dDbyz4VgqjiZjWB5SebhRTaa1k0
 .XPGriGitobJnoJn1zkLQSk5fn5tS6.QhINo8nFQ8wfIxalRKQWeycZ_YmpsLsK2wKKFbtwbAn1m
 rsCUxq89kYQ0BIMenpOO62zDHp2r.CtNZlqtCEZ2IPRO0alJzpHFraVvhVvPtkFsLXvTfDWEn3Am
 SMnF5DyBqn7T1o6lUgtQPWLRAt.EwWlrtxqReY.QAlNCqJsraUnITqdaH3.lg5Huk4sKW.iYdNaw
 ETl0ifHIT6_FAlbhTA1wBOGrFBYy8y6XxNANDiiSlhCxtUqBHBTVnHGKqIFpVj8jsXbMLuI7KYB9
 E2K7VVCrVv0Q2KiYTGv0xQfr8rWfC3O3KHPwN0rzA8gead6Z3hnx9SRxArpVrzZJ8kURzQae3QHc
 4UGHKIgpHEp3fTZf7bZy7qeS1.lpw_jPE.59GObGHB1lC.0am69C7z_HijiuBE8l21p.QZUGzVLI
 FVOH.CPaBG3vknK8s6GT57RmlT2apP_jJEim7WITCXjzhNa7iPDqBY31WOthssc.r0HW4ULxOi1Q
 VwK3s_nFKpffgFGc6NkLlmFvfxXLy7leKvgwWiXCoUnG778Qrv0SLX_qGYS_z5LL6o5nr6kDBv7f
 04AhKaJ.yExqgNWVDMW7mFLK3FgadLinc6_s2mQF5X61rNfCwz8W4VlBha_zoHomS28cpnr2_xgU
 UBk6XEG2sUFIGM3NUoPwKlHJRdimIBBoBSxxYwQhxo3l.9iScaYZWybgjsmSq9PtLTZY1jpnqdTv
 s4Qk.JGN_xwmjmjzYVzkDhfgxDe99kePBfF_cpy5jtwKv6AnT8Q2WXZz4sUMXL5Xf2MpX4OAqkjT
 .b6LdAJGKEow2IBqgQ13bMS74StK.Gik1D2VI9SWBG1Vo1TJGKIAAYW4k7IwoIFWtkceAQAXkjeH
 sFECv.2pIl2qrDa6CyHnPuR5zbfbDBhZEK0MDWfy2XF7ALK6ZkR0FrGRwkz68HRojfc6_omtI_MQ
 7tSnbALXPjRNZtxwzB3MavtX5SwmRqHsTNgLW62JK4dmkicgzjo_ONlJdaEYY_hC0ucc.HGQKkRH
 J46xAj0lcXJ58xkEQn4mXD_aufzTvDkJ0YEvGUroPHcvgxsTgtBHJ.DnqkbOEfVSYEu2obnx6ybt
 N6oZici6fNtNtb.KLxQxSpS3g_viNTcxndLU9f1Cid6Hxung_OGJatlN79mu7WAbDKXgtmO.ZdYV
 gFutft_Fl9WDujA_e40mYNVO2Dr.HQiCHHt4GHyaK8XdRDVFAQ7zhuFpmeWCI5btR9651cmshh55
 aIfo1l9Bd9zA3j.99CShRESMZ4OYIZ0ET7KnAFvut7YiTjteSgkp3Nr4Q4lYxXMZDZL_4Kg487IM
 B5_CHMJkA67i17kaMDguL8G5NJPMyR3Txpw--
X-Sonic-MF: <Djedhi@yahoo.com>
X-Sonic-ID: 90dfa20a-417d-445a-aea2-e603eb6b64fe
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Sat, 17 Aug 2024 23:09:55 +0000
Received: by hermes--production-gq1-5d95dc458-c8wt4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 996e7bc092d72e2d364d7d366e007daf;
          Sat, 17 Aug 2024 22:49:40 +0000 (UTC)
Date: Sat, 17 Aug 2024 15:49:34 -0700 (PDT)
From: Michael <Djedhi@yahoo.com>
To: linan666@huaweicloud.com
Cc: houtao1@huawei.com, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, song@kernel.org, yangerkun@huawei.com,
	yi.zhang@huawei.com, yukuai3@huawei.com
Message-ID: <361df5b6-c838-4f21-8651-9962dd1f55b8@yahoo.com>
In-Reply-To: <20240525185257.3896201-3-linan666@huaweicloud.com>
Subject: Re: [PATCH 2/2] md: fix deadlock between mddev_suspend and flush
 bio
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: High
Priority: Urgent
X-Priority: 1
Sensitivity: Private
X-Correlation-ID: <361df5b6-c838-4f21-8651-9962dd1f55b8@yahoo.com>
References: <361df5b6-c838-4f21-8651-9962dd1f55b8.ref@yahoo.com>
X-Mailer: WebService/1.1.22544 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo


git send-email \
=C2=A0=C2=A0=C2=A0 --in-reply-to=3D20240525185257.3896201-3-linan666@huawei=
cloud.com \
=C2=A0=C2=A0=C2=A0 --to=3Dlinan666@huaweicloud.com \
=C2=A0=C2=A0=C2=A0 --cc=3Dhoutao1@huawei.com \
=C2=A0=C2=A0=C2=A0 --cc=3Dlinux-kernel@vger.kernel.org \
=C2=A0=C2=A0=C2=A0 --cc=3Dlinux-raid@vger.kernel.org \
=C2=A0=C2=A0=C2=A0 --cc=3Dsong@kernel.org \
=C2=A0=C2=A0=C2=A0 --cc=3Dyangerkun@huawei.com \
=C2=A0=C2=A0=C2=A0 --cc=3Dyi.zhang@huawei.com \
=C2=A0=C2=A0=C2=A0 --cc=3Dyukuai3@huawei.com \
=C2=A0=C2=A0=C2=A0 /path/to/YOUR_REPLY
