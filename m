Received: from sonic306-3.consmr.mail.bf2.yahoo.com (sonic306-3.consmr.mail.bf2.yahoo.com [74.6.132.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C212248783
	for <linux-raid@vger.kernel.org>; Mon, 22 Jan 2024 22:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.132.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705961595; cv=none; b=CM9pcZurmNAioE5EeYvfG+Ka+VXNfS7Sr5a+tEs5buW4T36Ef7U/eg8xMGoraoSKesHSIEon3GxmqIaNoUDdwxCfqsOVRv1Nr7IPev2+buI185aartRKcYLmT2FeX6NlxD2zVoUzEHVoOOqHFoPxACaKTzwW+HAc5or7Io+rLr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705961595; c=relaxed/simple;
	bh=bF1GEQtWkMPNKdT4te/+CWGIM34JgeCSePxx4OyJA1Y=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=ZasjRh/4jqmCi2GR7LjBcIfFFPGxpqbI0hPFUnqyCdML9Jm0f43WmjpgMpxWpnsxXoJl3PDjPjs6BxQ4blHL6gq6+ZupsxqVt2ExKy2tK6Hzp45IHMQUHSSkefrmwUoSvJI7Zs5fXiAv3BcqtpTM4tzDlj+XrgXa0cViTb9pK1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=fhh4nrE9; arc=none smtp.client-ip=74.6.132.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="fhh4nrE9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705961592; bh=bF1GEQtWkMPNKdT4te/+CWGIM34JgeCSePxx4OyJA1Y=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=fhh4nrE9kMBHl3RdMcgRS7442w6bdIMA94MCtQwyFucug75kv62XMIfVtHak3jBR4u0YYH/G95FkQ6lZJQqPSAwYPETdRLR9JDFKu6rvUl+g3l/IGLsw482aj/pdX1DE3mhfrbAiC3bVO5fL5NFvZcm+HgMJvvkteHoTRApuX+9+l681Jp9lFppQzaFobddaWnqfBbMI7Z3WDzWaMlzo6fb5uPDdAOKoa6NaMKFZS0gzPxXuvr54znSqnvRFZUDO19im/8qhGDpk0/aWlAIk0wlvTv5C2AenWAxdgba3saJNC6wK4QnVxOhoFIKp+NmTCFlkOulepXPeC1r+VH5TVQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705961592; bh=479XYgufa5Nb9hiMd7/xiK2herfYsA7gvHsb0ueXANc=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=J4dbN0OYfn45icK5qK80zzbRBUssZLaQqT4gfIWPlRQoMMygD9tqXlBJdby29EIaG86SVPfUSdP+jT0sIe9JdxHusbHoKeXYOwf/h1eAi1U1yXEob8jxEozOJOuMm8jNrj315E99i2oEh0VxK2omaaKtKbtDLC2KdwVl47jMTvcd1GHdoXt02pDgEzuJKotCB1OTCpV2V3usaV527ACCUjtvBbxuCvoNJ1UmwvrIqYo15eHPCLYP/6DebgsjkrhysrgY5Hwp7xNoBDkiYyPnfEDxK/EbL5PC3ZkE8B/Bi8RCM0RQvjMeLAhOyKTRR6Nw+DKpO8mu9evIP0iEWRTMtA==
X-YMail-OSG: y0QyjVcVM1lNOvtND_rVxiQ3Bf37OuNDUAxE8suxqtm941widAmaKPT2by6WQBw
 WdE8HbSvR0C3nhIIwmTerFWjjuD2aHY_87ixNsBT28SYGx81pxEqWOsD.riT7AaY_SM7B3IJj2iO
 Q0GXlNvVm8e_YvLA6Z..z37EKJpYKdWrWFXKpxTu7TxVmYX0a8l8CWz82OLuVMQtCRW9B0avgBU6
 ssDzWEOT2U2jl78T_LENAkYTwodeD3XKsQRo_w4V3nPmiv29_lFuKx5T1LqySYJ9Zwyg7NDjbiZa
 z1on1bBjsaAOYgZSFJiIzSDUv1nSgRl99GHntbSNLcPhBb480_k8NjyFSYhwfGlUACjvAf.sjSId
 VuGwT69sCpsLV6aJjpwH8Vt08m9eXVhZCj_Wr4zymt6.TGR6SuNb_.eQ7zPo5pG5br_aVH1Zaf9F
 L_jyY.plFW.IgIUjhTZKtYAckaDKZqag.LX4ViYdSzC1ScRhcHklDivuMdj2bzvZyKND2JdFu41m
 NPH8TFBsj5fpLXWp0h0H41X7f_2mrPsWLGt9ItnIMNhiXqvrslN__mnYcfN.hINAJBA0TVDWaXwO
 bUcy5w0y4yYBkLLVp2h08M3BlTxqCWDJFLoGDP3l2wZqNB6B2qtkNU.ZtbXyxhwRforGIYhlpLTh
 EVHnrPP.WyZO7s5S_WzUI0LmNBz83a744EEFX3TffKhod0hOK79.Xw_qkvbAcoG5tqHztfsVTgjo
 Pr68QMsvRXG8NjX1UvYtoQm9T3fkaJwsQE1cwie7BruwZ5T_2CQ8fm75niEewAtLfztA2aWvhjmR
 LHLKbZBRLDOwJg269w6hKp8553xk4PDcl22AoqkLv7AkzHOS6iyuSxH3L98c..FgRaMxuXcIF4L1
 EMhWW5NI4xlpOvp07iTDDWMQhUXQcL9bpxvVbQBA48JO6fbpysXNlKwVR9uj5asewsj0JxIbeH0Y
 VZZa4M.qNSGoQh9Yy3aV.0YOg9KAZz0KDLRGvHuJaO35F4WZHmK4Lw368FHgiRvCALrQhLhz1luI
 ohSRepMIOfPMWcmYzA_W8z2hoGfVcH00pcGSz4sdxz50yIdeVbtRTSbLXRujFgP5TSTwUxUwnJVP
 refY3OXurAxkgGfQzTbueBIZHEYTP9iOmqsFSapKK_74O_T918Ikn05QOn5MZA9KoC41ldRJJRU6
 qervpxpdCUfyHX6hWh0CPbgvtzgRZUxwlGXzf8ItqP66oIIfqxIOP865_xdcmYSbt78yCSkgYUU8
 pt4.LprKclamJHBg8PuGpSETRrHiJTWwn6g15ys1cpoem2H8dFJCzPNq.XNvj5YnH3Tgh9zPh9vA
 YuEpRNPabi_90XNmtXd6gto64X2rW0yG6SkgSpVFpIRWP3ZvuOVaWfgsjZiC3L9hF6O7V3M_D3np
 GRrOvbBQd.Mo.4QS7BSChU6JnrQDHOqivPFUritHLqBnai46U6GEIn1gK4gKgNMU.GQeWTrcH6wg
 OuGkTLaRJ_fvnYfa10_qgBWa7uwrpywGTPQqtSB3WsObVwjLpOb6iuZ3Zr5_nMhvvwRyPcMTtIhW
 U8NW_QToZaaDW1YWD3gTHIEhQzk8JvRGTuf8H2jGZPSiF3dYarwZMrfj_JnY1QRNm9E2tN.3w8VW
 3Atmutn7ZBr8hPDg.jZvdm6AgrohzcsDrmqYpoWWF7nULQBjuEScdjD3Jz.nFP18tJjBd6XhN3bo
 0ORGrItltYmX4cw97HTpb2geS.9y7uiAS_ZkJNGPoD4ghaqyvSHbItyMoRDQjEh8cqY6iBhjoN7I
 GyWV9XlBSe3JQ5_nlMvp.opMxL3gaI_dbwCPClCYta2ywa6tQbr5HJc6P6V8q_h7oTn5FVMBG7k3
 AZIcyZoJ0SK51.BGOqOWoYyF0b_XOQWyPTpuOrmfFuOJJo2fj7JjDRRYC7_Sr1lzx_Afmou33Yqq
 fVoo9t7AnlbvVP8QKBVeIPrvMZwfWVUsikaj8Mxmvm8aPIrRF8DTX16n2J3xzNdjqYzLLC8V9w2F
 Qv9UmtSkmXWAaMPrnoUtwajDExH0Q_ppr_Yk9t43VPhTEJd620KcW6o5fZl2kBe5_bbqYT8qHpim
 mWQFQq6XUhGUX.B1.AcUnaXHlRIabaQVPKa_om7hGOzfNwGaSg5ZQ9KxZhFvD0u2Gey9ggMAn3fC
 w64fw7j5UVEhDcoqOyeAeI7nYSQsKd13DP21aRorw0SiTYgOTOaijMEg7sW_3kO1sXsklHSuAwxO
 tG_Y-
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: ae41c888-5682-427f-94d6-152f1db7df8a
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Mon, 22 Jan 2024 22:13:12 +0000
Date: Mon, 22 Jan 2024 22:13:08 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	Reindl Harald <h.reindl@thelounge.net>
Message-ID: <1085291040.906901.1705961588972@mail.yahoo.com>
In-Reply-To: <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22027 YMailNorrin

Sorry!=20

rj@jackie:~$ cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4=
] [raid10]=20
unused devices: <none>


Thanks.
--RJ





On Monday, January 22, 2024 at 04:55:50 PM EST, Reindl Harald <h.reindl@the=
lounge.net> wrote:=20





a ton of "mdadm --examine" outputs but i can't see a "cat /proc/mdstat"

/dev/sdX is completly irrelevant when it comes to raid - you can even=20
connect a random disk via USB adapter without a change from the view of=20
the array

Am 22.01.24 um 20:52 schrieb RJ Marquette:
> Hi, all.=C2=A0 I have a Raid5 array with 5 disks in use and a 6th in rese=
rve that I built using 3TB drives in 2019.=C2=A0 It has been running fine s=
ince, not even a single drive failure.=C2=A0 The system also has a 7th hard=
 drive for OS, home directory, etc.=C2=A0 The motherboard had four SATA por=
ts, so I added an adapter card that has 4 more ports, with three drives con=
nected to it.=C2=A0 The server runs Debian that I keep relatively current.
>=20
> Yesterday, I swapped a newer motherboard into the computer (upgraded my d=
esktop and moved the guts to my server).=C2=A0 I never disconnected the cab=
les from the adapter card (whew, I think), so I know which four drives were=
 connected to the motherboard.=C2=A0 Unfortunately I didn't really note how=
 they were hooked to the motherboard (SATA1-4 ports).=C2=A0 Didn't even thi=
nk it would be an issue.=C2=A0 I'm reasonably confident the array drives on=
 the motherboard were sda-sdc, but I'm not certain.
>=20
> Now I can't get the array to come up.=C2=A0 I'm reasonably certain I have=
n't done anything to write to the drives - but mdadm will not assemble the =
drives (I have not tried to force it).=C2=A0 I'm not entirely sure what's u=
p and would really appreciate any help.
>=20
> I've tried various incantations of mdadm --assemble --scan, with no luck.=
=C2=A0 I've seen the posts about certain motherboards that can mess up the =
drives, and I'm hoping I'm not in that boat.=C2=A0 The "new" motherboard is=
 a Asus Z96-K/CSM.
>=20
> I assume using --force is in my future...I see various pages that say use=
 --force then check it, but will that damage it if I'm wrong?=C2=A0 If not,=
 how will I know it's correct?=C2=A0 Is the order of drives important with =
--force?=C2=A0 I see conflicting info on that.
>=20
> I'm no expert but it looks like each drive has the mdadm superblock...so =
I'm not sure why it won't assemble.=C2=A0 Please help!
>=20
> Thanks in advance.
> --RJ
>=20
> root@jackie:~# uname -a
> Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31) x86_64=
 GNU/Linux
>=20
> root@jackie:~# mdadm --version
> mdadm - v4.1 - 2018-10-01
>=20
> root@jackie:~# mdadm --examine /dev/sda
> /dev/sda: =C2=A0=C2=A0MBR Magic : aa55
> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>=20
> root@jackie:~# mdadm --examine /dev/sda1
> mdadm: No md superblock detected on /dev/sda1.
>=20
> root@jackie:~# mdadm --examine /dev/sdb
> /dev/sdb: =C2=A0=C2=A0MBR Magic : aa55
> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>=20
> root@jackie:~# mdadm --examine /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
>=20
> root@jackie:~# mdadm --examine /dev/sdc
> /dev/sdc: =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Magic : a=
92b4efc =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2
> Feature Map : 0x0
> Array UUID : 74a11272:9b233a5b:2506f763:27693ccc
> Name : jackie:0 =C2=A0(local to host jackie)
> Creation Time : Sat Dec =C2=A08 19:32:07 2018
> Raid Level : raid5
> Raid Devices : 5 Avail
> Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
> Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
> Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
> Data Offset : 262144 sectors
> Super Offset : 8 sectors
> Unused Space : before=3D261864 sectors, after=3D944 sectors
> State : clean
> Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a
> Update Time : Fri Jan 19 15:25:37 2024
> Bad Block Log : 512 entries available at offset 264 sectors
> Checksum : 2487f053 - correct
> Events : 5958
> Layout : left-symmetric
> Chunk Size : 512K
> Device Role : spare
> Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
>=20
> root@jackie:~# mdadm --examine /dev/sdc1
> mdadm: cannot open /dev/sdc1: No such file or directory
>=20
> root@jackie:~# mdadm --examine /dev/sde
> /dev/sde: =C2=A0=C2=A0MBR Magic : aa55
> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>=20
> root@jackie:~# mdadm --examine /dev/sde1
> mdadm: No md superblock detected on /dev/sde1.
>=20
> root@jackie:~# mdadm --examine /dev/sdf
> /dev/sdf: =C2=A0=C2=A0MBR Magic : aa55
> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>=20
> root@jackie:~# mdadm --examine /dev/sdf1
> mdadm: No md superblock detected on /dev/sdf1.
>=20
> root@jackie:~# mdadm --examine /dev/sdg
> /dev/sdg: =C2=A0=C2=A0MBR Magic : aa55
> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>=20
> root@jackie:~# mdadm --examine /dev/sdg1
> mdadm: No md superblock detected on /dev/sdg1.
>=20
> root@jackie:~# lsdrv
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series Chipset Fa=
mily SATA Controller [AHCI Mode]
> =E2=94=9Cscsi 0:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 =
{Z7317D1A}
> =E2=94=82=E2=94=94sda 2.73t [8:0] Partitioned (gpt)
> =E2=94=82 =E2=94=94sda1 2.73t [8:1] Empty/Unknown
> =E2=94=9Cscsi 1:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403 =
{P8GSA1WR}
> =E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdb1 2.73t [8:17] Empty/Unknown
> =E2=94=9Cscsi 2:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUA72303 =
{MK0371YVGSZ9RA}
> =E2=94=82=E2=94=94sdc 2.73t [8:32] MD raid5 (5) inactive 'jackie:0' {74a1=
1272-9b23-3a5b-2506-f76327693ccc}
> =E2=94=94scsi 3:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST32000542AS =C2=
=A0=C2=A0=C2=A0=C2=A0{5XW110LY}
> =E2=94=94sdd 1.82t [8:48] Partitioned (dos)
> =E2=94=9Csdd1 23.28g [8:49] Partitioned (dos) {d94cc2c8-037a-49c5-8a1e-01=
bb47d78624}
> =E2=94=82=E2=94=94Mounted as /dev/sdd1 @ /
> =E2=94=9Csdd2 1.00k [8:50] Partitioned (dos)
> =E2=94=9Csdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda86}
> =E2=94=82=E2=94=94Mounted as /dev/sdd5 @ /var
> =E2=94=9Csdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6e}
> =E2=94=9Csdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5e}
> =E2=94=82=E2=94=94Mounted as /dev/sdd7 @ /tmp
> =E2=94=94sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41fb}
> =E2=94=94Mounted as /dev/sdd8 @ /home PCI [ahci]
>=20
> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215 PCIe 2.0 =
x1 4-port SATA 6 Gb/s Controller (rev 11)
> =E2=94=9Cscsi 6:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403 =
{P8G84LEP}
> =E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)
> =E2=94=82 =E2=94=94sde1 2.73t [8:65] Empty/Unknown
> =E2=94=9Cscsi 7:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 =
{Z7317D46}
> =E2=94=82=E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdf1 2.73t [8:81] Empty/Unknown
> =E2=94=94scsi 8:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41 =
{Z7317JTX}
> =E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
> =E2=94=94sdg1 2.73t [8:97] Empty/Unknown
>=20
> root@jackie:~# cat /etc/mdadm/mdadm.conf
>=C2=A0 =C2=A0# This configuration was auto-generated on Wed, 27 Nov 2019 1=
5:53:23 -0500 by mkconf
> ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0 UUID=3D74a11272:=
9b233a5b:2506f763:27693cccr


