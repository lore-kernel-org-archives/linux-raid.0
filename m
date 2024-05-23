Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C7D12B16E
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475173; cv=none; b=pIAadNsrCIVo6jt5PecuDfzmVr1hKGskXQFSDr5N2AlXpC1aM6dy1cfQlFXzKEsUsu2rHzWKv+w7xqfLS/kSI9ZQYvwZ04UxzNzCrQcptylmVkwY7CbiTtHtW2HFxVVJRYJaYldORLo+kEeMyNAObfarD82Qq6O2SVrEjEE4cdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475173; c=relaxed/simple;
	bh=DNULVP4x8ZxncFaKoIgCJ2NIwMYXa5EDn6MXczAZoW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qHvWVfuj+1p0/Z7246YmsMQYqUTaPK/PcywggAHsZ1VA2D5pOg6WIlQyU4M4xiuj1eS9cfhL/2JS/7kBqoSUR2lN66V/wn3eDhyFhQNQovgQeagVTMu4XoAO8EDAmZ1gE6Te9Exp5gZ0syKGCfoCnPGLQOecQeNvNq7ymn21ZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JFrhIEqq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JFrhIEqq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716475170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=++WVYAP1ppKB7VWfzpqHHEPhTu44zJ3SqT+XBGTLun8=;
	b=JFrhIEqq+sO3lE5hNP+5r1FqLQpIW7U6Iv9jYJxO2ZlVs1NyP1Gm7nh9n9icUxA4Z4JuzU
	A1KqUdtNDQwNk5nKqXXlzfTfkB4aGkuC5HhxbivVjFsOJTj6MCXLLI2ksh1tU3xfTJ9SVA
	54p9+KuvHs+PCrzhcc2w7jhiM6w00wA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-F2HZJNC_NFqRvRBl5cmBTg-1; Thu, 23 May 2024 10:39:29 -0400
X-MC-Unique: F2HZJNC_NFqRvRBl5cmBTg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2bde806870aso547646a91.0
        for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 07:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716475168; x=1717079968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=++WVYAP1ppKB7VWfzpqHHEPhTu44zJ3SqT+XBGTLun8=;
        b=t8TM4p6RN161zPMKUNd4+CY5wVPetWmvHrMOYVDCpDWR9Zh2pfV/jnqqnvTHNkZmE8
         ppmBPS9U6wDFF7yYRMLF6sWrwdL5jzEaUMKBLw2MfYNaEwaXTiRdNJwZN95J4Thgocap
         0sV7H7CKfsdQN/GnxHTstz0Atvl3K5Yh3vMmDVGFrAmzueDUjcHBYB48BNupU5xaD2fr
         uBWSMJomG+uke6HUYsI2/0HIBiPOFcboKDVptEYcuAhtp1FMuBEqExmEfX70P+AeEBGH
         AseTonGoaweOyE99x8EucygQZ0KhHSoyRZTCyFClWGUz6Ij1lVxYeUikJ6YkiXLQ+YF1
         lmaQ==
X-Gm-Message-State: AOJu0YzKw/z4nf89vCU0b+fLnQGYWX/t2da9h9FwLmMh1DZcHlOuWNuF
	jJZ4+I5bUk/SIbaBgna9rnJy0HBVJD0Sbmw6CQdC5mozlkcHdsLqpy0HY4OPQDROsVHji7ljrcy
	7KGYCBlm2DNLiGNZFioh/3bZ7DFyoEROyYHjzZMDY52Vbkvj8Y+IulrRdM/P8YRg+MIB8SpTWfy
	aFdfLk1x0/qPTn88gpkggLVOSBayWo35sgmQ==
X-Received: by 2002:a17:90a:db87:b0:2b3:c011:d28c with SMTP id 98e67ed59e1d1-2bd9f5a716cmr5084344a91.48.1716475167789;
        Thu, 23 May 2024 07:39:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5FzFX0phqWCDITDkkhmyn7bAm7J3i5wcYqYgIvxjauunwrkzrd+aj3qoVU7puKePA6QCG8oeADvAmuzpGzkE=
X-Received: by 2002:a17:90a:db87:b0:2b3:c011:d28c with SMTP id
 98e67ed59e1d1-2bd9f5a716cmr5084324a91.48.1716475167403; Thu, 23 May 2024
 07:39:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240522085056.54818-1-xni@redhat.com> <20240522085056.54818-5-xni@redhat.com>
 <20240523162614.000049be@linux.intel.com>
In-Reply-To: <20240523162614.000049be@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 23 May 2024 22:39:16 +0800
Message-ID: <CALTww29Y+DMpvCqzOSk+Y4LZYz2oU5Sdh5WnTXZZA-ekCMTVRw@mail.gmail.com>
Subject: Re: [PATCH 04/19] mdadm/tests: test enhance
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 10:26=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 22 May 2024 16:50:41 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > There are two changes.
> > First, if md module is not loaded, it gives error when reading
> > speed_limit_max. So read the value after loading md module which
> > is done in do_setup
> >
> > Second, sometimes the test reports error sync action doesn't
> > happen. But dmesg shows sync action is done. So limit the sync
> > speed before test. It doesn't affect the test run time. Because
> > check wait sets the max speed before waiting sync action. And
> > recording speed_limit_max/min in do_setup.
> >
> > Fixes: 4c12714d1ca0 ('test: run tests on system level mdadm')
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  test          | 10 +++++-----
> >  tests/func.sh | 26 +++++++++++++++++++++++---
> >  2 files changed, 28 insertions(+), 8 deletions(-)
> >
> > diff --git a/test b/test
> > index 338c2db44fa7..ff403293d60b 100755
> > --- a/test
> > +++ b/test
> > @@ -6,7 +6,10 @@ targetdir=3D"/var/tmp"
> >  logdir=3D"$targetdir"
> >  config=3D/tmp/mdadm.conf
> >  testdir=3D$PWD/tests
> > -system_speed_limit=3D`cat /proc/sys/dev/raid/speed_limit_max`
> > +system_speed_limit_max=3D0
> > +system_speed_limit_min=3D0
> > +test_speed_limit_min=3D100
> > +test_speed_limit_max=3D500
> >  devlist=3D
> >
> >  savelogs=3D0
> > @@ -39,10 +42,6 @@ ctrl_c() {
> >       ctrl_c_error=3D1
> >  }
> >
> > -restore_system_speed_limit() {
> > -     echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
> > -}
> > -
> >  mdadm() {
> >       rm -f $targetdir/stderr
> >       case $* in
> > @@ -103,6 +102,7 @@ do_test() {
> >               do_clean
> >               # source script in a subshell, so it has access to our
> >               # namespace, but cannot change it.
> > +             control_system_speed_limit
> >               echo -ne "$_script... "
> >               if ( set -ex ; . $_script ) &> $targetdir/log
> >               then
> > diff --git a/tests/func.sh b/tests/func.sh
> > index b474442b6abe..221cff158f8c 100644
> > --- a/tests/func.sh
> > +++ b/tests/func.sh
> > @@ -136,6 +136,23 @@ check_env() {
> >       fi
> >  }
> >
> > +record_system_speed_limit() {
> > +     system_speed_limit_max=3D`cat /proc/sys/dev/raid/speed_limit_max`
> > +     system_speed_limit_min=3D`cat /proc/sys/dev/raid/speed_limit_min`
> > +}
> > +
> > +# To avoid sync action finishes before checking it, it needs to limit
> > +# the sync speed
> > +control_system_speed_limit() {
> > +     echo $test_speed_limit_min > /proc/sys/dev/raid/speed_limit_min
> > +     echo $test_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> > +}
> > +
> > +restore_system_speed_limit() {
> > +     echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
> > +     echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> > +}
> > +
>
> Hi Xiao,
> control and restore functions are not used or in this patch. if you want =
to use
> them in next patches please highlight it in description.
> Beside that LGTM.

Hi Mariusz

The record_system_speed_limit and control_system_speed_limit are used
in this patch. restore_system_speed_limit has been used before my
patch set already. So I don't need to change it.

Regards
Xiao
>
> I will loop over the patches and take as much I can. Looks like there are=
 no
> conflicts.
>
> Thanks,
> Mariusz
>

