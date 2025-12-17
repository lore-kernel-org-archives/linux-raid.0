Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1582E093C
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765955233; cv=none; b=OgPVT/n2xT+U7CzxO/JatHDbYipM/4rV9OR6ffRY798nOhexjy2P8/uz06CqZtNDFZ4kZ1WlMkre88LbeO5O3+pw9EWgtkan2r47AOQ4raNikJJGaLdzzZUYP3UOMm8b5hXcva4Xispma0EPshamP214V2RAXcigQEYbLLM4x5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765955233; c=relaxed/simple;
	bh=SDeXiimBUfJV9vqwhFyn/W3+m4uPyRCDEX2cqZP5MHU=;
	h=References:Content-Type:To:Subject:Mime-Version:Date:From:
	 Message-Id:In-Reply-To; b=W3PgR3XZoInXmZ5mFJqMKazyRvA6iewCeOB7KBaoi3L58Omr0DhuN4XthmKPCbJH0iDui7icD2GTIrZSV5B6jOXqlFvdlRsAve+g4zchWcboC0rOK4YuObWawCbFTQ4FQCAmVbOxfYhVcPDT6oJ+Qxakemo2xC1LUdVN59LGuRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=M9EVw/Kj; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="M9EVw/Kj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765955174;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SDeXiimBUfJV9vqwhFyn/W3+m4uPyRCDEX2cqZP5MHU=;
 b=M9EVw/KjpBElDdwWIK+muC/ks0DeOFjU/H29lfFqNfeXPQUDV68GiM8ilpFBDv9hYPZ/zw
 q2ymUkaPSJn2pf2vn26yKa4VXfYfkux9ffJwPFPEU4bn2cUR0vPnehaDCvH7jng1Q1WpZ9
 T53CxEUSVRjVwVqnk79W9/LLZv4s1955B+ME/ssaWmAW2PBYJl3m146tYMfYuqT+qEFu40
 PxZS++HcLJk3VIr7y8nCgpaX9UaSdv0JFs1Sbnkl7NznRdB9Z6WTKXkLn/m2h9q9p7R8P6
 Xuk9W7d9i1GLRJSbjqUwYXt/NUudWV+PLl31Ww4vmlcXDX6JKRJ1n2qh0DlqlQ==
X-Lms-Return-Path: <lba+269425664+5ab6dd+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Wed, 17 Dec 2025 15:06:11 +0800
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "BugReports" <bugreports61@gmail.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <yukuai@fnnas.com>
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1 once
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Date: Wed, 17 Dec 2025 15:06:07 +0800
Content-Language: en-US
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
In-Reply-To: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>

Hi,

=E5=9C=A8 2025/12/17 14:58, BugReports =E5=86=99=E9=81=93:
> Hi,
>
> i hope i am reaching out to the correct mailing list and this is the=20
> way to correctly report issues with rc kernels.
>
> I installed kernel 6.19-rc 1 recently (with linux-tkg, but that should=20
> not matter).=C2=A0 Booting the 6.19 rc1 kernel worked fine and i could=20
> access my md raid 1.
>
> After that i wanted to switch back to kernel 6.18.1 and noticed the=20
> following:
>
> - I can not access the raid 1 md anymore as it does not assemble anymore
>
> - The following error message shows up when i try to assemble the raid:
>
> |mdadm: /dev/sdc1 is identified as a member of /dev/md/1, slot 0.=20
> mdadm: /dev/sda1 is identified as a member of /dev/md/1, slot 1.=20
> mdadm: failed to add /dev/sda1 to /dev/md/1: Invalid argument mdadm:=20
> failed to add /dev/sdc1 to /dev/md/1: Invalid argument - The following=20
> error shows up in dmesg: ||[Di, 16. Dez 2025, 11:50:38] md: md1=20
> stopped. [Di, 16. Dez 2025, 11:50:38] md: sda1 does not have a valid=20
> v1.2 superblock, not importing! [Di, 16. Dez 2025, 11:50:38] md:=20
> md_import_device returned -22 [Di, 16. Dez 2025, 11:50:38] md: sdc1=20
> does not have a valid v1.2 superblock, not importing! [Di, 16. Dez=20
> 2025, 11:50:38] md: md_import_device returned -22 [Di, 16. Dez 2025,=20
> 11:50:38] md: md1 stopped. - mdadm --examine used with kerne 6.18=20
> shows the following : ||cat mdadmin618.txt /dev/sdc1: Magic : a92b4efc=20
> Version : 1.2 Feature Map : 0x1 Array UUID :=20
> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host=20
> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1=20
> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB=20
> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data=20
> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :=20
> before=3D264112 sectors, after=3D0 sectors State : clean Device UUID :=20
> 9f185862:a11d8deb:db6d708e:a7cc6a91 Internal Bitmap : 8 sectors from=20
> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512=20
> entries available at offset 16 sectors Checksum : f11e2fa5 - correct=20
> Events : 2618 Device Role : Active device 0 Array State : AA ('A' =3D=3D=
=20
> active, '.' =3D=3D missing, 'R' =3D=3D replacing) /dev/sda1: Magic : a92b=
4efc=20
> Version : 1.2 Feature Map : 0x1 Array UUID :=20
> 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host=20
> gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1=20
> Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB=20
> 1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data=20
> Offset : 264192 sectors Super Offset : 8 sectors Unused Space :=20
> before=3D264112 sectors, after=3D0 sectors State : clean Device UUID :=20
> fc196769:0e25b5af:dfc6cab6:639ac8f9 Internal Bitmap : 8 sectors from=20
> superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512=20
> entries available at offset 16 sectors Checksum : 4d0d5f31 - correct=20
> Events : 2618 Device Role : Active device 1 Array State : AA ('A' =3D=3D=
=20
> active, '.' =3D=3D missing, 'R' =3D=3D replacing)|
> |- Mdadm --detail shows the following in 6.19 rc1 (i am using 6.19=20
> output as it does not work anymore in 6.18.1): ||/dev/md1: Version :=20
> 1.2 Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1 Array=20
> Size : 1929939968 (1840.53 GiB 1976.26 GB) Used Dev Size : 1929939968=20
> (1840.53 GiB 1976.26 GB) Raid Devices : 2 Total Devices : 2=20
> Persistence : Superblock is persistent Intent Bitmap : Internal Update=20
> Time : Tue Dec 16 13:14:10 2025 State : clean Active Devices : 2=20
> Working Devices : 2 Failed Devices : 0 Spare Devices : 0 Consistency=20
> Policy : bitmap Name : gamebox:1 (local to host gamebox) UUID :=20
> 3b786bf1:559584b0:b9eabbe2:82bdea18 Events : 2618 Number Major Minor=20
> RaidDevice State 0 8 33 0 active sync /dev/sdc1 1 8 1 1 active sync=20
> /dev/sda1|
>
>
> I didn't spot any obvious issue in the mdadm --examine on kernel 6.18=20
> pointing to why it thinks this is not a valid 1.2 superblock.
>
> The mdraid still works nicely on kernel 6.19 but i am unable to use it=20
> on kernel 6.18 (worked fine before booting 6.19).
>
> Is kernel 6.19 rc1 doing adjustments on the md superblock when the md=20
> is used which are not compatible with older kernels (the md was=20
> created already in Nov 2024)?

I believe this is because lbs is now stored in metadata of md arrays, while=
 this field is still
not defined in old kernels, see dtails in the following set:

[PATCH v9 0/5] make logical block size configurable - linan666 <https://lor=
e.kernel.org/linux-raid/20251103125757.1405796-1-linan666@huaweicloud.com/>

We'll have to backport following patch into old kernels to make new arrays =
to assemble in old
kernels.

https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huawei=
cloud.com

+CC Nan, would you mind backport above patch into stable kernels?

>
>
> Many thx !
>
>
>
--=20
Thansk,
Kuai
