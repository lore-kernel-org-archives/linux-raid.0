Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D21BA32
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709340127; cv=none; b=PDbJeLyAHBUBJVwvI+ZZkzdj5pNFsds9RRe/yEUvHXq3+acPtX0Uq0lsAR92R6YmQlCSS/Qj5Asn490LRRzWtE7YKU1xk5jhbNBUDEBm9hPe8jYRnxpzsgFJjJpK8wzKvVdayDCp3qQFxYxH9LhlPrWpoPF+ewZL23f5rYoCRIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709340127; c=relaxed/simple;
	bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8Rv0uJOkvfGgJnRJ/mY41w3zSXxMs250f5oaHWGvBvzrSdkNzzqcImF5++BzqyMBmOwtER+b8wi2AcMmlvmeaKcgV7ng4xwYVlS9Bok2oc8WYuBVCpliu7FuQzytH0GaxsSqMjPYMqdOZO+sIboLae+mr3GnZoc4rQGop2vDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCZnFjMX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCZnFjMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709340124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
	b=eCZnFjMXLMaBznlglKh0EscAg35wh6apCjkQJvt00tBDoOOIz+Zpmi+73Hhy0uX0K3TRkT
	QWl9asJcSqVCM6Qjno7N94oh506zRWPplnbpPIWvcyaJTtLUh0eIr0h7b6CmFpkhFecAfV
	hfe20QnsvxWTz5MZ7TYuPsXQPkBvdlQ=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-9RS59KKRP5-o0IWmpzknqg-1; Fri, 01 Mar 2024 19:42:02 -0500
X-MC-Unique: 9RS59KKRP5-o0IWmpzknqg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-299c12daea5so3082485a91.1
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 16:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709340121; x=1709944921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
        b=izQDdoRsPcHNd9b1+uo3gTZahohKma2uLvuhwgX/HUEwU2zzJM/j9QUUR9UsfPHVW/
         OHDFQ3jRo6cYdEooF3VZn2/NSP4jcX0RK4eYvsU/SEKg9qoeuYD0WVKYa3z3hZ0ZGuAT
         wG6Xza6MH/0wwWU9/E0bMPq8tYTgyZ3jIcNdQlIp0x8CCbCyuh+Cit8+x0nqNBtdkmiT
         zWLhO82T86OE/eHgsMW1ldmrHn9/QvAWPkn+F5BKlpRAIfVFs5mq4SmFqmIPb4PGDj3P
         gg/AsBJXeMpfZsmLeIs1jq+2FEaa1DrYnJXlkgrwuaBz0sQAyE7DxIYnysVQyOoqjAxv
         iKuA==
X-Forwarded-Encrypted: i=1; AJvYcCWmtA/k5NfkrokYytXQ8mzBuZzICqfMHqOcCJX+W/DpoIbe/7bsJe+6XQWoGV0+h5gnEir8mji+m/2SZcqRPHcXgmEDgh1cAcIKIg==
X-Gm-Message-State: AOJu0YzI7StRrm8onBinaE2NSxMSG52c/2bsQjHcEHDQTOgaUK5nUzBw
	oIotXzxDPDOUtOaiAYTPn18Jp6hoLLDV07I/bYXHVhSjkBiy5f8iTQYJWax5mX0s3H8Fpcz4nTx
	yIq7iBN9jHrwvpJXmkPgnhlVS5HPYcrBjQwT5MkJ1N07HGaVQOgjzaJefrX5VqUWGd2OmQWNND2
	Gj1DZ9e0NrXnX5c76mN0FjTId8+yfDBH3xHA==
X-Received: by 2002:a17:90b:514e:b0:29a:bdee:bc69 with SMTP id sd14-20020a17090b514e00b0029abdeebc69mr4954234pjb.8.1709340121690;
        Fri, 01 Mar 2024 16:42:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmQ5kRFjwCmVyags4kQc/4I/pGL7cgp2fA0CRlF1uj/1UejLX8I2lnBqaKZ+Iex0dKU0kd991J50MjJgaIO1Q=
X-Received: by 2002:a17:90b:514e:b0:29a:bdee:bc69 with SMTP id
 sd14-20020a17090b514e00b0029abdeebc69mr4954223pjb.8.1709340121393; Fri, 01
 Mar 2024 16:42:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301152128.13465-1-xni@redhat.com> <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
In-Reply-To: <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 2 Mar 2024 08:41:50 +0800
Message-ID: <CALTww29CwWtP5_jBJANGZyAAQw05g=ak6Cu5m+V8p=cJb4MgkA@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] Fix dmraid regression bugs
To: Song Liu <song@kernel.org>
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 6:28=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 1, 2024 at 7:21=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi all
> >
> > This patch set tries to fix dmraid regression problems we face
> > recently. This patch is based on song's md-6.8 branch.
> >
> > This patch set has four patches. The first two patches revert two patch=
es.
> > The third one and the fourth one resolve deadlock problems.
> >
> > I have run lvm2 regression test 5 times. There are 4 failed cases:
> > shell/dmsetup-integrity-keys.sh
> > shell/lvresize-fs-crypt.sh
> > shell/pvck-dump.sh
> > shell/select-report.sh
> >
> > And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
> > kernel too. So it can return back to the same state with 6.6 kernel.
> >
> > V2:
> > It doesn't revert commit 82ec0ae59d02
> > ("md: Make sure md_do_sync() will set MD_RECOVERY_DONE")
> > It doesn't clear MD_RECOVERY_WAIT before stopping dmraid
> > Re-write patch01 comment
>
> Unfortunately, I am still seeing the same deadlock in the reboot tests
> with two arrays. OTOH, Yu Kuai's version doesn't have this issue.
> I think we will ship that patch set.
>
> Thanks for your kind work on this issue.
> Song
>

It's a process for me to study :)
I'll have a test based on Yu Kuai's patch set and give the result later.

Best Regards
Xiao

