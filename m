Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130FC2D0C8F
	for <linux-raid@vger.kernel.org>; Fri, 19 Dec 2025 20:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766175268; cv=none; b=KOf0Fg3gBXR8icsZDHzdJyYZzcONYZSqLc+rUgyPIg278d4x0IJqKpbx9wnBad1jdbcV5LGTOhrlZiwMSKvhf4a0Rj4vwM5ZjKe2AEQILvEUN4swdjBtLZ4XpIwq0nSF5cNBdCuquxRJ0fkggnBrxdz3SRZ4NWf//TyPg8bipaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766175268; c=relaxed/simple;
	bh=dIxfwhhJL0i/I8nr6bMpMUsa10C0sVgxYpQj4hnaMz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMB8wXMrBQ0dEWZeaj4QULfSWy9Zv7wJa24dta77nE4zcQysNEgQLBCTH3dsbkVSRVY9w2VHuQjyeKzvpKolSHyNzltF5tUe9ZYzw7U4lUEdaPSjGzbAS+qPhsPfSoZPwFfvRTkm9AQwX8npn1IRiuWMzdNZxeLBSdUaKAJhPog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AN5maYIV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQ3PYQWc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AN5maYIV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQ3PYQWc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766175265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBfdYfCkq8K5J6dzHLuqBSpEl8OulRkj0yogBVBa9eY=;
	b=AN5maYIV3PxZ3iEoakMCzru859l/i6VPqtfKslWUR/dJuTNtFygnmjIIb+6ANoQUwx1Mk8
	JHkpVYrlJq7LXwXo1K1sHQhoGd/1QDyJwzTA+tj4esvdvHDfZKenNXAF2pz7BijW9+eD8v
	LKG8yawO+YgaLRkgs785lXezJvvxmyQ=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-xrFirMPCPYOtNsdL8hrv4A-1; Fri, 19 Dec 2025 15:14:24 -0500
X-MC-Unique: xrFirMPCPYOtNsdL8hrv4A-1
X-Mimecast-MFC-AGG-ID: xrFirMPCPYOtNsdL8hrv4A_1766175264
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-644548b1dcfso2990505d50.3
        for <linux-raid@vger.kernel.org>; Fri, 19 Dec 2025 12:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766175264; x=1766780064; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NBfdYfCkq8K5J6dzHLuqBSpEl8OulRkj0yogBVBa9eY=;
        b=hQ3PYQWcy0s4lENvOQtEDdQncWF1HE/Stn6Myx6WoOL09lfGU8oCZ2Y1hzdAICE9M9
         +ftchsGdl8zu+AbzaD0yPD+KuBNa5QR6jQch2tFWaelD0FZKfa4HJR/8FAngu+FQ8xKd
         KMdFLHkUj8gMAy6J6iVd37JF/2LnMIbEdriZQSBySJtXwk8l1uBulLTCZ8p4r1C20EMY
         IKEA72MJHIbOiGgUT2FGi7JqguADMZIkNMeIJ+aDA26OgzOcK0BR/4CgT/5V7YGH9s/O
         tP6+woAk68c8MY8nYvCKxqWRkSgMCqIbvZOF5s0TrsDU8vzI6YSOr77SAsKrP9Mei4ui
         UlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766175264; x=1766780064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NBfdYfCkq8K5J6dzHLuqBSpEl8OulRkj0yogBVBa9eY=;
        b=vWPk0CgUkcQrelNqKRLl1mVx6ickFRno3hb3RMjuGvOqrPZNrqoc2gYMXjQpufbV1F
         04mPzpOoXU7Dw6WWOTFavsn3K3egjAY3Sps7JeRF+FKlJWbgevQwHcY3VaMtRz1Qs53I
         mt2kSqd4tpJdtMm0JbcI/sfw8UgPiSiCGvk/5oi5G7W9mSbQzTysOCRqQfyU57g6SVIc
         9PTE8u/V7yBt1mHFla3I2P+gpScXfmUH4D5rs9VPA6tI6jIxshGoTNbPFL2xErwCfC8I
         zsCCdnWpwvC645MftwukRIfsd4zdSIbC653A4hNUYMXZFTixCqRmkywRVBVAyu6mJB+9
         LaWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNTCvXUyR4Ulnr6fO+SD5/6hqVThLc/RxMgONVoKPdDx+JiVHHLN0stQkXIz42Lm61uG2ViYNNmiGl@vger.kernel.org
X-Gm-Message-State: AOJu0YxeMu4JIHg/Zv99fCKu7ct9XfxR2JTqyzH/Os9znB6lw2p2GSFU
	/6wZ2YlaL8W4woQmtt3kTABmL31N91mt5aX4j9WWxoeg2jYtKYuEKmVRk88qQ9RZHXyOoyNgjz7
	nB0Aau6lEycA6+my+n7Z9+6iNgiZVvoYJ5AGTJuWbMw8yPkQtSE+hJyzkNIPdzCDeiENSr6CR7i
	XtI2gHHq0vZY+0i1wt17MtV026ftceLaMqdMe7szKf+7EXH8VG
X-Gm-Gg: AY/fxX6wDI7SZwrlvZfXRvO34K92YaAfRTqXjI1vIBhUFlnTzYNepek/rER3q+lO1oN
	mAQnMV1yQrGLQ3Mh7Di5n9XK6zV3JgfotF8+c9qR1Ge5prbdRqkYp6kAdjL8Bvj6XOq8gLBRSh9
	2Ify3Po15cHhgQphyIlL53YytuqaeRwuKnuKPihu1XN56aLYMTlCJ81pwayHGGE0Jh
X-Received: by 2002:a05:690e:d45:b0:644:60d9:7511 with SMTP id 956f58d0204a3-6466a924b7cmr2939909d50.97.1766175264013;
        Fri, 19 Dec 2025 12:14:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrNtpAXBkLfsv4ZPV7ytMwDCknVLCZ37g47oODzFz+yaO52Pr39pYpvX6RkjSMSLTqKC4vn7AIoer0DNh5XIs=
X-Received: by 2002:a05:690e:d45:b0:644:60d9:7511 with SMTP id
 956f58d0204a3-6466a924b7cmr2939880d50.97.1766175263490; Fri, 19 Dec 2025
 12:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org> <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
 <aUE3_ubz172iThdl@infradead.org> <CAHc6FU4OeAYgvXGE+QZrAJPqERLS3v7q64uSoVtxJjG0AdZvCA@mail.gmail.com>
 <aUO_u7x-4oIfKMei@infradead.org>
In-Reply-To: <aUO_u7x-4oIfKMei@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 19 Dec 2025 21:14:12 +0100
X-Gm-Features: AQt7F2qA1mcyWoa8p0XYXVuSER3YOFH3464n9K2F3F4P3zepWO8fQIC-uKVJeus
Message-ID: <CAHc6FU7H7gFFRw5FCc58ki85Pbedfs8NegjWQbpN7otzfsJNpg@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 10:08=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> On Tue, Dec 16, 2025 at 12:20:07PM +0100, Andreas Gruenbacher wrote:
> > > I still don't understand what you're saying here at all, or what this=
 is
> > > trying to fix or optimize.
> >
> > When we have this construct in the code and we know that status is not =
0:
> >
> >   if (!bio->bi_status)
> >     bio->bi_status =3D status;
> >
> > we can just do this instead:
> >
> >   bio>bi_status =3D status;
>
> But this now overrides the previous status instead of preserving the
> first error?

This is exactly my point: we already don't preserve the first error,
it only looks like we do. Here are the possible cases:

(1) A single bio A: there are no competing completions. A->bi_status
is set before calling bio_endio(), and it can be set to any value
including BLK_STS_OK (0) with a simple assignment.

(2) An A -> B chain: there are two competing completions, and
B->bi_status is the resulting status of the bio chain. Both
completions will immediately update B->bi_status. When B->bi_status is
updated, it must not be set to BLK_STS_OK (0) or else a previous
non-zero status code could be wiped out. But for such a non-zero
status code, a construct like 'if (B->status !=3D BLK_STS_OK) B->status
=3D status' is no better than a simple 'B->status =3D status' because the
if is not atomic. But we only care about preserving an error code, not
the first error code that occurred, so that's fine.

(3) An A -> B -> C chain: There are three competing completions, and
C->bi_status is the resulting status of the bio chain. Not all
completions will immediately update C->bi_status, but if at least one
of the completions fails, we know that we will always end up with a
non-zero error code in C->bi_status eventually.

And again, switching to cmpxchg() would not always preserve the first
error, either: for example, in case (3), if the bios complete in the
order A, C, B and they all fail, C->bi_status would end up with the
error code of C instead of A even though A completed before C.

This could be fixed by chaining all consecutive bios to bio A (the
first one) and reversing the pointer direction so that all cmpxchg()
operations will target A->bi_status. But again, I don't think
preserving the first error is actually needed. And it certainly isn't
being done today.

Thanks,
Andreas

