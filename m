Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90392C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 22 Oct 2021 00:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FAD60C49
	for <linux-raid@archiver.kernel.org>; Fri, 22 Oct 2021 00:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhJVAMX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Oct 2021 20:12:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232216AbhJVAMW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 21 Oct 2021 20:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634861405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sB72wAoIUuYd0j10XciX9LUFxZ2h5DO71FAZrvIaI4I=;
        b=E8eqn1UVxYnlzheLJJ4iUFjgi4OpsERxgXd1KCTKU3TBP05Rm1Zjo3Jvab4SuuhqMWcnVg
        049ZsuCLO2BN4eX+KX0gcuFTBsEG604dn0lwCQakEPwW7/zvQacCy4ySFm3Tob0x2r2Toq
        ac4aoX0Jd9oUA6Y+wcT+3W4b2G28EWI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-DsBWkIyNOTW6AJOJ3bJGoA-1; Thu, 21 Oct 2021 20:10:04 -0400
X-MC-Unique: DsBWkIyNOTW6AJOJ3bJGoA-1
Received: by mail-ed1-f69.google.com with SMTP id b17-20020a056402351100b003dd23c083b1so158179edd.0
        for <linux-raid@vger.kernel.org>; Thu, 21 Oct 2021 17:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sB72wAoIUuYd0j10XciX9LUFxZ2h5DO71FAZrvIaI4I=;
        b=tYmmjtvVF0plzY/NW44xjNaaEk8qlE38KqC/KNEPTbE6lR45htHbs8GEdmF2bXR0P9
         O3Zym2K4Jlfk3DcLXCkT7+fyNwbSeC063M4+3LDNMe+zTB0GrlLF83E/TIn0dWy7REyp
         BkBJiltTJwLxP3tHUG/WqUhyUPBMKzXnPujJQ9Vo/0ot5cXYOTIGHfBP+wXrllcsCdzi
         ookabGSNzpSEIIaDu1nNmHfGbteSj921tBnCWhNv0PB1zxVwe74caAu2YdpOlpJYlB24
         m+eGYMb6IjhPOZG/rBNm6kYU8fn3ojv0tlXUqMUA+XheQ813AHhnAsWKYWzHjmcC2f4X
         uAUQ==
X-Gm-Message-State: AOAM533FCF4tnIEWXf86H5ajtRpgiMolzorNqwdV3TCEIVooGN7B0vLZ
        Mhg5SMUtmjRSVzoKFeBaa5eCIjUNF6Ie9RkMWvWkIFjRoA1TEmzT/p/AaKydIy6hBnstJfFAhQc
        6zF5puhGa16vvcwirzqtCVs2Togmy9VYJwA1wfQ==
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr11330861ejc.239.1634861402896;
        Thu, 21 Oct 2021 17:10:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNWoNadJE7/Xb+D3DXAkmYKfvgoDLzSF5vjuYXtz5gqEQWWduDlLqIYkM17sl/m0PmSkrtEe5QkQoss9EZmbs=
X-Received: by 2002:a17:907:774d:: with SMTP id kx13mr11330846ejc.239.1634861402745;
 Thu, 21 Oct 2021 17:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <1634740723-5298-1-git-send-email-xni@redhat.com> <974e4fc3-f85c-bfa7-176e-a440fbdfc001@linux.intel.com>
In-Reply-To: <974e4fc3-f85c-bfa7-176e-a440fbdfc001@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 22 Oct 2021 08:09:51 +0800
Message-ID: <CALTww2_3e8-U-s4wkURv=zPATWrKSKcjWgK4EXSV-YtAbMNrkA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, Nigel Croxon <ncroxon@redhat.com>,
        Fine Fan <ffan@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Oct 21, 2021 at 5:13 PM Tkaczyk, Mariusz
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> On 20.10.2021 16:38, Xiao Ni wrote:
> > +             char dv[32], dv_rep[32];
> > +
> > +             sprintf(dv, "/sys/dev/block/%d:%d",
> > +                             disks[d*2].major, disks[d*2].minor);
> > +             sprintf(dv_rep, "/sys/dev/block/%d:%d",
> > +                             disks[d*2+1].major, disks[d*2+1].minor);Please use snprintf and PATH_MAX instead 32.
> > +
> > +             if ((!access(dv, R_OK) &&
> > +                 (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
> IMO not correct style, please verify with checkpatch.
> should be: [d * 2]

Hi Mariusz

I ran checkpatch before sending this patch. The checkpatch I used is
from Song's git
(https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git). It only
reports one warning
like this:

WARNING: Unknown commit id 'db5377883fef', maybe rebased or not pulled?
#34:
Fixes: db5377883fef (It should be FAILED when raid has)

total: 0 errors, 1 warnings, 25 lines checked

It's right. Because the commit is from mdadm git. Do we use different
checkpatch?

> > +                 (!access(dv_rep, R_OK) &&
> > +                 (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
>
> Could you define function for that?
> something like (you can add access() verification if needed):
> is_dev_alive(mdu_disk_info_t *disk)
> {
>         char *devnm = devid2kname(makedev..);
>         if (devnm)
>                 return true;
>         return false;
> }

Sure, it sounds better. I'll do this in the next version.
>
> using true/false will require to add #include <stdbool.h>.
> Jes suggests to use meaningful return values. This is only
> suggestion so you can ignore it and use 0 and 1.

<stdbool.h> is a c++ header and it needs libstdc++-devel, I don't want
to include one package only for using true/false.

>
> and then check:
> if (is_dev_alive([d * 2]) & disks[d * 2].state & (1<<MD_DISK_SYNC) ||
>     (is_dev_alive([d * 2 + 1]) & disks[d * 2 + 1].state & (1<<MD_DISK_SYNC))
>
> What do you think?

It's good for me.

Best Regards
Xiao

