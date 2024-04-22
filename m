Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D158414F9E1
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 13:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713792706; cv=none; b=aFBnC6QHspjd0j8bxYpvnftQqcCuX3M8Y2uXRDC12NaZmmD2sOfs1RWSByZIpZcVWDmVe0Tp0CwSkl86c873ezsiSV18iF3fK363pQBCm/rPhH4gPcvZ0SA0c+ZmuRaE2Gh64SOCsmbur3Fiu0Zsgfj0TYQGkf0RlPhKhHoaWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713792706; c=relaxed/simple;
	bh=Jds+NOm5z/wO58AVurSbq7kSM3fRisNyajH+3A55lfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gpJmFdFG8vnBEBUampQfoakTy7zBpziGRJGdM1c9GQwCCOvk6oFJmSC6G1rMmQNF+4Wmh1mn+OxONhmEfNfnRiiN5QFMrmfdomVbzC3LgHEHgeLJSK0rO/JzYgjnHBBx9SY4xnXRQcUR0RVpDNP5QiUoDjCIgjb/1hj9t4jt1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EwCzXBtD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EwCzXBtD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713792703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2HkK9i3B5rLuTEPjn/UEJouTXR3jafYt6vwlWq9V6SM=;
	b=EwCzXBtDcBrJbAezEkHb/4/8mllsk2meAZd3KeAqrx29UiQoR9yOFt51YC0XsfY7kqo7ca
	bxPeZdCi3ZwkqTklfWt25W5bC1va3UN/ctk4aYrmFSiHI0l1vvUxDSmOdQoI7GyUpIPTiV
	mJSKNQt5u17DDqBWlEI7rfCWcJ/yUO8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-odBxpGBwOCOVt9fZFSkMsg-1; Mon, 22 Apr 2024 09:31:42 -0400
X-MC-Unique: odBxpGBwOCOVt9fZFSkMsg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1e99fd7eadaso12394725ad.2
        for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 06:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713792700; x=1714397500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2HkK9i3B5rLuTEPjn/UEJouTXR3jafYt6vwlWq9V6SM=;
        b=N9loh2LNIr7CgsuL1D1kN8ayOhh1SmRY7rQb46nTpZ+pZ70ODff8Di4cNT8BNs7Orr
         W4EamDzvyZPZpx/1YN7y+hQeFFqhkTjW97Rzzsv43ovvc3iE8SBIIlHdAklS3YIfhN1a
         +QroAHQc8G3jF3G6qltiWRjNxte0bfdBfZ99kOy8mP7E7mA4Ycw/0KLAkMtnqDn8x2xv
         q6OISfXLzzBENmjYCEb9C5fayWwNPHwQLH4qVHmgCCSkoZY7w8SBYadWW7Q/GnX5O9Q3
         BXdVIKVF8dmyOPHN1ut7QWbi3gqUdIo1kRk16sH2z0SViS+1OGDlmyqscEG0jacgb7CX
         Y36w==
X-Gm-Message-State: AOJu0YzMUGcRoqIO1PVWcE21EwJCIeTda4zAZE/jOWiYTbwO6rKAyPaY
	wh05CKgVx/w/wjdTUOzv5AhN30sy0Kqz95orC5du4XSfeSiUo91GRZKKQaU6Pbsro7dQ+BkcwTc
	qOtoJKXkqNiRfo6+d0CMkOkPIogP+2amIaod0ebGF1k1ZaxU/7V3+RvngQOHcKaFfSPz7m5GuLf
	XcnXeBvDjJ5Afa9OsLtOBpmmcSm2C2SkBYkg==
X-Received: by 2002:a17:903:98c:b0:1e6:3494:6215 with SMTP id mb12-20020a170903098c00b001e634946215mr15248198plb.6.1713792700360;
        Mon, 22 Apr 2024 06:31:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkUHo49PslwbS6STzZnzpoJBf68b3jlUBc8jN/jMB6Azvkp4hXKseSN+XxmzjTX0SNLx1h9AGOwlcUZ92Z9UM=
X-Received: by 2002:a17:903:98c:b0:1e6:3494:6215 with SMTP id
 mb12-20020a170903098c00b001e634946215mr15248177plb.6.1713792700070; Mon, 22
 Apr 2024 06:31:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-3-xni@redhat.com>
 <20240419114702.0000694c@linux.intel.com> <CALTww28CNBYHrfScPgh9XCr932VeNw=WJFeXiqQM26XwE=DaKQ@mail.gmail.com>
 <20240422121518.00003ecb@linux.intel.com>
In-Reply-To: <20240422121518.00003ecb@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 22 Apr 2024 21:31:28 +0800
Message-ID: <CALTww29XqQEG8sMsa+5xHL+eUX=Vo98yuBgU6pn-t7VrzLEb9w@mail.gmail.com>
Subject: Re: [PATCH 2/5] tests/00createnames enhance
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org, 
	yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 6:15=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Mon, 22 Apr 2024 14:57:16 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > On Fri, Apr 19, 2024 at 5:47=E2=80=AFPM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > On Thu, 18 Apr 2024 18:23:18 +0800
> > > Xiao Ni <xni@redhat.com> wrote:
> > >
> > > > +     local is_super1=3D"$(mdadm -D --export $DEVNODE_NAME | grep
> > > > MD_METADATA=3D1.2)"
> > >
> > > You can also limit this test to super-1.2 it may depend on config, so=
 we can
> > > specify metadata directly in create command (if it is not specified).
> >
> > Could you explain more? I don't catch you here.
>
> Default metadata could be customized. At first glance, I thought
> that you added this because we metadata is not specified so I checked:
>         if [[ -z "$NAME" ]]; then
>                 mdadm -CR "$DEVNAME" -l0 -n 1 $dev0 --force
>         else
>                 mdadm -CR "$DEVNAME" --name=3D"$NAME" --metadata=3D1.2 -l=
0 -n 1
>         $dev0 --force
>         fi
>
>
> It seems that I forgot to add metadata specifier in first create command.=
 If
> you have different metadata than 1.2 you can add --metadata=3D1.2 and the=
n:
>
> > > > +     local is_super1=3D"$(mdadm -D --export $DEVNODE_NAME | grep
> > > > MD_METADATA=3D1.2)"
>
> won't be needed. Do I miss something?

Ah, yes, you are right. It doesn't need to check metadata.  I thought
there were other metadata possibilities. Thanks for pointing this
problem out :)

Best Regards
Xiao

>
> Thanks,
> Mariusz
>

