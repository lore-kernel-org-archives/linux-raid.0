Received: from sonic320-24.consmr.mail.bf2.yahoo.com (sonic320-24.consmr.mail.bf2.yahoo.com [74.6.128.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01401272B5
	for <linux-raid@vger.kernel.org>; Tue, 23 Jan 2024 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.128.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968550; cv=none; b=WtpdZn7oDVlZnYiblzruw0ZyfeTRQFQzXRgaV+kacS8V4JTSeChxV3ogEK6cRGPsgT2lC/d8rFnGNmmAM17vo2yCV8Ziln4VYWLnaAjnZI5Dpw9Z+jg58iLE/GajEkDp/jh0Rp8hcE5xV28MIoI7T+pI8q8VEzP+iQ76ciH8tik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968550; c=relaxed/simple;
	bh=Mn30gSg1z6goW9MG4AWXndwDf7LkvFXF57+BhGyHhCk=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YNfDuvWtPov4H4/trkZUPM655JPGRJDIRjylE75XeB5UGPs50MHg/B87PvtF/vUfHGAp+9QiSPcOnD6GB+nKKPduvSweFovmGiAPIGso7inqikfyjCej/WP8EMQZXI11tCx8hrZElewNP4EziyTvj9qA8MSvTOxA23W39n2zndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=TDCYNcTu; arc=none smtp.client-ip=74.6.128.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="TDCYNcTu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705968547; bh=Mn30gSg1z6goW9MG4AWXndwDf7LkvFXF57+BhGyHhCk=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=TDCYNcTuI6rzK0dg0WtK61HJkY8Cvk2oSgeQuVwWOsGQ0/MvSxoEjSGWXgQbzGHG9rVSYVZW2uisvAubm07NjOsN7JxrDW2Tbt+waTGIVLuuBF7h372OOP3oQH7GLnfCbDhPqCjmiFEtAlO7H6pdgzsPiwieUfTgJMiDC4dLM1+52cfdaKRxMI5ZAb7I6Vu6dQvNX9RE5sZVtPj6NzqoThLcc7mIfWKw7+iLXLgkxrA+OjeYejj3RgZg/0pZO/+Z/1PngmlbTeqOkVOIgdhObvaZ2FpQnDGCOPYS0La+L79QUehOO0mhsFcwwg82xQ8B2qMvpvbDHZAPCubwsNIlbg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705968547; bh=YkE6omhPEN4IV/kDC4vkCFRE98DzybxDk/hehym/BGa=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=Rt9D7UbR505Ubl4dry08fv7NyLSI9aM3rDaopyHVEZSEaByGKGZU1gnAKhNBT8OD9FDwXnXyJRZe7bevAbOv1TstzzviYACLvpf6BnDZOP2VCMTmINJ8IRy6WjgmyqG+K08NZY7jLSFdr7W3fg3VChFfFqq9Y3hpMigDmfmoLFEcV22S75AeO/3k1cu19yKxpnCSwPebsPpR8om2tujIqTGfdQKYydFc7wZwelRYHe+b8MkeXUtlEg5/HwAV14mGm254qkgYTew+zQO9bxfhQ6hpAp9qsXJsgYULV6I2+eXIx7Ty1VeaXPvhHI+75PZXoxVYZPUNFwlOHVUxWs1isw==
X-YMail-OSG: _2VrgukVM1mQzVfcOnDUOeU8I_UOUNXKpKJJh46JAiAg5xKzilefGaLzgZwXCgZ
 oxZF1nJtLcdXRXKjYfKgkgggb_0C1xCePAJbcyLw7CT.WxLlHJsnxkxZ.ZzeCzVy8eh4iVsUYyTI
 a7IKPbCbqAmF4ZvoTyDXrMTX2fxrH8yQoZfPnmMLL4sWEyS4d72NZxRCItVYKt.wcAULn0a8RyTZ
 2w6k3T7l.wv357SX1o1WOBWtwIW2uGQ1mM9Dt.VehSmtQfxpUZaxnvv2d.QpYo3gJgHyCE_2_hgr
 Ll0ZR05XspB9NYP642yOp9qnrcsvNLIU9rl.t4FIyIJagwoO_lhjVEUPdo4xg6bmJwREmsOuH2Ft
 5fauRUHpO1BV84d9ubjteTvIOgWlWLOn3HwmoTSCttIZCvhE76WTg_6wBRN2AJWpURnEAj6uHmhM
 aDcS5GzxZrpSPyTTg9I4vVumJD8J1xhDsbC2UqnVbpWBBsKbZT6hJ3hwnHAFotH2xixqnZ9eYG7e
 4mtFPe33CDOfX6b4jAArgqe0h_VfIXcjmGb8jKbD5iBVoOLVaiTJh2vM47JImDA_69ShMGyPo.Kz
 XrphnPTpvu0A8OHKwwc3UtfYeFA6I8ETHP16igpuI3h6KYYQYxfV5OFVpZtGIWsRNq17tJDY4xMt
 IK03GDZ9vZb7WdeFKXvlOaSme80ytnyMfhcjqkZxJgHVHda0O0RLEi0dGQhDOF576.ZHsJDEN7Nm
 ukBmlzsoZbMUmZ2M8GpTyHEUDWlxQnz.UNwKyD1n3fO6Mz1jUNxPjaCsirNBbDjXH9VKFRmHskRS
 MQeJsvDKOTxrchRIwmKhGQ9ECikf7iA0kOxjj7lt5fFVDHoqbHu8L3CghrAI6B9ySf7OD9L9xJ30
 0QcCTxv.r51_XLLcWuqQ1XQzi0vNxFJ5loEN9WrCIP_pYXuveTUCQLcFo26c97upiUAS1yJrNQEu
 nIVmFdtjJ1fP7APnlB7TxC37rwQgcfCxZN2sR1hZHrndQwM5284dbEf36VVFUEFOR3ItLYPmr_0F
 qI_wLE0XNR0By6IJu9AmW3WSzlqlQewmPSVSKlxYB5IMjAfJ6zsXsP17ORQtIO89WCMiWo_2VQ8c
 3HCnFjTZppJnQyyvllzKdjzhAZDpZov6EfbYs2xZTYWLSrKrZPSCO.._f9vZjKRR2r1Ne1qP_Dek
 TWDxj7APNrlMcW3Xi_dDP5eLKxObFEyeqeSI6gDT5KtVlGm4UohsQZIRaD5rOoomjUVvkiXps580
 .pAYBohHWNF9_V4RqgMONY2CXlGmUN2oBqShRNK8j9j7aGsSkvcLGMip.NnakTTfTC4UfzArQ5UR
 Rirg3X6ik0lclxBr8XiQlBU9omUBB4F22Kvpje6F_eQ0hQxS9cIDBPsG_UG1VnrJTTakV4ZJdFV9
 T3OS4qwC5h3RqsFMWWC.3bxDjQNPyCKLNkrMnX.Y36k61yq0HZ9tl..jHYgQBljQ6Oluu0HyG0Oo
 3MQ4d7P007xNs6Xj3AGj8i2XJLKwNFWSv0qUmXzKmaG2Csr_ErH3A.fJt1xg7JibVyDso3IlLmur
 LUwVFsTdhVeBAQUdmyI7RNOnYREQtAKUWH5lRBRzWimd8vLnOlUvcRf.5GzaLzgRoGgNpZEh9zv1
 90GtHrKEQzwnQenSHgyT1fEDDW.hKuDkBjqccl4.iPtHdpDZkrp6nds_Haxm1lGEW9GnWk6tXztH
 b_3yl8V2ZDq81Zv_mdP9K6hi4.b5yaUrybMfvaZ6S2C1le7auPE1v8Z_fPE9uHsqqA9gr3qc7YZh
 rGnQ6Wt2C77Hl6ci3P5Gv73OIeroaN0.TxT0wbjMHpOKYXeZEGYrvwS.Gtmi..cL0JNwIkEl.PYg
 0FIids0iEcm0BwuvodVxmNxbTRQS28rVhyvLx9bI6PYzXY7xdPoaH87sytWFti68etiVHqi.AZEo
 WDcYIaSaLUv3Dme21zLv6v8WTrpAlvlN4VdFg_FJWT80fJ38nPtek78vz70Cq1iMm82hA9is0d7x
 SITG9Mq5a0HErXo8UQomRmsRfoQ9NHHoRd0iAArkOQynMmmtk1EskCy0jHpaE_fhDkEMH0Oa7_tg
 rvZO4jwTgLcOHpbiufy38htcn54WZMBi52uieUiTw_mFjAAUvJWmbrGeWZpNYSJw.nd9Sn30LA5n
 Ejx7PCrZxxfUXca51DXHUVy7fj4hKhtJwKKGwACIJt4mq_kZmC2Is3nble8U5sLibywYn9POU1ld
 mMCc-
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: e0b19c12-9e0a-4a7c-892e-c4333263b928
Received: from sonic.gate.mail.ne1.yahoo.com by sonic320.consmr.mail.bf2.yahoo.com with HTTP; Tue, 23 Jan 2024 00:09:07 +0000
Date: Tue, 23 Jan 2024 00:09:02 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	Reindl Harald <h.reindl@thelounge.net>
Message-ID: <598555968.936049.1705968542252@mail.yahoo.com>
In-Reply-To: <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
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
