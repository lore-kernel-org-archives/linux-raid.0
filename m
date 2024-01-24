Received: from sonic301-3.consmr.mail.bf2.yahoo.com (sonic301-3.consmr.mail.bf2.yahoo.com [74.6.129.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0521353E3
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 21:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706131910; cv=none; b=fxdu9v5mcwbXAiUfaTIwvgsmmibtZD94zfpP/aFssNwa8aiYejKD3S6k+zwXvOUscNnIK7MiUrFhB0tbQ+agOuz+UY1Np1ZOfBYcwM9Xp8TbkSPmo2aNn+XGbFyrJOTDSZNwaX7Un3h4zpjZf31j4kxNigmX9NEKBJUHANtZN4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706131910; c=relaxed/simple;
	bh=YP7FWbsItC49H6uyYW/pUwWeeIP83Fu8n2DYQfOF6jY=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=lJhY1XBpTVKeEv88IX8FHhy87F5AuK/hMELxR2VYJNWn1RFIul7kj/bgahoi6mbPEoy7W7J/ZyO6kWiiDRR6lBLUylah9CjEewEPbl9eCptyP4WgSME4cbmC1jfqJpkWzQplZTUeUeImxBc1K92wnL+B9oBFzO74qVksMtxw35Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=kws7RXNL; arc=none smtp.client-ip=74.6.129.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="kws7RXNL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706131907; bh=YP7FWbsItC49H6uyYW/pUwWeeIP83Fu8n2DYQfOF6jY=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=kws7RXNLe6Z0edbovL+0XFrc0xnJe/jifsl8QI9qLAqsQSrEMAmoW9mMA53SRHkxSfQhcQqcIcFsc9KYPvvXnI1Rl0J3PiF8oBZ4jmGRe7GnZ0XTxOAIKrgs7Q6CFSG1FbJd7Mqkw/71mlO3k/sezXdqDXfwKBESo8hdtgQLYcjNJmx71HWPmEqRc00vViTC2FS93HeZ8FoPV7rSlJWVFL42IiFxcu/Y+TfLhJjh0PsRais/gqSpF6Cq0vlY0nFcVXpcZmQJF3GUlkGAakY7oUcIr8rgUMiwhikkRmz9YX9wIJeI5z2YLsjNAwGNcs2ARYGsG3uGs1gao3Kob0SVuA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706131907; bh=vC6Yx/lOQU6+HRqziZcyNeD4/6ojT/aU6WE5EO439/V=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=V7Rs81g2EgjSI6ayqP7M4FQ7VTug8+eisIQ/UTSP4OnPG6Oh5TIBhf4XSH2x+UAE121ATLCE2aYkC+Cyd+kidqSHIHxfZrXo07Zd6PaIs6PYyIhuIAdxZtly+1NQ1grtD2UUCPcxsfBDX2vAAivGVqM5sAOJnxLmjXLRSYP3dA5tCdGGdllpr4jG4eDIQzhbqoXMFCu7/Ron38IYpOr8RdkMARVPvpRq7lo6nEQJYWSkFN78U3Lurx3yVwe/LkS3o4uv/43FJp2GTrryAqbEnxtMF43phNfLJbWqKCaXtdVRFqHOk5e8E8C//K4TUrPAQHLpe8bKfiPBNzsLreRZbA==
X-YMail-OSG: 3iyuWoAVM1nslgTHafaNrRr_T1WHxrmShs8PHmodrhslG7Q4Lam47.KO_eKN.Yp
 E4HjMilOxBhs3Dm18VdWcZxesfIKKNRomtzeG0IU94pLS1urvooldG9HU3mNTV3wJDoBCaxmugpD
 nXH.rJxMt8AFidoPtEipd4d6lq2PWr14_Y02HM6ZzTzrDPukcZSSrwo9MaracXe_x9dmZwmYTbnA
 Zw61.HcCqhbqLiRkt3CcpMKIhLQVmviiO6xGo56BFNZ1azA2v2.qCeaaY3C7nYbU6UlmKzJGddGh
 wWXW9J3sa2Pu7UTcnSdeTXjN7BVD1REkwH82LPJWqDD9SQdoQGt1wuvZPdIvHdD_0q2PD1huOJUB
 gAlC7mLdzLPCjC81K8dD3GjkMPJFsjowcyceDOXPO0SrOe5JMbYGO4M6CiuOgbzRnDn_M0TuDlFQ
 h8g5o3CMivdXio7wnUVuCT_UV16pscVO0tFmWrxfU0Hu3WEzARzkMc4obquqGHbg.i5FocLcQ9Wf
 JIr7nYm81OkunZhJAr2_c.vOwTge.tsgVbMACZOe9Jlymt63T93lQEdpA8aPV19BiGac8U5p3rq3
 u4zUrwZDZGeuaHueVkrnsvIkkrMiRMvxiOiUNN5RZpaYexrbr5L1qGUymMIL3YnxeP6COqJkY_A4
 _qnYoh3LMW2Ikxblgyt9gW9lgfkPlank2R9OL8TsbIAjIE5jb.t89yx.XNt0g_MGNAjq2QjGTLIj
 7HcShf3bdes5GZCe1ctnIxijxUA8.7EkuXn5gJYJ4RDiMnD1pTxl9YKQJoAugLGSRFLbVPhzqQlt
 .oHTFhXQOnhbrnKcCZxwe8qlFb8XHVjQpEiZ_G8t9XwjsSqsDDjpZHk0ZnYMM9wlNZpE7Ws9EKQ3
 sa6Ei0pax5YfrpXGUoB2rl81HsWAcTXvZizU1su6ASAy3J6566xr1uZ5UcQYfCOepQREkskbMSkM
 uJ76snilf3AJ2bpnUoeC5_FVuq0kDLZxGkoYrlEQRcU_Vd5cc2VTjHuJZuGSQ4B4Y.wAxb7PgjxC
 CiCYyxh1_LYDsI31fksWZGRwu3BTpnDmI6xfDSUenASQknlmrJ6vAcWgyp5n60P4edMdhDnq0D2L
 5_jQwsCHAh1r3INpMjeAQdS9t6A3tjgsSFpFyiRx1yg50eNNgvY67OlbsJf6tBK4pu8drpkxm3aI
 5k81ZWGX8vy4X0bQQurpbf9Gzc7DgY9V5itZXp4DB0RZzTY3i7yWk2w01CYzlWv91X23BB_9e6L6
 nrdqnDUV9QJJHW8VUomVYP6Q0ZxtlSKAY8_bhsksS_8UnAG9HP0pSsLcP8XPLs.S8u8encAh31cX
 IkqZf2EY_ncY0De82aPzJhshJBeKv_w5jsJOQMZIybDME93GimpyuMsqLnayzzJeNBB9D6QnapSt
 yRCMmw5Z21bQUT7nmepPfSpK.7aIO0hIjrxi_8OEEO3cmkfBFl5qy4ElGaHQ3_m1wF9RZBJDuqcC
 K2V.7rz8f9dmDFZb6lV3KteGYfyixvrxydxkQXN1C_MEg5LHz77DRhHHW6WjQFrJxWgLbBKjT9XM
 QFdnOXE7sKgOdi0GWyzkVTLDvQSFSyvdHe_9cWoIWXDMLd5PtVmr2VlSXeUYkYOC0pX5_6egfDvF
 6zTsVhqJ0gQDCTm_tqb2c_dDp7BZKWCMNdFcx2WWZ4v_XvJ73W41VHWTWqlm0pkXuBkBYSImkwrj
 6adf.B5ny.twbEB73Reeplcr5fpyGR_Y37aRkayAIN.ubtUebnsGWOoTs.J4uSOm_J3M6zwnB__e
 Dk966B8IWpH13FF0xtlPhI5N7Xc_hf50hfLAnTxx5logN9rhTlTWc4sudR8pWgZiX38JL7Qb6SqU
 mUi6PoIfIqjmn9dDqGOwI6gGWFXDLuM4XAUp7SZ4.4egg7joubveI4ty7imZ.SDzHWrzygYcBf0J
 OYzlE4N8C3CdyThPNlSak54980LqeYQ7PnCmWSJ3FrNNVd1qkSpzcDnNP1pX6Yq3X8M_FQB.N1xx
 YgFdnDAQ9C.I23zAhVpCI_B2_5XsisLJAl_5PDfKmu.qa4ddEgQZTEQqC9uovgBW7VE6BMpu5dOF
 X5qoV43u6cHkUB_BvMzL_U8Jl4Fsug8royp32uztVdaRZAvJ7pJvTki_SPJHW55vvP2w7buKN6yX
 9EElmGj8ER1Zf16ps1Kv_1s3jXKDz3LLkqQp0BKd__k1Y2H6Um5TWI88.Fy7VuOqbErnWt3MM
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 5d997eba-9bbc-45a1-a804-8778d253c981
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Wed, 24 Jan 2024 21:31:47 +0000
Date: Wed, 24 Jan 2024 21:31:45 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <544664840.269616.1706131905741@mail.yahoo.com>
In-Reply-To: <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
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

I didn't touch the drives.=C2=A0 I shut down the computer with everything w=
orking fine, swapped motherboards, booted the new board, and discovered thi=
s problem immediately when the computer failed to boot because the array wa=
sn't up and running.=C2=A0 I definitely haven't run fdisk or other disk par=
titioning programs on them.

Other than the modifications to the mdadm.conf to describe the drives and p=
artitions (none of which have made any difference), I modified my fstab to =
comment out the raid array so the computer would boot normally.=C2=A0 I've =
been trying to figure out what is going on ever since.=C2=A0 I've tried to =
avoid doing anything that might write to the drives.=C2=A0=20

I thought this upgrade would take an hour or two to swap hardware, not days=
 of troubleshooting.=C2=A0 That was the advantage of software RAID, I thoug=
ht.

Thanks.
--RJ




On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <rogerhefli=
n@gmail.com> wrote:=20





Are you sure you did not partition devices that did not previously
have partition tables?

Partition tables will typically cause the under device (sda) to be
ignored by all of tools since it should never having something else
(except the partition table) on it.

I have had to remove incorrectly added partition tables/blocks to make
lvm and other tools again see the data.=C2=A0 Otherwise the tools ignore
it.

On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrot=
e:
>
> Other than sdc (as you noted), the other array drives come back like this=
:
>
> root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> /dev/sda:
>=C2=A0 MBR Magic : aa55
> Partition[0] :=C2=A0 4294967295 sectors at=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 1 (type ee)
>
> root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> mdadm: No md superblock detected on /dev/sda1.
>
>
> Trying your other suggestion:
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1 /de=
v/sdf1 /dev/sdg1
> mdadm: no recogniseable superblock on /dev/sdb1
> mdadm: /dev/sdb1 has no superblock - assembly aborted
>
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /dev/=
sdf /dev/sdg
> mdadm: Cannot assemble mbr metadata on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
>
>
> Basically I've tried everything here:=C2=A0 https://raid.wiki.kernel.org/=
index.php/Linux_Raid
>
> The impression I'm getting here is that we aren't really sure what the is=
sue is.=C2=A0 I think tonight I'll play with some of the BIOS settings and =
see if there's something in there.=C2=A0 If not I'll swap back to the old m=
otherboard and see what happens.
>
> Thanks.
> --RJ
>
>
>
>
>
> On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@penguinp=
ee.nl> wrote:
>
>
>
>
>
> On 24-01-2024 13:17, RJ Marquette wrote:
>
> > When I try the command you suggested below, I get:
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> > mdadm: no recogniseable superblock on /dev/sda1
> > mdadm: /dev/sda1 has no superblock - assembly aborted
>
>
> Try `mdadm --examine` on every partition / drive that is giving you
> trouble. Maybe you are remembering things wrong and the raid device is
> /dev/sda and not /dev/sda1.
>
> You can also go through the entire list (/dev/sd*), you posted earlier.
> There's no harm in running the command. It will look for the superblock
> and tell you what has been found. This could provide the information you
> need to assemble the array.
>
> Alternatively, leave sda1 out of the assembly and see if mdadm will be
> able to partially assemble the array.
>
> -- Sandro
>
