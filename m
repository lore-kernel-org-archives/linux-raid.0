Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A9A923
	for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 03:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751253930; cv=none; b=RBCx1Y7O0e6ITTyc8n/zJ1TIODeSEwKuozQRdwIYS32No6tXBE46cEWYdwstiWRPCeJ04EV7erBAt3aM3/IH3F9prjbbglrfrutREpLLMi5Y9uduvVKTHN1G1RA8NLIMxlaw0ZD+XlyDuQW7PTDz14+p7Yq1wD87+ZU8SjLf+PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751253930; c=relaxed/simple;
	bh=LV1RbfJMboY121pq/OVMD9JfCIwBjXF7y439XzrIWzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzx1Bv36ung0O6CRpd2nyPxmFelHvfw0q6qQEvzXiKS02YZ0qKrhyqruLN+BggT//w+msm2MruRcWSJdNZ8Zf2Q2sWF9BcbV8O+oWm5f7fACsA/MQ5b4kmaSPUZjDtbRVvwpYQ0jZBpFr6eVt10J0p6p6W2SbOMZdeh2QH79JjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C2Bz+pga; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C2Bz+pga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751253927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AdAJraI8U0XhGTjVP+sopEbvVySi3zH6N4wromX92ys=;
	b=C2Bz+pgayz4EfMArg7Q9RyciJtlmcaGjW+2lkkzz50XkxADAFjJhl2enCGmhrB3uXU+fu1
	HYYHM27Tl27suhuMBUuuG2ggAEH5S18eaznPjak7waMhlBnVNjOz4s6KkCcBrkGByyTRWw
	brMUSmYP0ybOk6LBVGqePeHKxmfCY6A=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-fOhrRwtxPO-b5YoEo1fABw-1; Sun, 29 Jun 2025 23:25:26 -0400
X-MC-Unique: fOhrRwtxPO-b5YoEo1fABw-1
X-Mimecast-MFC-AGG-ID: fOhrRwtxPO-b5YoEo1fABw_1751253925
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-553522f65a8so799976e87.1
        for <linux-raid@vger.kernel.org>; Sun, 29 Jun 2025 20:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751253925; x=1751858725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AdAJraI8U0XhGTjVP+sopEbvVySi3zH6N4wromX92ys=;
        b=DJJRlfGfbOFeqoWVkl2uCg6dqKmzDvqe8GXcLFoHH2Vjmlvi9hEykFgurB7ld5OYzd
         353JddctPY9pnn4cqi90EcWvTxpnXv4Q96ErmfPY13wVPAFvS7yoT/cf+QWIgLkQsb5J
         o83rk3VqAtUjst68ENsxpc0k9I57ZBmwmwQWDy4DOqXYaPXAA9SYFWetqlnwPrCnF2vz
         dsWW+6dRMc/dx9xj/l/d8iDLbJsxYHp/FzNSXznPqP3gPrfKu3Ak9kMHKsrQVJuanuzt
         gyapgYrNTEV/y3Kle4/kNlrWFy+ADcfzQuB92/uOYx7drm7C2943GlGpIxmz8k7z0Zwy
         dVaA==
X-Forwarded-Encrypted: i=1; AJvYcCV6FElD5nyrRIM1hz5IQPiZsLXsJmyMa0jIKKfao+lXIIe+jKuMowRCv4Txjmw7uwobg3jddGuoodx0@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc/U8zArwvDkEi/J740nbcI2S57CtNLoNym6fqUabvWqY/eM2w
	o41P1hSUo15IjiVvG+hUDg4Pdhv2LrdkuQEXafhv0fq2jbsxIemRrwmHplwKrwmQDulaWyA1LNG
	BjZY1Iy7gDQemz4fTrVt2z4eKLDb8UPTDiW3dOjBaZ9yYL7bPgOmQ9Zs8UqAT+GKm5HeL5thYXl
	MXnG3EzKQidwDC7cIPtERQLJdgi6Oh+2uP+CPeUw==
X-Gm-Gg: ASbGncv5nw+r4381rADiy2IpyIl/NSS552IrhNqb3WmkJdZMxmbf25obhQIBEarfWqA
	bWr6NPt4nRq9kIHyn7M1oPLuvuqM0yByhSGOmdgjsAaDuUTZFK4NwCjYIJ2eI3HM1FY2p1VwOgb
	9SWBE6
X-Received: by 2002:a05:6512:4007:b0:553:5283:980f with SMTP id 2adb3069b0e04-5550ba29ed0mr4059524e87.51.1751253924557;
        Sun, 29 Jun 2025 20:25:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGyLLTQ+hUO0WJJg7JLMiyQj3myWZqAvEdNrAeYoZ9AFQ3o2tQ0Qa2acrnVn4SpO4MOI2jPSt7MbClt01/TxM=
X-Received: by 2002:a05:6512:4007:b0:553:5283:980f with SMTP id
 2adb3069b0e04-5550ba29ed0mr4059516e87.51.1751253924142; Sun, 29 Jun 2025
 20:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com> <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
In-Reply-To: <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Jun 2025 11:25:12 +0800
X-Gm-Features: Ac12FXy84WM0Pt-z6-03Ek6OEzyZO-QLHqRx9zGvHmE5_V1IAcfGF77I2Lcfu28
Message-ID: <CALTww28grnb=2tpJOG1o+rKG4rD7chjtV3Nmx9D1GJjQtVqWhA@mail.gmail.com>
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 10:34=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2025/06/30 9:59, Xiao Ni =E5=86=99=E9=81=93:
> >
> > After reading other patches, I want to check if I understand right.
> >
> > The first write sets the bitmap bit. The second write which hits the
> > same block (one sector, 512 bits) will call llbitmap_infect_dirty_bits
> > to set all other bits. Then the third write doesn't need to set bitmap
> > bits. If I'm right, the comments above should say only the first two
> > writes have additional overhead?
>
> Yes, for the same bit, it's twice; For different bit in the same block,
> it's third, by infect all bits in the block in the second.

For different bits in the same block, test_and_set_bit(bit,
pctl->dirty) should be true too, right? So it infects other bits when
second write hits the same block too.

[946761.035079] llbitmap_set_page_dirty:390 page[0] offset 2024, block 3
[946761.035430] llbitmap_state_machine:646 delay raid456 initial recovery
[946761.035802] llbitmap_state_machine:652 bit 1001 state from 0 to 3
[946761.036498] llbitmap_set_page_dirty:390 page[0] offset 2025, block 3
[946761.036856] llbitmap_set_page_dirty:403 call llbitmap_infect_dirty_bits

As the debug logs show, different bits in the same block, the second
write (offset 2025) infects other bits.

>
>   For Reload action, if the bitmap bit is
> > NeedSync, the changed status will be x. It can't trigger resync/recover=
y.
>
> This is not expected, see llbitmap_state_machine(), if old or new state
> is need_sync, it will trigger a resync.
>
> c =3D llbitmap_read(llbitmap, start);
> if (c =3D=3D BitNeedSync)
>   need_resync =3D true;
> -> for RELOAD case, need_resync is still set.
>
> state =3D state_machine[c][action];
> if (state =3D=3D BitNone)
>   continue

If bitmap bit is BitNeedSync,
state_machine[BitNeedSync][BitmapActionReload] returns BitNone, so if
(state =3D=3D BitNone) is true, it can't set MD_RECOVERY_NEEDED and it
can't start sync after assembling the array.

> if (state =3D=3D BitNeedSync)
>   need_resync =3D true;
>
> >
> > For example:
> >
> > cat /sys/block/md127/md/llbitmap/bits
> > unwritten 3480
> > clean 2
> > dirty 0
> > need sync 510
> >
> > It doesn't do resync after aseembling the array. Does it need to modify
> > the changed status from x to NeedSync?
>
> Can you explain in detail how to reporduce this? Aseembling in my VM is
> fine.

I added many debug logs, so the sync request runs slowly. The test I do:
mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=3Dlockless -x 1 /dev/loo=
p3
dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M count=3D1 seek=3D500 oflag=3Ddirect
mdadm --stop /dev/md0 (the sync thread finishes the region that two
bitmap bits represent, so you can see llbitmap/bits has 510 bits (need
sync))
mdadm -As

Regards
Xiao
>
> Thanks,
> Kuai
>
>

