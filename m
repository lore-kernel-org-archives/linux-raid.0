Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BE1537B5
	for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726674019; cv=none; b=a33qELnZeCYbDfXI23IhmVcqZBL+YOkjKpeAAh+r5ahI42wpjndxBxhME28bxEpooKII3Cs1uywDYCPk2CLyysuLHdFonRn3FtbV4oa5LKXA9HSZGUZBf4JrKVNlbvBpcA4bVtaulW/CtK6rSLmUfNRv8yscNaxS+WSPV4d8wQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726674019; c=relaxed/simple;
	bh=24pwyGTzMhmcHWMhVx0Tz3Rgbpj1SMNDBJ+qzAtn+AE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OxQHDTL9oINSD5V9wsJj17HxwcDh8nNYS4eNIo0WywMmE55MEjy9pAWljYN+bxl0XbsU+i0hKYfxrsaTtY4pavMX0fnGUw3Jp6vsIVsL86sYDokwxObCxHzK7mR9KSKnLbbSTUnqda/2vW4xHeA6+H+eRY6o0bP5HvCGpEg4H6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=gX8Satxm; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="gX8Satxm"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-718e65590easo538193b3a.3
        for <linux-raid@vger.kernel.org>; Wed, 18 Sep 2024 08:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1726674017; x=1727278817; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C9yBwKTxpa2/vNRxD5b9EnlhzEMuTnwtN83hsqQqaRM=;
        b=gX8SatxmEF1n+IqwKKNc4IvzgXgfWuYd32r3dNoWn/bUazKLcsdP+fpXFZj6QcAllD
         9x7GsRgwT3bspt+oAxu0NxIAL2+m1QbvV4TuEjIR41ROv6bFfn5p5waaRA+JDCfTFOv9
         2c3Lv31GUH3qzikBMUNzD96gt+hEUgh7eeWvmJ5MBdEeRv9VlDnliTJyxTkqsW7BIDaG
         nB6Vjm38HecLVVfzyOpKEtJ8GPBvR1OEyAyb5+SyPNUdhfDgkFeqMgRK997LyjjlRJF6
         aYSwBjUNBIjbVf+h/DUYeyTbWzS7Y0sYl+Cq9RjhjWbKoAdRSlxTvH7XdL9WV2ucogig
         Mo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726674017; x=1727278817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9yBwKTxpa2/vNRxD5b9EnlhzEMuTnwtN83hsqQqaRM=;
        b=wJDOCkCshbUpIHJFq4g1B9knpHU+j08PGZajtpCurWLnLSa8tW9Acpt6yoCYBmgGwd
         hbVjDMt1ZVuVJ3kL0/YikQJ6Yicz41oTA4PvxuApfzCOpGng+0wGV5NV2CXws5eYF7yz
         KNtKcgFfJ06ykLhol1rv+vFo4JzZOF9eleHPTtc3frR+yMOffuxmb1lQoxn4oEWjo5tT
         vxX4XKuwmetEzyKNXGVwjqBgtxDn8X33OPRd39S4QLU6770d5NfDU36FmJmYdU3+9y6H
         lFvodR4DuSEqXRvYRrygOd4ucuhmq30q3U8QHt6Xm9dzxYuX3yaQfHPZQ2bJet3L737e
         HKBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBb+qpONgUukGlG50DHM+3twZJ1DYs6NaioEn3UoqvaodYzIcWpKzBPq8dzlXwkMigaSyWZVsMDda+@vger.kernel.org
X-Gm-Message-State: AOJu0YzBKkgYfIA6Dfzhpc++qxUV/l77tSyd/JAv3STAoxkmFrUru7s6
	fqnsRxNQTwsgwJ+WN37UOKSmKqiHB8xY/pM95s7J65EwYVIZlkNpghRrxaK81qGfej0zRI0amp6
	Gvurb1xZ13fclICoLo/nC2CY7fIk=
X-Google-Smtp-Source: AGHT+IFY6XfMICrpasQkG/EckJR+hqHc0Lu0UiY07zwiDtufTVjHbOzy0vfSrS/H5k1+D5xwQDq2hfr3Pve5h0dnWEg=
X-Received: by 2002:a05:6a20:a122:b0:1cf:4dae:224e with SMTP id
 adf61e73a8af0-1cf75ead50fmr16516113637.1.1726674016736; Wed, 18 Sep 2024
 08:40:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com> <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
In-Reply-To: <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Wed, 18 Sep 2024 17:40:05 +0200
Message-ID: <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: William Morgan <therealbrewer@gmail.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

> I tried to mount as read-only and got the following error:
>
> bill@bill-desk:~$ sudo mount -o ro /dev/md127 /media/bill/ARRAY3
> mount: /media/bill/ARRAY3: wrong fs type, bad option, bad superblock
> on /dev/md127, missing codepage or helper program, or other error.

What do you get when you do blkid /dev/md127


> I have noticed a lot of this type of stuff in dmesg, repeating every 5
> minutes or so:
>
> [ 1212.352770] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
> through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 1212.353063] sd 3:0:4:0: [sde] tag#3885 CDB: ATA command pass
> through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 1212.353077] mpt2sas_cm0:     sas_address(0x4433221104000000), phy(4)
> [ 1212.353084] mpt2sas_cm0: enclosure logical id(0x500062b200d564c0), slot(4)
> [ 1212.353090] mpt2sas_cm0:     handle(0x0015),
> ioc_status(success)(0x0000), smid(3886)
> [ 1212.353096] mpt2sas_cm0:     request_len(0), underflow(0), resid(0)
> [ 1212.353101] mpt2sas_cm0:     tag(0), transfer_count(0),
> sc->result(0x00000002)
> [ 1212.353105] mpt2sas_cm0:     scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [ 1212.353110] mpt2sas_cm0:     [sense_key,asc,ascq]:
> [0x01,0x00,0x1d], count(22)
> [ 1212.353248] sd 3:0:9:0: [sdj] tag#3886 CDB: ATA command pass

ATA command pass through is usually from smart monitoring tools but
this looks more like drive resets. Cables maybe?
