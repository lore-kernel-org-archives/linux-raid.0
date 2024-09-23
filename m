Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2818027
	for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727128486; cv=none; b=CFeDBJRYSHTqnLfALIl0A98FBLt5Oogzzpx8ZA1Hl7zw0JtjV/9dUOUZ9NeatQUUl13Z6hlivf+Tl58esn3Tbsi+QpfOPawoLPKLFfcz0t+6PMBZV0aOnKrAuYJJoV1mztl283f0QhkF1s1u6uGyDPZTbWz5K8vEhSKA3MuZbQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727128486; c=relaxed/simple;
	bh=kq0xKqyylcSXdxGiOVosEzfpPxcvFAmNbj48yAu3S0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BfBHtG1g2BO5/bMpPt/6wVEkTyw39YaUxttE/4s9KEiVtfsV+f/ViZmYnl5t0ITZJqfh7zKs5PL8/dF2c1OsLHLIkgsLEYr+72cQ843GeQi8ahx8KwhA8vNxiy4JoXnFFEPZG8K/2hJswqI22NpEPYapAnHvtYojPGf9u8iWw+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6KyaEYr; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6KyaEYr"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e1d22ecf2a6so4223160276.1
        for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 14:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727128484; x=1727733284; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oi2XiUNU2T6qEZFwBfCHB8+Gex7h2O/MtBEty2BPZ1Q=;
        b=e6KyaEYrPFAITNs3htQI3e1ryv0J82mOGyScd465YjR435j1yldvAyQoKH0CFLcCxz
         rIq7/3Fij0eVOTyEDRR/TZNHnjdupTeoUK6kFLGakVDz1IN/Of9qq9wBtiGaqRaJj6JK
         KDep8mR76k8yujHlktjsaxu4ctwOjZIm/2RgyFEs5fLRPSZ5w9tQTQL/u1pQ/JDOwzE+
         wD0lO78ZZbLb8tKrSmGpfJKftrxQhW4myJ94tnNEG+5zCgLXvb9Oo1ZVvKgztFBi9xVU
         NafDFXkEhCdTtW3Np8qparjaYkB8rkETAlXFR7CsEyu6Wy3D7aJV6HvVH3A1OQMjxkWe
         O6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727128484; x=1727733284;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oi2XiUNU2T6qEZFwBfCHB8+Gex7h2O/MtBEty2BPZ1Q=;
        b=Z9apBRA4ovv9irNphFwxYqYrOd2lADwYUZKpecMGJMTyD+Mg65pJpPeTjFYNq6iLl0
         x6HM2JmdZ6k/VtentdQxxU/c4Lfd4y7xJEO0kq+dcFYv4EfOQrq4m85rIx8QFSIcjCNs
         If+A1GC9qSiitqCAgTvjDPvkX/hcwA43I52UUxM1fjLciAox73aZgGbnakV5xH2OYXVQ
         9FpbI3uqrSDaKsrYKUVdR+ZXEh5TSeCFpXIYhwf5FYtabnAzqvq2JK4+9UEqzhwVgxOZ
         jfmlYzC9wHQAghZJAsIlNB92zh9QYOrTUqEqVNn8xVxAM76EE0YucFGr3nnOEuLYY+II
         0PRw==
X-Forwarded-Encrypted: i=1; AJvYcCXwIJ4lY2SPm7LwUQUbmPZ6xbuBR8/BMzVuo5J5AQxdWwlea6oNF7C+ugSk3uyUQAuQDnGNAMzTsM6r@vger.kernel.org
X-Gm-Message-State: AOJu0YzWudB9IeXZAp+unqEmzd+OJyb16UvLJdKZQ9ayVLOkr5pf7QWB
	Qk1QzJqjRb6lvfsbYD8tN8glvmzdvuepOnghBAWR05cAn+LzWJY+CaBvwweWRw/YyHOQQJ6uhC5
	yimdov2Kk1pClSz2ymtYgTkHoPdOa0fb8
X-Google-Smtp-Source: AGHT+IEiqLHYJTFbGAuv2iH6x7pTA6m30Ted07RGZk8UhQry4X+61X+g+KJoPp2s93+L6pdMIfJqZ99QkeaJcJtLuEc=
X-Received: by 2002:a05:6902:120a:b0:e20:1bd7:d43 with SMTP id
 3f1490d57ef6-e2250c3dbaamr9187498276.24.1727128483651; Mon, 23 Sep 2024
 14:54:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com> <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
In-Reply-To: <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
From: William Morgan <therealbrewer@gmail.com>
Date: Mon, 23 Sep 2024 16:54:32 -0500
Message-ID: <CALc6PW713M7fa_PDnzJmTzRBW5-CqvPn9gpXiUtw4DTysp8Fgg@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 10:40=E2=80=AFAM Dragan Milivojevi=C4=87 <galileo@p=
km-inc.com> wrote:
>
> > I tried to mount as read-only and got the following error:
> >
> > bill@bill-desk:~$ sudo mount -o ro /dev/md127 /media/bill/ARRAY3
> > mount: /media/bill/ARRAY3: wrong fs type, bad option, bad superblock
> > on /dev/md127, missing codepage or helper program, or other error.
>
> What do you get when you do blkid /dev/md127

blkid /dev/md127 returns nothing:

bill@bill-desk:~$ blkid /dev/md127
bill@bill-desk:~$ blkid | sort
/dev/md1: UUID=3D"8f645711-4d2b-42bf-877c-a8c993923a7c"
BLOCK_SIZE=3D"4096" TYPE=3D"ext4"
/dev/nvme0n1p1: UUID=3D"291e31b9-fe93-4ca2-a55e-925bd52e22ce"
BLOCK_SIZE=3D"4096" TYPE=3D"ext4"
PARTUUID=3D"4c04494c-aeae-4026-b619-319a47ea9b73"
/dev/nvme0n1p2: UUID=3D"3D01-0380" BLOCK_SIZE=3D"512" TYPE=3D"vfat"
PARTUUID=3D"a04ff739-1730-4a58-8831-77b32e6e8f97"
/dev/sda1: UUID=3D"00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB=3D"1f8a44fb-1f2d-602d-885b-0f8d0d993989" LABEL=3D"bill-desk:1"
TYPE=3D"linux_raid_member"
PARTUUID=3D"8fcf7b2e-9f81-464c-bec4-12b6fa522098"
/dev/sdb1: UUID=3D"00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB=3D"b6c783f4-aadf-ab7a-e272-6885ac2b8165" LABEL=3D"bill-desk:1"
TYPE=3D"linux_raid_member"
PARTUUID=3D"3bbdd3f0-65f2-4b73-8466-138416d715f7"
/dev/sdc1: UUID=3D"00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB=3D"5f32fb20-4db9-b554-1736-4d88d3de79b3" LABEL=3D"bill-desk:1"
TYPE=3D"linux_raid_member"
PARTUUID=3D"a57f49a2-b490-4d7a-b2e4-ef1fd35b4fea"
/dev/sdd1: UUID=3D"00cb57fc-23e1-ccd3-af14-db4398b61d97"
UUID_SUB=3D"4204adc8-7a63-46c6-44ed-2959bbfcb92b" LABEL=3D"bill-desk:1"
TYPE=3D"linux_raid_member"
PARTUUID=3D"10920175-cafa-4fa1-bd24-3eee1ceadaad"
/dev/sde1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"b22c0936-bec1-5431-b61f-c45452468eec" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"afa8f851-6dd8-4939-b0a0-8d4a941eb1cd"
/dev/sdf1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"dde8f226-617b-a075-0e4a-c08034067fc8" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"23fc5af9-a323-4dac-ba07-d71edfe8dc97"
/dev/sdg1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"42de9d6f-948d-537a-4176-c549534bd3c7" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"8c469209-3b5e-40d5-9b09-adbe701db0db"
/dev/sdh1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"56ca9b88-840c-c04e-cfed-c8a695804962" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"994e38fb-9bc7-4882-84d8-18e4eb7bb9ae"
/dev/sdi1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"9500b832-c47a-be89-adbf-f33493800ea9" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"0d2c9546-7204-4f82-8038-e42c06baeab3"
/dev/sdj1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"408f8551-5047-76ce-9066-9f13b2ab0de4" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"9c90f79f-d588-4c50-80d2-f9660ae03287"
/dev/sdk1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"c85fabbb-03da-1c1b-2362-35f9fe1e3da9" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"06177e2c-e030-418b-bae4-1d0243fce01d"
/dev/sdl1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"ffb9bedc-4cd0-f3ea-e5c7-e98467f8929d" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"fc41c31d-fd6e-4433-8373-4a7104b88b80"
/dev/sdm1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"9e3a942a-e9e8-0c16-648c-0d37000b04fe" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"414d1111-1f1d-4448-8c51-2a6f4c582b4f"
/dev/sdn1: UUID=3D"8a321996-5beb-9c15-4c3f-cf5b6c8b6005"
UUID_SUB=3D"7d7be15e-062c-df3b-cef5-a56ec0dee5fc" LABEL=3D"bill-desk:2"
TYPE=3D"linux_raid_member"
PARTUUID=3D"dbb4786e-d396-41de-a5e0-51d48b3069e0"
/dev/sdo1: UUID=3D"acabcdd0-80cd-4e5e-bf0c-f483ae58c0c2"
BLOCK_SIZE=3D"4096" TYPE=3D"ext4"
PARTUUID=3D"f979fc82-a8c2-4a44-898c-8a5fb9b3d3af"

I don't know if that is because at the moment, /dev/md127 is auto-read-only=
:

bill@bill-desk:~$ cat /proc/mdstat
Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid10 sdb1[1] sdd1[3] sdc1[2] sda1[0]
      15627786240 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 0/117 pages [0KB], 65536KB chunk

md127 : active (auto-read-only) raid10 sdh1[3] sdn1[5] sdf1[1] sdk1[8]
sdg1[2] sdl1[9] sdj1[7] sdm1[4] sde1[0] sdi1[6]
      46877236224 blocks super 1.2 512K chunks 2 near-copies [10/10]
[UUUUUUUUUU]
          resync=3DPENDING
      bitmap: 0/88 pages [0KB], 262144KB chunk

unused devices: <none>

Again, md1 is an unrelated array that is functioning fine. I have the
same issues with md127 when md1 is disconnected.

>
>
> > I have noticed a lot of this type of stuff in dmesg, repeating every 5
> > minutes or so:
> >
> > [ 1212.352770] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353063] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353077] mpt2sas_cm0:     sas_address(0x4433221104000000), phy(4)
> > [ 1212.353084] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(4)
> > [ 1212.353090] mpt2sas_cm0:     handle(0x0015),
> > ioc_status(success)(0x0000), smid(3886)
> > [ 1212.353096] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.353101] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.353105] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.353110] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.353248] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass
>
> ATA command pass through is usually from smart monitoring tools but
> this looks more like drive resets. Cables maybe?

I've been using them for some time with no trouble. I have the same
type cables on the other array that is fine. While troubleshooting, I
have unplugged and replugged the cables several times, both at the
drive end and the controller card end. Upon boot, the card always
reports the correct number of drives.
