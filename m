Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B7AC05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 18:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBASAl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 13:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBASAk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 13:00:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423A14C0DB
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 10:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA3A618F1
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 18:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C2AC433D2
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675274439;
        bh=I3cj4w02ek5Ap+uijd5AtX9LHCbh1vRpD1STQYU4giM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=StFwv4TZwyyHxuwGjm7/iFtohWuufqlHnJeQAKzRo3vK1/AbkUqemO6M+sJV3UQ2r
         mdIctu6qA0HBOLfPq5S2WbkEcx7DI14IbONll98JlDC7R/iPUvqlrBLg5vh0blpjyD
         AAk9MkMwPz0c17ZMhPM9/7WkkvwHoo3TQF6sJNcnURE4MiqBqEEQ4Sz2cC25UIb7dM
         DEzpIxbAMbnUgKG94uxvtg2lbghw+ZXOeL+Z5n8zgCs6940SQ/LgqNPiDKl2g1qgeS
         6hHDtyFyTBdSFdgxedBqfNYKbuOgdFoY2QAtDwbFKnxSkipirrUY/NeM9gqFlSHsxD
         0rOgwGrpKluBg==
Received: by mail-lj1-f180.google.com with SMTP id u27so13661063ljo.12
        for <linux-raid@vger.kernel.org>; Wed, 01 Feb 2023 10:00:39 -0800 (PST)
X-Gm-Message-State: AO0yUKXvSv80mnH7XZ24wiWn8fQNJGdJ1YnfvO5JHuK1tJ2ESKRZ0baM
        nXe106VJwG73gtxAkZscgMqzIooaoa64BLvE/S4=
X-Google-Smtp-Source: AK7set8bh7q+ZHw0Prm3HluNVRfO9vqepoCs3uHTV32p5RzaalNbzui/BjneqS4eCT4F2XmnjaCZNzu1sfhKafYnAHM=
X-Received: by 2002:a2e:9ec4:0:b0:290:5f6d:ac18 with SMTP id
 h4-20020a2e9ec4000000b002905f6dac18mr391330ljk.23.1675274437227; Wed, 01 Feb
 2023 10:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20230201124640.3749-1-xni@redhat.com>
In-Reply-To: <20230201124640.3749-1-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Feb 2023 10:00:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
Message-ID: <CAPhsuW7MCSVREMp48CoO-qE-HfMonxhJn-+HfRUxvHfBXL0Nug@mail.gmail.com>
Subject: Re: [PATCH V3 1/1] md/raid0: Add mddev->io_acct_cnt for raid0_quiesce
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 1, 2023 at 4:46 AM Xiao Ni <xni@redhat.com> wrote:
>
> It has added io_acct_set for raid0/raid5 io accounting and it needs to
> alloc md_io_acct in the i/o path. They are free when the bios come back
> from member disks. Now we don't have a method to monitor if those bios
> are all come back. In the takeover process, it needs to free the raid0
> memory resource including the memory pool for md_io_acct. But maybe some
> bios are still not returned. When those bios are returned, it can cause
> panic bcause of introducing NULL pointer or invalid address. Something
> like this:

Can we use mddev->active_io for this? If not, please explain the reason
in the comments (in the code).

[...]

> +       } else

Please add { } for the else clause.

Thanks,
Song

> +               if (percpu_ref_is_dying(&mddev->io_acct_cnt))
> +                       percpu_ref_resurrect(&mddev->io_acct_cnt);
>  }
>
>  static struct md_personality raid0_personality=
> --
> 2.32.0 (Apple Git-132)
>
