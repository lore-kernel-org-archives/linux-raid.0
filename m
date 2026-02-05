Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57EE239E97
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 02:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770257004; cv=pass; b=oCD/1HRljZsFnUjs4jKu0hnzEBXNOQAZ6IRT9y5snPvpa/cUxFpuSI/JRgvUO58Udjs3jcgE7IElAsEZVbropl4p3pq1D7xi09QbuRLB5E7RpA3TwraSe8g6toiWdlK7OkPIW8gOd7OcTv/LPG0OkNk/cyns7D5mmh6REwE/Qmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770257004; c=relaxed/simple;
	bh=oqkuP3S/fBiSB6W7Kojt/YvPvSIaxKuv9vw9xJPBlgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LDd/qgpEzLNORN9JvL5hx6+/DR0rmQyoBRRcgs40MqbscgFkz3qdeZqu/cyPcD6crSRj8NKT6GI55uJZs/VbOTHl68f0a6KZNlUHuT7sJsZwXW5XPt3wW9j21alT40oSeqa1Kguk4yrqLz23nkN9Ue4P30H3D4Eksj1Dyisf2/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aI82fmGB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=n+zKOIaK; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aI82fmGB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="n+zKOIaK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770257002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Ntwt7o4SDRzs3Mp4EXAHKP3r3QPmJhQKlqPeGoY2sY=;
	b=aI82fmGBI3LVbrURML95ITSslc77sOp5X4ltGTDPEIgxeYDygT3E+yQgZOOmBdpiAOKtuu
	EMb3S4zSN8rFHU5Vc+YJt1kWQRMwHhmKtJGP4NPOTVydHtxpWiPfA3AH5fiQYgYJbU481R
	PtlUJm83d28OFqu4EnpI2e+e8haLCL8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-JCYy5Z98OSq0d37HGUMiJg-1; Wed, 04 Feb 2026 21:03:21 -0500
X-MC-Unique: JCYy5Z98OSq0d37HGUMiJg-1
X-Mimecast-MFC-AGG-ID: JCYy5Z98OSq0d37HGUMiJg_1770257000
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-59b7e9f0af5so379662e87.2
        for <linux-raid@vger.kernel.org>; Wed, 04 Feb 2026 18:03:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770256999; cv=none;
        d=google.com; s=arc-20240605;
        b=RIW0ZXjyiY0N45q/1zxMg8lY0Zl8miJvuAu0jUCHri1H8UPJn75i5m9Aat/joVv4/F
         z3CHvw0keXjdHZBZWBSth42wiaM6JTrdAdObMXE3yb1K0aOoA9CRwT518vMuNzQTrLR8
         GSanrcBsoMxClzQk3HRFv3Jz/iYgxViPBFjGfTJLZdiA4XNr4y3FW3QLuLLg5CeJTkjt
         jr3ou3k7fsQavT0+6Vco21tiC39uBQr/+lGAKvvn1rfXsdXwT0zX1FxL1Oc1e+Den7Nl
         v1d1Su+XOIIq1W+gADuO5MzxE5Im54F8HsCLyJlZQ/JUhnXNOU4PinJ0jDOtAedpDGQo
         viTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+Ntwt7o4SDRzs3Mp4EXAHKP3r3QPmJhQKlqPeGoY2sY=;
        fh=Zr0Gmz5K2XVnY7DhlR+Mkq3b//E82H/QrSYkAntOeE0=;
        b=dc5Slg2N1kvqPr5JnyytrOusKV3F4IFkdtY235a40WJoWGIbn3Z6h1ceK6vs9v2lUv
         DWSlfAhmP3g+m3ZdoJtEkkVxJaq8yPOnZl3BCClGGlSaGhNxv74zpGD4864sPpGGFO/X
         QfRLFH3jveAXON2DbjKmARU+Os0/WvXm1sV3CqWGFetnTCLuhqEr5iShUSBmn+rnp+RP
         X5dtEZP7K81AwWAV0UaG5+H023fcMWOTgWgTf45JsjSc5bo0HkcaaeWFQq6yukWCES59
         6ejcnHoYSRAHKEhoLf2TgkrZR1/qvMBvWl3V0M0ptQLnNHwhfpSZkDWHuYKE/qjirzGW
         9sbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770256999; x=1770861799; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ntwt7o4SDRzs3Mp4EXAHKP3r3QPmJhQKlqPeGoY2sY=;
        b=n+zKOIaK0Ly/LcohmYv+QEamQB7DQ2xOScQu+Mt5o6BE5aPpqC4dZOMiD0jUPbpnuv
         cIkz52CgjGZnNgRIJTFWryeDtQSsj1OB2vNdHmD7L0Z15oQju8pswS4WsXJSrNYCqI7E
         T67wpoLiLe8UsoYtQZ+ZTKZxYaq8tOSYpHoI+xSqR/jEGDk+eIsg/Npo5uhkwSaPMNca
         K4Oumi+0xOvxvr9vF/8TEoXJJniQvPt5HLgjLT+yTC8Km/k+kwe8fq4hW94KQW09vt/s
         DtRe5U5F9hJsUWlYDGouDwSD8ad4A8bdouJhc0emxQm6MrgbptfKzzwD4lWPRbC56xAg
         1RiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770256999; x=1770861799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Ntwt7o4SDRzs3Mp4EXAHKP3r3QPmJhQKlqPeGoY2sY=;
        b=YoxgMJ839HbIMVueZGtNABCIfDeieLUFOJFV5UiZgqu6o1Oq88kYYS3xggUmtMuEzJ
         GlecinjyUUMBXLdrtEHsnNCzhdqHxT9FQ8dLIxrSkbyh1uN6ftIJNWLK7RZKB8D2hO80
         nU3OLqyfJUbK+kXspLmi0/MRNX7CyR7r0+KgVimW4pZNkjtca+XRsRuphTTzEolh1WoJ
         lg6GHbF1jUTyk76C7kz1pI6BBC3RO9FN7QhuW64nAWX1dzSjC7F3GuRXHlF3m1kSyeL0
         zk62vvGNfV9rtejGkPGkRCY38Q4HIblyBojXnumdyJ3QyWYrAvnpps1jJ0oNV5yaJVZk
         uxdQ==
X-Gm-Message-State: AOJu0YyQfMHqk26bvID+FV+H7Vx3Xc+NLTD/jtG9fDzEd7VmpIZ5jgro
	0I0jghSln5Q0qPOD9AXx0W0RmGzkBTm1I16uO2THxB9SQmk/EiNtvN9GuPmkVhk8Xb1Ny/73cJ/
	ZNczKlcyBrL2gxHwlMMJurdSEBskJELvfxKJm2Mjcw8x6yO3In+Lq+CBuhrLH+JPhFHfcQiqmGx
	V0Hd0zr8AF/PCFhsCRmU9c675+v+NSMFcK5LR2uT5SzEL97g==
X-Gm-Gg: AZuq6aKLq3kqkH0Y8k0uzkbNFC/Tv/b6H0Z59Wp77S0m5UoqyTT8ozkfTSgPJ6FjvHY
	Af1AI/zk6cdjlW76NAig3r6o9S1CZ6NAfhoZKl5i41EloW4JnhRoeGX7aVQQlm1GfIRqgybzXBA
	Q5mK+cFtgMdTe4AHxmJZ8g55cPrgkmaE+R37EMRV5XioCME6CaefdJ2Sjn8KrQJYtpVxbQ/q4Cm
	7z3AecfNr8Yd/8RQEFMBco3moq13aDJwTNBkzElYKyNfGJagEWgnp/xuzlWbOcfkQYVlg==
X-Received: by 2002:a05:6512:602:20b0:59e:399b:965e with SMTP id 2adb3069b0e04-59e399b9791mr1099176e87.21.1770256998964;
        Wed, 04 Feb 2026 18:03:18 -0800 (PST)
X-Received: by 2002:a05:6512:602:20b0:59e:399b:965e with SMTP id
 2adb3069b0e04-59e399b9791mr1099174e87.21.1770256998609; Wed, 04 Feb 2026
 18:03:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
 <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com>
 <CALTww2_e_49Cy=WLhtZVWWtMK+=v8dErCSvxK9qpB0vmybsGyw@mail.gmail.com> <9e56a1ae-05b3-48de-bead-386352e136ee@fnnas.com>
In-Reply-To: <9e56a1ae-05b3-48de-bead-386352e136ee@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 5 Feb 2026 10:03:07 +0800
X-Gm-Features: AZwV_QjWrAD9BM3b1HfaLT8cvvwNOghw0epAxqIVRgTYZ__l-LK0G7IkVGbjmj4
Message-ID: <CALTww2_gWS7VdqzHPtBxptLZv_YKiaJ+fPbNmntU+8OoBzFCmw@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 9:48=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/2/5 9:06, Xiao Ni =E5=86=99=E9=81=93:
> > And let me change to this:
> > Setup: RAID1 with one fast disk and one slow disk. Two requests R1 and
> > R2, each split into LO and HI parts
> >
> > Step 1-10: Request R1 Processing
> >    - R1-LO: writes to fast disk =E2=86=92 completes
> >    - R1-LO: writes to slow disk =E2=86=92 starts (slow)
> >    - R1-HI: incorrectly waits for R1-LO (wrong sector range check)
> >    - R1-HI: R1-LO finishes and wakes up serial_io_wait. R1-HI finally
> > writes to fast disk =E2=86=92 completes
>
> R1-hi should not wait for r1-lo, as they're not overlap. And as I said
> in the first reply, if here are still problem with WriteMostly case, plea=
se
> rebase and keep serialization for rdev.

Yes, it's a bug and patch03 fixes. I'll re-send patches based on
rdev-serialization.

>
> --
> Thansk,
> Kuai
>

