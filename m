Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D34C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 07:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239883AbiBHHNm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 02:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiBHHNk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 02:13:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808B1C0401F1
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 23:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24DDD61617
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 07:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801C7C340EF
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 07:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644304418;
        bh=yfHOuzgPnwZXqKkp03FUmYfIt2J9WQD0ZYHdzKSwCjY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kN+Cw6oTZvmmRRyZ9BR5AQvfqVYIGfhQo7qz4GiZugv+Ttjyh7bewmT88jbvQszco
         vXy0YdnmdtmxRfgnLRBkUwo3LkPwPyOzMUvYWV8aTWSGhucHO25uRfp/5Sl7ddKZX9
         grGQI7zfDq6iw0ojtmmoeBpok02uQz6s07rfuOt5aSQpjlPzGjiRZVIKxJE/3Upy1H
         0iVBJT+ULuCb7YvK7Zs83z67yg7LhaQoGqXGbD2ZMyjknaMV+oxWBdj8i+lofZRwT9
         jSn4Iu+LY+wjocZHHJTpMXd1fO6FFMi/ooWr65ot6RgslwCtnf4ynrdv2Yj3f+RHGO
         5vPnvKL6H5sBQ==
Received: by mail-yb1-f172.google.com with SMTP id 192so21064761ybd.10
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 23:13:38 -0800 (PST)
X-Gm-Message-State: AOAM531v9lGciN2XAz1i+1YjBbSbLHMokVMUdoeRg89RgvTf5RfCzwla
        w8+uLTzB4oXu2s3clXowcihUR8+ZNLDqF7vLQpQ=
X-Google-Smtp-Source: ABdhPJxwbDycXuQHGkmltUgkFmEpIzaC9rbF3anorr44qe6AVe5EoOxB6mKDMP7kUaU9I0jh1NBeW6yspiAq2TJHlZE=
X-Received: by 2002:a81:1d44:: with SMTP id d65mr3495652ywd.211.1644304417496;
 Mon, 07 Feb 2022 23:13:37 -0800 (PST)
MIME-Version: 1.0
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com> <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
 <20220131100609.000069a2@linux.intel.com>
In-Reply-To: <20220131100609.000069a2@linux.intel.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Feb 2022 23:13:26 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6pmT6XQrjgDRF6=gc7wBMNpQYsiH=GyM6hKZT=PC-V4A@mail.gmail.com>
Message-ID: <CAPhsuW6pmT6XQrjgDRF6=gc7wBMNpQYsiH=GyM6hKZT=PC-V4A@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 31, 2022 at 1:06 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Xiao,
> Thanks for review.
>
> On Mon, 31 Jan 2022 16:29:27 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > > +
> > >         if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
> > >             && !enough(conf, rdev->raid_disk)) {
> >
> > The check of mddev->fail_last_dev should be removed here.

I folded this change in.

>
> Ohh, my bad. I mainly tested it on RAID1 and didn't notice it.
> Thanks!
>
> >
> > > -               /*
> > > -                * Don't fail the drive, just return an IO error.
> > > -                */
> >
> > It's the same. These comments can directly give people notes. raid10
> > will return bio here with an error. Is it better to keep them here?
>
> Sure, let wait for Song opinion first and then I will send v4.

I think the current comment (before the function) is good, so this is no
longer needed.

Thanks,
Song
