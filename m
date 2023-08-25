Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A209C3DA6F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Aug 2023 09:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbjHYJBl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Aug 2023 05:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjHYJBZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Aug 2023 05:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067E5CD2
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692954034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlrJS83Wv3/IOuPkkk2Ks+EO0kINO2ZS+xxLo09mt/U=;
        b=OIs5+uSQZbaNAF8uyoeX/UMkkNgMfuJ+UupTzEjMFSPSrIOm/wcv668p/KnpL/BgA8UOSA
        FssYZNC3cLf1dUY3UEBa4W4g5zplNNGdbeYozsdff5ZsAKBOFy+uvvmZgKeQ7d0LJ+2JaF
        pYzpvzk/NSmzE5oVo/Un+QO6Nk4hx/U=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-K4h1XnWDMWCXxm9n5DMhGA-1; Fri, 25 Aug 2023 05:00:32 -0400
X-MC-Unique: K4h1XnWDMWCXxm9n5DMhGA-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a85cc69960so736308b6e.3
        for <linux-raid@vger.kernel.org>; Fri, 25 Aug 2023 02:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692954031; x=1693558831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zlrJS83Wv3/IOuPkkk2Ks+EO0kINO2ZS+xxLo09mt/U=;
        b=SP+q3dlT1nxqBxNhv4TUGVHvGPLg650VzjNdPthnnHF8btDQOn8lObBLwNmvAebtKV
         7RZ2Im1zUvtsc9WdSUkidgdFjZZigtruf9fabRy54+Ju3HBy2Sbv+BSxwFVmQ/3r6OXl
         79oB9Wa6wY1Cn5A4GqE+pcjYyNdp1cWBcL4i7+vtMh5VcByRlG77kuyA9umWwth8Eo26
         GN1HmuqYyZiOfA+EELXKjGB9lrAbFQ3XHtfP/qzOQ2sxfN0OuoIO0j3uEOQo3slQ5ykI
         dS4kIYdsNdhNKvNJPozQBzoaicCXkbfcRT6Sqil0QuwpjNyKPT6eWe3SwBEqMs6PvhO7
         IKlw==
X-Gm-Message-State: AOJu0YwEBDTo21wgHVpHulry3BuMLDNp4y2+vcDcJVHQjLbmjZcTZIet
        TXlJab89X7ds6PjCNEse1DkmOBkSWtRgZK7E+EI/0o8uT5tdgfYxTJG/SamLCN5L0aQ3y++ViEO
        0WBftOhy6VPhPasv+uE6S6gaIT6+mJ5BXRPVGAV/X2GWBjAk2ovg=
X-Received: by 2002:a05:6808:1892:b0:3a4:f9b:b42e with SMTP id bi18-20020a056808189200b003a40f9bb42emr2733924oib.26.1692954030870;
        Fri, 25 Aug 2023 02:00:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUPi6dXRb4FMRHQIEyj7pglS468JB3bSXomKnMtqZy8BzIkAv5V4FME12KHlBaC9slw8RdAe7UEU9DFY1xJxQ=
X-Received: by 2002:a05:6808:1892:b0:3a4:f9b:b42e with SMTP id
 bi18-20020a056808189200b003a40f9bb42emr2733913oib.26.1692954030658; Fri, 25
 Aug 2023 02:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230508133010.42313-1-xni@redhat.com> <20230823160905.00004d3c@linux.intel.com>
In-Reply-To: <20230823160905.00004d3c@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 25 Aug 2023 17:00:19 +0800
Message-ID: <CALTww2-sb5VnN2cN1=wRiEnrdXavgK9v8TQ7DO52KJaG2mfPHg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Stop mdcheck_continue timer when mdcheck_start
 service can finish check
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 23, 2023 at 10:09=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> some nits:
>
> On Mon,  8 May 2023 21:30:10 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > mdcheck_continue is triggered by mdcheck_start timer. It's used to
> > continue check action if the raid is too big and mdcheck_start
> > service can't finish check action. If mdcheck start can finish check
> > action, it doesn't need to mdcheck continue service anymore. So stop
> > it when mdcheck start service can finish check action.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  misc/mdcheck | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/misc/mdcheck b/misc/mdcheck
> > index 700c3e252e72..f56972c8ed10 100644
> > --- a/misc/mdcheck
> > +++ b/misc/mdcheck
> > @@ -140,7 +140,13 @@ do
> >               echo $a > $fl
> >               any=3Dyes
> >       done
> > -     if [ -z "$any" ]; then exit 0; fi
> > +     if [ -z "$any" ]; then
> > +             #mdcheck_continue.timer is started by mdcheck_start.timer=
.
> > +             #When he check action can be finished in
> 's/he/the/g'
> I think that there should be space after '#' but it is preferred to use /=
* */
> Could you please send v2?

Hi Mariusz

diff --git a/misc/mdcheck b/misc/mdcheck
index 700c3e252e72..f87999d3e797 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -140,7 +140,13 @@ do
                echo $a > $fl
                any=3Dyes
        done
-       if [ -z "$any" ]; then exit 0; fi
+       # mdcheck_continue.timer is started by mdcheck_start.timer.
+       # When the check action can be finished in mdcheck_start.service,
+       # it doesn't need mdcheck_continue anymore.
+       if [ -z "$any" ]; then
+               systemctl stop mdcheck_continue.timer
+               exit 0;
+       fi
        sleep 120
 done

How about this one?

Regards
Xiao
>
> Thanks,
> Mariusz
>

