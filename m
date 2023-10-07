Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8421AE95A61
	for <linux-raid@archiver.kernel.org>; Sat,  7 Oct 2023 12:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343891AbjJGM7U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 7 Oct 2023 08:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343741AbjJGM7T (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 7 Oct 2023 08:59:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2085EB6
        for <linux-raid@vger.kernel.org>; Sat,  7 Oct 2023 05:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696683514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xePKmRXKwqmLU5zq8Pg2yNTstk/bnGJz2w2w01qkT+A=;
        b=DJ+nAzaSfeJKkl7oH2EXYVt0io+Pmx1XCgbNrZaB0jsZlXMMiaFL06WnXDNi9TN5sfnojG
        b7kviXXOH6nF+l1KN3X38Iiw/HD9XfD/VJeQazo7rrjodPzu8tS9CynBZBXSGgkk8I7nT2
        sOR4GFwsTgvskiRJT8U/VwFXhkBWiq8=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-zu96sFAbOfu5tOnYmYgf-Q-1; Sat, 07 Oct 2023 08:58:31 -0400
X-MC-Unique: zu96sFAbOfu5tOnYmYgf-Q-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-57e460ac8c3so3885872eaf.0
        for <linux-raid@vger.kernel.org>; Sat, 07 Oct 2023 05:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696683511; x=1697288311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xePKmRXKwqmLU5zq8Pg2yNTstk/bnGJz2w2w01qkT+A=;
        b=KALEutpZud+KxhA/KaLZuaBGMt//obcyOf9O2GrT6J2Mteh938TTvOLvi507pUmcKM
         VbSLarLHPBDwOlBEKxZyI6YMYHbkBGqFoDZldin2UAaHm8YDKTKutdyVQH1hvMjtLBIG
         MeY+d2lQ6vUolLa8PlmsgJYJfmZdQqh3QSYWtmFOV8NKViTc935f3m9tCe0fHVB/3Tgb
         9mqmG6UrBm4FxRCcUSohKHS2IXj14NItXQWlzpPmS7crSRMx3aJ5F0Cvyi3eJdNiOFMV
         VEpi1t7wzh3mtigYQL6u6n0uwPp+NgYrn6v1sFwBR30FYbsToHkKRCboxLaE94W1GKG7
         5+ig==
X-Gm-Message-State: AOJu0YxdXZgO2Prkdl3c0/A7Vn1p+kK5cvYkm8f/m3dBNrZ2vd7QjQcC
        cT8MY2gcctvSIOvleLxHRgSBs1qpzRjdMJD4X/pHSFdJmcjP3G8K7HdHxBf505Ou0tE1FKvTDp5
        LpaOhfBGVdyKnu2QhpnlntORmAZ5VCT3DLKoMMw==
X-Received: by 2002:a05:6358:7e49:b0:143:8984:4ffa with SMTP id p9-20020a0563587e4900b0014389844ffamr11434838rwm.26.1696683511163;
        Sat, 07 Oct 2023 05:58:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvQMiYilT5xIRAIQa0LKAVomFwQQW4m8GtBh/p560FSy2h9XVp+J2eAkVZZ9pj8qiqPoP5yLN0fHEl10UdKbE=
X-Received: by 2002:a05:6358:7e49:b0:143:8984:4ffa with SMTP id
 p9-20020a0563587e4900b0014389844ffamr11434826rwm.26.1696683510818; Sat, 07
 Oct 2023 05:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230927025219.49915-1-xni@redhat.com> <20230927025219.49915-5-xni@redhat.com>
 <20230928115323.00001e3f@linux.intel.com>
In-Reply-To: <20230928115323.00001e3f@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 7 Oct 2023 20:58:18 +0800
Message-ID: <CALTww28fTVM1tUwZQrDKoqYPrweCtNW9cqAVgpUXf4zktnqMfw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mdadm: Print version to stdout
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 28, 2023 at 5:53=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 27 Sep 2023 10:52:19 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > The version information is not error information. Print it
> > to stdout.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  mdadm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mdadm.c b/mdadm.c
> > index 076b45e030b3..0b8854baf1aa 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -128,7 +128,7 @@ int main(int argc, char *argv[])
> >                       continue;
> >
> >               case 'V':
> > -                     fputs(Version, stderr);
> > +                     fputs(Version, stdout);
> >                       exit(0);
> >
> >               case 'v': c.verbose++;
>
> I agree with this change but...
> This one is risky for users. I can realize that some users may check that
> from stderr because it is how we implemented it many years ago.
>
> I remember that I removed calls to mdam --help from dracut in the past:
> https://github.com/mtkaczyk/dracut/commit/d3d37003dcecdf01f6ae0f4764d74cd=
035aade73#diff-f2466410e3aff8aeba95038d29b1652581c97d8d7d9feb4011d7b8bc103d=
e1b0L64
>
> And I can see that it does redirection "2>&1". I think that in general th=
is kind
> of problem is handled this way, so overall I ready to take the risk of ch=
anging
> it to stdout by default.
>
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>
> Thanks,
> Mariusz
>

Hi Mariusz

Sorry for being late to respond. I just came back from holiday. Thanks
for the suggestion. It's right that it's risky to do so. I'll drop it
in the next version.

Regards
Xiao

