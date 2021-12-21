Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C72C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 01:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhLUBlG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Dec 2021 20:41:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231151AbhLUBlG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 20 Dec 2021 20:41:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640050865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nHrb/QTjJ0savnD4xoQrP1LHg/MEFE4F4YpIUUouFsw=;
        b=Y12uF+DKijUru+6LTWFpTtPLHJQfbrt4YrKdmSBwdjf9FAqBVTJa1gxea3/oF+I0Q+R/7r
        XeRcAdFLyDBJHUL5mNu/906QdOG+bpLjaasyy1w8ikHMd6q4GeI1IKBe6hzfvx7VXX9QV3
        l67XP9hAvVdPQPU/cCcauGZRlEcMh1Y=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-DoKNwI5EOEiwT4BK9EwBpA-1; Mon, 20 Dec 2021 20:41:02 -0500
X-MC-Unique: DoKNwI5EOEiwT4BK9EwBpA-1
Received: by mail-ed1-f69.google.com with SMTP id h22-20020a056402281600b003f839627a38so5180158ede.23
        for <linux-raid@vger.kernel.org>; Mon, 20 Dec 2021 17:41:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nHrb/QTjJ0savnD4xoQrP1LHg/MEFE4F4YpIUUouFsw=;
        b=q5sTqqfcxG7SHsUle/gwe0Ch6CxdwkJ9Ccs6ThnAaxVc1PNGQWVYxm+fQ1hNLv4tB8
         MT5Yb29PM/nBDZi7zY1byeWbT4vKFv4AmlhbhYiVsRbPn8S3NDMcN2c1E4yktTU4k5g3
         tnQlRCPkoxVcSu4T7ui9g3nyY+8m+eeHIf5WSca+Z5EeIekkMJclu244u9+5P7UOtZdZ
         Mejjcqz5DW7f7/Zr8T4z1VqRvLD0r2o2nMyihZHhlIVwxVGeJL7NDo5SXcyaXqrnzl7z
         mbgvIc9vEK0iw0gjZl7QEOWqpHo9IuFT2IywZmB/0KqibhnRe+CZXpy/NQqsrwAN6kC1
         npRA==
X-Gm-Message-State: AOAM5336iDawI/6ebDVn0hNzAgaZI3YZifcmWau6TZUmW3g9xFuetsuT
        tDgo/fR35Z3p1JeGUUsns/jpH8Rq0RjKQHYDV/q1LNizYbM5Z32snns3CglT6MMFvgD0bKEyYwV
        csqzFJbE0+Dnhr+5TLGxBFClk+WCmEtZVp1Pe5Q==
X-Received: by 2002:a17:906:b04c:: with SMTP id bj12mr697407ejb.716.1640050860987;
        Mon, 20 Dec 2021 17:41:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6uY8WokUBLJk4vdIxamZZEbSZYm3PE1xLvdrQ9mTqKoZvU19XIin0unyAy99gXLLqTp9GuM65WNfHxRPA/pw=
X-Received: by 2002:a17:906:b04c:: with SMTP id bj12mr697398ejb.716.1640050860767;
 Mon, 20 Dec 2021 17:41:00 -0800 (PST)
MIME-Version: 1.0
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com> <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
 <20211220094519.000013d0@linux.intel.com>
In-Reply-To: <20211220094519.000013d0@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 21 Dec 2021 09:40:50 +0800
Message-ID: <CALTww28wmeuXA5V4ReTLjH-=AZ3VbR-qHEbBMEktHRU8PQQiVg@mail.gmail.com>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Dec 20, 2021 at 4:45 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
>
> On Sun, 19 Dec 2021 11:20:59 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > > Usage of error_handler causes that disk failure can be requested
> > > from userspace. User can fail the array via #mdadm --set-faulty
> > > command. This is not safe and will be fixed in mdadm. It is
> > > correctable because failed state is not recorded in the metadata.
> > > After next assembly array will be read-write again. For safety
> > > reason is better to keep MD_BROKEN in runtime only.
> >
> > Hi Mariusz
> >
> > Let me call them chapter[1-4]
> >
> > Could you explain more about 'mdadm --set-faulty' part? I've read this
> > patch. But I don't
> > know the relationship between the patch and chapter4.
> >
> > In patch2, you write "As in previous commit, it causes that #mdadm
> > --set-faulty is able to
> > mark array as failed." I tried to run command `mdadm /dev/md0 -f
> > /dev/sda`. md0 is a raid0.
> > It can't remove sda from md0.
>
> Did you test kernel with my patchset applied?
>
> I've added chapter 4 because I'm aware of behavior change.
> Now for r0, nothing happens when we are trying to write failure to
> md/<disk>/state.
>
> After the change, drive is not remove too, but MD_BROKEN is set and
> any new write will be rejected. The drive will be still visible
> in array (I didn't change that). Should I add it to description?

Thanks for the explanation. I understand now. But I still have one question.

Now for a raid0, it can't remove one member disk from raid0. It returns
EBUSY and the raid0 still can work well. It makes sense. Because all member
disks are busy, the admin can't remove the member disk and mdadm gives a
proper error.

With this patch, it changes the situation. In raid0_error, it sets MD_BROKEN.
In fact, it isn't broken. So is it really good to set MD_BROKEN here? In patch
62f7b1989c0 ("md raid0/linear: Mark array as 'broken'...), MD_BROKEN
is introduced
when the member disk disappears and the disk is really broken. For raid0/linear,
the raid device can't work anymore.

Best Regards
Xiao

