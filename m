Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595F83BB699
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 07:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781679898; cv=none; b=rzF+MrMT43rryT4jeCRUKxVl70G8r3Ye1EuOHrQXuXcaxRVNt2C2Jo8s7B860JMBp+nz6QJn8YLhOcKXbjJVmhiwzRm8AUSh4ApH9vg17fUvP6o6zhX+eQbG7261yF6vS/Lk5jrfz8Cgl8bxO2Asv9/js47dpHFbvoDQCaYDCMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781679898; c=relaxed/simple;
	bh=JP9o71QIiNICYGRq2irZJnb7vrlBaRtPHkuBL7ueBBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7VJrq33E3vCK6qyABoQXb0Uto4u/6c52/0jFtDulcxgN1OaY5WORJ1Pli2a5jjEeWxnoK8RhRBaccNuCzmVrDT+95gYIoNi5PRfuMfUdaZM3kLi+LsTTz9RShhu7p8Px+ePBZUjsFOBJ+T4Jfv32+d/8baoe3NlBejgpSEEC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gF/j91KS; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gF/j91KS"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ccf18ef922so78636406d6.3
        for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 00:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781679896; x=1782284696; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H8c6uDZHqr7JkoiE7mt6TRUa/7S9xF1jPc0Ns3g13rE=;
        b=gF/j91KSsipuenANEzm5HmRDuiHbvlugo14tNQn1Cn5eCqySybW+0KsKY4zPz4Mm6l
         KvKWRfYEouPdVDN+BmNHyhCrlnc6t6YuiA67x6WJNi0+kT8aFptgl5byMcbvoHPiRFoL
         s5NtRQPWIzWGSAMQwl7FQDzHQCtOxGcKshffF8GfCkAzroxLIihOQLr2H6FBT4oAGJa3
         vSqAtYlE6/AhctCmfFbJo+qYKfk/fuPP5HGXOMYKkJuQEggTlSQLiiO6e3Sh/+mHThBY
         7nXc7ko9LY0u1+p/Z7RP6EULzipGP0oEayB26lzFgw8St/WhOAaj+J/dnjkZWgC/TbEq
         pDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781679896; x=1782284696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H8c6uDZHqr7JkoiE7mt6TRUa/7S9xF1jPc0Ns3g13rE=;
        b=aRojorR1v5Z+bPTtsVWNqt6R8PWkX2pU+ZhRJJjug/xY2Q/EXp6fHuCAdTR6K30Znw
         pKKfQAB2my68Zw2iBLdYPLCDKyrS+s5u47wTS7pdVi64XkHYOEDSQLlgZYd8oIrn5XEa
         fqhyzILIJCKNE74rSm/kJ8bqPzKrgNFjyjpWkjNREXnsxwGCz/pEgTQHLdD/TryVKQhR
         hAn/LE2bWTMKfu2mI+Sb4QwVelyEQTFialAoptCvRDhr55YcFPLxERUvWvRYwAgdRXiy
         mazoG4w73oa2n5L3VPMzsy/utpYUWhELcZdW+NufJ3JDlLIyquxStwZOK5U3on50aANL
         xRfw==
X-Gm-Message-State: AOJu0YzQNyr/ql+r1zzm80c51EqlESvpFCmF2oTr46Px1j1WV7PXUf53
	1pv4AJK/1EgUDiEh3VgwRTUZ6ee670VonWKPP6PwhtbI8gXvRD08MkMk
X-Gm-Gg: AfdE7ckiQqzXopvz/BSaD4VoWJJwJ8jHzUZImlN7irQbaQxhSl4impUuSHsaHbp+FVr
	643BLVuLMMWECTeJWaM5ozOzQMl2PdH4+kMj5sYmTpAr1B9TlV4uvmwsfstn7chvXHcDHBS3E1j
	7XyBxiUAm5tevg2QhV9Kk6ABv5NmucCSlXHZhDQrSCRgFpUBvEidv7twQ8U5bM8N/GSTeaSnJ26
	SF/nnrEjcdMlJixNb4Y2sqXeu/cM42uWK3o9j0vikYPWkIxHbsvq9Kyh+Zf9roDD4eH0O76yLoC
	TrZ8PTn2n6CRAmsd5K9yF+Y4ut+T3BB9X4DKkmVljffgMhgwQr2OyAJDhzdgZxfAp5h3hoqakVr
	BC8g+MpnGXPx89kOwqjU8WVl5/onHSRxV6RZvPv2I0/VvTktYmY3hgBUddUattpNAZp8MLQJHat
	7C0IScw8ahKoLnNrvT
X-Received: by 2002:ad4:594b:0:b0:8ce:eaf7:dbd4 with SMTP id 6a1803df08f44-8db5b7ab7c2mr48763006d6.17.1781679895876;
        Wed, 17 Jun 2026 00:04:55 -0700 (PDT)
Received: from localhost ([43.225.189.75])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d9f4557d43sm55343736d6.31.2026.06.17.00.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 00:04:55 -0700 (PDT)
Date: Wed, 17 Jun 2026 10:04:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [bug report] raid5-ppl: PPL support for disks with write-back
 cache enabled
Message-ID: <ajJHEHtMns11Tax-@stanley.mountain>
References: <ajJF2wKYWRk4GGCK@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajJF2wKYWRk4GGCK@stanley.mountain>

On Wed, Jun 17, 2026 at 09:59:39AM +0300, Dan Carpenter wrote:
> This code is nine years old, so what I like to do is add it to the KTODO
> in case anyone wants to fix it.
> 
> KTODO: Fix use after free in ppl_do_flush()
> 
> Hello Tomasz Majchrzak,
> 
> Commit 1532d9e87e8b ("raid5-ppl: PPL support for disks with
> write-back cache enabled") from Dec 27, 2017 (linux-next), leads to
> the following Smatch static checker warning:
> 
> 	drivers/md/raid5-ppl.c:646 ppl_do_flush()
> 	warn: 'io' was already freed. (line 647)
> 
> drivers/md/raid5-ppl.c
>     608 static void ppl_do_flush(struct ppl_io_unit *io)
>     609 {
>     610         struct ppl_log *log = io->log;
>     611         struct ppl_conf *ppl_conf = log->ppl_conf;
>     612         struct r5conf *conf = ppl_conf->mddev->private;
>     613         int raid_disks = conf->raid_disks;
>     614         int flushed_disks = 0;
>     615         int i;
>     616 
>     617         atomic_set(&io->pending_flushes, raid_disks);
>     618 
>     619         for_each_set_bit(i, &log->disk_flush_bitmap, raid_disks) {
>     620                 struct md_rdev *rdev;
>     621                 struct block_device *bdev = NULL;
>     622 
>     623                 rdev = conf->disks[i].rdev;
>     624                 if (rdev && !test_bit(Faulty, &rdev->flags))
>     625                         bdev = rdev->bdev;
>     626 
>     627                 if (bdev) {
>     628                         struct bio *bio;
>     629 
>     630                         bio = bio_alloc_bioset(bdev, 0,
>     631                                                REQ_OP_WRITE | REQ_PREFLUSH,
>     632                                                GFP_NOIO, &ppl_conf->flush_bs);
>     633                         bio->bi_private = io;
>     634                         bio->bi_end_io = ppl_flush_endio;
>     635 
>     636                         pr_debug("%s: dev: %ps\n", __func__, bio->bi_bdev);
>     637 
>     638                         submit_bio(bio);
>     639                         flushed_disks++;
>     640                 }
>     641         }
>     642 
>     643         log->disk_flush_bitmap = 0;
>     644 
>     645         for (i = flushed_disks ; i < raid_disks; i++) {
> --> 646                 if (atomic_dec_and_test(&io->pending_flushes))
>     647                         ppl_io_unit_finished(io);
> 
> The ppl_io_unit_finished() function frees "io" so probably there is
> supposed to be a statement after it.

This sentence a word missing.  Probably there is supposed to be a *break*
statement.

regards,
dan carpenter

