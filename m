Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C32C072A2
	for <linux-raid@archiver.kernel.org>; Sat, 18 Nov 2023 01:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbjKRBO2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Nov 2023 20:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbjKRBO1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 17 Nov 2023 20:14:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AAF85
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 17:14:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4C2C433CC
        for <linux-raid@vger.kernel.org>; Sat, 18 Nov 2023 01:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700270064;
        bh=892wvsBjWlHKUUt/Q57gwURs4cLrzSWzCyk9SfxDYR8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VEJm/xvzW0LuX1VDL3JcSn03dNPDl1f2YUPlMHUlNAtq5Zb8bLR+1Ti9kj1mCeeYm
         Iupk+sv4iyOjUvD9m38Gw4+i+duKPjsFyjraLaIvDaDr31ezoVi2zW5wUi/i+1dXGj
         XFCo0i3RPoa1GXKCqyP3p+/aWa51mKLRNtlq258ESWP8hiXADSXU3762P63txL23Cn
         pmw1UZq3GYTPlOuUe1JqjE9lHrdMnnYgR/38L2ALK5fw3GteylLefsei/9qz4CUt0a
         9ZgdR1r0pRoEUfAZFdmoEdKuLSR7FnzskiQV94b9uJVM8UANjrCeirBolBwKMOfOwp
         laXK8ZWmxJiPQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5099184f8a3so3771689e87.2
        for <linux-raid@vger.kernel.org>; Fri, 17 Nov 2023 17:14:24 -0800 (PST)
X-Gm-Message-State: AOJu0YydoFi8G9RIzw2EsT3Ba0tlY9yxoV1vQc4a1o0iMVfp7cZPyF6J
        1mZeok0zo3njfl37OfE8axIjGYI+uL8CaB3ureE=
X-Google-Smtp-Source: AGHT+IFiF1KylJk6XpCG5LYIFRBESIO3+Hpjp3PperV8mJxCMkTwQP8wSl1oTYvTHfwxu0wp/SMtUjtkZNseLSD5hCA=
X-Received: by 2002:a05:6512:23aa:b0:507:b15b:8b92 with SMTP id
 c42-20020a05651223aa00b00507b15b8b92mr1006901lfv.59.1700270062409; Fri, 17
 Nov 2023 17:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20231108182216.73611-1-junxiao.bi@oracle.com> <20231108182216.73611-2-junxiao.bi@oracle.com>
 <a08baf6c-ae35-f83d-2524-4715263c512a@huaweicloud.com> <ee2330ea-6fca-4360-a981-26df47d68cff@oracle.com>
In-Reply-To: <ee2330ea-6fca-4360-a981-26df47d68cff@oracle.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 17 Nov 2023 17:14:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6TTf2n7B01Y+ZJYCtxsgGdaNf5Zo-99og5nvwedqSp4Q@mail.gmail.com>
Message-ID: <CAPhsuW6TTf2n7B01Y+ZJYCtxsgGdaNf5Zo-99og5nvwedqSp4Q@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
To:     junxiao.bi@oracle.com
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        logang@deltatee.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 14, 2023 at 5:00=E2=80=AFPM <junxiao.bi@oracle.com> wrote:
>
> Hi Song,
>
> These two patches get reviewed-by from Kuai and Logan, I didn't see them
> in your tree yet, would you like review it and pick it up?

Sorry for the delay. I was traveling for LPC. I will look into these soon.

Thanks,
Song
