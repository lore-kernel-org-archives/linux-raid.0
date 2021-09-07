Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A24C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 22:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2198961101
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 22:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346914AbhIGWkF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 18:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhIGWkE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 18:40:04 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC320C061575
        for <linux-raid@vger.kernel.org>; Tue,  7 Sep 2021 15:38:57 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n4so57349plh.9
        for <linux-raid@vger.kernel.org>; Tue, 07 Sep 2021 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfzYaGvmP0wjIYyf+sBKmfNzSAdXZCnIpJyALOYaKnY=;
        b=Ez38LAswwP4bg0zszD0XQck466iyshd/5DA1mMJOdk5XAb0z76ij4uMLm5YhqkNsP7
         FSxXHbgPbkzzIispZKPkXlf6hIyIZGHpp5leeH6U4vSXNxVXAnlJNFuRgSF8Opu2E9du
         ELqoIThJUIz2hTsFPgTBBew8pEuq9PwIVNmmbwEfId0lcdcRXuQUvFWO2PjwL+3A84pm
         yOmYCk55jdR827zRlxMpD7163XeaY+55cC8JKpK6G9x5B6oqUaWyfkaEMj06K0l2Texv
         yQaA6pWsorGeGBP/uqn/iFJzcXZ2Vjdmi4tfnzDckGZ7Icnw3UNjthootd3kKu7Lr9Lt
         UPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfzYaGvmP0wjIYyf+sBKmfNzSAdXZCnIpJyALOYaKnY=;
        b=QLVrADw2Dx6XhbLvfmjMfZHFlQ/FZ5vxAsn1O4OBDffAabRve8n0XIIjDhWkSyPOmc
         gCV//zJMUbk+9pXei78AOS1bxGaCbnyR7Dh7d9ytiUftMRpNGU8yIZOxnWiY6MA/Wdpb
         6cyReXt4Yelh8d9brxDu3MPYBOvqByfVBtWPPxEYb6NG7wBbPCKzjTzalX2HAUHbliEl
         zRd49QmgGkXgZxSXgBKyEW62ynyAqqYfooyBxVYc6F7L/lAmoxFTK/Bulg3AMbgWfkR+
         HdPCpit7fv9Ei/CTwRJuwF1KXbPflCJi0FrI3vS+0gI8irWDOuFaTolgg2FyOHi28kDZ
         CwRA==
X-Gm-Message-State: AOAM53283shAUn6BW8shyj4O0x8Ga2t1IUgaMc07WotteX77aq/IOoqe
        iKBAt5aLQ0TBk/ADwP8RQ4pj+2eI1SafvjLYXBxxLyJ90yQ=
X-Google-Smtp-Source: ABdhPJxgegLMoGis9xlYFhx9r0udjfVrlymL71wWNLhS/UonVxVg+nRweJLdjE1n+JkjdAWz/VI57vAPdBu60YGqgoI=
X-Received: by 2002:a17:903:41cf:b0:138:9b83:b598 with SMTP id
 u15-20020a17090341cf00b001389b83b598mr312384ple.37.1631054337263; Tue, 07 Sep
 2021 15:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Kggd7mUF9MWdJsLtAQMv=KXtwaNvj6BqfM+NMyffE86iHBoQ@mail.gmail.com>
 <6136F1C2.4020804@youngman.org.uk>
In-Reply-To: <6136F1C2.4020804@youngman.org.uk>
From:   Ryan Patterson <ryan.goat@gmail.com>
Date:   Tue, 7 Sep 2021 18:38:46 -0400
Message-ID: <CA+Kggd4eGAq7hnN7-ryRAayFXiraB9KJrFCn7=iOjj6XZqmABQ@mail.gmail.com>
Subject: Re: mdadm resync causes stable system to crash every 2 or 3 hours
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 7, 2021 at 1:01 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
> On 07/09/21 01:44, Ryan Patterson wrote:
> > My file server is usually very stable.  The past week I had two mdadm
> > arrays that required recync operations.
> > * newly created raid6 array (14 x 16TB seagate exos)
> > * existing raid 6 array, after a reboot resync on hot spare (14 x 4TB
> > seagate barracuda)
>
> Aaarghhh
>
> See
> https://raid.wiki.kernel.org/index.php/Linux_Raid
>
> And especially
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>
> That might not be your problem, but it's the very first thing you should
> address!
>
> Cheers,
> Wol

Thanks for the links.  I'm confident my issue is not Timeout Mismatch
related.  I've experienced that before.  It manifested with different
symptoms.  ie. mdadm would think a disk had failed and remove it from
the array.  But the system/OS stayed stable the whole time.

The seagate exos drives support SCT Error Recovery Control and it is
set correctly.  The barracuda drives do not support it, but I've used
these drives for six or seven years without issue.

-Ryan
