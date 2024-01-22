Received: from sonic317-26.consmr.mail.bf2.yahoo.com (sonic317-26.consmr.mail.bf2.yahoo.com [74.6.129.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727843FB1E
	for <linux-raid@vger.kernel.org>; Mon, 22 Jan 2024 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705953128; cv=none; b=cdb/1p2zhGWTR8RfyeV3Rr2IqsHGqXNwWgS9mwhKZ3LTB+26NsdrC6FGAYwdgohBHGso+LGzlocdryPf+gQu/xalA9u9lToM8LBSZT4tKh/oiIUdfzKkE+aLDJVNpBgmxlve1DppLohXKPQkIZV15D1LT9Lughj88SVmZQE5Gkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705953128; c=relaxed/simple;
	bh=mNVFVsvdRybZ1XG9SGvJDc1/wSiHPf/FaVIg+otLpH8=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=iPhSFnMPAaB4czi12PjHO31nhCvOfv8EfVHFbHUedEe6x+XRRDa7H5AUMi2RSGPdu7op4SG10yPQk/BC8qZxgLhRGr8dVlUElff2uSvTAPOqIZmM3skFUBevyiEvrISnbYgBT7wRKCzh923zpOMvRctcsxxRJNrRKwK3rx+867o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=EdDIDoIT; arc=none smtp.client-ip=74.6.129.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="EdDIDoIT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705953125; bh=mNVFVsvdRybZ1XG9SGvJDc1/wSiHPf/FaVIg+otLpH8=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=EdDIDoITrDWmjwj+8lrAIrLjREBU80buga3U5wlHj/GXOEh0xhCDLrFXRoMT8lsMEjZ7rpBf4XziVB1tgFPKBeDBSbM7+uESsTZly2N1ldz66dopJe1PXeiB+Lvg9/uYcWNGz8/i5dOWtHzk4OXnkUZlUr21eh9wMVE4+TSUSJbBjQq8p8LMbTyMLIzVSw+aBC2yy/aqUdkAVATt30r7zYlR9Q6Faly7m3MUt4WaO4VNhJycqBGrrFmoElLmNF1M1nozYjNAuX6y8udmbnLGUjOWVcXfp7rsDF5RqBq+OLg4zgcTdKHJ6tYv+LsMGszGJSb+MnAfck+XoUKhd6s00Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705953125; bh=bydiNhhlLxMF41paU/UGks7TENi+2wBCntqbXEPAG6t=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=r2dOg1VSwtizkaZ65enV+oMIhBZj2RVk4EyYBsKlJLJb76Sa1v+5G1mWo74uh/YggyjzyPzno0FMtXQpr2lsrWm9g/KIhc+rM/KdubVb2Wjl4jdnA6CNv1Bz4muc0NIeuTgMfemtMkQe1i3AJ925qehbak23/pVvRYU2hN2nQ0Vqz2MtH+Q6ZQFDxUNhJK6mHKkww3XOFvxReymDRlna/xfjwcya29t8wp2oCSdxHp/WJTR8lIiE1LRB6mYxjtW/yrZcPQCo5EZs13S/wu+tUoF0iv7ewpk4HH/joQ6rqA/o39WUVbdFBbGDxJWH8fUSu3eP7WqnKrDY2fDnCkAzoA==
X-YMail-OSG: i.5jBzMVM1nczlvw5rK38TYOnf13lW3XUJ6i.wuJScgYoq4gH7IPPtbBOvFTYB6
 781qci9VkHx7Q6bCZr5W5pkMCUnM9Z_yMvsFSgXAI.Z3dO7Q1T0p.eYp2xv4MhVkbycguF5FezaP
 YyWmnMlp1_sn9qdLXDicu3Uz40XITfyezJdCSYmzuzRZi332Si0Y7uPWN_3_hQ4hOuaXnkun5DVv
 EmFig4D_O8Nopns5Xe5x1T2RLhsxzbbNzgBS1J0.roSlGGisA44KfremsxA1278wcSXUAyh2a0m0
 vdjHPrXIKH3DwwnZqOlzN.K7_UQ8wDiC99q6VfLAXfnFEXKfF62ZOzvRPLkf1pTo1P3o.Ch6bzxx
 HuQ9h4rtBRwQZYSGtMnv_fQ_18RchL3GvAYu.EoGxTeHkbSStoGRZ4Y8Y2IQ8JxHcrJB8lgRoIXM
 BDuZh442_W85Bzcmzd.23SQa.dD_BOZLwzxIDxajhmi_bqqxJs3ulTBijbSs5r5Ekmt7oxhdFUnd
 l2j92Fxb6B0KILuj_.YzWrWO58jIS0FBYz8UUqbGbpPrKRBiGEPe9aBY0Iimc02XC5xib.qjB47U
 B21_Ll0IdmmhrWJr35CS2_oSGxBCo7eUs5BwFJYrZDEKJXCH7xJoI5lsFoxwzG0eOGSMGxShxUKq
 HCnk2o0KlcCIsWevZbJ3612KXoiZc5tXY5A4TfsFneZNBiCdAeFh.lyIEkjXZXO195BRM7XBrirZ
 Nbj8cfK9yQw50UCdW2cIXLLqvylCNKIFZ.DolxbRu1FidhOyW4KFNm3ldqSdl6H0hlfBmo0O5.29
 mQJQ1Y.8rGuwSRJiRisucoisPd1lORb.WaBrg4HODFC7oqvJnDgk_wy7KRTmAePjNuTfCCXDcNkX
 4MgZzZpzTTojrox2i2lNqb5FnRa8s.4qbJD0Rq7CFkljUwTnyJR4EeSWEE5usFChnQg_F8V0C4Ol
 z3faxOEiEmbhBwHhWYSitp4dyTZBNHqj0Sc3ZFcOZqJLDg_eUZn4j_lS9zRXWJTDYzQKWCbEU51D
 ShvMHy7BI_7WbWhxsqJmZRzcTfTDxXMj3tsLd76Jb.Zvxo1We1y105JAr7Yy18C0oe_swBysMA3R
 .9Zk3cnYKy9Me5ToP.1YtzlFiOYC9gj.eKkWGYhS2F6rfAjypkloBqYHzwu1g2EFAT1jhw4NhaQT
 FpnhI4IwJu4VR5RajhlIx6srFlT3tF4Ag70738DBeqQLb80eTbLmJ8UeumTaeXCSqiUpgxrkrh3m
 49EoXYuvLrFdAdgtpAlFd_Qn_e1ZkSfu.QzM2WrUo.BaBelPPzVv6lSoZYDUq5.5diyvZ8PuD.wZ
 Y1hTRXUm_MH2XZBrMyFZ.hzV436xMBiILpCktub_SEDd4LBfdP2X87Y.Q2cE3hKZ.bImrHf3gwRX
 1hl4X8ygHPr41.gpddIRnZS0n9ObhtGB3LkafMdMGzSYsDBRWJrnkwEK2Z_sFceI6YTcNog5i8Ys
 wL9W6sCbSkfNl.Ilbs.831O5SiIMFi3AwAahnDd6tEH8dpleYj5_zz9_ZFXm7CtJsTLPtMbse7aa
 OL0ep2_Egy0jvfO6bq.9h6KVTi45tp.wxOta30KzEdQKZFKn_hXgU2_kEfKAsMvyYTnFksR5RTOx
 .37OfWtkPp3RxCbhsD7wROwrBtTaIO_WgA2JNGIjj2sAzZO3WdwNh5Q52E0WP08L9fk_EVrybYtJ
 HA5mslgWUR0SxjsSrvy50xs8aflQvDGYUMtidZrN9fgQkRm3FL9xx55v6WZDszlXloiF8fpwcrTM
 0BgG1dLFrS6DfbQo4LpClV16Nn.W.cbSMAXuoJokYvx.biys8EHF.aeCCTv3suUSzAm8uKoP4Wst
 TV01FXZMW8YloreF.f.h2x1I837HPRIJJRO7AMeCC5dX5x2r8NwB5NDZ9S_P_TV3DAPQ.efT3N6F
 S.OV25xfPus4V2I1PQugCzaWiyGE58jC.mNKV0IAf9oaZ1vL2aDQDJf5jEHtJ38ntNH36K_WtgHc
 humeXEwo_6l1uxC.v9DfNtvDbTDmMQhGFD_A7umU0w8lFmW_9XMABuVt_T9hGxAA9KGzOSeBd1sH
 5j1_gAyTVKpcBynnAOBjq3QmV5b4Q7d0HhDKRxih308tlP5Cfti4HNxuPSnPZCOjea42pVxvVtfh
 eGgpijAG8bfovM.Ptd8QnIaVdVm.DhohElUUK
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 5bc6219d-75da-4c23-a50a-074c9e75acbc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Mon, 22 Jan 2024 19:52:05 +0000
Date: Mon, 22 Jan 2024 19:52:01 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <432300551.863689.1705953121879@mail.yahoo.com>
Subject: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22027 YMailNorrin

Hi, all.=C2=A0 I have a Raid5 array with 5 disks in use and a 6th in reserv=
e that I built using 3TB drives in 2019.=C2=A0 It has been running fine sin=
ce, not even a single drive failure.=C2=A0 The system also has a 7th hard d=
rive for OS, home directory, etc.=C2=A0 The motherboard had four SATA ports=
, so I added an adapter card that has 4 more ports, with three drives conne=
cted to it.=C2=A0 The server runs Debian that I keep relatively current.

Yesterday, I swapped a newer motherboard into the computer (upgraded my des=
ktop and moved the guts to my server).=C2=A0 I never disconnected the cable=
s from the adapter card (whew, I think), so I know which four drives were c=
onnected to the motherboard.=C2=A0 Unfortunately I didn't really note how t=
hey were hooked to the motherboard (SATA1-4 ports).=C2=A0 Didn't even think=
 it would be an issue.=C2=A0 I'm reasonably confident the array drives on t=
he motherboard were sda-sdc, but I'm not certain.

Now I can't get the array to come up.=C2=A0 I'm reasonably certain I haven'=
t done anything to write to the drives - but mdadm will not assemble the dr=
ives (I have not tried to force it).=C2=A0 I'm not entirely sure what's up =
and would really appreciate any help.=20

I've tried various incantations of mdadm --assemble --scan, with no luck.=
=C2=A0 I've seen the posts about certain motherboards that can mess up the =
drives, and I'm hoping I'm not in that boat.=C2=A0 The "new" motherboard is=
 a Asus Z96-K/CSM.

I assume using --force is in my future...I see various pages that say use -=
-force then check it, but will that damage it if I'm wrong?=C2=A0 If not, h=
ow will I know it's correct?=C2=A0 Is the order of drives important with --=
force?=C2=A0 I see conflicting info on that.

I'm no expert but it looks like each drive has the mdadm superblock...so I'=
m not sure why it won't assemble.=C2=A0 Please help!

Thanks in advance.
--RJ

root@jackie:~# uname -a=C2=A0
Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31) x86_64 G=
NU/Linux=C2=A0

root@jackie:~# mdadm --version=C2=A0
mdadm - v4.1 - 2018-10-01

root@jackie:~# mdadm --examine /dev/sda=C2=A0
/dev/sda: =C2=A0=C2=A0MBR Magic : aa55=C2=A0
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)=C2=A0

root@jackie:~# mdadm --examine /dev/sda1=C2=A0
mdadm: No md superblock detected on /dev/sda1.=C2=A0

root@jackie:~# mdadm --examine /dev/sdb=C2=A0
/dev/sdb: =C2=A0=C2=A0MBR Magic : aa55=C2=A0
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)=C2=A0

root@jackie:~# mdadm --examine /dev/sdb1=C2=A0
mdadm: No md superblock detected on /dev/sdb1.=C2=A0

root@jackie:~# mdadm --examine /dev/sdc=C2=A0
/dev/sdc: =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Magic : a92=
b4efc =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2 =C2=A0=C2=A0=
=C2=A0
Feature Map : 0x0 =C2=A0=C2=A0=C2=A0=C2=A0
Array UUID : 74a11272:9b233a5b:2506f763:27693ccc =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
Name : jackie:0 =C2=A0(local to host jackie) =C2=A0
Creation Time : Sat Dec =C2=A08 19:32:07 2018 =C2=A0=C2=A0=C2=A0=C2=A0
Raid Level : raid5 =C2=A0=C2=A0
Raid Devices : 5 Avail=C2=A0
Dev Size : 5860271024 (2794.39 GiB 3000.46 GB) =C2=A0=C2=A0=C2=A0=C2=A0
Array Size : 11720540160 (11177.58 GiB 12001.83 GB) =C2=A0
Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB) =C2=A0=C2=A0=C2=A0
Data Offset : 262144 sectors =C2=A0=C2=A0
Super Offset : 8 sectors =C2=A0=C2=A0
Unused Space : before=3D261864 sectors, after=3D944 sectors =C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
State : clean =C2=A0=C2=A0=C2=A0
Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a =C2=A0=C2=A0=C2=A0
Update Time : Fri Jan 19 15:25:37 2024 =C2=A0
Bad Block Log : 512 entries available at offset 264 sectors =C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0
Checksum : 2487f053 - correct =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0
Events : 5958 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
Layout : left-symmetric =C2=A0=C2=A0=C2=A0=C2=A0
Chunk Size : 512K =C2=A0=C2=A0
Device Role : spare =C2=A0=C2=A0
Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D repl=
acing)=C2=A0

root@jackie:~# mdadm --examine /dev/sdc1=C2=A0
mdadm: cannot open /dev/sdc1: No such file or directory=C2=A0

root@jackie:~# mdadm --examine /dev/sde=C2=A0
/dev/sde: =C2=A0=C2=A0MBR Magic : aa55=C2=A0
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)=C2=A0

root@jackie:~# mdadm --examine /dev/sde1=C2=A0
mdadm: No md superblock detected on /dev/sde1.=C2=A0

root@jackie:~# mdadm --examine /dev/sdf=C2=A0
/dev/sdf: =C2=A0=C2=A0MBR Magic : aa55=C2=A0
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)=C2=A0

root@jackie:~# mdadm --examine /dev/sdf1=C2=A0
mdadm: No md superblock detected on /dev/sdf1.=C2=A0

root@jackie:~# mdadm --examine /dev/sdg=C2=A0
/dev/sdg: =C2=A0=C2=A0MBR Magic : aa55=C2=A0
Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)=C2=A0

root@jackie:~# mdadm --examine /dev/sdg1=C2=A0
mdadm: No md superblock detected on /dev/sdg1.

root@jackie:~# lsdrv =C2=A0
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series Chipset Fami=
ly SATA Controller [AHCI Mode]=C2=A0
=E2=94=9Cscsi 0:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 {Z=
7317D1A}=C2=A0
=E2=94=82=E2=94=94sda 2.73t [8:0] Partitioned (gpt)=C2=A0
=E2=94=82 =E2=94=94sda1 2.73t [8:1] Empty/Unknown=C2=A0
=E2=94=9Cscsi 1:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403 {P=
8GSA1WR}=C2=A0
=E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)=C2=A0
=E2=94=82 =E2=94=94sdb1 2.73t [8:17] Empty/Unknown=C2=A0
=E2=94=9Cscsi 2:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUA72303 {M=
K0371YVGSZ9RA}=C2=A0
=E2=94=82=E2=94=94sdc 2.73t [8:32] MD raid5 (5) inactive 'jackie:0' {74a112=
72-9b23-3a5b-2506-f76327693ccc}=C2=A0
=E2=94=94scsi 3:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST32000542AS =C2=A0=
=C2=A0=C2=A0=C2=A0{5XW110LY}=C2=A0
=E2=94=94sdd 1.82t [8:48] Partitioned (dos) =C2=A0
=E2=94=9Csdd1 23.28g [8:49] Partitioned (dos) {d94cc2c8-037a-49c5-8a1e-01bb=
47d78624} =C2=A0
=E2=94=82=E2=94=94Mounted as /dev/sdd1 @ / =C2=A0
=E2=94=9Csdd2 1.00k [8:50] Partitioned (dos) =C2=A0
=E2=94=9Csdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda86} =C2=
=A0
=E2=94=82=E2=94=94Mounted as /dev/sdd5 @ /var =C2=A0
=E2=94=9Csdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6e} =C2=
=A0
=E2=94=9Csdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5e} =C2=
=A0
=E2=94=82=E2=94=94Mounted as /dev/sdd7 @ /tmp =C2=A0
=E2=94=94sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41fb} =C2=
=A0=C2=A0
=E2=94=94Mounted as /dev/sdd8 @ /home PCI [ahci]=C2=A0

06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215 PCIe 2.0 x1=
 4-port SATA 6 Gb/s Controller (rev 11)=C2=A0
=E2=94=9Cscsi 6:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403 {P=
8G84LEP}=C2=A0
=E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)=C2=A0
=E2=94=82 =E2=94=94sde1 2.73t [8:65] Empty/Unknown=C2=A0
=E2=94=9Cscsi 7:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 {Z=
7317D46}=C2=A0
=E2=94=82=E2=94=94sdf 2.73t [8:80] Partitioned (gpt)=C2=A0
=E2=94=82 =E2=94=94sdf1 2.73t [8:81] Empty/Unknown=C2=A0
=E2=94=94scsi 8:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 {Z=
7317JTX}=C2=A0
=E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
=E2=94=94sdg1 2.73t [8:97] Empty/Unknown

root@jackie:~# cat /etc/mdadm/mdadm.conf =C2=A0
=C2=A0# This configuration was auto-generated on Wed, 27 Nov 2019 15:53:23 =
-0500 by mkconf=C2=A0
ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0 UUID=3D74a11272:9b=
233a5b:2506f763:27693cccr
