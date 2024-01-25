Received: from sonic301-2.consmr.mail.bf2.yahoo.com (sonic301-2.consmr.mail.bf2.yahoo.com [74.6.129.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3809D12E45
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706183377; cv=none; b=kJkE+UXofsslm5/XDKbiQLjpe+sM2x1ODHf48Pz1bLYcN1LdExBxyuPA9NRtZSAj5A83BBs3v90MW77U9rWPf96tyMvaL1fqyqLfbQlhkLgy2zn1LpeW7NG8Rj0ASSZUVt8IWwEslKOAB0H3DScgdk7q60n/rJALVkCAvQUMCGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706183377; c=relaxed/simple;
	bh=8r4keLShboRH9zsXFlNaalHTcsUkwqd9bhNVc/EnYcM=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=oliXDDqeohcYU8Uf95dVKDaINvJtOpTU4wi9ca2WZObGdoZ2XrLg99TQ9q7dtj8zMttn5kK4GjHWCaz6ihWoYhUjwr6s2XXWe3MlCF0BXEAJGvORn4Wc5Iw1kKJ3VLPKxmjv24J0mBvXRypfKBOaQ/Rr4/01osU6IL9Vk3Pqt7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=OAkSXpId; arc=none smtp.client-ip=74.6.129.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="OAkSXpId"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706183373; bh=8r4keLShboRH9zsXFlNaalHTcsUkwqd9bhNVc/EnYcM=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=OAkSXpIdXV2cAAGYbkaXxDpnyt2NsvH8oh4xhdADYVDysTgYRPjEdKQSZ6486CYUg4Y/TnKtmNs4tMuEZ1EE0/9VQjeESqfcB2Fyf72Ubrsx5KTj602ZTHNXMgCCC7+W4vMjQEB1Iz60feVtCtQ/O3Cmo8F+MUuHh2j1IQ0OjhIszKGHkYFsysrZNc5/RZUT2pZAP1sNPGTgkJkQpQtN5O7JssPeMdKeblgDRaCcgYz9jj9lPeYYTt6+pxGGCAcWVzcw4uBLIKFHjM70Yw8/7lYIHxvzQM97VOzLdRBTNvOCiAkx9jJv6gHOrM0MGUSMjHCbgS5mTZrxPXodsztnEw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706183373; bh=ptHgS3MnY26IwMcYGy2BXbwTM+aBPhMpG0h1EYcs7gJ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=piqooCjiwRAcvszuOCbVln3WDnqK6RwGh4W6aW7bqwA8FY2hQuyCV2sLiCoi+Uoq02/fBmMUwX45DDuUrB/uzG06+YdTcy8UGjxslpJuah7yjKtqMn683O3A8AzpQ1cswWQaselrjvNH9sxZpN31SVM5ndPNmvsNaX8QswmQBEqGGquqMzM6C91H5VcuO1iUC3W3xcFy+VKmPWG/BX4/89q7GaB4MnaSJEMgdx0urdJgjWa4SVZgj9NHbdKqZdnywivMyG9tYFYPxKsMG9Jo7FO/1rst1H/hqk56Qln+GpMYNX+ArnIRtwbZqdsG9t86o25o2CHjGypiW/hOkK5JuQ==
X-YMail-OSG: DFwEjIYVM1lWKh_UTYUpXEmrn_eGtwSqSQu6DV.xpSJcNEjWNb7KpFKo74i8lnc
 kX2JJWvVnhvD8B6vgFvtJq8bhzA0mPWu7.5PZIK575uRjC779.CU6nFp_Rq.aCmU0Aa2gWOPZ4o5
 HZ2Ptvezv9nKzTpvMsf.RnRWed8mYoYXrCTb0a._qGxLIfPyaMqCzza9oocoy3a_PgPT1_qJ3RGI
 d.TZ.1WSwxkuofDkfZSCdmSXphk3MXxY7znbV5rNj6jk2JmyJt5L2B0B8AtKndFR4AI0.jbpzv.e
 _KbGBuEw4tJjTsGvgfpeQIy3cu1NsNlN2pu9F13e0MD_J0uAE94cgCq476SUTaQ2JoNNHuzdyW51
 FlSvwvRRdwaecxYEogTTDBrPBo2w99hy43Ne1_RTjO_p8uU9ETjY1eSB1LetNck2NvCLjFzNPISz
 B4hb9m.7Hz4jGfMmK05_Raffmpi5u.qS2CpFAZr.WJmXdQlk9o3779Or.bkTtqnHB0HcDNtKaArD
 whbv_P9RMsFNpGs3q65YMp4iGtYGkZFE0KSjGqEyWKv6BxFVUsVmUxQ.1sbGFVEgnMa2hZ_AFEqY
 xeU77rSuOLTu5Hhy5jRXK.4VJaCZhmEwFnLkNH2WbCz9KyaqSeCn4unOdLk_1gX8Wru010M_hERX
 jZmncFqKelFRnJieIr5KHLIEtb9hPoDPE_auuDZidkH0D94fLGJVbbhWWnCmQsd1tQ53oVw36YQa
 GT157AgO_AIRc0I..vgLoKeVKu4v9x1e8Bc7L6YB6edAjZx8hSGWT87jPh0m430YYnyZghVZVLDq
 jWkg1gtMCcCu_tNOHAm4SFgK4VhosVpNVdFlSXyKeo2.bBQMKfBqXGpCVAFDK07htyTaAF7T9OBz
 4LbxYK7CIcB.hXAx0Ls_8npqCcO7VjxVnjH4pmXG.93JXPhCuMn0qQjFv46pAqWJjxOjtCFnzN.Y
 AGneJ.FnW5cJt8pdTFq073Ym5d_O8zO6ktA1g.sd9R1myo_xwqyvMAJwVF4_cuuVOFtm7hD7.EtT
 aTq7QtYdyh.33LynMN2U5Ebii5A9nEZpxc1XU4V8J6s.dmFlaXCyigFcHWleo89qf3yoy_gzMCfN
 U3LIt1ZP79cprxcOT0V5oinUDyISrkyMCgrjfaHO.PLCh0ka3D8HHsNZ5qMYUwPfhuyWttbCtifl
 wdEDcxFUdcABlgPhN9MVHWB7ICagfhag3kE65G_IcDua1dW75tv4OdRJcawB1cCyvhFM.MDJdr._
 VMH.mqQCMQCcbAr4DovQh041FC4VPAdYEVReWcbL_aWDc1o2Z3p5uFHzlr5aYt3PX8UysZQQbGpg
 UXOc9kXySA.Ml6y9Hlvd6Vr0u7gYUcCKVcQBgNwrtj0hD8TYwFN_l.davxhuBdXNali5gfToYGZD
 MilUDISVlTIRQfGeRV.AhD892vhHk.g_cTZUlUst1fro8LoRyvaYCrGIvkyYJAxcbiK6BXWrswDp
 C_DLnVPyqgMkRQeUO9FNA_4NABr4ZyRsx6uAGAUYp3hQrLnijUImb6up9vgvvFAun7NHoptFpsU7
 67zYRaKKl86DksOnQTsEgR3YS1GBkq_PrrX_zBSAcUvvx2SLGDg3xcT.fiJwdQxe_ivfS22L8Pl4
 xsNUGpSzsmAxVTbuoj.g3M5ptO0lzndT3iCag7E4CuRrsmWkI35Tsh8caKmBSAH5FmGXJr9CTWOX
 Gia1Ca5a4OQDeclYwF0QFPc99NP2Llfl0yvAZ6PElwkRDt518ldZcEjSKanFL32qAyEyGtzWI9Pu
 7N4JfEcRt4P0H.8uBONSl8NNRWQqOUcVYH2GQJnmyXyzcdIJ8qOzcw1zfnKy6SFd_jezg7z_3VOs
 ZYJIFTrxYJna73i9rl37wfUkzwmIa7pcxCNkbvO4D1BtQPPizezCKT0.kcPfHJkxfw1grPIlUWMp
 189WqlxHkTv.XqDFRFtMd3ZSsBdePt9QAHgnd5HskKkLcDi7AGT27xPBxEqSoZ8t8Cv6qhu2iAU_
 LL6lmum4kCx6cxV1QKoCksDptyD5D_uR4GfwzsBwfD6z2mqk7gvSn721EQToEYaW.Xk__dNxWShT
 YFvhdm1a2qs4CR._KBCSYgogiupA2WQKNZyhSyGW_8LLwaJEhVEkRneKZqWVzZIYfOyn5CoyTmNH
 yCGFwSvtyIy2rZsK_7_aMzbQIRA5Q1I6L6qXV_vy8HvIZA0dlZjpJ3xkQg2WlWzx7rJAyvhsp
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 9516f21f-23b0-4e9d-8f28-a0d185395809
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Thu, 25 Jan 2024 11:49:33 +0000
Date: Thu, 25 Jan 2024 11:49:27 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <1822211334.391999.1706183367969@mail.yahoo.com>
In-Reply-To: <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com> <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com> <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org>
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

root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
Disk model: Hitachi HUS72403
Units: sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627

Device =C2=A0=C2=A0=C2=A0=C2=A0Start =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0End =C2=A0=C2=A0=C2=A0Sectors =C2=A0Size Type
/dev/sdb1 =C2=A0=C2=A02048 5860532223 5860530176 =C2=A02.7T Microsoft basic=
 data

root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start =C2=A0
2048
root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
5860530176

(I haven't checked all of the drives in the array, just this one.)

Thanks.
--RJ





On Thursday, January 25, 2024 at 06:07:27 AM EST, Pascal Hambourg <pascal@p=
louf.fr.eu.org> wrote:=20





On 25/01/2024 at 02:57, Roger Heflin wrote:
>=20
> dd if=3D/dev/zero of=3D/dev/sdb bs=3D512 count=3D1=C2=A0 =C2=A0 (for each=
 disk).

I'm afraid it won't help.
As far as I can see, having an MBR signature in the first sector does=20
not prevent blkid or mdadm from detecting the RAID superblock.
Also, previous mail from the OP show that the disks have GPT partition=20
tables (as expected with 3 TiB) which usually span (~16 KiB) beyond the=20
beginning of the 1.2 RAID superblock (4 KiB) so I suspect that the RAID=20
superblock was overwritten.

A tiny hope is that the RAID member was actually in a partition but the=20
geometry in the partition table is wrong or the kernel does not read it=20
properly (I have seen this once). You can check the partition table and=20
how the kernel sees the partition with

fdisk -l /dev/sdb
cat /sys/block/sdb/sdb1/start
cat /sys/block/sdb/sdb1/size

> On Wed, Jan 24, 2024 at 7:13=C3=A2=E2=82=AC=C2=AFPM RJ Marquette <rjm1@ya=
hoo.com> wrote:

>>
>> It looks like this is what happened after all.=C2=A0 I searched for "MBR=
 Magic aa55" and found someone else with the same issue long ago:=C2=A0 htt=
ps://serverfault.com/questions/580761/is-mdadm-raid-toast=C2=A0 Looks like =
his was caused by a RAID configuration option in BIOS.=C2=A0 I recall seein=
g that on mine; I must have activated it by accident when setting the boot =
drive or something.
>>
>> I swapped the old motherboard back in, no improvement, so I'm back to th=
e new one.=C2=A0 I'm now running testdisk to see if I can repair the partit=
ion table.
