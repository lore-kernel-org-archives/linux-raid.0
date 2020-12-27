Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E385C433E0
	for <linux-raid@archiver.kernel.org>; Sun, 27 Dec 2020 21:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 011D32078B
	for <linux-raid@archiver.kernel.org>; Sun, 27 Dec 2020 21:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgL0V6G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Dec 2020 16:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbgL0V6F (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 27 Dec 2020 16:58:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC7CC22AAB;
        Sun, 27 Dec 2020 21:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609106245;
        bh=4MFzvoyxvWRh9e/3p4uTIb7qp4diLUFpLw6324rdMdI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FrRdiI4VtCP2Jh+pvScqUsl0+NLr/hDFsYNIMcdHqiKmtAKU0ErVUy/KAmaHidnu5
         dHgdZPyhmGZ/dntmnfYbrSnW4NO77NIV1ZSSdj9PasXEoenFrLfnU9G+Iy3L++rwNA
         tvKuPRsPi3oWt15Rxq0jCA+yucOtWeBnSHGUTtDTrf27ZaGWmJxxxgKSGP4sPtOwbc
         ZtuuVpPVAQfU8lkpx/UFH7YfTHG0fZ/6bRYgtKp2oC3aiiYXzPKUZ0bP7PngqJoiK6
         GZmL8F1XJP5Z+wThMmQep72m9+fVeZIeck8Hl20+R4fzlymThaagM9oCnIYmqP+5Ie
         nXcymR/0WNW1Q==
Received: by mail-lf1-f47.google.com with SMTP id h205so20154848lfd.5;
        Sun, 27 Dec 2020 13:57:24 -0800 (PST)
X-Gm-Message-State: AOAM5310DrFXDFYKy6Aaf+OtfO1y5Kqfm7W/o/187eSMRPv4ge0Trl3k
        6stDNqtpqY6b6I69hVCK6LZqsvigmhfwS0s3hpM=
X-Google-Smtp-Source: ABdhPJzukkONqv2e5bnGIEXtJcKYZ332DEHUE7bGwmBOEZDK+ob7v7nMB60W3loyn6lRBtDdmzT+2joI5asFOrYXATI=
X-Received: by 2002:a2e:8910:: with SMTP id d16mr20131771lji.357.1609106243184;
 Sun, 27 Dec 2020 13:57:23 -0800 (PST)
MIME-Version: 1.0
References: <dbd2761e-cd7d-d60a-f769-ecc8c6335814@canonical.com>
 <EA47EF7A-06D8-4B37-BED7-F04753D70DF5@fb.com> <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
In-Reply-To: <a85943ed-60d4-05ad-9f6d-d76324fa5538@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 27 Dec 2020 13:57:12 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5Fs9Zz+-2ZEZQe3g5jen4SiHNf7sRtYCN0w4TBGZ1Vsw@mail.gmail.com>
Message-ID: <CAPhsuW5Fs9Zz+-2ZEZQe3g5jen4SiHNf7sRtYCN0w4TBGZ1Vsw@mail.gmail.com>
Subject: Re: PROBLEM: Recent raid10 block discard patchset causes filesystem
 corruption on fstrim
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Coly Li <colyli@suse.de>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "khalid.elmously@canonical.com" <khalid.elmously@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

On Thu, Dec 24, 2020 at 2:18 AM Xiao Ni <xni@redhat.com> wrote:
>
>
>
[...]
>
> [  789.709501] discard bio start : 70968, size : 191176
> [  789.709507] first stripe index 69, start disk index 0, start disk
> offset 70968
> [  789.709509] last stripe index 256, end disk index 0, end disk offset
> 262144
> [  789.709511] disk 0, dev start : 70968, dev end : 262144
> [  789.709515] disk 1, dev start : 70656, dev end : 262144
>
> For example, in this test case, it has 2 near copies. The
> start_disk_offset for the first disk is 70968.
> It should use the same offset address for second disk. But it uses the
> start address of this chunk.
> It discard more region. The patch in the attachment can fix this
> problem. It split the region that
> doesn't align with chunk size.
>
> There is another problem. The stripe size should be calculated
> differently for near layout and far layout.
>
> @Song, do you want me to use a separate patch for this fix, or fix this
> in the original patch?

Please fold in the changes in the original patches and resend the whole
set.

Thanks,
Song

>
> Merry Christmas
> Xiao
>
