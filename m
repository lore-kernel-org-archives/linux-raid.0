Received: from sonic316-12.consmr.mail.bf2.yahoo.com (sonic316-12.consmr.mail.bf2.yahoo.com [74.6.130.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD75660269
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.130.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974755; cv=none; b=Lm3xV5mgP5ixysB6p4HVcRb+hCBOwnyV9I2lNhkUKK1cA0SJMLCQamGovQdRxdCD9Xp74QSrH7+D99Q1UuEvKiyfd6qipYjyAF11V3ni9EshlGM5rpax2lG21+t7+wS4mqnAa8Mrfbk79VA7ysWLOZ23VMUGKBeOLIGqG0qsoEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974755; c=relaxed/simple;
	bh=uR9x56/ky8y0YrIhlpdgjw0hxN/O77e1jruRNnWyJls=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YOo8OdJyXDZtxW0XAq+j/f3h3KFkGOxV/Aq+Av/s4eEvQtQ6OF2uPTSfkYZfhtdbltql7VxWLtTd8qRpoQq1zxVdra8sV46X78L32Q/Y+sXVKy5Fg7AENRuSOOJjvIs3oATNs0EWUkJhV4EFHOVoVF+MNGMiSpZF1pLuxRWc84c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=mnvW1SSm; arc=none smtp.client-ip=74.6.130.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="mnvW1SSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705974752; bh=uR9x56/ky8y0YrIhlpdgjw0hxN/O77e1jruRNnWyJls=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=mnvW1SSm3m2y3UMietJGaz5lLfYMkENFhKs+X4xPRo7dUcUJz/RAq4YAm4m4a65XKo1Qifn4fLEnmMfMpSgWyE0KGT5RmtnpnlgQKkzAyICaYtaGL2O/tE8x+2bQI3k8wSFk+QcW79S7vzD00Qbz2iO/lGGZK7b28b/U6ynm50RdkLA0OU3oA2U/TAcMwtbNPWJJoWHU1OzfOrXaMv26nkI6R8Hp7kW1rc8qTd9VYKEiXOCLateiA8nOMq2gWYy6mJ7V1Kwf+axyy6jXFpcLw7y7/QOmEO8YyqXR1kSAH+hVGn2fPK9ATqjbdocF17QqQYGGot3gow0Z0FpbfmZ2cA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705974752; bh=qyhikYPE3hA97kVcrZCcrNeB/M66upl7Zi+scoWF1hU=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=WcONhv6oS2SMZquic1AiQ2h2B/3a7mt6DxTs/P5AIlQEA+LcoBqDih30rEETQkap3n1zO//nP0G8wrRjJM+mHLrpud+QMSla636ZBXT7JjFemom5xrqfeQ3HDsbaC0mgUVRd12MJWxu/uZjORnMm30k/T1ACBjMOqEhGi93yCGMWfgX9TxBZZjTHPfMw9HRM89qj4PWde/tpurG+Ng7mGQhGbx0CWEwWn8OVjJP3s4uLadbx17p5ZTaKaD97k4tsoFYFGzBQZTzja/T9LMOQO3VaBNmCQNglxwcQyhLTSYbMyNGf/3uO44b9n9Pti25mgGczvc9fyj9WbI/9WbzlYQ==
X-YMail-OSG: GF3Pt1cVM1mjeCdI_VMt1pvowLU_v.GZLmqAgANFBbq4CATPc2mHZgUQ_9dsfVw
 TEFZBU3paXL9dZLYduthjw7VEseEY.Qq3uLgrIvTyRZ2.UeAaXtMpYU4n_jwSrv_H6NaQfQVdBtR
 m03.EQLhOcM89BRLYSJ.eD3HTsBviLrliAjnQ8x.oFVqdTgMklyTmfwq60oqxnuGqvzTcH9o4qHW
 dRmmJBvytN7gPtHmtngrf0Cl.HmvQYIAhkUsmiQu7s8myMgmpIXbc3mf9EAYHiAJFndOLnP.gn61
 2rvoH2b1pmu35kc_BKdD32iW_prGxVCQ0LCoW_oNKrSnzz0EmR_cNGO7qoqOaQk872UsJV0mvug8
 NZqk2tI_Iy2mASPZ0NS6KNmQAdZV6YZVAw_WIXnIGPTv0NwVoX0PO28JkUEJ92vhBGS.okgwt8.S
 Zx2_70H_8WPKKtXfrmkMuXpgrjbOCQOk5RfwDBm1_J0ifYEIace.QXg1LIql3oXU__DGeeDQwpLT
 CUgRsazn4HhdDJX8SFtwzNx9v4EA6H6u1ht3krNW_sqU0nBWJ44jgfmqLGtG.mgXfpSNtWgCXlzm
 R.gCCNmnXz4UCYmZYC6sr2ypwYNyjhWYFj1mYcKApWBJ8.qMwRjwcwpFK2h0.pY_AJqZ1Gaet8PK
 GYvIwG1HloSr83GaCyoskJ.2E933EUbKAYtquuj9VmfGk_ko.4RKrIdpUVW8Sx.e8qoJ51t9MHOC
 .KKCVkPwsk6nRSUMHbftpFRwH6H0uL_0DjQNZYR009FyqQeEaZSn.iWvhT3x1ALU3jNH2Eu5Rfzt
 R4EdvaA1UyqND7wHMY8Q9zTEFhvfr2nDz7u28cH2ioZSaQD2g4buJM1IKdm_QE3udaESi8iRq8yR
 xcGsXD5f0iqWbBxWR.JGpz9JV_FYMesslDD_aV4MrKEoAFG8GuzvCIRTpGZ_wKCCQmw4kjBkxRvQ
 qY7GScBhiSGWtaNJXzKtS8Dkc4vxZMhXGwzZraPM373aiWmB9YXefhQG5lvahDcRVfr3oY2YR_5Z
 uXhVXTN0rU1h_e2BApURb8sc384K3gZcESODWS46VTFWHYwuYwFJgCBCUpwe6vmeg0r7ce7GOiAV
 I05BackKU7NLd75IVJ4lF5P4_8zet5s43d.dbLQm.yrKBpQKnWGp86Rdhl.vzfjfuVlUU8TlDfrw
 gS2a2AUuWD5yRn2Czq7abylEwutTtjMxBEI9_O7tDrKlwwwhcP.j3UWjTF8fr14kRYyH4mpfTpoO
 zl3.UqQnnz762znFUlqMbO_xceJux3lqLfXxKSiDpHimDXa60VvhcluT1fzOqaEMjSQKpswMYb2J
 d83LCzkS5mF_PDNnm4AO8qGkEYJJCW4HOCpIqKqvRvqsHKlZodhGRPEpsEUhzD8wfhcMNwGaQEWT
 KbL3sO_gs29nKkQdF0.7xYOcEDtmo89Yb5.NWAO01lVW2kU8WNESvFNuT1xABMo2z2Yaz9C6lT7x
 SDJijgTMKM.Pi0UJs_sFv15cUqvY8qEtm2aY.IE_z76IIHRq.aLvOQZeYzuv6K.rMzeJIf3GnDhG
 doLWxNbCVuSaNLH_fwnAKQ2t1GwJl0xKo37jzKkLnDqY4181t1lPO8sgZ9Uqzo7PBzWxEbwCGsj9
 Y5VcRiqxD0zdo2hQF4Q0ke5zLZIQEDjhhznYUykvD_l_AH3Akc72NMVWLXPcRbftQD4x343lwWii
 DHKZM7harBveXm3OPA8nxvAMMy0l3os4euQzmTfdYIG1QlkRinn8XHSCxyhKM8jkhBx0XJqeXl0J
 t5X9XzdSbjmlyBxrQgqNRMBed1O_a2EMyPfSzRMJAZdXLqbCR0XteGmWB.WOYjueeVycRUno9V3T
 30nTAGb3VaIDhOEayzvq1dYw9k1o5yj5Pq_sdRYfFuemNst7v..si4mVS.HyJonagMown6p5FBxs
 _lLjF1sGoDKTMA.LRrLeBHWceHH.SbybTbVndeVp0jO._gbFqZnPP9OPAadS9tL1IfS8MI7kC3Jo
 NKgPTyrkCv0L28YOOYQVMy3_GgELJR4CCLW_dm.HjdkyOmCJyzLKuAIrYBnKWNKraqBzuUnyPBD2
 C0arHthUcMLQ6w3y47hTgGZrgrsI9IwcrcjC9fhG_Mmeky8PXoZOcuTy2KzCvM0ATeeCHEhajN.5
 Q1_tmHOiIkR0Do4npYI_hvlQ5idxf_mHJ92t9c9IGff9Tqxz6JM0jEmXvYuSx4ZpQSC3H8Q6qiO6
 ae5w-
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: e767ba50-a657-4354-98df-59028f99fb0a
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Tue, 23 Jan 2024 01:52:32 +0000
Date: Tue, 23 Jan 2024 01:52:31 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	Reindl Harald <h.reindl@thelounge.net>
Message-ID: <755754794.951974.1705974751281@mail.yahoo.com>
In-Reply-To: <598555968.936049.1705968542252@mail.yahoo.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com>
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

I meant to add that my /proc/mdstat looked much more like yours on the old =
system.=C2=A0 But nothing is showing on this one.=20

I may try swapping back to the old motherboard.=C2=A0 Another possibility t=
hat might be factor - UEFI vs Legacy BIOS.

Thanks.
--RJ


On Monday, January 22, 2024 at 07:45:29 PM EST, RJ Marquette <rjm1@yahoo.co=
m> wrote:=20





That's all.=C2=A0=20

If I run:

root@jackie:~# mdadm --assemble --scan
mdadm: /dev/md0 assembled from 0 drives and 1 spare - not enough to start t=
he array.

root@jackie:~# cat /proc/mdstat =C2=A0
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4=
] [raid10] =C2=A0
unused devices: <none>

root@jackie:~# ls -l /dev/md*
ls: cannot access '/dev/md*': No such file or directory

It seems to be recognizing the spare drive, but not the 5 that actually hav=
e data, for some reason.

Thanks.
--RJ








On Monday, January 22, 2024 at 06:49:50 PM EST, Reindl Harald <h.reindl@the=
lounge.net> wrote:=20







Am 22.01.24 um 23:13 schrieb RJ Marquette:
> Sorry!
>=20
> rj@jackie:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]
> unused devices: <none>

that's all and where is the ton of raid-types coming from with no single=20
array shown?

[root@srv-rhsoft:~]$ cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb2[2] sda2[0]
=C2=A0 =C2=A0 =C2=A0 30740480 blocks super 1.2 [2/2] [UU]
=C2=A0 =C2=A0 =C2=A0 bitmap: 0/1 pages [0KB], 65536KB chunk

md1 : active raid1 sda3[0] sdb3[2]
=C2=A0 =C2=A0 =C2=A0 3875717120 blocks super 1.2 [2/2] [UU]
=C2=A0 =C2=A0 =C2=A0 bitmap: 5/29 pages [20KB], 65536KB chunk


unused devices: <none>

> On Monday, January 22, 2024 at 04:55:50 PM EST, Reindl Harald <h.reindl@t=
helounge.net> wrote:
>=20
> a ton of "mdadm --examine" outputs but i can't see a "cat /proc/mdstat"
>=20
> /dev/sdX is completly irrelevant when it comes to raid - you can even
> connect a random disk via USB adapter without a change from the view of
> the array
>=20
> Am 22.01.24 um 20:52 schrieb RJ Marquette:
>> Hi, all.=C2=A0 I have a Raid5 array with 5 disks in use and a 6th in res=
erve that I built using 3TB drives in 2019.=C2=A0 It has been running fine =
since, not even a single drive failure.=C2=A0 The system also has a 7th har=
d drive for OS, home directory, etc.=C2=A0 The motherboard had four SATA po=
rts, so I added an adapter card that has 4 more ports, with three drives co=
nnected to it.=C2=A0 The server runs Debian that I keep relatively current.
>>
>> Yesterday, I swapped a newer motherboard into the computer (upgraded my =
desktop and moved the guts to my server).=C2=A0 I never disconnected the ca=
bles from the adapter card (whew, I think), so I know which four drives wer=
e connected to the motherboard.=C2=A0 Unfortunately I didn't really note ho=
w they were hooked to the motherboard (SATA1-4 ports).=C2=A0 Didn't even th=
ink it would be an issue.=C2=A0 I'm reasonably confident the array drives o=
n the motherboard were sda-sdc, but I'm not certain.
>>
>> Now I can't get the array to come up.=C2=A0 I'm reasonably certain I hav=
en't done anything to write to the drives - but mdadm will not assemble the=
 drives (I have not tried to force it).=C2=A0 I'm not entirely sure what's =
up and would really appreciate any help.
>>
>> I've tried various incantations of mdadm --assemble --scan, with no luck=
.=C2=A0 I've seen the posts about certain motherboards that can mess up the=
 drives, and I'm hoping I'm not in that boat.=C2=A0 The "new" motherboard i=
s a Asus Z96-K/CSM.
>>
>> I assume using --force is in my future...I see various pages that say us=
e --force then check it, but will that damage it if I'm wrong?=C2=A0 If not=
, how will I know it's correct?=C2=A0 Is the order of drives important with=
 --force?=C2=A0 I see conflicting info on that.
>>
>> I'm no expert but it looks like each drive has the mdadm superblock...so=
 I'm not sure why it won't assemble.=C2=A0 Please help!
>>
>> Thanks in advance.
>> --RJ
>>
>> root@jackie:~# uname -a
>> Linux jackie 5.10.0-27-amd64 #1 SMP Debian 5.10.205-2 (2023-12-31) x86_6=
4 GNU/Linux
>>
>> root@jackie:~# mdadm --version
>> mdadm - v4.1 - 2018-10-01
>>
>> root@jackie:~# mdadm --examine /dev/sda
>> /dev/sda: =C2=A0=C2=A0MBR Magic : aa55
>> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>>
>> root@jackie:~# mdadm --examine /dev/sda1
>> mdadm: No md superblock detected on /dev/sda1.
>>
>> root@jackie:~# mdadm --examine /dev/sdb
>> /dev/sdb: =C2=A0=C2=A0MBR Magic : aa55
>> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>>
>> root@jackie:~# mdadm --examine /dev/sdb1
>> mdadm: No md superblock detected on /dev/sdb1.
>>
>> root@jackie:~# mdadm --examine /dev/sdc
>> /dev/sdc: =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Magic : =
a92b4efc =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Version : 1.2
>> Feature Map : 0x0
>> Array UUID : 74a11272:9b233a5b:2506f763:27693ccc
>> Name : jackie:0 =C2=A0(local to host jackie)
>> Creation Time : Sat Dec =C2=A08 19:32:07 2018
>> Raid Level : raid5
>> Raid Devices : 5 Avail
>> Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
>> Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
>> Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
>> Data Offset : 262144 sectors
>> Super Offset : 8 sectors
>> Unused Space : before=3D261864 sectors, after=3D944 sectors
>> State : clean
>> Device UUID : a2b677bb:4004d8fb:a298a923:bab4df8a
>> Update Time : Fri Jan 19 15:25:37 2024
>> Bad Block Log : 512 entries available at offset 264 sectors
>> Checksum : 2487f053 - correct
>> Events : 5958
>> Layout : left-symmetric
>> Chunk Size : 512K
>> Device Role : spare
>> Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D r=
eplacing)
>>
>> root@jackie:~# mdadm --examine /dev/sdc1
>> mdadm: cannot open /dev/sdc1: No such file or directory
>>
>> root@jackie:~# mdadm --examine /dev/sde
>> /dev/sde: =C2=A0=C2=A0MBR Magic : aa55
>> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>>
>> root@jackie:~# mdadm --examine /dev/sde1
>> mdadm: No md superblock detected on /dev/sde1.
>>
>> root@jackie:~# mdadm --examine /dev/sdf
>> /dev/sdf: =C2=A0=C2=A0MBR Magic : aa55
>> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>>
>> root@jackie:~# mdadm --examine /dev/sdf1
>> mdadm: No md superblock detected on /dev/sdf1.
>>
>> root@jackie:~# mdadm --examine /dev/sdg
>> /dev/sdg: =C2=A0=C2=A0MBR Magic : aa55
>> Partition[0] : =C2=A0=C2=A04294967295 sectors at =C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A01 (type ee)
>>
>> root@jackie:~# mdadm --examine /dev/sdg1
>> mdadm: No md superblock detected on /dev/sdg1.
>>
>> root@jackie:~# lsdrv
>> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 9 Series Chipset F=
amily SATA Controller [AHCI Mode]
>> =E2=94=9Cscsi 0:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41=
 {Z7317D1A}
>> =E2=94=82=E2=94=94sda 2.73t [8:0] Partitioned (gpt)
>> =E2=94=82 =E2=94=94sda1 2.73t [8:1] Empty/Unknown
>> =E2=94=9Cscsi 1:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403=
 {P8GSA1WR}
>> =E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
>> =E2=94=82 =E2=94=94sdb1 2.73t [8:17] Empty/Unknown
>> =E2=94=9Cscsi 2:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUA72303=
 {MK0371YVGSZ9RA}
>> =E2=94=82=E2=94=94sdc 2.73t [8:32] MD raid5 (5) inactive 'jackie:0' {74a=
11272-9b23-3a5b-2506-f76327693ccc}
>> =E2=94=94scsi 3:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST32000542AS =C2=
=A0=C2=A0=C2=A0=C2=A0{5XW110LY}
>> =E2=94=94sdd 1.82t [8:48] Partitioned (dos)
>> =E2=94=9Csdd1 23.28g [8:49] Partitioned (dos) {d94cc2c8-037a-49c5-8a1e-0=
1bb47d78624}
>> =E2=94=82=E2=94=94Mounted as /dev/sdd1 @ /
>> =E2=94=9Csdd2 1.00k [8:50] Partitioned (dos)
>> =E2=94=9Csdd5 9.31g [8:53] ext4 {6eb3b4d0-8c7f-4b06-a431-4c292d5bda86}
>> =E2=94=82=E2=94=94Mounted as /dev/sdd5 @ /var
>> =E2=94=9Csdd6 3.96g [8:54] swap {901cd56d-ef11-4866-824b-d9ec4ae6fe6e}
>> =E2=94=9Csdd7 1.86g [8:55] ext4 {69ba0889-322b-4fc8-b9d3-a2d133c97e5e}
>> =E2=94=82=E2=94=94Mounted as /dev/sdd7 @ /tmp
>> =E2=94=94sdd8 1.78t [8:56] ext4 {4ed408d4-6b22-46e0-baed-2e0589ff41fb}
>> =E2=94=94Mounted as /dev/sdd8 @ /home PCI [ahci]
>>
>> 06:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9215 PCIe 2.0=
 x1 4-port SATA 6 Gb/s Controller (rev 11)
>> =E2=94=9Cscsi 6:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hitachi HUS72403=
 {P8G84LEP}
>> =E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)
>> =E2=94=82 =E2=94=94sde1 2.73t [8:65] Empty/Unknown
>> =E2=94=9Cscsi 7:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41=
 {Z7317D46}
>> =E2=94=82=E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
>> =E2=94=82 =E2=94=94sdf1 2.73t [8:81] Empty/Unknown
>> =E2=94=94scsi 8:0:0:0 ATA =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ST3000VN007-2E41=
 {Z7317JTX}
>> =E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
>> =E2=94=94sdg1 2.73t [8:97] Empty/Unknown
>>
>> root@jackie:~# cat /etc/mdadm/mdadm.conf
>>=C2=A0 =C2=A0 =C2=A0# This configuration was auto-generated on Wed, 27 No=
v 2019 15:53:23 -0500 by mkconf
>> ARRAY /dev/md0 metadata=3D1.2 spares=3D1 name=3Djackie:0 UUID=3D74a11272=
:9b233a5b:2506f763:27693cccr
