Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F4B801
	for <linux-raid@vger.kernel.org>; Sun, 25 Aug 2024 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724615667; cv=none; b=hVFZb5+yN6YmgaMrrRw6XNIREooaa36OlaGiwtJheMeso22BPuC1TR8qo9ozUjCZHYCDhop1UemCVa0A0E6L/u4sdLxvaqZINBiZ42LCKo+qfHYP/pYolIv/Qp/BFEXH3fLlF/U31oMMbNw9TiqdQ0xBfgUDA2OEq+Xtn/5cGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724615667; c=relaxed/simple;
	bh=SZDhFSz5cGQqOrGnjwqK1octDVUeO0+e9a3ispg7DMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h6fN/YVqIz55yiecE3fx96GJ+st1bjf/Rlnzmysa2h/wIAneYIV5MXC+DHMG80HPDTrwVDCjAyIoB9MoRyBjpFqT3TydGHnt2nb3r/MF8i0fMLzr1DT5TbZMv04AoladmIMVSI4qaPnH990ZiSZVvvjFk+oy0Mfye6Rf4dAc9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CWPU8w/Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWPU8w/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724615664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SZDhFSz5cGQqOrGnjwqK1octDVUeO0+e9a3ispg7DMk=;
	b=CWPU8w/Zr3X2eu8X1zdOj4DmiTeGOlTzQkKqaLhBjb253nfbA3zY1B+qOSPuhaIxzbzWDV
	ZxjJpD0VCsCU1h4aJ9YXqP8bHfaaymltVBjMarwrwR1VV+qAfEVgop/P35N8JMpF0xxugq
	szzXoqyiVVS5moMUdDjCcOq6ETIn3UY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-UbPLv0UPNBurWIEtfjotSA-1; Sun, 25 Aug 2024 15:54:21 -0400
X-MC-Unique: UbPLv0UPNBurWIEtfjotSA-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2f508065daeso6344021fa.0
        for <linux-raid@vger.kernel.org>; Sun, 25 Aug 2024 12:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724615660; x=1725220460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZDhFSz5cGQqOrGnjwqK1octDVUeO0+e9a3ispg7DMk=;
        b=PIcaBAxPKckITrbe6viUB9JyJoHVC6n9h+nbVazIK1H7USutIcCj0BfMUMEgLJRmLD
         pRNyvniJiBDXPO4s+68ZjJYdCJ1HHz9bOlr3Z8eGdFT5P1NjZ3tcl9uH1PCKScrqSWRu
         aeJN5kvCFcAuSDqhk94g846uZRwieOLEgg3jVaMNVWDW/JVaD4Uk0yiQD7RkvV7DqMIc
         oAaykFqjtykGjCcoD00sdyaG5aj6UWJZZugtiNvNGmFlnrAYwscLBaoKFzEgXTVUEihX
         E4Y3bCf33l9MFDl97DpvMwZXAXG+e3bxp/A2oqF+hNnIzJnv1KFA04ESRdS1aBv+S9Zk
         uCFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAGNrn+3Ssy9n0JQKyf8kY7x8REG96yETKP3kWrh80//vwg/PeKeEQm/AbJs0Y0kgpDZ/Eiio7mwF9@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmw7pX4TTqexxva0yVXzGfhHrqhLO7tSkNTnxbzFM0uvxwWt+a
	/udwzDWJ7muMfBgChYVgEkU9n1K0K9tlG98i21/MmW9OeMVtd6SO4Kquw7wi2tA8De4sjWJZ+3R
	DWWnQSM3rpDEkrInMP8sjsSo2ThUlyVUn8SJiLt6HRLy+u7eiXRgFpnEAeEpvc97c/X7uwejamz
	wDHPLyua7aAcpStSUAggUaBvNvQat161anFA==
X-Received: by 2002:a05:651c:88a:b0:2ef:2843:4135 with SMTP id 38308e7fff4ca-2f401ef2f8bmr42009981fa.22.1724615660294;
        Sun, 25 Aug 2024 12:54:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRR2RFGKYRIqaHIAtJY42+DmWhiPgyqSAg1f8W2qWMs4UGf31c1qZMTWRheB2QuKBk9MdDY6hnbgQqeIx520A=
X-Received: by 2002:a05:651c:88a:b0:2ef:2843:4135 with SMTP id
 38308e7fff4ca-2f401ef2f8bmr42009901fa.22.1724615659703; Sun, 25 Aug 2024
 12:54:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814143414.1877505-1-aahringo@redhat.com> <20240814143414.1877505-9-aahringo@redhat.com>
 <2024082459-neatly-screen-9d29@gregkh>
In-Reply-To: <2024082459-neatly-screen-9d29@gregkh>
From: Alexander Aring <aahringo@redhat.com>
Date: Sun, 25 Aug 2024 15:54:08 -0400
Message-ID: <CAK-6q+hqhitE=_Lw2kd3kN3-hrquK550-d4jHgrkUX1uqj=zDg@mail.gmail.com>
Subject: Re: [RFC dlm/next 08/12] kobject: add kset_type_create_and_add() helper
To: Greg KH <gregkh@linuxfoundation.org>
Cc: teigland@redhat.com, gfs2@lists.linux.dev, song@kernel.org, 
	yukuai3@huawei.com, agruenba@redhat.com, mark@fasheh.com, jlbec@evilplan.org, 
	joseph.qi@linux.alibaba.com, rafael@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, lucien.xin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Aug 24, 2024 at 1:18=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Aug 14, 2024 at 10:34:10AM -0400, Alexander Aring wrote:
> > Currently there exists the kset_create_and_add() helper that does not
> > allow to have a different ktype for the created kset kobject. To allow
> > a different ktype this patch will introduce the function
> > kset_type_create_and_add() that allows to set a different ktype instead
> > of using the global default kset_ktype variable.
> >
> > In my example I need to separate the created kobject inside the kset by
> > net-namespaces. This patch allows me to do that by providing a user
> > defined kobj_type structure that implements the necessary namespace
> > functionality.
> >
> > Signed-off-by: Alexander Aring <aahringo@redhat.com>
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

note that I added the comments the kernel test robot pointed out. [0]

Thanks.

- Alex

[0] https://lore.kernel.org/gfs2/20240819183742.2263895-9-aahringo@redhat.c=
om/T/#u

