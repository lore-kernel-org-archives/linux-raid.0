Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502511BDD3
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 06:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716879526; cv=none; b=lZKJCc+KfexJlVQrop3RTSviKPjJRm3XmQ0eyZ6TFTj51kuNQi3qJ0VhXsbms/ZVA4/gng05MtJZMiS6QRefIXSIwEfZsHkR9M8ljB2qBt8CQORZ+Wz1N3I8nQrjEwB+UjdrweVe+eB8gzA4MCcQtNP9Jh88nyaWZIxnGrgMwOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716879526; c=relaxed/simple;
	bh=nSe5hKWR6ar8HI5mdpnsZD8tMmIPZlQOfIYXR7E43GE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cTKoHEhdKCjoYMwjdNUtUKDjlv7aL7/5tHIrveK3rEzicG+DXP7Ei7OeZz+aF9PbPSQD4sCaLaA6W0rgnS/O9sP2qrzJhlhGjo2R/Hpr/0RdEr8p/rpmWy9HsgwqE+zVcLwy4P7KPwS965EpOOUEfzkyp3/AsaJkuZspJsEd2i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CVtMapbo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CVtMapbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716879523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sz9ssNXBfWZE9j7WKRZv7TYhSAr6Aotft+mAZXEDaow=;
	b=CVtMapboWiGcLXcpH1wm6kBEOx1HcUY6WAodLHOssK+vq9dDxetbLYz77xDziqlYk+nzdn
	Z4Ow64a6SIxSaJn6LBsRivgLV+3mgFes5jHJIcZkwlx0tUYDQV6aaUVunm7fUNlNxcDvzx
	ZV+/QA+wZTZtMhOJE+rKtuegZFSj4NM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335--jy1bWtsOAW_uWR0HRVkrA-1; Tue, 28 May 2024 02:58:40 -0400
X-MC-Unique: -jy1bWtsOAW_uWR0HRVkrA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-68194ee2242so408218a12.2
        for <linux-raid@vger.kernel.org>; Mon, 27 May 2024 23:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716879519; x=1717484319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sz9ssNXBfWZE9j7WKRZv7TYhSAr6Aotft+mAZXEDaow=;
        b=wa4a1bPkV34IsBKsh1yrYJZw3kGrszU/oYavHSn56NPPfExIMZE3HbSVW+h0lenweG
         XyKi/MdxPvdKPpAln5GcyWxqyBPAzixjACxwOJh5slOU7F/q6XTSfWz89+h0aZ5npKUq
         ykq6NfLOwJB0lsJEyLY4Tk2M9R6VWMPvTNHXwgxdLN5ZH+tdiT4aUg/vWJNxPqq3VtL0
         qZ65EZ2BnlF2pdMOHq/6qTKxGOW9rAqVLH4joThMtRJ86ouHAz4iKg2Orqv//SJYJv/I
         mWytHK0cFbL7g8SByHe38ZVoM8YXTwDDtWZUtgnLH6Zr3df7zPSA5xrCSC/EbFV8wNr+
         Bubg==
X-Forwarded-Encrypted: i=1; AJvYcCVroAg9b561xUs02nMItoR3O2VFCBAvBWs6R7ih7egOKha1+Xbrt0+oE1MbRAYP4BUnL08kNxiUKgkGjMg6OQ9o2NfyIflSPlcJlA==
X-Gm-Message-State: AOJu0YzDklRX0y5GMWUe7QcZ4AlEhmn/DlbvNhQyppOApAUVk/kjqOPA
	YerZYVEhP5UhSqjtfG0y8cpTuWG7B7G6V2cbCjISTunRtCTXS8rlayt/omBMnFGoyOF8yuS/OVc
	mAYoGveWhVI13UXDyUJ19m6MBia9iXJ9F0C8jc+A62KMYXFGTOmv58WSEe153dh8L25EKfEWCzX
	L8ETKjmPru5zB8i2snOrzCBNoZDw5qnAgZe8izL1Tvj/Sg8CiW/w==
X-Received: by 2002:a05:6a21:3483:b0:1af:acb1:84bb with SMTP id adf61e73a8af0-1b212ccf8b8mr13034696637.4.1716879518771;
        Mon, 27 May 2024 23:58:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2G2NDa3g1lZXre4mifyxpBFY4alYIv5/xxND7DEWZNR150bKE6bnqnD6dUnB4nSNcRXdHj2J1zCQFYq+xAP4=
X-Received: by 2002:a05:6a21:3483:b0:1af:acb1:84bb with SMTP id
 adf61e73a8af0-1b212ccf8b8mr13034690637.4.1716879518388; Mon, 27 May 2024
 23:58:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528022903.20039-1-xni@redhat.com> <c198d2ff-bcfc-4355-bc97-3804e8dc0ec1@molgen.mpg.de>
In-Reply-To: <c198d2ff-bcfc-4355-bc97-3804e8dc0ec1@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 28 May 2024 14:58:27 +0800
Message-ID: <CALTww2_nrGE2Zdok0fTT713uSWysGrzCZu=vzXh5OdgQV-wwew@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/platform-intel: Fix buffer overflow
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: mariusz.tkaczyk@linux.intel.com, blazej.kucman@intel.com, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 1:10=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch.
>
> Am 28.05.24 um 04:29 schrieb Xiao Ni:
> > It reports buffer overflow detected when creating raid with big
> > nvme devices. In my test, the size of the nvme device is 1.5T.
>
> I always like the error message and example command pasted, so chances
> are higher for affected people to find this in search engine.

Hi Paul

Thanks for the suggestion.

mdadm -CR /dev/md0 -l1 -n2 /dev/nvme0n1 /dev/nvme2n1
*** buffer overflow detected ***: terminated
Aborted (core dumped)

nvme0n1                        259:3    0   1.5T  0 disk
nvme2n1                        259:5    0   1.5T  0 disk


>
> > It can't reproduce this with nvme device which size is smaller
>
> s/It/I/?

Thanks. I want to type "It can't be reproduced" :)
>
> > than 1T.
> >
> > In function get_nvme_multipath_dev_hw_path it allocs memory in a for
> > loop and the size it allocs is big. So if the iteration number is
> > large, it has a risk that the stack space is larger than the limit.
> > So move the memory allocation at the biginning of the funtion.
>
> =E2=80=A6 move =E2=80=A6 *to* the b*e*ginning of the fun*c*tion.

Thanks.

Regards
Xiao
>
> > Fixes: d835518b6b53 ('imsm: nvme multipath support')
> > Reported-by: Guang Wu <guazhang@redhat.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   platform-intel.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/platform-intel.c b/platform-intel.c
> > index 15a9fa5a..0732af2b 100644
> > --- a/platform-intel.c
> > +++ b/platform-intel.c
> > @@ -898,6 +898,7 @@ char *get_nvme_multipath_dev_hw_path(const char *de=
v_path)
> >       DIR *dir;
> >       struct dirent *ent;
> >       char *rp =3D NULL;
> > +     char buf[PATH_MAX];
> >
> >       if (strncmp(dev_path, NVME_SUBSYS_PATH, strlen(NVME_SUBSYS_PATH))=
 !=3D 0)
> >               return NULL;
> > @@ -907,14 +908,13 @@ char *get_nvme_multipath_dev_hw_path(const char *=
dev_path)
> >               return NULL;
> >
> >       for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
> > -             char buf[strlen(dev_path) + strlen(ent->d_name) + 1];
> >
> >               /* Check if dir is a controller, ignore namespaces*/
> >               if (!(strncmp(ent->d_name, "nvme", 4) =3D=3D 0) ||
> >                   (strrchr(ent->d_name, 'n') !=3D &ent->d_name[0]))
> >                       continue;
> >
> > -             sprintf(buf, "%s/%s", dev_path, ent->d_name);
> > +             snprintf(buf, PATH_MAX, "%s/%s", dev_path, ent->d_name);
> >               rp =3D realpath(buf, NULL);
> >               break;
> >       }
>
>
> Kind regards,
>
> Paul
>

