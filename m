Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC011C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 03:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhLSDVO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 18 Dec 2021 22:21:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22229 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhLSDVN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 18 Dec 2021 22:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639884073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YxR/UyTOlBO2F/4PuCxDSNpPTC5l4cKM8QIFcw7NaN4=;
        b=KZ5GKu0m6QqZQ4wjPfjOwKL9EiBlpsLGkKs5EBcqEuuuaDDPEfMfP3nO8G9wkqomxfmCmY
        oQvRJl7RFd0nJFfTKtLmHQvSQJ13du38NEv5+yeuWnpak1SmWsbZHjYCjuYnBXfGwZBGif
        gAu7zoN8Sq2FXc36+/CElV4KQuW26Bo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-Qs9plmReNB2vGaPdy6bZiQ-1; Sat, 18 Dec 2021 22:21:11 -0500
X-MC-Unique: Qs9plmReNB2vGaPdy6bZiQ-1
Received: by mail-ed1-f71.google.com with SMTP id c19-20020a05640227d300b003f81c7154fbso4157316ede.7
        for <linux-raid@vger.kernel.org>; Sat, 18 Dec 2021 19:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxR/UyTOlBO2F/4PuCxDSNpPTC5l4cKM8QIFcw7NaN4=;
        b=dCYkf0lgR0TYhYznS8mb+YkUla7agT6BzDFZaopZBtJCRPRBpQRxkyo5oCWTP2BARv
         tui57BGJ2JV54SPC011pbNG6gmt5FaeI+HICeqG2jEiwQ+ksHXAH+s1yQEdf/37pwfRk
         rF00sIGSNiZy+UmsIy4VlifL/77/oAP9a5LYKGkwx6Y09dcFOfDN7XS99iiuKfNLL3VQ
         Tnj/gYPuKYKta9Z+Su1gKBIdTUItD79GrNUaAwB4ptyqsWfV0LTLZ/7ouZfkx5eq4oqa
         h8AMmo9DNjCYo9dUgydYzoIQeme8vEI+QVn/2pzT25pWp5NdBDb8jw5OinjYAmydroqF
         y74g==
X-Gm-Message-State: AOAM533ZE66dbYSwEwuCtp3WK+Kcf9pkpd+yp7ZMphnYN4SxZB7iCclV
        Ec4Pl/OxrIJ9qNrooTOjWjFUQUSqQFJ6KtD/n+5QAn9rCbL9gxC9SLMSPpB2GpuJSHyRSeEwjfz
        nsTV76TSd18fN++jhdd/m4HN6F+EM1F439au9Hg==
X-Received: by 2002:a17:906:458:: with SMTP id e24mr8396829eja.108.1639884070387;
        Sat, 18 Dec 2021 19:21:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyaBa3D2NfaW6isDVETdRy+cEMVNnIWQfXEDSmApqqnYMKIIlVKk3SGnBSPM0WJNIMnAbIig+WVb9wqKC2fBmo=
X-Received: by 2002:a17:906:458:: with SMTP id e24mr8396822eja.108.1639884070173;
 Sat, 18 Dec 2021 19:21:10 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com> <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sun, 19 Dec 2021 11:20:59 +0800
Message-ID: <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 16, 2021 at 10:53 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
> if a member is gone") allowed to finish writes earlier (before level
> dependent actions) for non-redundant arrays.
>
> To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
> is detected. This is done in is_mddev_broken() which is confusing and not
> consistent with other levels where error_handler() is used.
> This patch adds appropriate error_handler for raid0 and linear.
>
> It also adopts md_error(), we only want to call .error_handler for those
> levels. mddev->pers->sync_request is additionally checked, its existence
> implies a level with redundancy.
>
> Usage of error_handler causes that disk failure can be requested from
> userspace. User can fail the array via #mdadm --set-faulty command. This
> is not safe and will be fixed in mdadm. It is correctable because failed
> state is not recorded in the metadata. After next assembly array will be
> read-write again. For safety reason is better to keep MD_BROKEN in
> runtime only.

Hi Mariusz

Let me call them chapter[1-4]

Could you explain more about 'mdadm --set-faulty' part? I've read this
patch. But I don't
know the relationship between the patch and chapter4.

In patch2, you write "As in previous commit, it causes that #mdadm
--set-faulty is able to
mark array as failed." I tried to run command `mdadm /dev/md0 -f
/dev/sda`. md0 is a raid0.
It can't remove sda from md0.

Best Regards
Xiao

