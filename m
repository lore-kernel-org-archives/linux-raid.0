Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF9FC433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 03:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9954720848
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 03:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gobGRMTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgH1DTk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Aug 2020 23:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgH1DTk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Aug 2020 23:19:40 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5056DC061264
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2020 20:19:40 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id z22so6567852oid.1
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2020 20:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=2HdAdjBZB9wMz+bwyQNAKx7D/LPDqZOu0Hrcqtf0UiM=;
        b=gobGRMTjGT/LCfORM03Jm6nhtvObs9xUD6q+VC2NqOYk6nPAhs+CjbvcD531QAn0pr
         psMKmpRYYE+UHAEkboLU6uEBV2VfKB7SZod6igVUybbAi0OhsifKTz8JqG4XP6tiYmQZ
         yDi8XgekXVE3nc6YqX6qYGGQLMt/iVLGCT+p2Ja4Ef2cg4UHsVp+NExjgbKl3vo7uUHu
         qoWlERQfkgBSBSxF/tuEOGTFjEtqwC8UUUeOK9wYsMrpM8jX6JnEb6F17cgj2ghFGpW4
         SLJOnd0Ncfv2qPtAZlswGs2QKW8pcv8Yh5J8EZAxd3cboREjmxGsuDHouocuMUHgwi2d
         CpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=2HdAdjBZB9wMz+bwyQNAKx7D/LPDqZOu0Hrcqtf0UiM=;
        b=Eu2cGRO0bqGTUpBfrtY9JFJmukjNXiajV3ikH+VvywRHBC9qG33CBVga/H2UHEzHUv
         Q3qjqmgV+8viJqnCeg0K2jva636xNWRHrYBhueJzOJgLN5bLrJpIY4jj86N1lngC8TNt
         trY69JuZ8fLv7XLPxznbMpqkOn1q+JE+SkqtWaIasvi1wk8I38+WXwwk+0idTqJrA41h
         /IOMxvGShGfvhP0RQhart8bXNF21e4DmhK78JCeoIpGQNpomcXj8BG9uQCO6P6DmabMM
         JmqTI+ZV+6oLtVlubBeB4SWtMHkaTRWvtW/llfRACXPvhmvFAO9ENHFxsWxqEah0mul/
         tslA==
X-Gm-Message-State: AOAM530yvCsSgwYcbtN1cYi12uG4yAracBcaTOM7QCATwqgbffQ7j7zV
        112+TAjm4CmyCi+Eato/a7wp1HHVE94=
X-Google-Smtp-Source: ABdhPJz4cFKJgXnuLgPl7d1dkDqKTr5qtHOy0VlH0f/vsHobXXg+TrOdADEHxzDKiNOJmGrf1q9jbg==
X-Received: by 2002:aca:4dcf:: with SMTP id a198mr371494oib.133.1598584778324;
        Thu, 27 Aug 2020 20:19:38 -0700 (PDT)
Received: from [192.168.3.65] ([47.187.193.82])
        by smtp.googlemail.com with ESMTPSA id h75sm857292oib.44.2020.08.27.20.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 20:19:37 -0700 (PDT)
Subject: Re: Best way to add caching to a new raid setup.
To:     Peter Grandi <pg@mdraid.list.sabi.co.UK>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <24392.29796.81915.842904@cyme.ty.sabi.co.uk>
From:   Ram Ramesh <rramesh2400@gmail.com>
Message-ID: <f3018e1e-2563-9c32-c173-96aaf0b103c3@gmail.com>
Date:   Thu, 27 Aug 2020 22:19:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <24392.29796.81915.842904@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/27/20 10:05 PM, Peter Grandi wrote:
>> I have two raid6s running on mythbuntu 14.04. The are built on
>> 6 enterprise drives. [...] want to build new raid using the
>> 16/14tb drives. [...]
> This may be the beginning of an exciting adventure into setting
> up a RAID set with stunning rebuild times, minimizing IOPS-per-TB
> and setting up filetrees that cannot be realistically 'fsck'ed.
> Plenty of people seem to like that kind of exciting adventure :-).
Yes, just as exciting as my raid1 on another machine with 3 one TB WD 
black from 15+ years ago (one of the first 1 TB blacks) Still running 
strong after this many years 24x7 and has TLR :-)

Most likely I am building same size raid (likely raid1 on two 14/16tb) 
No EB filesystem for me (yet!)

Ramesh
