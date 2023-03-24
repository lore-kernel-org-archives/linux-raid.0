Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0D9C6FD1C
	for <linux-raid@archiver.kernel.org>; Fri, 24 Mar 2023 02:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjCXCOK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 22:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjCXCOI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 22:14:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8984C2A175
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 19:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679624001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MiwgDY257oOQIwLjn5xMzPpg2Z4UknXA+WM+3FFNf70=;
        b=i0df0tZdqV0ShaRAbfKFVQK0+M5HXVvHWhMMmHffrM5JFJE8wZ32xRfIvoQ8+J6iBf1A++
        Rlf0rNSHULNtNv0JyxX8JQyoME1JysL6VRfQYPnsTXnSHDpsTYHWvYb/6SZPMRNUws9oKM
        ZieJNVydXK422IL5uoVERSpry9Z41zk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-9u6lushaOd6D_FekZSuGSA-1; Thu, 23 Mar 2023 22:13:17 -0400
X-MC-Unique: 9u6lushaOd6D_FekZSuGSA-1
Received: by mail-pj1-f70.google.com with SMTP id b8-20020a17090a488800b0023d1bf65c7eso132845pjh.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 19:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679623996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MiwgDY257oOQIwLjn5xMzPpg2Z4UknXA+WM+3FFNf70=;
        b=rkS7cyp3t/zF1mrpTEK3ImW931mY2TXwMzF52zU+DK6S6HdTrfRLUVEb5IP1thveAQ
         BnX6NXTKYodQaP7mKqXPCORwKPJQnN/gF08QoRIaFslvWCkMfhiarg5MCb0HFmX64cW2
         9b0caafUZSGJk442GmYqcKF9zJxHJ4wUwxrUkLAFFMAmQPCYSK2b99dAjydiTAKAMs+o
         +TZyrYFA7TaOKoNl1R0GG6sDcOiaTUC/M5nuUp7QfCHiCmHX/BeWYRP8maKTheRJuxBF
         BjUHJNKdiVPk+/XxokCn6mCYJnvOBr1MV1/qR1UPLkM+aY3L5jiBViALuNLfvhsl6HiR
         kpRA==
X-Gm-Message-State: AAQBX9cTVpxcN7yrtdZfos3CpZHq7yspDnNvhjbRnqHaMXtjd+R/w3XL
        xUEML1NwVSLDYEDlQBf5ZMMDusCUEnCi2ElOzv4FFvK8cN74CFyAJfOeHHo7sAajj1+lt70hlNQ
        TH+XekLbn2Wx6LVzxGUGB33Chu3RFXPNxPDv1vA==
X-Received: by 2002:a17:90a:de93:b0:237:9ca5:4d5d with SMTP id n19-20020a17090ade9300b002379ca54d5dmr329008pjv.6.1679623996034;
        Thu, 23 Mar 2023 19:13:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350az1dZaobczDnEQRKDE5zY/0hxrN7C3sAhuCE7Zax2RUD+NDIfl6hP3QULlcMuNa9773+q0epFvmxiG5PpVfJo=
X-Received: by 2002:a17:90a:de93:b0:237:9ca5:4d5d with SMTP id
 n19-20020a17090ade9300b002379ca54d5dmr329002pjv.6.1679623995729; Thu, 23 Mar
 2023 19:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 24 Mar 2023 10:13:04 +0800
Message-ID: <CALTww2-bbwpo1O=ez8+CpMV+tvKFQ3onR65EU7mrnqs+6HP-cQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Few config related refactors
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 24, 2023 at 12:50=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Jes,
> These patches remove multiple inlines across code and replace them
> by defines or functions. No functional changes intended. The goal
> is to make this some code reusable for both config and cmdline
> (mdadm.c). I next patchset I will start optimizing names verification
> (extended v2 of previous patchset).
>
> Mariusz Tkaczyk (4):
>   mdadm: define DEV_MD_DIR
>   mdadm: define DEV_NUM_PREF
>   mdadm: define is_devname_ignore()
>   mdadm: numbered names verification
>
>  Create.c      |  7 +++----
>  Detail.c      |  9 ++++-----
>  Incremental.c | 10 ++++------
>  Monitor.c     | 34 +++++++++++++++++++---------------
>  config.c      | 43 +++++++++++++++++++++----------------------
>  lib.c         |  4 ++--
>  mapfile.c     | 12 ++++++------
>  mdadm.c       |  5 ++---
>  mdadm.h       | 21 ++++++++++++++++++++-
>  mdopen.c      | 16 ++++++++--------
>  super-ddf.c   |  2 +-
>  super-intel.c |  2 +-
>  super1.c      |  3 +--
>  sysfs.c       |  2 +-
>  util.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  15 files changed, 137 insertions(+), 77 deletions(-)
>
> --
> 2.26.2
>

Acked-by: Xiao Ni <xni@redhat.com>

