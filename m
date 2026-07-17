Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FA235C1A9
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784311923; cv=pass; b=RGcF3WDrBtKVizs++66IMSHP+eJFbyUVV+FXP7rzwcDYUWQ6YQEGSVqm/bZQAT8lOyeVx/d3u3iXJPbutL+m3ya3G4ik2ftsIjI4iTmFS0Su3szTJHQ9vhwaE0Yfh//WCiD+isvzEnQSyUI+OIGZhVH1ZvauM3X63xCmt4/iyZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784311923; c=relaxed/simple;
	bh=uUEDXeVaOVJQS4j0uEhTQisiTfLSqU5Vw2Lm4mCmlJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ToxYM/f5PDSkbuqUSNoHKow/2CyREegl/G11tdPiLAJwoz0siH1pjLsqDufO9UpkR4dFyDbBujXPTT61XJ9M13XDTTqp1OIkwbF42ZfN3wFptGhUosexQ3c7Obq3LG2c4W96mxMNCu1N3TXd39hSbVVOkMb/LAL0O11AKh1SJik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WdVZ8sCl; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WdVZ8sCl"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c12614b81c9so1467935766b.3
        for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 11:12:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784311920; cv=none;
        d=google.com; s=arc-20260327;
        b=aYgNjFGKLfoAR9mole7Z/xeG0p4KgBKac2UGK/O+eev8v4f8nE764ZYkD1vkwdothu
         TUEIefGlQFQ63cEMe+rbImwmsR82huEu850IihlyGJOSbU1pMKdk3xSmUFo8XDgEJ0pg
         JGYZC9TQjYATGwK02LZ4YVVsiyYEAIRVJMjXS9+AludrPMz1RVE+hw4Wajj+MNc/3pyP
         n21FbWwngFSsHtR/0W5JG1UpfJI8nyTw3Npb3MjpXKuCsqCV3ppb8tsWj/FBpEsN1H+C
         ucTvXyTLv+Mf2zmsMBwDk1JtlmIugyNmyuAb2AlIXrAAJhaIidy+W2xkbxYoLvEv5Lr/
         K6Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Gr5If/L4JBCYnFefWnEGp7Am+p00nB6GuXb7MIqkwM=;
        fh=rscoZJZG1rDNojWDJtQ46cZ72Ssib48QpvEhqw/2Mgc=;
        b=j1hqpcUGhboMl/a7gk4QwPcaZCW6P/ADBBgjFfhpL8UlwHanv1uTnl7jpF2Ve78AyF
         uXXadoGriaGGDxlhOPfT8KV0StGrY8w9EIRNhQvRMdlnaShVFvnZsTZkTb8Z84wAtmlr
         KFmsGnJMNdemEW4CWZm1UKuKmdBxrCkBWgsc1NDO97JaYwXKTSLdAsmtB2IjHHZccIjS
         NFGATRs4CgU3JwN96L01aCHJe9IQEYwyPa2y+XZI7/VwVXG8euSW6nb9OERdv7ShSw2M
         pB2bBvkeva35XtEVweAVvHtxZjOcvUzmj4wkle+XR0KDYdOeftNsoRjOpfLXtVNoXRkz
         5WaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784311920; x=1784916720; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Gr5If/L4JBCYnFefWnEGp7Am+p00nB6GuXb7MIqkwM=;
        b=WdVZ8sClDTgEPjlrVIOOzqAOBdv3Aeq6p4kP6mfKkz9wVmt8O+OwqoNo1N5eFKaBqp
         EcbwQ7/JxMiV9/QmNQGPGVXH8sbkXvFNNEyqOhkKBPmXNCVgbLCnjeXCIK5YSnGLevSI
         fw2Pt2KZ595QbNKzccfg8jl6lsGZRQQnqDUfZlvSjoeK1/t46P55daPnvy0cQyBOsQA4
         4sD0yh/NEk/4KNyM5FIdyvVZeu6mA6+2CpnGYndTBga6SNBLwymkmWjqmF3FhAUCbkWJ
         EW9NqcDG1YLT6XiWm4otF9W86wuRjWBadJ+p1O0Xt0p7w5vp4Fk/71agXA7I/uesn0Hc
         nZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784311920; x=1784916720;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Gr5If/L4JBCYnFefWnEGp7Am+p00nB6GuXb7MIqkwM=;
        b=k3FxfEfeAs6gJXiNUYgX8Pwa0HA1ot9+aJCh/9Ul5qseAx2YbgyZOKUz4BDwGOcP7s
         0kb1MyQKZjdTDSa90gONeALSsFRVCRjroLztC4lJihKAv5XTEuOFponfO9laOshk97jz
         5A6nuCYSZ20L9LF7B4dq4rg1Obk3sPDPg3/e9ZHKmjYQe7aTYz6y1HVOt5eIeT772U55
         b3LvebWVeRp3xPykl0kklY3LG9tRUICnKg/LvU8QNIIHhYpGscRhIkwtXe8unrDarFqD
         uNer0ZqONi92jADUs4OvDBMLyk8vltn/MmotrbcogQCIuusNXxbIr1QDTjIMPjFhK/LD
         eQGA==
X-Forwarded-Encrypted: i=1; AHgh+RqtcXDWPAYXhGLsKlnQp8Rbpml65FnxEAWT0wr3HWWsPL3YTX+wBaclnoazmsRWL+80FqHvJ5G/jouU@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhq3cL7JZnsG2V0qzkzB6ofr9G3FyaRqP5RIvFHHK2Lm6V3pJ+
	SjXgUA1Hzgk2YaZJ8QvjoSzvWD2DVi7YpzPaz7nfTKWutAccmgzMZRkS5Tj3dcLGMj5C8rvKysW
	A6wgwkUC66pRHnlGD1CEE41A4H17kwvk=
X-Gm-Gg: AfdE7ck1+EnfAg02VijUN1m7dV5YqyYR7S88dSj2cmuxF6beU4Jo/6SsggsHzXRhJJh
	ZK6/G75dzwVAC+Y7tRF4yzZt8aadFqLXfTr0KzoxIGambc+QbaqozuFFXOUSZnbVqUDjOcDXhar
	nYePV+F+NzoyRm9VrJ9mfoekrgBqOphhSHN3fmY6pJkb0go5zHaOOh+KNfIstBWQ7PRso1fY4N6
	FMgllJbJWksvS0xcDFm8S/7G3bjkEMt561GIYO2QLZqPPJ0qk2vr2tYmH6Ql4pPaUG/wWU=
X-Received: by 2002:a17:906:f049:b0:c15:f395:ac31 with SMTP id
 a640c23a62f3a-c16b48969aemr170809166b.61.1784311919730; Fri, 17 Jul 2026
 11:11:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
 <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
 <59fa3f9f-eda1-4f8a-917d-8f6612639a1b@hunenet.nl> <CAAMCDeefBEP0c4oW3iX4_cbZBLDuyfuAtCREtFgiH-qS4ZaiXQ@mail.gmail.com>
 <fd1f940e-4382-4a8a-9d16-e70a708da3cb@hunenet.nl>
In-Reply-To: <fd1f940e-4382-4a8a-9d16-e70a708da3cb@hunenet.nl>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 17 Jul 2026 13:11:48 -0500
X-Gm-Features: AUfX_myRA90NUAgPg9Eng2Vwkfn7itbObBVthCS6pdyzIruZ4djKUQ5qABmqcL8
Message-ID: <CAAMCDefN+a_mMWByAMPEkCo6sT2iyi-b8J2et5LsJpxZtZBzQQ@mail.gmail.com>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The drives are said to do refreshes when it finds a weak sector when
doing a long media test.

The manufactures do not seem to document any disk internals, they
never have.    All manufactures claim their magic firmware/processes
give them a competitive advantage and so don't disclose what goes on.
 Pretty much all of the hardware is handled this way, with poor
external documentation.

Smart seems to only disclose the common settings/errors, and don't
seem to allow anything except setting changes, and to run defined
tests (short, long and similar).

I have been told by a WD engineer that their internal tools have the
ability to read out a number of other parameters that aren't exposed
to SMART, and may also be able to do other things.  Those tools are
not externally available and the when I had access to one of those
tools (for a few hours so I could get it into a high security site
with the WD engineer) I had to agree to not keep it.

I watched one of the tools be used on some disks by a WD engineer that
went onsite (but I don't remember if I saw any non-SMART like data on
the screen--it was 20 years ago) to check for errors and determine if
WD would RMA/replace (without media return) around 1000 disks.

I have been reading smart data for as long as smart has been around,
and outside of maybe at most 10 parameters, most of the rest of the
parms are rather useless because the manufacturer does not supply a
decoder ring to make any sense of what said parameter is really
measuring.

And whatever the manufactures document would be what was documented
before the disk firmware was completely finished, and may or may not
have really worked in the given firmware.   I have ran into disks that
would refuse to relocate most bad sectors (even though older disk by
the same company did this just fine), and a number of other weird disk
actions indicating that the firmware does not always even implement
the features that they are supposed to correctly in all disks.

Basically if the smart tools team actually knows anything about the
disk internals, they are almost certainly under an NDA and cannot tell
you (likely this is not the case), and if they aren't under an NDA
they were not told anything.

And contrary to what other experts claim (that disks regularly will
return bad data--ie 1 in 1e15 sectors), I have never seen the disk
itself return bad data(I have seen raid controllers deliver corrupted
data many times from both hardware failures and defective raid
controller firmware), if the sector is read successfully it is the
right data simply because the disks ECC correction uses so many bits
that the chance of a corrupted sector being corrupted and still
passing ECC is so low as to not be worried about.

On Fri, Jul 17, 2026 at 10:48=E2=80=AFAM G.W. Kant - Hunenet B.V.
<g.w.kant@hunenet.nl> wrote:
>
> On 7/17/26 12:55 PM, Roger Heflin wrote:
> > On Fri, Jul 17, 2026 at 1:42=E2=80=AFAM G.W. Kant - Hunenet B.V.
> > <g.w.kant@hunenet.nl> wrote:
> >>
> >> On 7/15/26 8:04 PM, Abd-Alrhman Masalkhi wrote:
> >>> On Wed, Jul 15, 2026 at 19:41 +0200, Abd-Alrhman Masalkhi wrote:
> >>>> Hi Dion,
> >>>>
> >>>
> >>> I'm not entirely sure about the media refresh part on modern drives..=
.,
> >>> I'll have to look into that first.
> >>>
> >>
> >> Maybe, we could ask the smartmontools people about this. They should
> >> know this. But I have never read about a refresh action in their
> >> documentation.
> >>
> >> Best regards,
> >>
> >> Dion
> >
> > I am not sure why you believe the smartmontools people would have ANY
> > idea about the refresh action.  Smartmontools simply exposes the
> > internal drive counters that the drive manufacturer exposes and/or
> > documents.
> >
> > The refresh action is 100% entirely controlled by the drive's firmware
> > and has nothing to do with the smartmontools, and the smart counters
> > may not show any of the internal ECC forced rewrites.
> >
> > As far as I can tell in general the drive does what it wants to
> > (refresh or not, relocation bad sectors or not) and there is NO way
> > that I have ever found to force the firmware do do something else.
>
> When you refer to "the refresh action", are you referring to a
> documented firmware mechanism that periodically rewrites successfully
> readable sectors, or are you using the term more generally for any
> internal media maintenance the drive may perform?
>
> I have not yet found documentation describing such a refresh mechanism
> for commodity HDDs. That is why I mentioned the smartmontools
> developers: not because I expect smartmontools to implement or control
> such a mechanism, but because they are familiar with the capabilities
> that modern drives expose through SMART and related standards.
>
> I'm trying to understand what is publicly known about this.
>
> Best regards,
>
> Dion Kant
>
