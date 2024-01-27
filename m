Received: from sonic317-28.consmr.mail.bf2.yahoo.com (sonic317-28.consmr.mail.bf2.yahoo.com [74.6.129.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146A21114
	for <linux-raid@vger.kernel.org>; Sat, 27 Jan 2024 12:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706358618; cv=none; b=Yi8ZUIiJ7rVN21h2cZrpUMijYQ23E9S//BwmiLq9NIMsb+HTMP6Zc5vwa0s1rxK8MfczuRRTlXgtxzwntNTWEZN1ywZpOI6cNMWVzRbXxIA4p+23k3isbd34gyKdZjE8Z+X88VD4AjWDKICxkRJLu+0MKhmt5eIfhTNjNRHKuTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706358618; c=relaxed/simple;
	bh=QoD+5zaIBTD7FzKhmdgW+G7+KOt4e6J1Axe81BpnHnY=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Yp9uxpGL4Kt7vIUfugGKFCB65B7dBRmMc9Te6L2AojJoI5ieXtuDiJ8WJvEMo7UEWRuj+r0woEN8fJwHhy66xLI/+sJ+NAqNlzuU/PN9P6Qmb5PThIrsm72Dc0OfbYuW+98ZeN9234BNsISchMr1s70F6QkmlgIxvKksbLxOaGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=lF4whqHB; arc=none smtp.client-ip=74.6.129.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="lF4whqHB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706358614; bh=QoD+5zaIBTD7FzKhmdgW+G7+KOt4e6J1Axe81BpnHnY=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=lF4whqHB9Jehk9nt2Ax/YvLTNjWpNGlTBoAHDU4mA+Mjbo2ab8YzbbOY8ozhQsLMZZznWeGv3a7H+1oCF1piYvqSsps0SS4On92/oEokkZOHoCCCmweuXG6RdgASsye4NZS9LXA6JcZxzq6YeGXBvjMxHEtib/1ApEXulwkZEbHWQegjru5D/B/K/yMS4BZWczjg37wvd6D7MUlsMD0E0lU915XmTm2j8Lha8cjKO8Yi1k4PuZRmyQcdHFhgfSfCOhwBDy3Prri42B2vC9CNL6hPQ85q6ULGyLFAP+brcdAbSBJWQ1Dq5u9JMzXWN4epY+xOw2WR28/h1PgE8mHjgw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706358614; bh=G2KeETkBIMC006pnQw92yeAhisXIcj9OY/7h4cDY+Hp=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=gyXbkPH0eu6bl13uIwjobYuchltIDXWxuPPwyjady9mwAskjDCPfB7ngStFDiObIbkgaxZOq2BXSIAaobTLUQyTaKo7yNmWdNTSWVOp1b98LCsdKgIr/jjm7UcnZBMokh7zmvPoWDassWeiHrj0SkwFBcZsoRvhIIJGgIB0HMb2UjVkiFYbWZMLmXNDbx9uyTOziBMBRng34aekv5lDNO50X0V6Vu/IEI9ehdjFDBLQEfJXQEMmrTNKiiVuLSAw6l5lt7Z9oRThxxtx5rzcI5HkAvpo4yh1YAK5mX1oh8eHMZBDuk6qVKUiIyQphQheh8Q+BnxTcGdkabzHvt6GxHw==
X-YMail-OSG: DA9YHFMVM1k2J8ZQBi7p16el1nKK6pOCEPn6HgB14XrrBeY.b3.5yHZO3ElfuzL
 OrMeaxy92kWQJDIFmapWaurSD7Zt5svZIpGCBqlHDBBzyCUwkntLN27HLIITG2mNfo9YM02du5BU
 6oT0CtZIGkiBNMppqO5sku.q5iSp4IK5St1OumJwZ2KsALUo9Pv0spH0S1sXhyzBI.C00EXpNbYQ
 ahdRtpjxpPnxAxtDLVk6io.ieusN0.TnFz3j9xniPvw9oBTtv3vth0DkhNgW4fVc89UN32j67.SE
 IM5nQoFXrVOKWPVoGnuCuuVKNAJf_3JL01Jb5hpcgj1Y9pHALMnAJZq1lgABGKk_2FDoFz6.E9Ed
 YMrzPT.Suf5YwHRpxmn0z27HeGxDD.PZ6kxiLliAxx_JAOTGjH4.eQnVCEyhww09ZFYWx1Kra5vg
 HdlayGLiDNcr_yajGaJCr3XEphtbSZD9vehNpa3ZWLccYnxlAl3_PBJHJRESrkxqOO1jiw0_a_4c
 B6yq8FrFH7mapdImGZU1SUrGmjgDfa4aCxONLQv9uAHzhYuAUCd.IhlaXXDjrs1JocUQoH7c_Gml
 cAJwu9_pcf8j0HaZjWpVaRP6Hb5OrLQYj3Wo6pCe1.baKdJ5ZuMh2RdrxBGV6FylFBxyakjU8IEN
 lcQRtzXVdeFyWsajTDGVNmvSLFcimlRugJXZCMgX115iBVYFQNjACGBInNDU7t_GqQ6N4akow5iY
 HOJVjpB.OGVH.8yU8ereWYOgihgjllEtG4mqDytxfKu8lJEkDV5m33zWtis304j4_bppaah5vOgM
 F8cAwhFzCC0D1kY6JHp3xO5MmBkDuavbu549ODQpI56MXlEG916Hbeh2b0v2i5G7wv2pd2HoA92y
 wXeDJXIM.M4HGa_W6EZMtHVPNDLhiO12H2v1StxQrU2GytPmkgd.Rd3_hn7RUpiVDnQNII5UvwWo
 WuR.OeVRDOnMYbP51DokFeEtYfhZrMW7ex4OxUsVBvJ_U0tnvBVsQrF2a7JHQJmqTYeF8aqCFgz3
 xQAZYVuEJQW5B4hZwfoYFxX1Q4SekaTS9VGsi2TIs5FOXBYA3hxUsXVKK9fAuSdYSc.JwVTYQJ09
 c9hy34nBkIQ5qRNm38SnW.YPXcC0KWU6GSFIA8c3kCdqqpNIYqeeKvyy4qiE9SOfBA1NEU9byKuD
 gYQj3yD024Csx6UX0pkGvmXHYu0gFxSnbJGHjCzE1mus324YeZ9lFR2tbA7SGwlg5TLUp_p7hJEa
 5V2.Vmu5EXo621VNg92HStDa5gv9Og3s5FYcdMHVkKZ8NgI.KmKmYfjlp_fbklyuZMsjjAnjUJob
 4qBVM_2j.KE9iF0bfAUaEvYQgWI8wj8GCxuzDv_Lv4ZinFRimXV1Mz9cD3NnKkg_woxwlmKvRFdi
 .1C5CPwon.9zKIfP2ATIUFVHbtvQKFs95TFElm.01uvZKQkkzXn61T1VteQOnqTFEW5D9l5ec1Lb
 yTbDy2CE3Lx_l2lLpXzsrhY7HaoufGoXaVU0slJssrWH_O2Pfai2tUHa18_e_7vyJXKk.nTuvB4K
 4l6idUpZytraZK9FFLRODrYom.hUGPXNgb.gZsssxLhh1r6pp6g3p9qlKl3_aN48hBMk2PjtxJx3
 WbwHoRUvYvZdwYofXlrGaoQiLPZ3L7QnKD.SKDEYBcm4tFheHCRw6KzHauZuSKQxoxY6awkyklJF
 HnySdf8sadNebCW3cJhn8Wyo_jwWmKSGtrngsO1AX3k7BTEqIyoeyaLMBdFWDWAbYraFGdv.CrvM
 ANxrvRatCXTDj8o2_HcLCsmutGxysxdyeQZHTxb64qZ.jEydHrkcki2YvCJ7gEhNlZNKfMQ0l65a
 SBKwpWFXlgSMeVIUhFhAW27xDT6gl2nOB3PVKE_HnVGlFkwwFxMtpK2aYm1ubXzehqHW75MRE7Iy
 vcvAKU_KCMPL0IQ._V.BvgCq9LZuw.D99YQD9XgRndILy.4NkyA41U8kedx5BKAFlsYGmldFVtm7
 n1h58XWBMB62dZrUri_TXLxvAS97YFUv_pBZuh6zh4Ns2aYWdArrHuPKTZ.cfaV7uZZPqCZUEFsh
 KXzyi4dohha_CL6f9yRpXijqP3zNVxLA1ETPzs3gpniyCMj_EwPKmwFMMENJFAM.1fyjFXEnWb0N
 BSmBsB5Ek34SYUfgbCvh80bIYrh_PjULu84l4epqJrcFu4X88VvL5xurzC7crLIAivYIKu20GyA-
 -
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 78d6f755-038f-4bba-81b2-b8c7823f02cf
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Sat, 27 Jan 2024 12:30:14 +0000
Date: Sat, 27 Jan 2024 12:30:10 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <410329971.892462.1706358610883@mail.yahoo.com>
In-Reply-To: <6b65096d-3833-4aeb-ac88-7cabcab3d877@plouf.fr.eu.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com> <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com> <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org> <1822211334.391999.1706183367969@mail.yahoo.com> <17 00056512
 .428301.1706195329259@mail.yahoo.com> <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com> <1421467972.497057.1706207603224@mail.yahoo.com> <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com> <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com> <CAAMCDefv8XuxJqDOCQV+u80TT+Jnr8fVik+vzhc7NWy+NPU=Cw@mail.gmail.com> <394943768.706124.1706282116746@mail.yahoo.com> <277668438.720791.1706285018378@mail.yahoo.com> <1795235772.837302.1706312745369@mail.yahoo.com> <6b65096d-3833-4aeb-ac88-7cabcab3d877@plouf.fr.eu.org>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22046 YMailNorrin

On Saturday, January 27, 2024 at 04:08:21 AM EST, Pascal Hambourg <pascal@p=
louf.fr.eu.org> wrote:

> You should be able to rebuild the array on top of the partitions by
> subtracting the partition offset from the data offset. If the partitions
> all begin at sector 2048:

> --data-offset=3D$((262144-2048))s

Thanks.=C2=A0 I might try that after I get the new drive... and back everyt=
hing up.

> Beware that /dev/sd* names are not always persistent across reboots, so
> check that the disks are in the same order as during the previous boot.

Yeah, so far I haven't had that problem, but I do know it's possible.=20

> RAID5 provides disk fault tolerance. If you only need disk aggregation,
> you could use RAID0 or LVM instead.

Well the original reason for this array when I built it was that huge drive=
s, like 12 TB (the effective capacity of the array), weren't affordable, if=
 they were available at all.=C2=A0 That's the point I was trying to make - =
the need for an array to get 12 TB of storage has gone by the wayside; I ca=
n just buy 12 TB drives.=C2=A0 I have no plan to move away from the array f=
or now, though, I figure I'll keep using it until drives start dying or I t=
ruly fill it up, then decide.

Thanks.
--RJ



On 27/01/2024 at 00:45, RJ Marquette wrote:
> Quick follow up:=C3=82=C2=A0 When I rebooted, the partition tables got mu=
nged
> again.=C3=82=C2=A0 Definitely a BIOS issue.=C3=82=C2=A0 I have a 10TB dri=
ve on order, so I'll
> copy everything off, then rebuild the array in the recommended format
> with partitions, and see what happens then

You should be able to rebuild the array on top of the partitions by=20
subtracting the partition offset from the data offset. If the partitions=20
all begin at sector 2048:

--data-offset=3D$((262144-2048))s

Beware that /dev/sd* names are not always persistent across reboots, so=20
check that the disks are in the same order as during the previous boot.


> (though one wonders if I even need an array when a single drive can
> hold everything...).


RAID5 provides disk fault tolerance. If you only need disk aggregation,=20
you could use RAID0 or LVM instead.

