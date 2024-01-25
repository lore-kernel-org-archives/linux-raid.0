Received: from sonic304-9.consmr.mail.bf2.yahoo.com (sonic304-9.consmr.mail.bf2.yahoo.com [74.6.128.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2726E2B3
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.128.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706195335; cv=none; b=ncc5TPizOKM1EoHYOKsFwyhjXw1bElIIIrJ7/eVrxjQwqzaACZ3wrMZnJtS24w03LOOjrp2KOnmIK4RdQ6d1Q8g3ExrVIp5W6vSe2IfV5LJsB6l7+8scVjg+cEvJEM38mwbg/3BXkNVX4qUHX8V3aoojfq03+A7blYMnT0TmZjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706195335; c=relaxed/simple;
	bh=p2LVDIV2gJW48/AvINMHZqGaW3P1zdm+a4DkDtnigAE=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Qv1Pprynmzqef+Rx0GR69CwF9oUiBjeTZz4DnHANJUbEwwBQd5TQIiKf7w0G2w4KRCAHcgyrcCD/H8wxOxHEuCVD/P9qpEio2clfVmyRKoUoN4ADW/1ficVUmVnHecu0uMY6a3A8RFwN+1r7ttHnkpNCu7APFK+jTAvviDQlXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Kz/uazQa; arc=none smtp.client-ip=74.6.128.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Kz/uazQa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706195331; bh=p2LVDIV2gJW48/AvINMHZqGaW3P1zdm+a4DkDtnigAE=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=Kz/uazQacJXdC/AbLIcpq+H9mRY3psi54YyVNPb6FkuJq6Q8psJAlISZSkraRUptk13aeGmQSjDGfV7qyE0/enTCmUfg4ej+x9nG9GpKgr4y0S3C8eRXN5OBx4E+ncM6jhIe+FHv8KbhVi4AFWwz5hBsm+M/ns3pZW/XDheuJ2EFUCUwtwocSD5TMDUVrjxBa03wiIVXpPHKsKBFweypUsC1YNbjGpKRjtTfW4COuWTmpZxFLYYMNMBlz5d8uQoUOKYQPsxWrEMmtJUtipKIOpQ35JoBdBuhNc3Qtm5nITOd9YWgTCaHFBlG/R+uqL1KOpTZvLGxB5gHRntuANa6Ig==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706195331; bh=kwQ+o0JuNJVH9Md33/7iBzgf5zbxF/uL4b1KlgrUwO7=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=P5BC1AZiUCvjqwr+Ez5Kum7rFd5IE22YrHqkNauJxQBZyfE/zGEYQ0t+Ktts6bocAddMZREdbsaPc3UGWAOsTgR06jVBMp/QEo0dK3Ok3egifaErsMtulbQ5DywtMa3/dem68kE50yHFdz3JYlTth8UjmM56Lf+pJBM3lCKFUvZTNBKYyp5NMq91VqMVocCNP5kJ3SghXWiNcSEygnpT2nYz4uNhK9tDrhcEAWWZqvfz/LqQeiTZlKq1tPBHamdhJVrVNixHm7R1boObtyZU+Y3Myjcl94mA9gHGHbrC+8twoDIrasSaoJ/rNLjwwUPtOlMAFIw5D7lkLwdmMY0wuA==
X-YMail-OSG: OuKzfTMVM1nQ_iraAZ4lpclmmO_0py0bfRc0102Cp2A71VuYrYt8CL8lr7ToMjS
 YSmqbJKIsxTyjV1LjbMcJWBPp93AAUfuve2ChIyPIKHbZ7i2EEhio7SHfyHo9rQx2cJL0hFzRQrB
 9gWrKkFMELEdJos1Hfm30Z33zyq2qM1CXkCdFL6AJi9JM7hg0ielAQfRgsKbWWnv_nIGs4iqEOQN
 T894D_Egrvr0xsHC.U7WeqFiUAL880UpwQwXP8e9Hjj6yK3HeKCCWbGd8HeAlLS.DdX5dwvlMoSB
 KCDAhBFbryxmFuqdhkbPwYE_eqnXw1JVPfW_1pZG2sYIwEOgnWdaLcMKjCSv3QKU_at1.g40pTyt
 rD5g_n4mkPaKehs5sOY4cMQv4plJ4p9M5Q3EEkWLCpCspcfdPPT71BqG3_4n5ANQY7bIR5Gj06Ct
 tLAsqo1ewB6oJ3EKjitQMItXUoVNbyuy4uzLsV4JrXNbiw1uj29c7DmOxN5Vt8kgGi.tEqur3.Ky
 goDz1eLgj2chHmj_HfHQsbgYZ73rz6qrIAQm9Pe3ZoqupP3FU93Vl2HBJHmFFBBPHmDf0w571eAO
 hovi5XRXo5bDe3fqlHEPR.TrwfJxi7f2hQvMgYxcS8Kaz4lJD.KG8goS0VKMI1f6Mk223WMorOtd
 varBXU6U1J8ELrB4Ncs5yzWSkk5PKoMpvxWB.7ecCLzSmi4JOFbb3.NjoMRQwGzLg1kmlg1HUA9m
 CR8NSE2nASM096nJS7dp7LfUwoSmljEqDsTNHdRGe9GU56pDv4Uk0K8Ndkw.3k.c72E9mhw_jgNo
 n5u1llAlB6uFjMIEieOhUvAvByHkpnnrAnE4M15pmLcDCcj6wx6aLAli3yIWZvtkyozMOFFbwwqN
 62AXmOy3WevbXbUDWKeTdBgSusqpYTbh2OCF68h91KoeOEn7BxuU2I0Zjl7xvrmkJy2TK0u3Lahj
 resb4gbHS13OdBpG7JZoGCHTxL1_bfZvT5E9u95ibb7CqpuSSlat4ZCchlARn3t6ab.U4LIxMHbK
 yT6jq57DaKK2njUu9slSS34LJ9.tacE3TvMJCvOSSFs3t83CjGW79GT8MCGOTGkH.aiqDSiL6vC1
 9asxYLBfiH0iIRh_NH_T9ptY4zpvSJvsehsRuZeWSJLOYOUGWFCRgFt_Gctgk1PQKd3t.Td_UmCg
 QlMN_ZqaaNkJcwOR4ePVdq4Rywo_op20pp.FCuw3CZ3anhkn6fuwSfXwhatChTU_EZ18BEObKljo
 118u6Vx1ajtMLQFtf4T_X8y_C4egLknoIImBPBIrlHAC5pVMVjKqMNY5ykbDEZTgodSAtwMtrToM
 QT0_fXjNmxgXPT1zXECrf0bIeATp1Yma9_RxpKaKa8tUP.VKwIpBEHl3HjGsvs_kAsbRaJUw2zic
 h0NZPYk0Zs3ZKGc2X4OeBlpUPrz_yb_dkj1xd3hUEfPXgAWgbKaWGBdYgBJW82RDdMF4mrt0V.FA
 IeS6gQB4Fdg4Ep8YVsiTYy6VUllseDN885Aotj0EUr96v3jeC7hk0L2WT4sl8FJjsHAGbTxwdu.x
 a6wUe522LGNqDGRtAq0XnpWlGgiALI.fQiOXfOzDdmTnxgbctW_dsJfbsAMtg0PM5HAbsBdXuoS4
 mh.XJDFwLuamhu17ynckoembat.0QXIL.qC4ue04c0b.Jr_JF56fmZg3xstKP_hDUWZ1LkD.pcft
 EA1RQfK.JDa12uRKmXRHpZ0nBmBBcIEk.3TXHpc86VT2jxQ1sF3_lhKIQ30e17Io.Zq49BfjNsWl
 jSEVL2g8W.MG_JJVtuTvcuVYw8tZ.KMV3H7pxHd8PbwnIgImd.tLBjUxa8W9UZ5itjhA8fNpyV7J
 6YvRKDUn9wEhOE2q9AL3oHAA.P0pQjp7KOKfkes1HyknYsJV4c4eZnLsd3mGfFIGRrHxNfRes6Fl
 uITTVHoRpupmeP0FVrkA9Jk6ytcky3gYHegQMgagcNe4jJSBO5KJmyjDB_XoxLurXrDYbo8Vhpjj
 _WaprAsLn1sOhTu.zJ1m9bCXd.kAcdCGwsQmK0NeHOVAvv_unvkUA5hN41Vm2FlEYuvuNXPfQLIs
 9JB_71dbxIjubvPQw_u.ue5XqHK5xz9BJVtPuQ1skK7_CCV1GH_yxLNbJYep2BfdasKqb9cQp4Jm
 L5f55Pu0h7TlBDunQ4yMSduDRwjOcouvUImnkKJ_Gp9bdZnYlkeV8WrbOMhHX3ruvSfeaSZ2KsQ-
 -
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 2272f1ba-f654-429d-8858-b356c1cb4035
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Thu, 25 Jan 2024 15:08:51 +0000
Date: Thu, 25 Jan 2024 15:08:49 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <1700056512.428301.1706195329259@mail.yahoo.com>
In-Reply-To: <ab04e35d-b099-441b-b829-428a2c9c2dd8@plouf.fr.eu.org>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com> <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com> <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org> <1822211334.391999.1706183367969@mail.yahoo.com> <ab04e35d-b099-441b-b829-428a2c9c2dd8@plouf.fr.eu.org>
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

It's an ext4 RAID5 array.=C2=A0 No LVM, LUKS, etc.

You make a good point about the BIOS explanation - it seems to have affecte=
d only the 5 RAID drives that had data on them, not the spare, nor the othe=
r system drive (and the latter two are both connected to the motherboard).=
=C2=A0 How would it have decided to grab exactly those 5?

Thanks.
--RJ


On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <pascal@p=
louf.fr.eu.org> wrote:=20





On 25/01/2024 at 12:49, RJ Marquette wrote:
> root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> Disk model: Hitachi HUS72403
> Units: sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: gpt
> Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
>=20
> Device =C2=A0=C2=A0=C2=A0=C2=A0Start =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0End =C2=A0=C2=A0=C2=A0Sectors =C2=A0Size Type
> /dev/sdb1 =C2=A0=C2=A02048 5860532223 5860530176 =C2=A02.7T Microsoft bas=
ic data
>=20
> root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> 2048
> root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> 5860530176

The partition geometry looks correct, with standard alignment.
And the kernel view of the partition matches the partition table.
The partition type "Microsoft basic data" is neither "Linux RAID" nor=20
the default type "Linux flesystem" set by usual GNU/Linux partitioning=20
tools such as fdisk, parted and gdisk so it seems unlikely that the=20
partition was created with one of these tools.


>>> It looks like this is what happened after all.=C2=A0 I searched for "MB=
R
>>> Magic aa55" and found someone else with the same issue long ago:
>>>=C2=A0https://serverfault.com/questions/580761/is-mdadm-raid-toast=C2=A0=
 Looks like
>>> his was caused by a RAID configuration option in BIOS.=C2=A0 I recall s=
eeing
>>> that on mine; I must have activated it by accident when setting the boo=
t
>>> drive or something.


I am a bit suspicious about this cause for two reasons:
- sde, sdf and sdg are affected even though they are connected to the=20
add-on Marvell SATA controller card which is supposed to be outside the=20
motherboard RAID scope;
- sdc is not affected even though it is connected to the onboard Intel=20
SATA controller.

What was contents type of the RAID array ? LVM, LUKS, plain filesystem ?
