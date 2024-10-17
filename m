Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131B1DA0E9
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729167794; cv=none; b=ifdw6jBBmRx1AsGAtEfDwjI/mKiq5q1ewfI+KohHM2JRfPxAEE7XtEGKkanVVCHogIyMtaJ5mDb9r4qixD7MIICQGEhAG+pAxibzhH4LYlIq6u9p3Oda6f07g7skccsiLjZKPoyK+e0Ep2Oa5RTgM1iyGTExS4Ds7AK30C17Jsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729167794; c=relaxed/simple;
	bh=ad7GNnt6beaImYn64R0/jJYZGyBWIRhrOKleGyRwgBo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mSXomLQtpHjstbtmJFNXeS2DPuiP07q0Kwo5nQscLiWZpZWJBVR/qf5/hhuXPPoIdqZ6jerRylmAkylFCcgl5HqW6qqUMUWOKpgerEVFcK9JPOY7KVaSesBxujA7sideRdlPgY4XgKAmIqi/MubPReSOnNnqaeXXYygAQKOvyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XW0ow/IS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XW0ow/IS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729167791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ad7GNnt6beaImYn64R0/jJYZGyBWIRhrOKleGyRwgBo=;
	b=XW0ow/ISS/SIX8Obo6Gknda2qth/hLUX2acq4kCWNMk0VXhxQGEQtw/ocK5pMkIx7QHKbH
	Fex1QrAb3/JmIrJgdSq/qCdfxHKiYbDCZxQz4O+2fJ+cI1JteGUARXE9fCN0Khndc4Re0o
	hTjLUhcm6JHv48GurZZycz46up4HJzE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-b7hMLP_9OUSvtVcqZaLGnQ-1; Thu, 17 Oct 2024 08:23:10 -0400
X-MC-Unique: b7hMLP_9OUSvtVcqZaLGnQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4605b68dc92so14230561cf.3
        for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 05:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729167789; x=1729772589;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ad7GNnt6beaImYn64R0/jJYZGyBWIRhrOKleGyRwgBo=;
        b=aMZuiFLpmYnwcD2EWyIsNM2jUxy449bOW//nnqXfjkWYVFyAcjfXMQdDkRaaVNqaZX
         Zuy4Jv207orYuG7PoMmg7jjfSOnSApiv1X4R1KU0ITPptaKdVylNF7nXyrquxUtX9yu8
         Ox+qZkk3wqPgNJERnmWtPNemtqejG7Kes2IKZWPxnofyIoUBusfhCSB88pXbTuVTUIOV
         FNR+SYfqyj4xLhm0SpnffMlSB+4MrSI7pNVUFGfbmZ7xV5lUWRNkIecdIgzeGEmOhyx1
         X0Ttmme1r+/qGuxOMh3ihQd0f7Nwbi1YfRuDEdN0DrBDYDAcEgiTWy59MiN+9f28zysi
         OZGA==
X-Forwarded-Encrypted: i=1; AJvYcCUuTSWkme/JrwDwsLPr0pASxWnVKucGQjOAnBzlU+KigHEY48kwbGzNt+vYQ6Bp1YVeRmuvNbcm7TF5@vger.kernel.org
X-Gm-Message-State: AOJu0YxlNZ5xL6CgxtRxPMkMJwWIMvvYqUUj7qMQZmzk2ZkjaXTaLxpo
	pwS/kHm7QkiPWVLymhw7eSXKpwRj7eplLzY/S7QqrmyBpERPGEx1NTxclOIHwUzsKcb0/xY2Avx
	TJaVKr0/a487R89iuQvWCXgbdcDMmBuyL5uLur8SuZEMUNdUCEIj6xcmJGl+Z05L/KLM=
X-Received: by 2002:a05:622a:22a9:b0:460:9a7c:8dd0 with SMTP id d75a77b69052e-4609a7c8f23mr39159711cf.55.1729167788753;
        Thu, 17 Oct 2024 05:23:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQqHqKKR8kTPb3crqY5WXaDvV2RSqO/TczrbpIf6jtblvtxTPDrhoIysCCPzXrJSAaS3FJsg==
X-Received: by 2002:a05:622a:22a9:b0:460:9a7c:8dd0 with SMTP id d75a77b69052e-4609a7c8f23mr39159531cf.55.1729167788439;
        Thu, 17 Oct 2024 05:23:08 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4607b0e207esm26981801cf.34.2024.10.17.05.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:23:07 -0700 (PDT)
Message-ID: <5a53110cad3519de3990cbe4eb67acee72f9238b.camel@redhat.com>
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
From: Laurence Oberman <loberman@redhat.com>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Xiao Ni
 <xni@redhat.com>
Cc: "Hellwig, Christoph" <hch@infradead.org>, linux-raid@vger.kernel.org
Date: Thu, 17 Oct 2024 08:23:07 -0400
In-Reply-To: <20241017132631.00004d46@linux.intel.com>
References: <20241015173553.276546-1-loberman@redhat.com>
	 <20241016101433.00005bb9@linux.intel.com>
	 <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
	 <CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
	 <20241017132631.00004d46@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-10-17 at 13:26 +0200, Mariusz Tkaczyk wrote:
> On Thu, 17 Oct 2024 17:24:59 +0800
> Xiao Ni <xni@redhat.com> wrote:
>=20
> > On Wed, Oct 16, 2024 at 9:11=E2=80=AFPM Laurence Oberman
> > <loberman@redhat.com> wrote:
> > >=20
> > > On Wed, 2024-10-16 at 10:14 +0200, Mariusz Tkaczyk wrote:=C2=A0=20
> > > > On Tue, 15 Oct 2024 13:35:24 -0400
> > > > Laurence Oberman <loberman@redhat.com> wrote:
> > > >=20
> > > > Hello Laurence,
> > > > Thanks for the patch.
> > > >=20
> > > > ":" is used internally by native metadata name, we have
> > > > "hostname:name". We are
> > > > searching for it specifically, for that reason I think that I
> > > > cannot
> > > > accept it.
> > > > Name must stay simple.
> > > >=20
> > > > If you want this again, I need to full set of mdadm tests that
> > > > is
> > > > covering every
> > > > scenario and is confirming that we are able to determine
> > > > hostname (if
> > > > exists)
> > > > and name in every case correctly.
> > > >=20
> > > > There are some workaround in code for that, I can see that we
> > > > are not
> > > > appending
> > > > homehost if ":" is in the name. It is not user friendly. I
> > > > prefer to
> > > > not
> > > > allow ":" to keep in simpler unless you have really good reason
> > > > to
> > > > have it back
> > > > - there is no reason in commit message.
> > > >=20
> > > > =C2=A0
> > > > > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > > > > ---
> > > > > =C2=A0lib.c | 2 +-
> > > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/lib.c b/lib.c
> > > > > index f36ae03a..cb4b6a0f 100644
> > > > > --- a/lib.c
> > > > > +++ b/lib.c
> > > > > @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const char
> > > > > *
> > > > > const name)
> > > > > =C2=A0{
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(name);
> > > > >=20
> > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char allowed_symbols[] =3D =
"-_.";
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char allowed_symbols[] =3D =
"-_.:";=C2=A0=20
> > > >=20
> > > > Because the function has been made to follow POSIX, this cannot
> > > > be
> > > > simply added
> > > > here. Please at least explain that in description.
> > > >=20
> > > > It is not POSIX compatible with this change.
> > > >=20
> > > > =C2=A0
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const char *n =3D name=
;
> > > > >=20
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!is_string_lq(name=
, NAME_MAX))=C2=A0=20
> > > >=20
> > > > Thanks,
> > > > Mariusz
> > > > =C2=A0
> > >=20
> > > Hello
> > > Apologies Christoph and Mariusz, this could have definitely done
> > > with
> > > more of an explanation.
> > >=20
> > > We have customers complaining about a regression in mdadm since
> > > these
> > > changes happened. They have 1000's of raid devices that can no
> > > longer
> > > be started because they have ":" in the name. Example
> > > mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not
> > > POSIX
> > > compatible.
> > >=20
> > > Should we add a --legacy flag where the original behavior is
> > > still an
> > > option, what are your thoughts ?
> > >=20
> > > Regards
> > > Laurence
> > >=20
> > > =C2=A0
> >=20
> > Hi Laurence and Mariusz
> >=20
> > Can we allow assemble an array whose devname has ":"? So the users
> > can
> > assemble the arrays which were created before patch e2eb503bd797
> > (mdadm: Follow POSIX Portable Character Set).
> >=20
> > For creating an array, we can still follow the POSIX policy. So it
> > can
> > keep the naming rule simpler.
> >=20
>=20
> Thanks Xiao,
>=20
> Please give me some time to reproduce and understand this case. I
> will find some
> time on monday, maybe tomorrow.
>=20
> I hope that works for you guys.
>=20
> Mariusz
>=20

Hello

Yes, Thank you, if we can have the option to start already created
arrays but make customers aware of the POSIX limitation in creating new
arrays that would be fine with me.

Regards
Laurence

