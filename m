Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF701DE2A4
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729178854; cv=none; b=NtY5xR47ttj4SaU3STX9tIMaEka1CCPIap0d+gvqdDEiAZLJm6oc8JcJI874l4W39UQfhx5Fxlhp0LelhclhsMxkiHy36kPfMGeRjWJprdqBr6GGGuUj5xVPCSBj6f+At1NuuIdo/LKjLIzED+Lf6zriqiGeQhM/gNQLcGkee+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729178854; c=relaxed/simple;
	bh=zGSYih0Y0CEe+E41cqaq0JVOuHQL+Zlp2oENY+blb+M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HKn96T6W/5qyTSV+fr1yqcZz6TC0y7LyUT4YpErCl58gsLJ4U8UwcJUIZOOhIww85rKwFypBv26ej1ety9tizEI7QMpIZfkp/+PJHekJGf5D7eFYkl2sMulF4fKy04vA/Sma7VkLymY4THdVznfcisnut7YcPoTUrLRNT106fIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X5xmi2XZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X5xmi2XZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729178851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGSYih0Y0CEe+E41cqaq0JVOuHQL+Zlp2oENY+blb+M=;
	b=X5xmi2XZyOY1r02x0SIYm8ZQvr8ztYji+TU8nRw0l5bt5o1BlnC9f4YOL4alej9v5Tz9tO
	Ha48a5cQSWFXihcPKZxac1Flo8DdK2Zfgkj62rKLxw4MDgbUD79UajJP5QePB6nz0ws1E0
	4pSzCqgux2Fy4h86wi5QmqZBu1PF1Zc=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-inLPJdMTMYGrHiS71k8MaA-1; Thu, 17 Oct 2024 11:27:28 -0400
X-MC-Unique: inLPJdMTMYGrHiS71k8MaA-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e24a31ad88aso1408441276.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 08:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729178847; x=1729783647;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGSYih0Y0CEe+E41cqaq0JVOuHQL+Zlp2oENY+blb+M=;
        b=KIGB6RODz/nsPBY5kTqSmagiw7NPAIzTiYNxaZ3vHdrgxu3ivuMf7ykK2mE1Yb0I1u
         3WZjbGRT4200BIkRhHs6dbl3X4lPMP33cWUoMdvbGd6F8f/bqVT94x4rJFro3il6jVc/
         3AnZ/c/KgQoYBPbQPWBjdsaugYaYMXRt7kKqIOLby5krUrGNzSkh/86/vGg26Q7/r5Ns
         PdPUPUfi+5h9KRoBoXn9r83xtTk3oaxp1PRqQE4GeOsQGp59DDPc8AdgB+4BsrQeDOWZ
         KrcPItEIasxMfL08xe+EiKgJe04kUJlKXzpR1kFgmASKlooYOkoKDO/ZkW4aukxc09QO
         bxrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW6OnhqWSabkrJGZ0ZKANgLA6eSR4RUvPkATKdL8Lu5b49/sPIZLP9DXcUBHxVjUX7cK0SglOW3uTE@vger.kernel.org
X-Gm-Message-State: AOJu0YwctcKE38/0yOIA1W7CxUgwaO0Ez9kckax9eTatgFm9tFU5rBNk
	boNNHBj76wHoKODPtWlq6V1GlBus/1w64CAGPMx7CdTSQUlRgEX2FlyqwDq1rP4Q24/clRqq89C
	b9KuGJyXKM63sqdXuerj51cITnq15Hq11x1JFJeptokgJdXWQcHJ0gioBrCM=
X-Received: by 2002:a05:6902:240e:b0:e28:f12f:73d8 with SMTP id 3f1490d57ef6-e2931b328femr14811474276.13.1729178847075;
        Thu, 17 Oct 2024 08:27:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhb1Aiwu82E40gicjx+g9iroH04dbwvczGpc+po/cJ3rU6j1MqdJO2Kgl3Jy+TrWa+c20CFQ==
X-Received: by 2002:a05:6902:240e:b0:e28:f12f:73d8 with SMTP id 3f1490d57ef6-e2931b328femr14811457276.13.1729178846725;
        Thu, 17 Oct 2024 08:27:26 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4607b37ba5fsm28568361cf.78.2024.10.17.08.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 08:27:25 -0700 (PDT)
Message-ID: <49af106759fc1ec3da109c166c4c09e7251bf9e8.camel@redhat.com>
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with
 the latest POSIX changes
From: Laurence Oberman <loberman@redhat.com>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Xiao Ni
 <xni@redhat.com>
Cc: "Hellwig, Christoph" <hch@infradead.org>, linux-raid@vger.kernel.org
Date: Thu, 17 Oct 2024 11:27:24 -0400
In-Reply-To: <5a53110cad3519de3990cbe4eb67acee72f9238b.camel@redhat.com>
References: <20241015173553.276546-1-loberman@redhat.com>
	 <20241016101433.00005bb9@linux.intel.com>
	 <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
	 <CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
	 <20241017132631.00004d46@linux.intel.com>
	 <5a53110cad3519de3990cbe4eb67acee72f9238b.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-10-17 at 08:23 -0400, Laurence Oberman wrote:
> On Thu, 2024-10-17 at 13:26 +0200, Mariusz Tkaczyk wrote:
> > On Thu, 17 Oct 2024 17:24:59 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >=20
> > > On Wed, Oct 16, 2024 at 9:11=E2=80=AFPM Laurence Oberman
> > > <loberman@redhat.com> wrote:
> > > >=20
> > > > On Wed, 2024-10-16 at 10:14 +0200, Mariusz Tkaczyk wrote:=C2=A0=20
> > > > > On Tue, 15 Oct 2024 13:35:24 -0400
> > > > > Laurence Oberman <loberman@redhat.com> wrote:
> > > > >=20
> > > > > Hello Laurence,
> > > > > Thanks for the patch.
> > > > >=20
> > > > > ":" is used internally by native metadata name, we have
> > > > > "hostname:name". We are
> > > > > searching for it specifically, for that reason I think that I
> > > > > cannot
> > > > > accept it.
> > > > > Name must stay simple.
> > > > >=20
> > > > > If you want this again, I need to full set of mdadm tests
> > > > > that
> > > > > is
> > > > > covering every
> > > > > scenario and is confirming that we are able to determine
> > > > > hostname (if
> > > > > exists)
> > > > > and name in every case correctly.
> > > > >=20
> > > > > There are some workaround in code for that, I can see that we
> > > > > are not
> > > > > appending
> > > > > homehost if ":" is in the name. It is not user friendly. I
> > > > > prefer to
> > > > > not
> > > > > allow ":" to keep in simpler unless you have really good
> > > > > reason
> > > > > to
> > > > > have it back
> > > > > - there is no reason in commit message.
> > > > >=20
> > > > > =C2=A0
> > > > > > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > > > > > ---
> > > > > > =C2=A0lib.c | 2 +-
> > > > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >=20
> > > > > > diff --git a/lib.c b/lib.c
> > > > > > index f36ae03a..cb4b6a0f 100644
> > > > > > --- a/lib.c
> > > > > > +++ b/lib.c
> > > > > > @@ -485,7 +485,7 @@ bool is_name_posix_compatible(const
> > > > > > char
> > > > > > *
> > > > > > const name)
> > > > > > =C2=A0{
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 assert(name);
> > > > > >=20
> > > > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char allowed_symbols[] =
=3D "-_.";
> > > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char allowed_symbols[] =
=3D "-_.:";=C2=A0=20
> > > > >=20
> > > > > Because the function has been made to follow POSIX, this
> > > > > cannot
> > > > > be
> > > > > simply added
> > > > > here. Please at least explain that in description.
> > > > >=20
> > > > > It is not POSIX compatible with this change.
> > > > >=20
> > > > > =C2=A0
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const char *n =3D na=
me;
> > > > > >=20
> > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!is_string_lq(na=
me, NAME_MAX))=C2=A0=20
> > > > >=20
> > > > > Thanks,
> > > > > Mariusz
> > > > > =C2=A0
> > > >=20
> > > > Hello
> > > > Apologies Christoph and Mariusz, this could have definitely
> > > > done
> > > > with
> > > > more of an explanation.
> > > >=20
> > > > We have customers complaining about a regression in mdadm since
> > > > these
> > > > changes happened. They have 1000's of raid devices that can no
> > > > longer
> > > > be started because they have ":" in the name. Example
> > > > mdadm: Value "tbz:pv1" cannot be set as devname. Reason: Not
> > > > POSIX
> > > > compatible.
> > > >=20
> > > > Should we add a --legacy flag where the original behavior is
> > > > still an
> > > > option, what are your thoughts ?
> > > >=20
> > > > Regards
> > > > Laurence
> > > >=20
> > > > =C2=A0
> > >=20
> > > Hi Laurence and Mariusz
> > >=20
> > > Can we allow assemble an array whose devname has ":"? So the
> > > users
> > > can
> > > assemble the arrays which were created before patch e2eb503bd797
> > > (mdadm: Follow POSIX Portable Character Set).
> > >=20
> > > For creating an array, we can still follow the POSIX policy. So
> > > it
> > > can
> > > keep the naming rule simpler.
> > >=20
> >=20
> > Thanks Xiao,
> >=20
> > Please give me some time to reproduce and understand this case. I
> > will find some
> > time on monday, maybe tomorrow.
> >=20
> > I hope that works for you guys.
> >=20
> > Mariusz
> >=20
>=20
> Hello
>=20
> Yes, Thank you, if we can have the option to start already created
> arrays but make customers aware of the POSIX limitation in creating
> new
> arrays that would be fine with me.
>=20
> Regards
> Laurence
>=20
Hello Mariusz and Xiao

I re-ran all the tests in house and I can actually start the arrays
that have the ":" in the names, just not create new ones. So I think we
leave this as is and we keep the adherence to POSIX for newly created
arrays only.=20

My patch or request for a change for creation can be denied, its fine.

Regards
Laurence

