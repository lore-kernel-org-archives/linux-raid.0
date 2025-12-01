Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF9E1DE8BE
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 14:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764598203; cv=none; b=NLN9GMC28IyOh4R8zJcdyyhoHlDc8c/6ivCxzeBEoFfyDi+RIy0CXnBEGg99jl2sTV/GCFUJL0lRVTgKPOttoR992PVeo4fBwLA67MuN/N/IylhJW+iTVFmrVYrRflguZ0aOvDc1ohYPMOEWPfNcPPAcXfFxbQw3SIfgNiPGW7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764598203; c=relaxed/simple;
	bh=9N2Br49cfTTo33IutbTBwA0nRKCP3MxmMyD3p/hCdrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lwGO6oE6evnoah3uHxg+kORcwnfZR7hEyjzbJTAofdS+lSN/J5ALNRzVXOBQ8y5+mn0tvoinohGeQduSYgc3zWPS93no+2EoOHKiADq3a5v5AQV3FZCexKppMXyCigZKSWn4M0QoQ1EVmOvC7bdgEUu9++Hqdhh8uftazE9Cw2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=UaeQTlTO; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="UaeQTlTO"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c52fa75cd3so3182728a34.3
        for <linux-raid@vger.kernel.org>; Mon, 01 Dec 2025 06:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1764598201; x=1765203001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9N2Br49cfTTo33IutbTBwA0nRKCP3MxmMyD3p/hCdrk=;
        b=UaeQTlTOOpE9UetgBbE1UWF5Pl4tK1TjAcI4ng88cBx8yWE9+VBpkAzAeGs7BQAmcZ
         on2xVCVYnh61WC4UxZJO11i1FZy59PEc6NJ4iugKlq1sQjfEsTrGMR2mTMDWU/xbSVAO
         Mqd1Bokim5Z8DLpmni2I/QOnPdZxVzyq6mcVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764598201; x=1765203001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9N2Br49cfTTo33IutbTBwA0nRKCP3MxmMyD3p/hCdrk=;
        b=ja2Td/l9NnpKms/mB52wdEAp268RT2vVExveuPTYVvDT77+jTUcXPMiDx+e2bC/ZJf
         hJcv8VvsI0vMS0q4T4aHi3t4uahVFK28Sfp03WGuDfW2vJbS5PnwKq+Rgp6QPR+ZdLLQ
         72IhzoLAXxTlBjwli0B3wd8o/Ohi9JPvEQw0Q+nmI24NTjr+Qf+DeVj8oKaybybHDYVJ
         D6LULgjoo3K56tgTFazcSnl+0hYsRPEWbLpbivwYTTYNg31wkiE5C2DKZwquyZ63Y0oP
         Dq4jAhTWEiy2BnRStfH1sJMxn8/ko6CEmzE3QyShPKnc6WLcLOpK2K4YUMTgPTpHQbfE
         f/6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXlV0ufqiI3QHPrUB4fQ26gFucISfQsIYYf+gHdu+xFjWuBFeHXGbEG2yCKUVnAxgwMJYgCvI3jepbh@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0lDX7W7RAA3Y+1OWYSaEAHLPqLBJWn31P6cb297GLF3E2c8u1
	gUo5MX35wVRGJMoRL9kFRCpW+laMsS6/S8zl6nUGf7FuJx8LlI5NM74DaZ4YQTNB7uDVDazMLDu
	rWwGTZ5VX8SNGuO0zxU8vHkoSw/0NR4/ogtpCpmS/TWgjW2uHk35hyq8=
X-Gm-Gg: ASbGncsIMVCAV+IlYqcPpXiXPKJSXwqcuUd6K1PsKn2RAS+/NIssw1WBCKaVVV9Mmjz
	Hu7ae1oywwcAhZyGyb3GXJ3octPFij4/D15KcS4iAzbI1wWvBHIKQfu+qzBJqwdrPgIiKtuXl/e
	praJocCcdOftVza8tk4Qdyr47Y31V54kfPf9PEbRSRgot0P2iwVCHP+y0s++bZ953zCOVNW3a/7
	HNfJ7WIdqaBl8F87RSuNX1PMVE/Hp5DiT2zJVPbqFEGV4VOSWmhPakwnHTUpeUgJD1ntU1Sd0ka
	HQFIiJfOZ2Zw0rESjZrnn1t3q3tgu7bW9uP06Z+A4CQPUALVqQRgzTLZIO9qYcQ=
X-Google-Smtp-Source: AGHT+IFRUfgSsf/TJkHeANSH4dfp2CZgqrYY4eMQAE8vHEGMie1cY6/g5n24t2kOWvlcuoH0jVrzNRVVuINc92eyik0=
X-Received: by 2002:a05:6808:67c6:b0:43f:2464:ee55 with SMTP id
 5614622812f47-451128f91d5mr15599176b6e.20.1764598201100; Mon, 01 Dec 2025
 06:10:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <aSXBwBoBZp9t890U@gallifrey>
In-Reply-To: <aSXBwBoBZp9t890U@gallifrey>
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Mon, 1 Dec 2025 09:09:50 -0500
X-Gm-Features: AWmQ_bm5--99g4Aj2GUCOOkdASboV31CU7h7n5xreYibAeG3yoF9MLp3qxHFWQE
Message-ID: <CAO9zADyCd_rDa3WEYCU1tw2pNv6PxdJdDkPuJwM437Wv3CRYNg@mail.gmail.com>
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 9:48=E2=80=AFAM Dr. David Alan Gilbert
<linux@treblig.org> wrote:
>
> * Justin Piszcz (jpiszcz@lucidpixels.com) wrote:
> > Hello,
> >
> > Issue/Summary:
> > 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
> > drop out of a NAS array, after power cycling the device, it rebuilds
> > successfully.
> >
> > Questions:
>
> > 3. Are there any debug options that can be enabled that could help to
> > pinpoint the root cause?
>
> Have you tried using the 'nvme' command to see if the drives have
> anything in their smart or error logs?

Thanks, I did check on this and ran the usual tests, everything passed
- as part of this thread it was mentioned that some consumer NVME
drives have these issues:
https://github.com/openzfs/zfs/discussions/14793

For those using an multiple NVME drives with BTRFS/ZFS, are there
known good NVME drives that will work and not have this consistent
timeout issue where the drives drop offline?
