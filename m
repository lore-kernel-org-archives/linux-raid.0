Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA6360BBB
	for <linux-raid@vger.kernel.org>; Wed, 14 Feb 2024 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707930764; cv=none; b=QPFvt8IgEe1zw1yXpG8hmUT3w2dSg+1bzwSLWXPAfZtkrzWzD8WVG0uQE9dpY/Efrcb/sLIe3ECvpyzD/oiVO4w3VZ8oNUkcIoMKjcKKOpGjSKkhIhn4LeusnfxwXXsK93uj63GS5oCN5/Pjm/chdfR5mX46g7ISLSNTZXh41Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707930764; c=relaxed/simple;
	bh=iV3BWBLDh98P53mhL1PjpPtk0jVUvdMz+Wb9RRmSm9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oDn0zOzJO2G6529UxYvhpNC/DnvCoWWr9zCcHGZKpdPvG+2A0EDT4m2KF9JtxJsOqGgcgdUQJgukntfSK3APvmq3ZbQiGb5qoAUGEntwIeyGrqASTiCLG5x2RgWz5/HGPb6KmsajN9JFmKy3qw8EFTkDq/ijIGxZSNmb65q+r3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+SP6B33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+SP6B33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD576C43394
	for <linux-raid@vger.kernel.org>; Wed, 14 Feb 2024 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707930763;
	bh=iV3BWBLDh98P53mhL1PjpPtk0jVUvdMz+Wb9RRmSm9A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s+SP6B33s5UmPDqeNBKMoOnixk0Q38lLGz00cnKs+fORHoBD6ozrG2jlF4TCPgyDd
	 nRTWP2VL1aqfH0Rs7j4wFOAwYFfkmowv2Xin8ubxgCNtfKLwS8CFFIL+oGMP4B7v7R
	 Cs1p5ixnjXULlELNYF2PQSJE7jXXw0jC1rgHV8hNai3Qw9NUnRMbFxc1srLajA6Y8x
	 1csIgX0jSbAaqHmtzUrS2uXbUm3upKCy99UZEjeRDNPxOq+UCWULsQotWmL9myfqFD
	 X5xapmSz0uBXMXvvQadfPr6W9uF0bE7vuBITzjMpXz+b5hV5cBCfMgpi8HbUv8Lc52
	 +KGgAQdgRNvXA==
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d71cb97937so54935595ad.3
        for <linux-raid@vger.kernel.org>; Wed, 14 Feb 2024 09:12:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQJX3MaXhUNhIClbt0tF9DeoF9JcSV2IOuHLUtOt2BZH1e6J8Q3JCOW3DWtZP5EQiQIBZhofVO2lNnXL0j+xlX6uJ3jg8EhQ9JGQ==
X-Gm-Message-State: AOJu0YwkKWxjGScZ0jqUa5V8LI3J/3SK+MJhyLow97N0RklYy7shtluV
	ZQo6iS6TBehJJN9wzQhd5cANV1TiNc7UOzCBWw2y7+01gQWsDB5ErmqMV3unZEu/Qy8iFonL1DQ
	qxagQ87jUdSgu1JenllyiQW9pXH0=
X-Google-Smtp-Source: AGHT+IF1rZvOfzy1OOQBsx8GzrSfuDtLPDGheRQyjTL3XlbyRf1wannbCP0k+WKnxEqh0KddgyfDl45qh1Bl/G0udfI=
X-Received: by 2002:a17:902:db01:b0:1d9:620d:d40c with SMTP id
 m1-20020a170902db0100b001d9620dd40cmr3345262plx.51.1707930763452; Wed, 14 Feb
 2024 09:12:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
 <5ead30f5-31db-4175-bae7-e776a0be07ff@linux.intel.com>
In-Reply-To: <5ead30f5-31db-4175-bae7-e776a0be07ff@linux.intel.com>
From: Song Liu <song@kernel.org>
Date: Wed, 14 Feb 2024 09:12:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6=CRqK4y4OxWVoHwbtxE7M+rA0uFHV5D0UE8Z=CvEBng@mail.gmail.com>
Message-ID: <CAPhsuW6=CRqK4y4OxWVoHwbtxE7M+rA0uFHV5D0UE8Z=CvEBng@mail.gmail.com>
Subject: Re: Fwd: The read data is wrong from raid5 when recovery happens
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: xni@redhat.com, guoqing.jiang@linux.dev, heinzm@redhat.com, 
	linux-raid@vger.kernel.org, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 14, 2024 at 7:16=E2=80=AFAM Mateusz Kusiak
<mateusz.kusiak@linux.intel.com> wrote:
>
> Hi Xiao,
> I'm bringing back this old thread to ask if there is any progress on the
> topic?
> If I'm correct, this is not yet fixed in upstream, right?
>
> We have multiple issues submitted for multiple systems that we belive
> are related to this behavior.
> Redhat backports hotfix for their systems, but the vulnerability is
> still present on other OSes.
> Is there a plan to have it resolved in upstream?

I think 45b478951b2ba5aea70b2850c49c1aa83aedd0d2 have fixed it.
Do we still get reports from systems with this fix?

Thanks,
Song
