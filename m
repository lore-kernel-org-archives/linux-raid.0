Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41CE431A3C
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784138705; cv=none; b=t1fNgqX2exMdcPxgC0qS9VBIHTa4tCPgxt8nZA2Y82NZv2ldNhS8W4CxuSL9d01e3OB/Naykb4kYlWLXRaWUSiRgXOCCAQbhYBMcAfcPMSCGkMHFW0p2j5tDGCAefZKPGQukzgfnt6IlCtrQMUB30gMoUJv8j6C95czAmQ0kMtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784138705; c=relaxed/simple;
	bh=wq3DNJVd71uFlzTBu2l8GTTyuTaTPswa9Rx3r8XMRxg=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KiBk8DaAXFbuN+nTBOXSIBZ7KjOmtR4CHDvAfc1BoxlQT8wumuOY+FE2qpj12obBqqQOufGm3cNDYgH2lVZ/8GbfqTGe2BgEZEhaIy9NeD/k7njUzKiW51NNU2aY+er7pVd4cYI5fz+nPkDbSK9U1/pIdikmbp9iVY3mFCxkwKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qcGPi03k; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qcGPi03k"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1639626a12.0
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784138685; x=1784743485; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wq3DNJVd71uFlzTBu2l8GTTyuTaTPswa9Rx3r8XMRxg=;
        b=qcGPi03kMT+YUdHSK4RTzIKhqoPacHSLlCbm3vmrBZ36GjyUq98DulQxI5JS12Mr/J
         PCR3BGC8GQVQjsRSEvjv8DqtA58x4++WK4LijEia8Sc2G/FBk41WORP1f3nby+QH3sUe
         Jx3t94VOf0zOF0jZs2GkNP8BGgw2A4zATGjqKny+0NtTk7qmmW/+O2vpyIb4u2CHqShj
         NBRo9rvocuLNdxl4iGHcIpO4Us41bFu5VuT03aqi/MbqEUOvtXknAgO8MQYIshkXhmod
         Wszv+5lBFQsHGwAwVpYVM4SmUO5Uf5yC7LFD7sxM9Q1AtqOyx0yvSNoMIHkcO1BEq6do
         k4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784138685; x=1784743485;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wq3DNJVd71uFlzTBu2l8GTTyuTaTPswa9Rx3r8XMRxg=;
        b=LH05Dz6lziP22vJ+DCTDM8POtsCyT0tfMzuOaQM4UYwc+zv64mgEKsmG/qK+9Td8Y7
         tSYzc3pSP8TrI98iez+j55R863l3ILoaSnOQMJk/35tQl2olHzMP0gERb1qbrERl3J47
         GRTA0V/FzFiequoDc7qfoiy1mAhLd5LyybkeluiNDzjrnh5N9Vir26oexntNW9VIZpLZ
         Dm6REaPe3yvkhScrqkGIHp/2l1Y7VrBptq6drBLoLm/w7dz2RHbXHngXxIEEKP6NVjjp
         k0/z/SrfelGNixmX3pHyx35UPQX+mNAHM7ojGGoyLm04YN4U4Ul4hbYce0pgT3KnlXr7
         wuFw==
X-Forwarded-Encrypted: i=1; AHgh+RokoQSwl6pZACroaWfPbYp307ol7jFYYu28Nin4H1UH6t3TQI68E7D9R8pantrVdwZmtPHI4Kgq4giv@vger.kernel.org
X-Gm-Message-State: AOJu0Yyz9D3vODDM9pE19rCAxrIi2hQ2NukPyu1qOTsc6JYYAZfRuQyD
	fIVkRzgcL4u3YJi61pVGgo6o1ZyxE/kuJNr/tWs8kORL5h+cWcHepNrb
X-Gm-Gg: AfdE7cnqm/h4vYsQoG5mGKg3+fwcztxOfahVmxLf9r4go2DbGFOEYxiwFCJIt0Aa/Lc
	l6cDFFNlu+AlygeU7fD8w9HCBLXCoC45xw6zgWOL/edpTRaQBZg/rFkNbNTLBp5JR67vpD1SsDh
	988YyVeeKbY8FmGVWek5HngY0DBxO5QaN+y1gw6zDs43kUYArS21lzTyJafOQ31THt2NDRPY5/B
	zYRurewju99z7r1wBrLWdhI9tlfTnrDA4VA1VRWsaJ8sNr7HDN0wuSQi5oGiMKhI9HXzBL8BHh+
	cV5s2TvRQJgkztSqkdRCfuCpkV41Qmh5Vgnlqh7P5+nJi1VvRNFGulP7jd+atj7i1t9iRARvcdA
	jPSj4zH76WcGDrxs2+CMTlxMzfmMXZzYbO0e+JXdPsTHz02OXgjsz6en0etFaWFQiu5iV5Kb53S
	NEOVib059XuSS8IkRw6tdm9fpgkcQF9QUEIp92RQxOSVjgj2kCch2CjnmzJWRd9nKZ6M67Oy3id
	JiFR7VkXp3lXA==
X-Received: by 2002:a17:906:f584:b0:c15:a7b9:2ae1 with SMTP id a640c23a62f3a-c168bac608amr29365766b.6.1784138684573;
        Wed, 15 Jul 2026 11:04:44 -0700 (PDT)
Received: from f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box ([2a00:1f:e402:5101:59d6:a58:a64a:b7b4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c16871962cesm74457566b.25.2026.07.15.11.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:04:43 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "yukuai@fygo.io" <yukuai@fygo.io>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
In-Reply-To: <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com>
 <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
 <m2jyqwduba.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
Date: Wed, 15 Jul 2026 20:04:43 +0200
Message-ID: <m2ech4dt8k.fsf@f8410a22-cd7b-4baf-acf5-82353315d5e5.fritz.box>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 19:41 +0200, Abd-Alrhman Masalkhi wrote:
> Hi Dion,
>
> On Wed, Jul 15, 2026 at 14:13 +0000, G. W. Kant wrote:
>> Hi Abd,
>>
>> On 7/15/26 7:27 AM, Abd-Alrhman Masalkhi wrote:
>>>> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where=
 data may
>>>> remain unchanged for years, latent media degradation seems increasingly
>>>> relevant. A successful read from the alternate mirror may be one of the
>>>> last opportunities to refresh such a sector before it becomes
>>>> permanently unreadable.
>>>>
>>> And Check/Repair is the right defense for cold archival data on large
>>> drives.
>>
>>
>> I have been looking into your suggestion that periodic check/repair is=20
>> the appropriate defense for cold archival data on large drives.
>>
>> Before I start reading the resync code, I would like to make sure I=20
>> understand what repair actually does.
>>
>> Suppose all mirrors read successfully and contain identical data. In=20
>> other words, there are no read errors and no mismatches.
>>
>> Does repair simply verify the data and move on, or does it also rewrite=
=20
>> each successfully read block to the corresponding LBA on every mirror?
>>
>> The distinction is important for what I have in mind.
>>
>> My concern is not recovery from an existing read error=E2=80=94that is a=
lready=20
>> handled by fix_read_error()=E2=80=94but rather the long-term aging of co=
ld=20
>> magnetic recordings.
>>
>> If a sector is still readable today but is approaching the point where=20
>> the drive's ECC will eventually no longer be able to reconstruct it,=20
>> then a successful rewrite would effectively establish a new "write time"=
=20
>> for that sector. If the drive can no longer reliably store the data at=20
>> that location, the rewrite would also give the firmware an opportunity=20
>> to remap the sector.
>>
>> So my question is essentially:
>>
>> Does repair perform such a rewrite of successfully read blocks, or does=
=20
>> it only rewrite blocks when a read error or mismatch has already been=20
>> detected?
>>
> Okay, I see what you're getting at now. No, check/repair won't rewrite
> sectors that are read successfully and match across all mirrors. It only
> rewrites data when it encounters a mismatch or needs to recover from a
> read error.
>
> I think a full-array media refresh is a reasonable idea. but to my
> knowlage, modern drives already perform background media scans that
> refresh or remap marginal sectors, which covers part of this...
>

I'm not entirely sure about the media refresh part on modern drives...,
I'll have to look into that first.

>> Regards,
>>
>> Dion
>
> --=20
> Best Regards,
> Abd-Alrhman

--=20
Best Regards,
Abd-Alrhman
