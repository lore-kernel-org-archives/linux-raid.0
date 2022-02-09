Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EA3C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 21:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiBIVHv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 16:07:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbiBIVHt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 16:07:49 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A4DC014F2A
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 13:07:52 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id c189so2736812qkg.11
        for <linux-raid@vger.kernel.org>; Wed, 09 Feb 2022 13:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WuGY4ECij73xZOaLraD2vtAqOXgq13UGOe6EA58G7UA=;
        b=m7+Bxyz8rHNAsSWhADcBxEW1ZR44KK8puU8z3wlh9vxL9f7gBFyT3xmWC+2vA4SE3Q
         zGomavd+nOrvSclS3pfSH6ITC8cleSXUTgA+cZV1wJJn3uPgueUb88lRS/hYqYKdHOVK
         zHCoYobumZdrifqmbTJUndMaoGjrrtSrshLmCUwEul2m2bpw7idLCl0iV9XESU0Q9nh9
         yScpZvc/TfGjXmC7QAze6inNRr6bbVgcpWcZQKkX1vfVCLzdtgAwzZHBwSxLnFXz8JeX
         rE0y/FekCZ+rZYv1aih7NhhgxIDUKRymHiq7VIPG1EvNxCHRuoPvohl1AJStdreNOZXa
         1qXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WuGY4ECij73xZOaLraD2vtAqOXgq13UGOe6EA58G7UA=;
        b=LMvhLy7KgplCiZLM/936S0yBiH8WeA9R+t7Q7/mYgSKCGt5hsvkRkQM6njKp0u1ePo
         SV6hVv0ufv4NMVsO6TyjwOj3OpBe6YNYXC0St5mE0ECV0S6qvc/uQUK6sDfLrZovfZtF
         4ouUUyA15UMBWLii/EdTmhoqLCDWIjx/doWEp3hBsTQoLlue0GKPVmYQpB8/E3dqaHSc
         h85+AtLzTqSU1oCGHczK5kQKwBgbeyDplRH5IoqPF/+R6Au0oQeLwCq9zVRPccgF4lU5
         f06jfhWUvxWM4hnV1KFtZsvQlwE2hQi2kNn1p9ZS01MElISf2Mir6SBslU1tpGW+Sh0Y
         Ljsg==
X-Gm-Message-State: AOAM533wWEN43RA8fvcFyVkFd+HAZSaRY/I43tjZ4xK/xcdK4bIbr3oX
        NU00VAVL+U6QCt3jSHYz1fc=
X-Google-Smtp-Source: ABdhPJwjywq4X2sDa9LEhlYm9VhqUKvhpRVcU1wZZ5WnUpRgcFvnWoWVuD7RsJ0pADiqnBakUW7/mg==
X-Received: by 2002:a05:620a:4502:: with SMTP id t2mr2215559qkp.311.1644440859836;
        Wed, 09 Feb 2022 13:07:39 -0800 (PST)
Received: from falcon.sitarc.ca ([2607:fea8:c39f:f018::c39])
        by smtp.gmail.com with ESMTPSA id t18sm9677539qta.90.2022.02.09.13.07.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Feb 2022 13:07:39 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:07:35 -0500
From:   Red Wil <redwil@gmail.com>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
Message-ID: <20220209160735.0cef9e13@falcon.sitarc.ca>
In-Reply-To: <CAAMCDed4hGHUTLDKo2JxNwMmEhAk35OHeR0MPKPG7OTNfFVg-w@mail.gmail.com>
References: <20220207152648.42dd311a@falcon.sitarc.ca>
        <CAAMCDed4hGHUTLDKo2JxNwMmEhAk35OHeR0MPKPG7OTNfFVg-w@mail.gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 9 Feb 2022 07:02:45 -0600
Roger Heflin <rogerheflin@gmail.com> wrote:

> On Wed, Feb 9, 2022 at 3:12 AM Red Wil <redwil@gmail.com> wrote:
> >
> > Hello,
> >
> > It started as the subject said:
> >  - goal was to replace all 10 disks in a R6
> >  - context and perceived constraints
> >    - soft raid (no imsm and or ddl containers)
> >    - multiple disk partition. partitions across 10 disks formed R6
> >    - downtime not an issue
> >    - minimize the number of commands
> >    - minimize disks stress
> >    - reduce the time spent with this process
> >    - difficult to add 10 spares at once in the rig
> >    - after a reshape/grow from 6 to 10 disks offset of data in raid
> >      members was all over the place from cca 10ksect to 200ksect
> >
> > Approaches/solutions and critique
> >  1- add one by one a 'spare' and 'replace' raid member
> >   critique:
> >   - seem to me long and tedious process
> >   - cannot/will not run in parallel
> >  2- add all the spares at once and perform 'replace' on members
> >   critique
> >   - just tedious - lots of cli commands which can be prone to
> > mistakes. next ones assume I have all the 'spares' in the rig
> >  3- create new arrays on spares, fresh fs and copy data.
> >  4- dd/ddrescue copy each drive to a new one. Advantage can be done
> > one by one or in parallel. less commands in the terminal.
> >
> > In the end I decided I will use route (3).
> >  - flexibility on creation
> >  - copy only what I need
> >  - old array is a sort of backup
> >  
> 
> When I did mine I did a combination of 3 and 2.  I bought new disks
> that were 2x the size of the devices in the original array, and
> partitioned those new disks with partition the correct size for the
> old array.  I used 2 of new disks to remove 2 disks that were not
> behaving, and I used another new disk to replace a 3rd original device
> that was behaving just fine.  I used the 3rd device I replaced to add
> to the 3 new disk partitions and created a 4 disk raid6 (3 new + 1
> old/replaced device) and rearranged a subset of files from the
> original array to its own mount point on the new array.

Obviously, as usual in 'nix' world there are multiple solutions for
the same problem especially if you have a small number of drives.

My real question was regarding (4) if a exact copy bit-wise replica of
an entire disk/spindle would have any technical or safety concerns.

Thanks
Red 
