Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144483B7A8
	for <linux-raid@vger.kernel.org>; Wed,  9 Jul 2025 06:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043461; cv=none; b=iX9HTEAOTuKugxjt5JOsWgMUy8pQ/ljf3yrAL7py9pnu0rAMRVrM0gWVfXhHc3xM1W7YMoFdzlknAd1bRAG2pyakRoepKNNR4JhMZaCeXbxKPehfTjrl0SFi1xw4utbNRDRgucG+5l+h4/W/JYc7wbHntBzkUPYM8063tp7LZVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043461; c=relaxed/simple;
	bh=7YJMfEMWtnbEm+hnMOaB6MRDauQ4SESLJ43JId9VeTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oG/tLQvDlIwIw7lXAMhWFFv7OS7rPJmOe02idc0oQS+uwUZQLv8mpzlyyUJNo2n8DP7MOs7dY06BznI2VQcPNpcdTzHDOFmV2sYvxsSYUuswtb6/kpKDbMoIbFN0J+7Gdf5X+p7tvV41OfKfACJu5a0DLgc7jlaM8M4YVCt1yJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RT03va88; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RT03va88"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ae0b2ead33cso112111266b.0
        for <linux-raid@vger.kernel.org>; Tue, 08 Jul 2025 23:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752043458; x=1752648258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfR9Qscn7adSqg4nWq4c8PNGYjN+OsevQKsZiTgdGck=;
        b=RT03va88i+464KHmpInhLcCVPj3AdBlTvhsBl8nkhEclQx1CMaKGy3pHpT1eBLSxcZ
         kyVPxPIWuM8pJwghHtaXpkBreBi4KNH701mjL9d3CqdfxCfO1ohzzbGlfeO25M4pr3jF
         phJY1e2/MaXpbdl7JB4JjpTpA4fRMzAhLqpjluYHaaok8Clf9zvXHI5VblAjZpOgGaMI
         wG2Tdf0yYgKeabc0SkjX3PVn5s6p9ldrAMVdnP6dSsYPNBcYFjTk+e9vhDKXiHQERtVx
         UY1eWSVDcQ0PNoZyOUKd8ar78bKTXCgdzx6KClV0ZuNfj08dEovV/xhc/q5XnQt57bzR
         Ypcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752043458; x=1752648258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfR9Qscn7adSqg4nWq4c8PNGYjN+OsevQKsZiTgdGck=;
        b=KOZ66aAarNHW4ATCr+AZBkxx1TZV1KJk3UMP41gkQviy9fHVXW5sAvNpOFh3+vKWoA
         fA4N9twZ5mZooCQbLpayjJ2aU8Ngbxoq2YzPDUYZXxU21/+dIx/YVNaF8t38zcfnoKKg
         EWf8i2hK4o48oHNs/tV+4Fi7alQwd8JnzKBJjstKaQa3gtjokhwv8udTrOP/rvJzq5Er
         rYdIAT32ndLsbCEjrDNuUqBR4C+U+A2MwdETLr/lBLSWh8TE/h1wa/bB2zvtRyI81lYb
         A9QLCTYoQMrI8JgDnqHK0RKmj5vo0C109Rb5czzfyinQM4ELqOP+6eRAky/2HuZdYSf3
         D+/w==
X-Forwarded-Encrypted: i=1; AJvYcCWO0i/Vpqy7lNy/v6SBxpKzuJjt7LphxHjiKGF9egq2HEeE36+EX0J2Z5OYxnXF+c0ZTRuDKYzskNIZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyE1R78+8NzZBEjuGC9qkAZkIc78nYvleEF3jSnmeQo/4ZRLwIl
	Si1yYxsSU0Epe8cbnpQ0ePr/+HC96mcT2FDTEGk3NaYsxBkg834U22prmrTI+LWVdE30JJW/2qM
	Op1KnDDE99A/ilwUp7w86YM6gbWc1a1Y=
X-Gm-Gg: ASbGncvrdC3s22iP5qKFjaxo2RuGAkzIkSOG+Zsx0HJAthyUM8V0bYEcY0QnVlGHphe
	vc88vJ36yhUnp1vkfZhC3uE6IPsEcmSpdXvFgf1n5HXi2ZdaVqBXBEgvFQ6Lx2qjyLxBt/hQ8ZE
	41q/FBbRjRHRSZzxsFeTdrRiM0HUzEQKndEZR+q9cqRWEU7Heu
X-Google-Smtp-Source: AGHT+IHSW0bQBeCUw1tGFy9MUlQV9xdyIxe5DZvfMoOENg1cm7LIkvTNbU7kZ4xOPM7oZxvH+iEqDqd48rkXsr2OL9o=
X-Received: by 2002:a17:906:3114:b0:ae0:a464:99d with SMTP id
 a640c23a62f3a-ae6b26f9190mr519879266b.17.1752043457980; Tue, 08 Jul 2025
 23:44:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707165202.11073-1-yukuai@kernel.org> <20250707165202.11073-7-yukuai@kernel.org>
 <4ef10fad-03cf-4fc3-90c4-13fd31dd19c0@suse.de> <CAHW3DrjVM-yb-U==ZfR3k9ZS7qSpqY4ASch7qqhP2zquTdSS2w@mail.gmail.com>
 <9cc88458-5162-42e0-97ab-07ef0c529061@suse.de>
In-Reply-To: <9cc88458-5162-42e0-97ab-07ef0c529061@suse.de>
From: =?UTF-8?B?5L2Z5b+r?= <yukuai1994@gmail.com>
Date: Wed, 9 Jul 2025 14:44:05 +0800
X-Gm-Features: Ac12FXysqJ3McuwfWcaa78mzI0szYQTxgymjYpgdeo1lWubyoiLeFfNazJIEhUU
Message-ID: <CAHW3DrhO0gikFu4Hv6fTAp-xL8jZs5VVikw==w7Msjj7x376ug@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Hannes Reinecke <hare@suse.de>
Cc: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk, 
	linux-raid@vger.kernel.org, song@kernel.org, yukuai3@huawei.com, 
	yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2025/7/8 19:57, Hannes Reinecke =E5=86=99=E9=81=93:
> On 7/8/25 13:31, =E4=BD=99=E5=BF=AB wrote:
>> Hi,
>>
>> Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>> =E4=BA=8E2025=E5=B9=
=B47=E6=9C=888=E6=97=A5=E5=91=A8=E4=BA=8C
>> 14:29=E5=86=99=E9=81=93=EF=BC=9A
>>
>>      > +     if (mddev->bitmap_ops->group && !mddev_is_dm(mddev)) {
>>      > +             if (sysfs_create_group(&mddev->kobj, mddev-
>>      >bitmap_ops->group))
>>      > +                     pr_warn("md: cannot register extra bitmap
>>     attributes for %s\n",
>>      > +                             mdname(mddev));
>>      > +             else
>>      > +  kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
>>      > +     }
>>      >       return true;
>>      >
>>      >   err:
>>
>>     Ouch. This will cause havoc with the udev rules.
>>     Having different events for 'add' and 'change' tends to confuse udev
>>     rules (most treat 'add' and 'change' identically), so at the very
>> least
>>     you would need to document this.
>>
>>
>> Do you mean document here as new sysfs entries are created under mddev
>> kobject?
>>
> No, I meant to document that 'add' events will have access to
> different sysfs attributes than the 'change' events.
> In the running system one will only see the final status, so it's not
> immediately obvious that some attributes are only valid for 'change',
> and not for 'add'.

Thanks for the explanation, just to make sure you mean:

diff --git a/Documentation/admin-guide/md.rst
b/Documentation/admin-guide/md.rst
index 2030772075b5..db7a39894c8d 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -388,6 +388,9 @@ All md devices contain:
       bitmap
           The default internal bitmap

+If bitmap_type is not none, then additional bitmap attributes will be
created
+after md device KOBJ_CHANGE event.
+
  If bitmap_type is bitmap, then the md device will also contain:

    bitmap/location
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 22378686a964..60e2de23c9b5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -699,6 +699,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
                         pr_warn("md: cannot register extra bitmap
attributes for %s\n",
                                 mdname(mddev));
                 else
+                       /* Inform user with KOBJ_CHANGE about new bitmap
attributes. */
                         kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
         }
         return true;

>
> Cheers,
>
> Hannes
