Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBA14AEF5
	for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727128987; cv=none; b=D3x4wQDdkVgCigo2gnZpeBnP8EyO9TGkBVUVpOznQV9ofxMjDKObxGaTxOGSqhjt+rsAsFgjInV/5WvuQMCCQZ36J1BS/AJTS6Vj+yS9lV1MgE3TO0rOfoo9ZEOwkm02kACOf7HlKyamvvwPjmRXCS259MtBIfuOvUneXFUtKVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727128987; c=relaxed/simple;
	bh=nyW6LCiZQModqbxD5hnO2iwDt6XQIL1zXX4xUrClDvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PG09MX5AIfPvhqhglm4I2HwveCpib5RNCTaeN1ZXwqkGvnXLHyr4TJzbwTPYLUgT5/afHHX4v0B902hq4oS5eo2J1r8Sy2Xxo6/5xvcB3ZB3xA9KFKKK4bxKhxK48sE6NchPagDJwZ4a00SmuhyNefrXCwGxH3szVTaxPLrfscU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlrZf9Lk; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlrZf9Lk"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6ddfdeed0c9so39074757b3.2
        for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 15:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727128984; x=1727733784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1G3PyNwyGzYxn4jDExKzwwNlbUPRFRZ0+azfZGaJojs=;
        b=TlrZf9Lk+P3fiKTWWUEfS2NltLewR1t45BNCzNMU0URn0EIuDV5T9KKWlKQpCKNJpY
         4YxELS27lptT+gde4W5xy9gtLmYMH5K6gHEXMlj6Y7FsaoeL6RXa9057Xm6EVPbRN5EZ
         evi1j8Bp4GOwh3PRpirGtiqK6jRSAhugDcoc70GmygjUunIjaGC+6rnjNrbFQmSC/oT6
         wNs1pf5Ki8hZAGyD4/yOEBTq78Tr6+SDj4Fo/tnMOzjZFqnEglOZX1ccsnsHElO6r8RN
         9VtcSqt1jqCBawwTqhcSGNH1/Soa7JqV+M4Fj6SNyTLtLu44W4ysznAZGX3NGhybdCeZ
         aUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727128984; x=1727733784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1G3PyNwyGzYxn4jDExKzwwNlbUPRFRZ0+azfZGaJojs=;
        b=BnZkftGH/6BkvoDq6bl/dBOXY1/S1MGkHniYlKZt+03UWI+KCT76MUqaX4lBtTFWFF
         vFWZZ8T5C3Exxs0NzQdV6mWQF2hnt0u1ONn/eQVQdCejBZfIPrAw0rpF1wxCOYCKWn7z
         wI2Q6H9tvdp5Fi8HnyYI8nQnL589ZrcKWtA/st4kZUFX6vjB365IXY/cr6CWwZbSaqVm
         vd6Vy9+jlj/V4tQv+FVkJv5p6skadwWYX8eYxCUGwhLmsY6j5DWL/Ixjqs933qsaqHGR
         wpcSOGDRskw+9WhRfCgaqBGOvdCG8bHNkuJUmdYoIkmAHQEP1Q+e5p0OqPYv3Mgde2X2
         l2Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUnYfWGlRCsa76EtDtgwvr/JAU7N08ZD2CyPQ+KjG1JZ9NCCHvERuQDGEvktMWCdUYFUWHyYTEG9xkC@vger.kernel.org
X-Gm-Message-State: AOJu0YzxypbPBvhySz1pWku1Hg94zWy57J2Zk+aIuiVCQmkukLw/QoyJ
	VDoNxdCyqnJTpU/uahBRitNVe4bXfABXFBAeOPey6rEt7cZ9+SI9eiltVe478KX9j39ih5GP4Pd
	wVKd4IVO0AGDzKgQ8xu03MUieVBg=
X-Google-Smtp-Source: AGHT+IEduGZqirQbgmw/5PbBuAzQrWkL/7ye1j8y8sp5HsgTk3sWmYB5ANLjtLEkC/dP+Kpda8rONdVNTdzukd2gq3A=
X-Received: by 2002:a05:690c:3703:b0:6d6:3cd6:cddc with SMTP id
 00721157ae682-6dfeeeef8bdmr88185967b3.45.1727128983728; Mon, 23 Sep 2024
 15:03:03 -0700 (PDT)
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
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com> <b118cf34-2957-65ed-761b-f999c4ff03fc@nuitari.net>
In-Reply-To: <b118cf34-2957-65ed-761b-f999c4ff03fc@nuitari.net>
From: William Morgan <therealbrewer@gmail.com>
Date: Mon, 23 Sep 2024 17:02:52 -0500
Message-ID: <CALc6PW71Bzzvv+M+SmXYCCHjCA6cni5HcAMiRvP-v+dwXhz24A@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: Stephane Bakhos <nuitari-vger@nuitari.net>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 10:03=E2=80=AFAM Stephane Bakhos
<nuitari-vger@nuitari.net> wrote:
>
>
>
>
> On Wed, 18 Sep 2024, William Morgan wrote:
>
> > Date: Wed, 18 Sep 2024 09:08:13 -0500
> > From: William Morgan <therealbrewer@gmail.com>
> > To: Yu Kuai <yukuai1@huaweicloud.com>
> > Cc: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huaw=
ei.com>
> > Subject: Re: RAID 10 reshape is stuck - please help
> >
> > I tried to mount as read-only and got the following error:
> >
> > bill@bill-desk:~$ sudo mount -o ro /dev/md127 /media/bill/ARRAY3
> > mount: /media/bill/ARRAY3: wrong fs type, bad option, bad superblock
> > on /dev/md127, missing codepage or helper program, or other error.
> >
> > Superblock seems ok:
> >
> > bill@bill-desk:~$ sudo mdadm -D /dev/md127
>
> You are checking the raid superblock, but mount cares about the
> filesystem's superblock. Which filesystem is it ?

ext4

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
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353508] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353514] mpt2sas_cm0:     sas_address(0x4433221109000000), phy(9)
> > [ 1212.353520] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(9)
> > [ 1212.353524] mpt2sas_cm0:     handle(0x001a),
> > ioc_status(success)(0x0000), smid(3887)
> > [ 1212.353530] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.353534] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.353538] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.353543] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.353603] sd 3:0:10:0: [sdk] tag#3887 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353766] sd 3:0:10:0: [sdk] tag#3887 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.353772] mpt2sas_cm0:     sas_address(0x443322110a000000), phy(10=
)
> > [ 1212.353777] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(10)
> > [ 1212.353781] mpt2sas_cm0:     handle(0x001b),
> > ioc_status(success)(0x0000), smid(3888)
> > [ 1212.353786] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.353790] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.353794] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.353799] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.353874] sd 3:0:11:0: [sdl] tag#3888 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354132] sd 3:0:11:0: [sdl] tag#3888 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354138] mpt2sas_cm0:     sas_address(0x443322110b000000), phy(11=
)
> > [ 1212.354143] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(11)
> > [ 1212.354148] mpt2sas_cm0:     handle(0x001c),
> > ioc_status(success)(0x0000), smid(3889)
> > [ 1212.354153] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.354157] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.354161] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.354166] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.354226] sd 3:0:3:0: [sdd] tag#3889 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354418] sd 3:0:3:0: [sdd] tag#3889 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354423] mpt2sas_cm0:     sas_address(0x4433221103000000), phy(3)
> > [ 1212.354428] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(3)
> > [ 1212.354432] mpt2sas_cm0:     handle(0x0014),
> > ioc_status(success)(0x0000), smid(3890)
> > [ 1212.354437] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.354441] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.354445] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.354450] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.354510] sd 3:0:6:0: [sdg] tag#3890 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354780] sd 3:0:6:0: [sdg] tag#3890 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.354786] mpt2sas_cm0:     sas_address(0x4433221106000000), phy(6)
> > [ 1212.354791] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(6)
> > [ 1212.354795] mpt2sas_cm0:     handle(0x0017),
> > ioc_status(success)(0x0000), smid(3891)
> > [ 1212.354800] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.354804] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.354808] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.354812] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.354908] sd 3:0:13:0: [sdn] tag#3891 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355181] sd 3:0:13:0: [sdn] tag#3891 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355189] mpt2sas_cm0:     sas_address(0x443322110d000000), phy(13=
)
> > [ 1212.355197] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(13)
> > [ 1212.355203] mpt2sas_cm0:     handle(0x001e),
> > ioc_status(success)(0x0000), smid(3892)
> > [ 1212.355210] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.355214] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.355218] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.355223] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.355293] sd 3:0:12:0: [sdm] tag#3892 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355476] sd 3:0:12:0: [sdm] tag#3892 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355482] mpt2sas_cm0:     sas_address(0x443322110c000000), phy(12=
)
> > [ 1212.355487] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(12)
> > [ 1212.355491] mpt2sas_cm0:     handle(0x001d),
> > ioc_status(success)(0x0000), smid(3893)
> > [ 1212.355497] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.355501] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.355505] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.355509] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.355573] sd 3:0:1:0: [sdb] tag#3893 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355768] sd 3:0:1:0: [sdb] tag#3893 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.355775] mpt2sas_cm0:     sas_address(0x4433221101000000), phy(1)
> > [ 1212.355781] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(1)
> > [ 1212.355786] mpt2sas_cm0:     handle(0x0012),
> > ioc_status(success)(0x0000), smid(3894)
> > [ 1212.355793] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.355798] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.355803] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.355809] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.355928] sd 3:0:0:0: [sda] tag#3894 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356135] sd 3:0:0:0: [sda] tag#3894 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356142] mpt2sas_cm0:     sas_address(0x4433221100000000), phy(0)
> > [ 1212.356147] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(0)
> > [ 1212.356152] mpt2sas_cm0:     handle(0x0011),
> > ioc_status(success)(0x0000), smid(3895)
> > [ 1212.356157] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.356161] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.356165] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.356170] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.356250] sd 3:0:5:0: [sdf] tag#3895 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356428] sd 3:0:5:0: [sdf] tag#3895 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356434] mpt2sas_cm0:     sas_address(0x4433221105000000), phy(5)
> > [ 1212.356439] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(5)
> > [ 1212.356443] mpt2sas_cm0:     handle(0x0016),
> > ioc_status(success)(0x0000), smid(3896)
> > [ 1212.356448] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.356452] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.356456] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.356461] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.356521] sd 3:0:7:0: [sdh] tag#3896 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356700] sd 3:0:7:0: [sdh] tag#3896 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356706] mpt2sas_cm0:     sas_address(0x4433221107000000), phy(7)
> > [ 1212.356710] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(7)
> > [ 1212.356715] mpt2sas_cm0:     handle(0x0018),
> > ioc_status(success)(0x0000), smid(3897)
> > [ 1212.356719] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.356723] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.356727] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.356732] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.356790] sd 3:0:8:0: [sdi] tag#3897 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356954] sd 3:0:8:0: [sdi] tag#3897 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.356961] mpt2sas_cm0:     sas_address(0x4433221108000000), phy(8)
> > [ 1212.356966] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(8)
> > [ 1212.356970] mpt2sas_cm0:     handle(0x0019),
> > ioc_status(success)(0x0000), smid(3898)
> > [ 1212.356975] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.356979] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.356990] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.356995] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1212.363633] sd 3:0:2:0: [sdc] tag#3898 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.363837] sd 3:0:2:0: [sdc] tag#3898 CDB: ATA command pass
> > through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> > [ 1212.363842] mpt2sas_cm0:     sas_address(0x4433221102000000), phy(2)
> > [ 1212.363846] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), s=
lot(2)
> > [ 1212.363850] mpt2sas_cm0:     handle(0x0013),
> > ioc_status(success)(0x0000), smid(3899)
> > [ 1212.363854] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> > [ 1212.363857] mpt2sas_cm0:     tag(0), transfer_count(0),
> > sc->result(0x00000002)
> > [ 1212.363860] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> > scsi_state(autosense valid )(0x01)
> > [ 1212.363863] mpt2sas_cm0:     [sense_key,asc,ascq]:
> > [0x01,0x00,0x1d], count(22)
> > [ 1516.488470] sd 3:0:4:0: [sde] tag#3899 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 00 00 00 00 08 00 00
> > [ 1516.488717] sd 3:0:4:0: [sde] tag#3900 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 20 00 00 00 08 00 00
> > [ 1516.488851] sd 3:0:4:0: [sde] tag#3901 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 40 00 00 00 08 00 00
> > [ 1516.488967] sd 3:0:4:0: [sde] tag#3902 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 80 00 00 00 08 00 00
> > [ 1516.489080] sd 3:0:4:0: [sde] tag#3903 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0d 00 00 00 00 08 00 00
> > [ 1516.489190] sd 3:0:4:0: [sde] tag#3840 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0e 00 00 00 00 08 00 00
> > [ 1516.489300] sd 3:0:6:0: [sdg] tag#3841 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 00 00 00 00 08 00 00
> > [ 1516.489673] sd 3:0:13:0: [sdn] tag#3842 CDB: Read(16) 88 00 00 00
> > 00 00 00 04 0c 00 00 00 00 08 00 00
> > [ 1516.489916] sd 3:0:9:0: [sdj] tag#3843 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 00 00 00 00 08 00 00
> > [ 1516.490136] sd 3:0:11:0: [sdl] tag#3844 CDB: Read(16) 88 00 00 00
> > 00 00 00 04 10 00 00 00 00 08 00 00
> > [ 1516.490379] sd 3:0:13:0: [sdn] tag#3845 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 80 00 00 00 08 00 00
> > [ 1516.490531] sd 3:0:13:0: [sdn] tag#3846 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 f0 00 00 00 08 00 00
> > [ 1516.490660] sd 3:0:4:0: [sde] tag#3847 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 08 00 00 00 08 00 00
> > [ 1516.700168] sd 3:0:13:0: [sdn] tag#3848 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 f8 00 00 00 08 00 00
> > [ 1516.700550] sd 3:0:13:0: [sdn] tag#3849 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f2 f8 00 00 00 08 00 00
> > [ 1516.700871] sd 3:0:13:0: [sdn] tag#3850 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 c0 00 00 00 08 00 00
> > [ 1516.701160] sd 3:0:13:0: [sdn] tag#3851 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 00 00 00 00 08 00 00
> > [ 1516.701454] sd 3:0:13:0: [sdn] tag#3852 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f2 70 00 00 00 08 00 00
> > [ 1516.701728] sd 3:0:13:0: [sdn] tag#3853 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 b0 00 00 00 08 00 00
> > [ 1516.701992] sd 3:0:13:0: [sdn] tag#3854 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 58 00 00 00 08 00 00
> > [ 1516.702256] sd 3:0:13:0: [sdn] tag#3855 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 20 00 00 00 08 00 00
> > [ 1516.702533] sd 3:0:13:0: [sdn] tag#3856 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 70 00 00 00 08 00 00
> > [ 1516.702805] sd 3:0:13:0: [sdn] tag#3857 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 30 00 00 00 08 00 00
> > [ 1516.703081] sd 3:0:13:0: [sdn] tag#3858 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 20 00 00 00 08 00 00
> > [ 1516.703387] sd 3:0:13:0: [sdn] tag#3859 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 48 00 00 00 08 00 00
> > [ 1516.703829] sd 3:0:13:0: [sdn] tag#3860 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf ef f0 00 00 00 08 00 00
> > [ 1516.704141] sd 3:0:4:0: [sde] tag#3861 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 18 00 00 00 08 00 00
> > [ 1516.704696] sd 3:0:4:0: [sde] tag#3862 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 38 00 00 00 08 00 00
> > [ 1516.704967] sd 3:0:4:0: [sde] tag#3863 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 78 00 00 00 08 00 00
> > [ 1516.705265] sd 3:0:4:0: [sde] tag#3864 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 10 00 00 00 08 00 00
> > [ 1516.705290] sd 3:0:4:0: [sde] tag#3865 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 28 00 00 00 10 00 00
> > [ 1516.705312] sd 3:0:4:0: [sde] tag#3866 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 48 00 00 00 30 00 00
> > [ 1516.705367] sd 3:0:4:0: [sde] tag#3867 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 88 00 00 00 78 00 00
> > [ 1516.705441] sd 3:0:4:0: [sde] tag#3868 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0d 08 00 00 00 f8 00 00
> > [ 1516.706393] sd 3:0:4:0: [sde] tag#3869 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0e 08 00 00 01 f8 00 00
> > [ 1516.707457] sd 3:0:13:0: [sdn] tag#3870 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 00 00 00 00 20 00 00
> > [ 1516.707470] sd 3:0:13:0: [sdn] tag#3871 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 28 00 00 00 08 00 00
> > [ 1516.707481] sd 3:0:13:0: [sdn] tag#3872 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 38 00 00 00 10 00 00
> > [ 1516.707494] sd 3:0:13:0: [sdn] tag#3873 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 50 00 00 00 20 00 00
> > [ 1516.707526] sd 3:0:13:0: [sdn] tag#3874 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f0 78 00 00 00 a8 00 00
> > [ 1516.707545] sd 3:0:13:0: [sdn] tag#3875 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 28 00 00 00 30 00 00
> > [ 1516.707566] sd 3:0:13:0: [sdn] tag#3876 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 60 00 00 00 50 00 00
> > [ 1516.707604] sd 3:0:13:0: [sdn] tag#3877 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f1 b8 00 00 00 48 00 00
> > [ 1516.708573] sd 3:0:13:0: [sdn] tag#3878 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f2 00 00 00 00 70 00 00
> > [ 1516.708600] sd 3:0:13:0: [sdn] tag#3879 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f2 78 00 00 00 80 00 00
> > [ 1516.708630] sd 3:0:13:0: [sdn] tag#3880 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 08 00 00 00 78 00 00
> > [ 1516.708646] sd 3:0:13:0: [sdn] tag#3881 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 88 00 00 00 38 00 00
> > [ 1516.708662] sd 3:0:13:0: [sdn] tag#3882 CDB: Read(16) 88 00 00 00
> > 00 07 46 bf f3 c8 00 00 00 28 00 00
> > [ 1516.709944] sd 3:0:4:0: [sde] tag#3883 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 02 00 00 00 02 00 00
> > [ 1516.711635] sd 3:0:4:0: [sde] tag#3884 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 02 00 00 00 02 00 00
> > [ 1516.712008] sd 3:0:4:0: [sde] tag#3885 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 02 00 00 00 02 00 00
> > [ 1516.712294] sd 3:0:4:0: [sde] tag#3886 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 00 00 00 00 02 00 00
> > [ 1516.712574] sd 3:0:4:0: [sde] tag#3887 CDB: Read(16) 88 00 00 00 00
> > 00 00 04 0c 00 00 00 00 01 00 00
> >
> > I just don't know what else to do here.
> >
> >
>
> That's a lot of devices that are complaining about something.
>
> What does the SMART data show? (smartctl)

smartctl shows all disks passing. I'm not a SMART expert, so I can
post the results if you want to look at them yourself, but it seems
like a lot to post if you don't want it.

>
> Have you checked the cables? Connections are well seated, no hard bends
> near the connectors? Anything that looks like
>

Cables all seem fine.

> Are they shingled drives?

No, all the drives are CMR.

>
> Are the components of md1 (the unrelated array) on a different hardware
> controller / wires?

Same controller, but I see the same results even if I unplug md1.
