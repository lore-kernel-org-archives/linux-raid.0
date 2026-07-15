Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12582242910
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784137294; cv=none; b=FiP7IepnPlkY2MWhZyzzbQ5KuO6UJMXZ78znx1P0fQGO4yL0TgLaAzUUIUGuWpHSgLn7OFGuun06S7DwQyyc7kbyTZ0QD6G1gaGwTraQwixErr594JjhnnsGTPoZx52o1s3rTRGZu7NhEk2H3nGYXJGma9SRMpXkDyNlFuyQLIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784137294; c=relaxed/simple;
	bh=PedPWIAGRUmoqreAAp6NVJcMBfbS9Bd5OgkqN/z9g40=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=j4ucRHsyDB74sDrC+bzFL7+s3pIza2XZ4Kv4cVexX2qzEB8oe+8chi6wLj7RmVDdr22+fuhJbs/HtbCuN984VJxa+knIn+cgAPjv2P/nqDHIqXaIS60tD6NK6b2eykUWEGYe2ojUlcaooX+yKr6hSWXPhZZITWQv4l/h5JGYnd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqDk7WlN; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqDk7WlN"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15f6d667bcso725554166b.2
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 10:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784137291; x=1784742091; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PedPWIAGRUmoqreAAp6NVJcMBfbS9Bd5OgkqN/z9g40=;
        b=VqDk7WlNbhJdrOaA2GcmPMOJHIUS9WqhlPQZ0y9aDMsg5/zRSeFSmGlJLhBKzunLLG
         Jfk2hf5xjtGPPZpebsv0zvtWgkXJ3AgMIUbDUReeXRjuHuo1kIhGxkn7L6Av197fvVyQ
         GIgAfvpa1nn+tbnvtcX+t7c5HiKHR59GXk/ROyTNC8s+xQ0ooxvqfr+K7ApKAt9NKCwR
         mDAo36RpL65IWMC89/uMWWJ0mbQln7XxdIvtJZah0tf63elclLQ0XyhscxMh04N1BCZm
         YQodfe9FIv02zjP7p+7qVLl0rHZNcOwMN/lctWoouoP83nYbLHh9Vka7HESTGttneXqz
         XJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784137291; x=1784742091;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PedPWIAGRUmoqreAAp6NVJcMBfbS9Bd5OgkqN/z9g40=;
        b=HC4H3Ru/in76JmMeQCgKeQIrF0Fw7QWMGZ5fIOT8czzzLa2DN88ZvPRb/9rLw3ZplD
         GpnUlZf9veeEK1fjVMJpGevBDQqpEDPO0wqkY5X8wW6ZQd1CEx4p+Oys2Gw/U8cBIIa0
         yvKyDzCSRfNpQIvoM0WSkI5Z1CacFtu/PUbPBNUWFhAk/zMBRzj+CtcZHm3kdYJuce5h
         C1PSfHUADo+MzQuzHzlRZ3GN7ZHA9d2tDx7h+kidIb21gqDco80nV6+QaCamzwEHhmaQ
         nNLKJy8Kho/qvierqkPmu1nYZ3CRCQHOZ9R9+i8ngEGc4lKwCvaGi+giszkTG8VNYdmP
         tnzw==
X-Forwarded-Encrypted: i=1; AHgh+RrcLozBxMa6Kn/rj/vykhzll3QPuA5FM8Pxfi28gMBzAK+nLWqeXoywNJ2nRq7DcIrSwHAwQnYe2NSH@vger.kernel.org
X-Gm-Message-State: AOJu0YwvmcLb/smMMEbOe9G5Asv6+6isQ1sgxwm/X3kBrtdPG6OydSpT
	rK25Bvp6kIDk0nLFh0QQl6EezjBMfNIfTrMUH24Cj9Oy9Nh+WmnNsVLB
X-Gm-Gg: AfdE7ckYLktnHJJHP9uFqdqd4gA/766k6NTzd5pm5Sj30zw/NeS2UNPKt5MXSgcMIKY
	6dNhmjfhP4MP+Awt85NpCdKk3n1bJQ7LkTDvpzH5fvUjCZoW/EhTPBQfOMatZgUHIDamgnxgMCC
	XOm+wse7rixNQCFM9FTEMbLVvnxlgGdVHSIImgUjQNbbynW+EBv/mzlrokHAg83+aUOdrrTeavm
	7frpRpfusjTaIv6zEez7j22Aqzwk7w4tyNFNnfCPv786ZOhn/v8mtrxnyi5m9b8NSufSGunWfd0
	ojVWCQvp9cQTIHPRdwUWJQBinuS5HBre/wmGqVacQ8//0hCv+y9g+ZTvaVDs5/ZxNGUOLyR4lHC
	Kt9Qj1Y7rLWvj/NwtZokkB9dfpXg3tUqpvhLGjCbsKn1pKONlPHKicd0t/3UDgiR4yEm4EnorNq
	9tKhEjVoKw53KAN/VEVUxLbeZXTfVWyhP/2aWM2gekw6wIH2a7zeaGiKwgebowWrUTofMIo8bAY
	S3v/yceIkzhSZnm0xgyenho
X-Received: by 2002:a17:907:940d:b0:c15:e956:f529 with SMTP id a640c23a62f3a-c167921c646mr259749766b.8.1784137291141;
        Wed, 15 Jul 2026 10:41:31 -0700 (PDT)
Received: from f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box ([2a00:1f:e402:5101:59d6:a58:a64a:b7b4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1687125f2asm74126966b.10.2026.07.15.10.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 10:41:30 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "yukuai@fygo.io" <yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
In-Reply-To: <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com>
 <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
Date: Wed, 15 Jul 2026 19:41:29 +0200
Message-ID: <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Dion,

On Wed, Jul 15, 2026 at 14:13 +0000, G. W. Kant wrote:
> Hi Abd,
>
> On 7/15/26 7:27 AM, Abd-Alrhman Masalkhi wrote:
>>> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where =
data may
>>> remain unchanged for years, latent media degradation seems increasingly
>>> relevant. A successful read from the alternate mirror may be one of the
>>> last opportunities to refresh such a sector before it becomes
>>> permanently unreadable.
>>>
>> And Check/Repair is the right defense for cold archival data on large
>> drives.
>
>
> I have been looking into your suggestion that periodic check/repair is=20
> the appropriate defense for cold archival data on large drives.
>
> Before I start reading the resync code, I would like to make sure I=20
> understand what repair actually does.
>
> Suppose all mirrors read successfully and contain identical data. In=20
> other words, there are no read errors and no mismatches.
>
> Does repair simply verify the data and move on, or does it also rewrite=20
> each successfully read block to the corresponding LBA on every mirror?
>
> The distinction is important for what I have in mind.
>
> My concern is not recovery from an existing read error=E2=80=94that is al=
ready=20
> handled by fix_read_error()=E2=80=94but rather the long-term aging of col=
d=20
> magnetic recordings.
>
> If a sector is still readable today but is approaching the point where=20
> the drive's ECC will eventually no longer be able to reconstruct it,=20
> then a successful rewrite would effectively establish a new "write time"=
=20
> for that sector. If the drive can no longer reliably store the data at=20
> that location, the rewrite would also give the firmware an opportunity=20
> to remap the sector.
>
> So my question is essentially:
>
> Does repair perform such a rewrite of successfully read blocks, or does=20
> it only rewrite blocks when a read error or mismatch has already been=20
> detected?
>
Okay, I see what you're getting at now. No, check/repair won't rewrite
sectors that are read successfully and match across all mirrors. It only
rewrites data when it encounters a mismatch or needs to recover from a
read error.

I think a full-array media refresh is a reasonable idea. but to my
knowlage, modern drives already perform background media scans that
refresh or remap marginal sectors, which covers part of this...

> Regards,
>
> Dion

--=20
Best Regards,
Abd-Alrhman
