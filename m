Received: from sonic319-26.consmr.mail.bf2.yahoo.com (sonic319-26.consmr.mail.bf2.yahoo.com [74.6.131.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38081EEE4
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.131.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706207608; cv=none; b=A5++ESHYlh0K2FiwRlOqAD4RmihndqZMenmvpC2GZwdpM/WTcJ2l0nNlcnMSppA0EtCT7udIouaBsiH5zL2IchlY2myF6NOZYZVqNl6IalBweCDBgfEuBFNVNMT9/iilOEhIk7zxDIIkKa+9B7F89oQim/RhJLBOnibrEurkVbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706207608; c=relaxed/simple;
	bh=bLCspTk8g50HcyDBA4pzH9dC6pUvkGJzy4L5F9/2OkM=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=oyAaFoqILgV8CL+V0wb/2hQulxd6zndK+2RkiEGVFXEeVEZJUIGstk3c1WDfUPvBQUy7dAwIZkGG8R1DWJ7vMsZdq8bSqZEg7jj/GwHYHiH1EEZx1rMtqmQGbK4CmUeTNChv38M8+SH/I4HgwlWM1eO8HjJTckyZUVkFqBSuOOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ilSBbSjd; arc=none smtp.client-ip=74.6.131.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ilSBbSjd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706207605; bh=bLCspTk8g50HcyDBA4pzH9dC6pUvkGJzy4L5F9/2OkM=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=ilSBbSjdxLUKBUtuJ2o52kQ2kDKwzK4OCClmn2UnTv9LS3qXgQWmKo5uBc6TRmKCPiZw71hary0tSoPe+HLIshSI0sjh7ptpn+NnwKyCqmHPKOahSEKApi/JmDBQeJ2nO9Q3nikJRVqo4oZ/2rxfC6WQ1zir6gotMrT9o/xLJ4ppnXeD5i0bAIBVOzqGcMrAapXaHusCJhfF7dZ648naEIfvkRInS57lb/8GzjoTkJb77W7zYdJ7qYhQsC+2KyafOHt60Y0fChlsYUoPeS8ltvoMzz9VlRuVy+sn8KxLvsRh/poftiLVoSs2ZI6/XSL8VRqzsQ0pavSd57vXAxIPyQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706207605; bh=smwnO31cwZe7jyjJl7rH3vsjUon+2a0lghIFfXjSAg0=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=FBoY6UJBi3ZGNPJz8sfAg+0nSzM4AgDspuo18tTY/TrWIJqr+M3O9yG4Oe+pzgg88Vv03gVUEL/4Y0nY5Tq+JPYsgs7ZPVmWSlMord6mp4Eeg7AyIb5dfkvJu7nugycieyxS5K2VNHBHqx6R3nn53ADGgKXZaVxvEurkm0JyLblUwqxNv3Sr5IxhddLLkW7dZP0tWK5yc5xousUuE3wYZAwWoJmbwZIVKf3Xm78VYCLz/Xt67JAcfChgItRfRiawsxX0cXGSqGbu/V5nvDro1P/djw7jkjpfNbUfJd3E5lX6K4iJmtCx0KhOXzsB9TJKYSU/MnVOV2kCL7PB+PhEzQ==
X-YMail-OSG: CbyKOkMVM1k7C.5p1dFLd9Tvo1LetyIGVznVdmC5ZPCkUUDPToZfBIFCBqQiPKT
 mKq3.TS3DyGbzYifKsoSpt2pwDMCJhOnvvYLwPJUNSDx15aC9F0kSLOk542s_xsLX8sQRNPxthfn
 LJtssF4N3fb_NAKzGuqUOOMAGYR9A_5yT5PXEqBt7GTPMS_3drT6VF6Ps7Z7gfpCm_REgvsHLvAJ
 YJipsi1FngM7.neJB9j5aCODeLlWG3AmREc7dpU0EOOgknq1HGink4IHTVT1P5_IeYgTDlhM8s0h
 BAncJii2tYZoMGBMyfdPnsC_MV9VHzS7NmRBGtKJnBLePCUHQyCPyhXP1LQfvt5DQQ5F.YRNrNVU
 V0fwilSwvSweuIMNdXOLjB87OCT3ea6XH9VdYy.MMbwuFTI8EZIT0dZzZnO_wopNZxyXTF6VEXRO
 QvOtltrVnPWti9Nd.JeHxKkr2QIfyo.61GOVfl2dUJtKD6tFxVn_aMljSeoTb5XD4zUjRE8dlECm
 8X_Yp5Zx.IQhi5M1APmMYPfL2.vvywAp4nSK724gn1gKB8ujdU8lKRU9HuAo9IPxwC1rhBuSyyhZ
 5cZnb7ftvifPe7y5TFKq8y2nrW7YN20_Mz8mVnuj9cFwXNwQY41Uqb.NLmlGuh_fZ.4zsE9X.4yw
 DhqRS6KQQssi8fLqVrRekodnug011rgyZ615pwWfvhhCl_zpumIewcTqNgrMoy1FKT9kgDzWkgBL
 4RQ0Tr0c0M5NV2aok9P_.sVMHoAayuhdGn.dqUb_FIIeYEuFzKm06aQBkkl1j4LUeSPhy62kTC42
 FzqvFwF.CTnerHPmvGt4CXwuR_IAt8IYyvjB1PPanN4_cz5JWm6QWT1qBWP6i5gMgcuMdiULxEaB
 hAuB7uJu0xEg33enVe1QHGik_PpXmHJSYch3UZB0Rjr5kX1ey6PYcvWBn_iBwjlXSiZCNKbxDo4n
 nzhs7NC.LJSfDJlqy5RYIGMEO3dFmLLTMtGOG4xV.BBhF4jZluzfxuMYFNz2SdzV9Wv4sVtt2g01
 bKQyGn4zaJfWBoht3EeLUAoR6RU8OIF2uiRj6gUBz2Ltw3HH7AAPLZbpvRzSp6rQ6c_XZtclDWis
 sZU3QEBQIXJ4PdnKULrAo3bXlBbID.w9vyiMJhgdZ5sQXyaGZJjTjViRLO5QzgcJ8o3c2DcwFqr3
 hiBGloFZFLASU9E_sGiEhosOveUOmrBzHPlY38g8PZsYqfwNbFs3gDsq2WaAPrv.SmQrnnD11kw8
 iPW2xnUI8wfEAYXjnfW3KtVDKpEuuJ3fl.WVBWRr8nnkvfbBdSKM6hgTTCVrbZNItAas7Bg9UReh
 wENyHoju3sOh7OUZng1WWJFT188TtRnZCBzM2K9gBjgckFbLo5QcqxMKTECrtIrX_h_4JZy57rRe
 pn70mscrxdMStcg0dz0hPMCH.vmjRWX_D6t8NMSTjKF1nh06WvRD3pIrfwJC6aHUwFEZpdHMArrX
 ddi7guBYtSCvndEkBgWo5rcdzh4yclmOSG3uaggZW9q9GprCEuWayQzbbFSiR2ClFnZgq2GLSNsc
 T4NAWygzaHhdEUhBdQUKacHhqSkIxH1qkNQz52h_fj2xZ2m.t4eEbqKLHY4hlD0GfomLqazdYkyr
 sD2_q2L7UaBCWEBGP06c2bPmN4xkQFIV3.o3myFyu9MNWofEziLk7IIy7lQoEscD322TL.E_m7DH
 YPWIeijnZJ.KBnqYEXbVwKOQEOgC4n7nHMJkxOXzsE45y0QE3sV7mRnZCWo5fv9RppPCi_sSTY3t
 Gn.WIr_6Ci2HGvOvQEL.cF7vDDOTJQDCG1.DO59DMngiptsBb_j.Hvw6w7MEVrbR29Ina1NTa_wC
 jEnZMj0u8qRuTAmDNVM_glEKDdjhU0kVYc46Oad5bKbCwNvSC61492KO3I52iTMr8sNNFXQ_KuVm
 eWtR4_mNU4rf2PYdAgo9KdDkoxF79xPL7ovxZ4OECWCNHrdEI7tRBetIsEefSSXSlW6wcavagdD6
 2eUmGsjnuAUjzvN1TfLPth2DvefntexPF_Q5Vi10.9HXwPAz9vyhKZBtoQGQKDZa.7zDKS.30Ad7
 CxNWvaeY4pYPmBA1ijCdnkeInHDrCQk_BdvU7jRdmKV0mnNxQwW3kS.Nfr5ZpjUfud32jsUmb_4.
 3_wNUnaOfMbncQ9qiIFn7zmEnvKkNXmluf4u1rvdMoZPfpda7sq0b9W6kResvZWXUmsrCgaE-
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: 71fc84c2-e08a-4642-a30f-1158305e8295
Received: from sonic.gate.mail.ne1.yahoo.com by sonic319.consmr.mail.bf2.yahoo.com with HTTP; Thu, 25 Jan 2024 18:33:25 +0000
Date: Thu, 25 Jan 2024 18:33:23 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <1421467972.497057.1706207603224@mail.yahoo.com>
In-Reply-To: <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com> <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com> <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org> <1822211334.391999.1706183367969@mail.yahoo.com> <ab04e35d-b099-441b-b829-428a2c9c2dd8@plouf.fr.eu.org> <1700056512.428301.1706195329259@mail.yahoo.com> <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com>
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

No, this system does not have any other OS's installed on it, Debian Linux =
only, as it's my server.

No, the three drives remained connected to the extra controller card and we=
re never removed from that card - I just pulled the card out of the case wi=
th the connections intact, and swung it off to the side.=C2=A0 In fact they=
 still haven't been removed.

I don't understand the partitions comment, as 5 of the 6 drives do appear t=
o have separate partitions for the data, and the one that doesn't is the on=
ly that seems to be responding normally.=C2=A0 I guess the theory is that w=
hatever damaged the partition tables wrote a single primary partition to th=
e drive in the process?

I do not know what caused this problem.=C2=A0 I've had no reason to run fdi=
sk or any similar utility on that computer in years.=C2=A0 I know we want t=
o figure out why this happened, but I'd also like to recover my RAID, if po=
ssible.

What are my options at this point?=C2=A0 Should I try something like this?=
=C2=A0 (This is for someone's RAID1 setup, obviously the level and drives w=
ould change for me.):

mdadm --create --assume-clean --level=3D1 --raid-devices=3D2 /dev/md0 /dev/=
sda /dev/sdb

That's from this page:=C2=A0 https://askubuntu.com/questions/1254561/md-rai=
d-superblock-gets-deleted

I'm currently running testdisk on one of the affected drives to see what th=
at turns up.

Thanks.
--RJ

On Thursday, January 25, 2024 at 12:43:58 PM EST, Roger Heflin <rogerheflin=
@gmail.com> wrote:=20





You never booted windows or any other non-linux boot image that might
have decided to "fix" the disk's missing partition tables?

And when messing with the install did you move the disks around so
that some of the disk could have been on the intel controller with
raid set at different times?

That specific model of marvell controller does not list support raid,
but other models in the same family do, so it may also have an option
in the bios that "fixes" the partition table.

Any number of id10t's writing tools may have wrongly decided that a
disk without a partition table needs to be fixed.=C2=A0 I know the windows
disk management used to (may still) complain about no partitions and
prompt to "fix" it.

I always run partitions on everything.=C2=A0 I have had the partition save
me when 2 different vendors hardware raid controllers lost their
config (random crash, freaked on on fw upgrade) and when the config
was recreated seem to "helpfully" clear a few kb at the front of the
disk.=C2=A0 Rescue boot, repartition, mount os lv, and reinstall grub
fixed those.

On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com> wrote=
:
>
> It's an ext4 RAID5 array.=C2=A0 No LVM, LUKS, etc.
>
> You make a good point about the BIOS explanation - it seems to have affec=
ted only the 5 RAID drives that had data on them, not the spare, nor the ot=
her system drive (and the latter two are both connected to the motherboard)=
.=C2=A0 How would it have decided to grab exactly those 5?
>
> Thanks.
> --RJ
>
>
> On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <pascal=
@plouf.fr.eu.org> wrote:
>
>
>
>
>
> On 25/01/2024 at 12:49, RJ Marquette wrote:
> > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > Disk model: Hitachi HUS72403
> > Units: sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 4096 bytes
> > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > Disklabel type: gpt
> > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> >
> > Device=C2=A0 =C2=A0 Start=C2=A0 =C2=A0 =C2=A0 =C2=A0 End=C2=A0 =C2=A0 S=
ectors=C2=A0 Size Type
> > /dev/sdb1=C2=A0 2048 5860532223 5860530176=C2=A0 2.7T Microsoft basic d=
ata
> >
> > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > 2048
> > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > 5860530176
>
> The partition geometry looks correct, with standard alignment.
> And the kernel view of the partition matches the partition table.
> The partition type "Microsoft basic data" is neither "Linux RAID" nor
> the default type "Linux flesystem" set by usual GNU/Linux partitioning
> tools such as fdisk, parted and gdisk so it seems unlikely that the
> partition was created with one of these tools.
>
>
> >>> It looks like this is what happened after all.=C2=A0 I searched for "=
MBR
> >>> Magic aa55" and found someone else with the same issue long ago:
> >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast=C2=A0 Lo=
oks like
> >>> his was caused by a RAID configuration option in BIOS.=C2=A0 I recall=
 seeing
> >>> that on mine; I must have activated it by accident when setting the b=
oot
> >>> drive or something.
>
>
> I am a bit suspicious about this cause for two reasons:
> - sde, sdf and sdg are affected even though they are connected to the
> add-on Marvell SATA controller card which is supposed to be outside the
> motherboard RAID scope;
> - sdc is not affected even though it is connected to the onboard Intel
> SATA controller.
>
> What was contents type of the RAID array ? LVM, LUKS, plain filesystem ?
>
