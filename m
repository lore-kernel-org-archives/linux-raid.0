Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1C517E9
	for <linux-raid@vger.kernel.org>; Sun, 21 Apr 2024 02:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713667593; cv=none; b=ic0sfOFGJAwFZJ1r5MzdwEHMamSr9Asu9cKkFmbMskCXfxm8waP395bT6YTKx2nZnGQHhv6bLdX6NzTVczs/jgWddBJ/PC9KL7xNCsByWiHoQVXaF7H13qMEVvHUTYgcY6t7IaV5u/4MMNcoqMNq3umorL04nkJ50O7O9wdvGl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713667593; c=relaxed/simple;
	bh=RYuMWr/GoVfMF/FTGpmi67b+qBZ51B+AcxrlNleWE10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q6i86OU9qNt6QKO+1cIvdXtqhSGAi6cmn4SwXTR3dU6bSyjvt7KTTOy19G1hSk0NkimypftitqNYNtPsh2BvsGfd7opssQe/qO/O1soUOip1bqW9EhjkwySt5Moy7j5T4FJkfkRvp7tgKccDnWkowf8snklIKhOg/kyyB/QcCQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0dHSLzd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0dHSLzd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713667591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T5qpoBSnq3xLwOBqi9hVwHAwLsDCgeSnvOVR++67ffo=;
	b=W0dHSLzdcK0+3spwvP9Ioz92RiPNVlsnoHg/ODsnV/fRfEEK3CBvxXF287EOS+TKUohKgP
	R/oBOQibBAGfNCS8aNIZjdiOKnxVbRNPHu6EFBIZZETSKgvIEEmAFptTQ4DvPOT+mrjCr7
	5sxfrOyIU9GGYIkw5xq0SwTbzPbFiis=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-lQj9Z3L1PyOzU5ctnD65lA-1; Sat, 20 Apr 2024 22:46:29 -0400
X-MC-Unique: lQj9Z3L1PyOzU5ctnD65lA-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5ac8b684f26so4710004eaf.2
        for <linux-raid@vger.kernel.org>; Sat, 20 Apr 2024 19:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713667588; x=1714272388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T5qpoBSnq3xLwOBqi9hVwHAwLsDCgeSnvOVR++67ffo=;
        b=IqCvoM3z/oFS+O7tQIMqW2w1yPQNm/fX+tt3193hfepTMMxhIAeiDQTZCT0JB4APPU
         UPPoKh2DtcXYj7YmcMghYT10R2ATuC0qvAGWvJ836eX2sv4eiu1UrpYE7fEMmMy16S8e
         5rQmNYUGC/NKXcuDyXxcTIgV7LfQSTqffe+T7yZ9NaZtiQAG0hZ+CA3TAaUNzvacnNOb
         /BR4YWS56L/Fixo2694g+XF1RP8tJD4lGaaE3uMeWYLqOUon8nr6XmUiua4Dp3NfCPaw
         FY9X/KFyb8DJqo2iZu3xWrFJ7R1kTqbdzyEMiD0VB2+YuCDNDTlEo6nO97o/ldCtXnMa
         hjdQ==
X-Gm-Message-State: AOJu0YxxXau1YVelrt7mjyf/9tN1E1lqulh6diABLBqQtEjc37bnL5Z9
	+i8wL8yAgcQrUV1hV6FVkHlS2LOXnRJO0D6+Xs7q8TXsbzYclKr/Um1kpGNeNOoO7NZVbBO/5Qv
	9cXeTT9XaD2gYwBZbbM2tWyi7O0MZzhmb52QH1AX0xbh44AP5m41rgOk/ZUff360CWAttw0IISX
	ApRSk5FNdAvNT3QHx60xN9nhlsj5nuShQ1zQ==
X-Received: by 2002:a05:6358:7b95:b0:183:5c59:6455 with SMTP id n21-20020a0563587b9500b001835c596455mr6045568rwg.0.1713667588590;
        Sat, 20 Apr 2024 19:46:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDNlHVYv6DtCXs4MY6wDLLis8V7c5vIV13T78o2+uBO6MoGqhGJ/25VyJa6IA0Zd1PGAjoB7CUqw/Q3iqc2jQ=
X-Received: by 2002:a05:6358:7b95:b0:183:5c59:6455 with SMTP id
 n21-20020a0563587b9500b001835c596455mr6045546rwg.0.1713667588350; Sat, 20 Apr
 2024 19:46:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-2-xni@redhat.com>
 <bf7edcf8-9cb8-4349-ae34-a9ca5fa9cf17@linux.intel.com> <64f751b0-542b-474e-aedf-7d2b80f41d2d@linux.intel.com>
In-Reply-To: <64f751b0-542b-474e-aedf-7d2b80f41d2d@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 21 Apr 2024 10:46:16 +0800
Message-ID: <CALTww2_pih57aNZxrFwrRNwZU8LKF6AW0AKKDqgXLtc0CZQ1gw@mail.gmail.com>
Subject: Re: [PATCH 1/5] tests/test enhance
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org, 
	yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de, 
	mariusz.tkaczyk@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 3:30=E2=80=AFPM Mateusz Kusiak
<mateusz.kusiak@linux.intel.com> wrote:
>
> On 19.04.2024 09:16, Mateusz Kusiak wrote:
> > Hi Xiao,
> > one small note from me.
> >
> > On 18.04.2024 12:23, Xiao Ni wrote:
> >> @@ -309,6 +322,7 @@ print_warning() {
> >>   main() {
> >>       print_warning
> >>       do_setup
> >> +    record_system_speed_limit
> >>       echo "Testing on linux-$(uname -r) kernel"
> >>       [ "$savelogs" =3D=3D "1" ] &&
> >
> >
> > I feel like record_system_speed_limit() should be called in do_setup() =
rather than main().
> > Saving current system settings is job of setup.

Thanks for the suggestion.

> >
> > Thanks,
> > Mateusz
> >
>
> One more thing. Feel free to add tag "fixes".
> I broke this behavior (lowering sync speed) in 4c12714d1ca0 ("test: run t=
ests on system level mdadm").

Ok, no problem.

Regards
Xiao
>
> Thanks,
> Mateusz
>

