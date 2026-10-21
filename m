Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792617440;
	b=lSbGkClPkJTFFBZV33mUinssPA0EL6+s4h+mhOX4ueH+KihRIXENcPVF16hQsiorjSwK
	 esS0wpY5uLj+WUflsAScDqCiiRI8KzQSrwpnG8y4YZ8+PjqY0jh+WxXEu1LtKEFt1QFip
	 q2zzZ7Wf8qILOt4H5JlhxaG1BfBbJjM+TqqojQrXTEtHQrw60wYozTmb39VZGvH6/EjVk
	 yIXyFKTKBUHu+ZnkjIbGixDSevjwA6gIHpK57F+gxDFy6jFyRCI2172F/sHXybsLldbei
	 HdByZI1LFhEs+2A+mp/5r+I0ki0BLBrGBgttsvodBSDQ/FrwWCcgMgRozZ/RHY3lRZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792617440;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=RJUIsMIkPpvhWF1NBSmRJxgDLKZfTvlFZQEWC9TVqmQ=;
	b=Z1dEG9/cQh7xbInc7xSGPYE8iPh4vhmOPqoBGh82Mb9C2mh3b++iG+zGuSHZvP57yxUG
	 QDdGDkRG3VxEDXN9eDnjwXUPcxFt3qMHu/BfmE93dbZ2uiu3M4aChdcle96A0GGfM1y4Y
	 GdYUoFFy6clwiHs8kHx+SjaX7BuqVDLeULn7aeMnYR+ZYEbV+0eyV64Zsz5IomXGjjws/
	 ZKiTpMf4fjspNKlRukR5oVqM38iLhzqC9PW6C1OPmSDIRszUo66Ugzu2qkcjqT5VVYh0K
	 nkjcW/+UNAWA+ePxyySTkoq5VPvZd/IoIOEGCZFyLopKE2HuomuIXDBAbOCkEuxJd1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fvNikAbw;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=rAHCCk8H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9961606A32E
	for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 21:17:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9961606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=fvNikAbw;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=rAHCCk8H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792617438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RJUIsMIkPpvhWF1NBSmRJxgDLKZfTvlFZQEWC9TVqmQ=;
	b=fvNikAbwTO/JnBmNLpsn6vIFUzkuJk4camPUvY+2FItyJm1pVrd5EKbmMA+wcdojZFBxff
	h1XQcGaHR/702a1XSP81JX3UdsGCkA8Hc+tAprVGhtOVDq7Q8o/0kNpTv+VA239vvIdyee
	9JBzb7FMTDEyB1up5NJEO2Ml15zMpEA=
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com
 [74.125.82.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-sXHgWnhlNVaC6g0HNG_qPQ-1; Wed, 21 Oct 2026 21:17:11 +0000
X-MC-Unique: sXHgWnhlNVaC6g0HNG_qPQ-1
X-Mimecast-MFC-AGG-ID: sXHgWnhlNVaC6g0HNG_qPQ_1792617430
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3580c07911eso3259766eec.0
        for <linux-raid@vger.kernel.org>; Wed, 21 Oct 2026 14:17:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792617430; cv=none;
        d=google.com; s=arc-20260327;
        b=s2QO6BRv7F+ZMZKDXdsaP93V5Wu4k+B3/ltkj2AP3A5gRijdxYoxwt+jkcEW8r56Mi
         QcdBbyg+rUJEYHuUtXdDrP7gqqS8x+zl6bU7iAR3Sjh4ik7bSf/HR4OLNJQUf8VfeptX
         TG1iQobKBV6awC1qMTeXyNnofwZhIqFnIB1h913Vz2AOo8bbLeUutxcuvwsCIffK24ZB
         Xhg++tGqN0VNdjuOvvKWAdrIbLyUvTfdKmXsS43beGhx8sjfdUlYscDLEf2wH+uA43EN
         AjOhHZDB12PIR397KwUhTYPU92SXn9WP2gT66KEvPV1AMlRxOjZ9y5IBczZNmRk/OCoN
         zNmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RJUIsMIkPpvhWF1NBSmRJxgDLKZfTvlFZQEWC9TVqmQ=;
        fh=39egR711mJrwnXr+N6t/uDrsU4bhTM5AdYh2nRJGL1E=;
        b=YOc0fe6ZMEueOJWm/r/Cd9EW08mruav8I6G9kiIUCa1bbmLOCWeij2jkhiGLQtkXsu
         L43qvgsS1U2AdftGi2mEwB+sDI/Xz7W2K8MP6thKNz84rDRj7676Nr8mAJK/PvbNcUNj
         16HnOKerGyu/F0tmX+61Fpacb9TwwjRZkqOokUNC1Bz70+vAxzBPrSvx9AevaKTSqsr0
         qbzpp9/Gz8VyczwrLQxrtGQuo05o/dkpS9pYcxjYw5LZPBb0FvINRm/leToTVCC0Tht5
         HPp5jnK6AM3OMsrmtZ+AErq15oQn6SsWsKADtQYoZAh8apK3um6ldrvtMVEXV92F89zu
         Fc4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792617430; x=1793222230; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RJUIsMIkPpvhWF1NBSmRJxgDLKZfTvlFZQEWC9TVqmQ=;
        b=rAHCCk8H7EQ4kXw/JI2vPmO3WoGkC6xcjATrqTNPkCdHtg878c1uo6SCGD0IAZd6OA
         rXf28ni7QzLEVlXmll2H1HDGGI88FV4Ef01wpZFW0EwzJDpvtRkJlZqmkBhZdpgXRYlB
         1SxboOoGWW9rVzU7XLY1TZKYcP9K9V+ByALovyHI4RD5Skcgj6pKDiJC1J5zMR9rlgj2
         FFhmoufyApwgxsI7AcL0DrfFMRDXISA2TglgsNBJgmjrN+XrVsa4RytjsvJl0/HKWgcf
         qmPHuwDRiM95X/Dse/cPsCdzhnfDqhuR9Yxfi1JW54ShOovaWO29ndt7s81W4tEZkCBx
         /WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617430; x=1793222230;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RJUIsMIkPpvhWF1NBSmRJxgDLKZfTvlFZQEWC9TVqmQ=;
        b=fW7Ja632Dwsw/TdUYdU2rLMF+G+PZ0KvYpyYaaKa0hraWtlXHPj3StwG9eVpzYVJ2A
         9+l2ceZZlvadAAvkY3zMFr5zQ1zAzHb5YEA5VNXFp2dsqnSvCyjh1AwXlW/xVSuXlmQc
         3aTJ22GkfLkfkO6wIrhGpZyTpZfpTEOfCZApdWJmEtukmystwyQZUz8vaGGXP3jmjJc/
         3fLrG9oPQ478LBhiWuyE95BMSsjTd0Y37yNelFncCz5v8OJneiP2X6IVvOKHlPy3J76n
         UATZvfKTPEA/kDaXrlhYvFxw27oycVkKuKedd4MqDs3EFK8F6UC+D4bkyPt/7ChlifbK
         edow==
X-Forwarded-Encrypted: i=1; AKwUvByZOUBksz2W9lCxsDOmlz+Pcp9HpHRiXwz7evoO9WjGnbOIr1g8ld35XF7l4y0FZ1rPAfXmmPPqpcUm@vger.kernel.org
X-Gm-Message-State: AFq9FYI5Milb/WRoPWY36ipvVdtMLuwoOXBG90ljj54ienuiPGhQKxWX
	PKVSKJp5UyqiGcWxOsVFun7fKJiEqNyrN6fu1mYYt2z+ZC8KM5O4J2+O96yi6vKGLNlx8oCKvMT
	y/ocTwRajH/fY+IHglyOImNretKeMWix5R3FIdqAqmAAXxWLljIzI+C4+dwAOouM5ChOy3BSI5F
	SSPxgc6OtZ6vvLDmyujDSfKKMl1ypEPS6OwxCWc94A0WqkpQ==
X-Gm-Gg: AYBFou3sGv8ZODnQL/WypdxDmdlb7WyqjYgl6D5246AxFzImoYG3CD+GFk5zpCdDu6B
	amWCb4eo6KTygF6vFJTal98m003ez4wyi9i7PDhzyJbJ23C9GFFShV3pA06AOMJATUk7dOkYpbo
	iylzzFX/eq+hr27z/alz3MUQqrvQyIKrOys7Mi9CZw0Rdnjm/nB+vYY6w=
X-Received: by 2002:a05:7301:2ab1:b0:35f:f0:8ed1 with SMTP id 5a478bee46e88-367502ff37bmr4843253eec.36.1792617429937;
        Wed, 21 Oct 2026 14:17:09 -0700 (PDT)
X-Received: by 2002:a05:7301:2ab1:b0:35f:f0:8ed1 with SMTP id
 5a478bee46e88-367502ff37bmr4843217eec.36.1792617429377; Wed, 21 Oct 2026
 14:17:09 -0700 (PDT)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
 <atenHrzZVtzu5YOa@vdo-obuilder-bjohnston.permabit.com> <cc3dc99d-cb3e-49b6-b01d-1eaedabfae0e@huaweicloud.com>
In-Reply-To: <cc3dc99d-cb3e-49b6-b01d-1eaedabfae0e@huaweicloud.com>
From: Bruce Johnston <bjohnsto@redhat.com>
Date: Wed, 21 Oct 2026 17:16:58 -0400
X-Gm-Features: AclHuK8rrnanGn0t5epyTiMkNesBYBrar3akDGPkemeD7KZyXMIklFTd-fYL8nI
Message-ID: <CAOjDE+DNYYa9GEgSD_JVTZAhsxiecxRwR2GB4XnCSjHp7AbtkQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/6] md: fix takeover failure handling and raid0 size calculation
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: yukuai@fygo.io, Li Nan <magiclinan@didiglobal.com>, linux-raid@vger.kernel.org, 
	yangerkun <yangerkun@huawei.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"

>
> So the chain is [1-3] -> 4 -> 5 -> 6. I'd slightly prefer to keep them
> together for that reason. Of course, this also depends on what Yu Kuai,
> Li Nan and the other maintainers think. What do you think?
>

I'm happy to hear other opinions. I will try to review the patches as
presented.

> Thanks,
> Zizhi Wo
>
> >
> > On Mon, Oct 19, 2026 at 09:08:21AM +0800, Zizhi Wo wrote:
> >> From: Zizhi Wo <wozizhi@huawei.com>
> >>
> >> Patches 1-3 fix the inconsistent mddev state left behind when a takeover
> >> fails.
> >>
> >> Patch 4 rejects a raid0 takeover whose zones cannot cover the capacity the
> >> gendisk advertises, fixing a syzbot BUG() in find_zone().
> >>
> >> Patch 5 factors out the member-size rounding. Patch 6 uses it in
> >> raid0_size(), where the power-of-2 mask is not a round down for a
> >> non-power-of-2 chunk.
> >>
> >> Changes since v1:
> >>   - Added 3 patches fixing the inconsistent mddev state left behind by a
> >>     failed takeover in raid0, raid10 and raid5.
> >>   - Patch 4: expanded the commit message with a paragraph addressing the
> >>     issue previously reported by Sashiko.
> >>
> >> v1:
> >> https://lore.kernel.org/all/20261017005802.2212102-1-wozizhi@huaweicloud.com/
> >>
> >> Zizhi Wo (6):
> >>    md/raid0: don't leave mddev in an inconsistent state when takeover
> >>      fails
> >>    md/raid10: don't leave mddev in an inconsistent state when takeover
> >>      fails
> >>    md/raid5: don't leave mddev in an inconsistent state when takeover
> >>      fails
> >>    md/raid0: reject a takeover whose zones cannot cover the array
> >>    md/raid0: factor out raid0_member_sectors()
> >>    md/raid0: round member size in raid0_size() with sector_div()
> >>
> >>   drivers/md/raid0.c  | 84 +++++++++++++++++++++++++++++++++++----------
> >>   drivers/md/raid10.c | 11 ++++--
> >>   drivers/md/raid5.c  | 13 ++++---
> >>   3 files changed, 84 insertions(+), 24 deletions(-)
> >>
> >> --
> >> 2.52.0
> >>
> >>
> >
> >
> >
>

