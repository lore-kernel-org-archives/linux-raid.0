Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4853B47CA
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 05:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784093235; cv=none; b=ExrJpV1jyqp318+JhUJaQwuf4mStVVRxzFRR4kuXR4wYkwKcRGFoJNTAu0gxWJfiXwBXO+9QFTZa5GG9zWGLW9fw/nB8SKOmi56Xs3BczIqZpxXZtYv0oj3D1m0uB+qfDOkVjZNSRBRYjyKnNk+Z3CmXWcQm6opqe9BB39Tpa6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784093235; c=relaxed/simple;
	bh=0H5cTGb3KxpJWZXY0Fnjc11a+5n2DwBPP3Q+x5xDgoY=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nghoPmhn/jJHDuP3zP7MXtlo1ilR3MGwHSoaL4eA+iTmhUcutjZdanFIFkziSmDDHImmuJGh7OZgfOqLaMKP324tkX9vxBJ6U0DQFkXuve/Um2JCVpzXOVL1oFJU99pk5N/S1YDQJdHH/anwmhYN7G6P8hGkaXFmr7nUFgKbyMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGl2za4j; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGl2za4j"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4720d22c94aso1692438f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 14 Jul 2026 22:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784093232; x=1784698032; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0H5cTGb3KxpJWZXY0Fnjc11a+5n2DwBPP3Q+x5xDgoY=;
        b=jGl2za4jjZKZFwxsIdTV0WurUx9loYdXKQ+rtpqMLp4ZfuvPi9rbkmDkOVSOWeW1V+
         oJYYLG/1v6OHBKpi8qcx3i7TjxeXsJkUNcSZUcnVP1VWGF4lYSMjfjEwRe96VKka+J9A
         Xl+0suXtqQ89LgYhNh0roW5fJjhXAdFR4SaEJcL5gfQOppxdpcEy+kYK3Ay2MFbBwqNp
         26pyFcsT1ZpjAkDahOC8qENJ19O8N/DnqZr5k+K0CDloLohgw1wyL5q8sO2dIpuyYKl8
         hvbakW9Jd3QHRWewzB7zcMyn7JvFSKshO26N8J1BTnCVNe3YkRY3bzKP5vwKF07LlyF4
         +cZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784093232; x=1784698032;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0H5cTGb3KxpJWZXY0Fnjc11a+5n2DwBPP3Q+x5xDgoY=;
        b=DWepcFwspY5g2FHYcHBDHc2r4eIxEbTF8y8l8NGhuwtbKty3J7u9O83iWnPj2SN+A2
         8jBx5yPafng0p6sIVz7fAx0nZIprIMitQFLTFsh2R23yRKj0oYxpKBAG9Q80l5urM2bq
         kT4vaBe4Mx+pIOaxeEU2AJoK+qukjRb0gEY9X2oPDicCozRKrNGpPdXQBxgNZzQi/tH5
         68tCQGKcIBJJi8LlX17q6ie0QRuUT3kNlrY1wwiRySgj3cj4BUUCV/QA63CNHvqv/BZ6
         5dJ9qnlob4XN5pDYBAtaDj1/7OBkdGMN9bDjOl/jfk5o/DBlzY8H8h/KL6gOVvEzsKk7
         yvEw==
X-Forwarded-Encrypted: i=1; AHgh+RqBhoarmLzwj1Ntk2jhYuYMwYjw9OLTqtW5erDHrIPqF2q9N1eb5dM20IE09aSCkDictRjz2PkUpuEW@vger.kernel.org
X-Gm-Message-State: AOJu0YzeRimyheoz/vi5RNhq5kL/5XY68pJeHr69TMiio+iYqCE34mNG
	8U29B/saTC5SCzwHIB2flkeyCM8sP/CCSEAf8bZXcd5G+MBI/nedVs8zR+w27g==
X-Gm-Gg: AfdE7cluPLjXqNWmNKszP+2yIkjOOiSZ0WYp2qdV3UUuWvogRHFENzp2hFg98pUmLKx
	qXKO9a92dPcq6RTM8jCKgTt93dSQwog45Qvyaelgh0D/LIplEbVbItFeAkTjYoqwsizQiK9mvCj
	g92dRmuo/yc7sOpZyBwUA4Huslvg0Nc+2Nliijt44vNlDEC+/sHoui3qcGqqGQ4Yf4fDpHhnjeb
	RBTxYBr+rkLvNN4nm4ABcpwKSD+DDGwASCo+OYnh/MSNLGfsoYRECtPjfHve6Kv9NUb59Ubhspq
	9QsF/Po49FUMNiK3f/bRtxMFV0yKZ4Ci/YwUXpqqR/EecqfzYhaW3ME8GjpDcmK9+3Lk2e7lsTx
	0GnXtrTHuDeKY5SujWJO3N9sQFpxUFtMtsHJqK9vH8pH3+j3HLKkmuIv/wz716xgqXWI+k1z94P
	BduTu2ySu4rzAe81a2TeUcOK1hleNVV/aCuucEvueNyQGzgDVxklZQQERe7znpdU8tbMe+HH6WC
	l0=
X-Received: by 2002:a5d:64ef:0:b0:475:f0d1:eb57 with SMTP id ffacd0b85a97d-47f2dd1115fmr21221566f8f.50.1784093231746;
        Tue, 14 Jul 2026 22:27:11 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:666:1871:6dde:6657:c15a:3fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464caeffsm12505795f8f.36.2026.07.14.22.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 22:27:09 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
In-Reply-To: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
Date: Wed, 15 Jul 2026 07:27:01 +0200
Message-ID: <m2y0fcesbe.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Dion,

On Wed, Jul 15, 2026 at 02:52 +0000, G. W. Kant wrote:
> Hello list,
>
> Recently I encountered an interesting failure mode while migrating data=20
> from an aging backup system.
>
> The source Btrfs filesystem spanned several LVM logical volumes, each=20
> backed by an md RAID1 array. One of these logical volumes resided on a=20
> degraded RAID1 array, so I added a new logical volume on a new RAID1=20
> array and started migrating the data using:
>
> btrfs device remove
>
> During the migration, many read requests encountered unrecoverable read=20
> errors (UNC) on the remaining member of the degraded RAID1 array. The=20
> migration continued, which is exactly what I had hoped for, since only a=
=20
> small fraction of the media appeared to be affected.
>
> This made me wonder whether md RAID1 has, or has ever considered, a read=
=20
> repair mechanism.
>
> Consider the following situation:
>
> mirror A:
> read -> UNC
>
> mirror B:
> read -> OK
>
> During a RAID1 read request, if md can satisfy the read from the=20
> alternate mirror, no data is lost. However, this also represents an=20
> opportunity to repair the degraded copy. Once a read has failed on one=20
> mirror, the array has effectively lost its ability to tolerate a second=20
> read failure for that logical block. This window persists until the=20
> affected block is rewritten by normal filesystem activity, which may=20
> never happen on cold archival data. Repairing the degraded copy=20
> immediately may restore full redundancy while a valid copy is still=20
> available. Writing the recovered block back to the the corresponding=20
> block on the failed mirror would give the drive an opportunity to=20
> recover that location, for example by successfully rewriting the sector=20
> or remapping it if the write cannot be verified.
>
> In other words, the first successfully recovered read request could=20
> automatically become a repair opportunity. The repair could even be=20
> scheduled asynchronously, so the successful read is returned immediately=
=20
> while the rewrite is performed in the background. Unlike a periodic=20
> resync, this repair would be driven by an actual read failure, making it=
=20
> targeted rather than rewriting the entire mirror.
>
Yes, md has had this for a long time. Look at fix_read_error() in
raid1.c. It is called from handle_read_error() on any failed read. It
reads from a healthy mirror and rewrites the bad region on the failing
device, giving the drive a chance to rewrite or remap the sector. If the
rewrite fails, it records a bad block. md does this synchronously under
a frozen array, so it is not a missing feature.

The likely reason you didn't see it is that your array was already
degraded, so there was no healthy in-array copy for fix_read_error() to
recover from. In your case, you were likely able to retrieve the data
due to btrfs level redundancy, and md can't repair across arrays.

> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where da=
ta may=20
> remain unchanged for years, latent media degradation seems increasingly=20
> relevant. A successful read from the alternate mirror may be one of the=20
> last opportunities to refresh such a sector before it becomes=20
> permanently unreadable.
>
And Check/Repair is the right defense for cold archival data on large
drives.

> One advantage of such an approach is that it does not require md to=20
> decide between two conflicting copies. One mirror has already reported=20
> an unrecoverable read error, while the other has successfully=20
> reconstructed the requested block. The proposal only applies to this=20
> specific case.
>
> Has this idea been discussed before, or is there a reason why md=20
> deliberately avoids this type of read repair?
>
> Regards,
>
> Dion Kant

--=20
Best Regards,
Abd-Alrhman
