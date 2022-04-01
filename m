Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F113C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 21:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350104AbiDAV0q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 17:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237505AbiDAV0p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 17:26:45 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544E3228D05
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 14:24:55 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2e5e9025c20so46513177b3.7
        for <linux-raid@vger.kernel.org>; Fri, 01 Apr 2022 14:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=oFvYGBDYb2ZHftuf/QJQ/jaLj8aH7hnHFQPzO1nSJSM=;
        b=cKfbT/YebiBGcBKyBpQCxScxw6vLSWIPGeSp8As9/S2DxoG4SuwB47iewKi0I/PMox
         Y1dLwR1UnMgygqLjcTtg0DxnzBswkWcBoWFJ72BBhiDHy+ypi8U+ijnHg9/QZrPHuo43
         aJyT9UgHJ9nKMBFRu4VEvbv6jCXBGLkKBHunUXqrfbvnxQm3y+XmYLD6ElKsLI/zOEn8
         UESU0ljG52cee9hvLex1nyer7nL20c2vK52CPP62i2uR+28D+rhan+tJDe9aic8AEQhq
         WAPI1OZ1FisNWBLj82iF+C40he3oqSxLnNygibU88h9IsUrFbRx3HFm9xE90IgUIKPI7
         +7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=oFvYGBDYb2ZHftuf/QJQ/jaLj8aH7hnHFQPzO1nSJSM=;
        b=yqL37KzJlQ+nKABk0CWyBOf8nR3Bz/cCi4ZdQhjGtEkxcGGsHFG2HrpSoZugRW6qM9
         VC/4h8O80tM3fqDdifzqpzxT7mlOiAjjQ92/0TPM7831trNknVinlDfGtkDBEHZStjSV
         EJOvYzVyoi5FE9BMCsbBWW3imXNimY5K47+5j0eh9uMKq19glb52bB0BXRgr6cbbrfnP
         3S7NkSAdkRxXdF/4OxLab9JDUkTh852w1l+uSYN11B8Bnqd1uhlX1NJ1irgDtfXrnclp
         yG7JnIZiviazaL3teajVCJMfYRC2cr2tEz4iDh6yBcJK7CJEfNWfdEUBNy2I9WlcVCM5
         PPxw==
X-Gm-Message-State: AOAM533oYPRC8SNDdAN1Iyndc8YUVGUVr1jQp5hpF0soozmkLPJA3tDo
        fSMktBftb5Ojyf11aPXX9EBYz2ig/yzD2veM8ik=
X-Google-Smtp-Source: ABdhPJweVcN8GJ17dKqz4yHMyElt0xrxT9s3MoTVyOX3WatHn1sZRQlLUEYcT6Ympfyee+79o/ukXl8JlpYNxiZOkHg=
X-Received: by 2002:a81:b288:0:b0:2d6:39d5:31a1 with SMTP id
 q130-20020a81b288000000b002d639d531a1mr12160620ywh.506.1648848294625; Fri, 01
 Apr 2022 14:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk> <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk> <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk> <CAKRnqNL0aNWGHFgcz-KVKn3dpVpUa1oN5miu+oiv16vdJx3OHw@mail.gmail.com>
 <0955d209-ab2b-dc20-a9fb-ad15c09eb884@youngman.org.uk>
In-Reply-To: <0955d209-ab2b-dc20-a9fb-ad15c09eb884@youngman.org.uk>
Reply-To: bruce.korb+reply@gmail.com
From:   Bruce Korb <bruce.korb@gmail.com>
Date:   Fri, 1 Apr 2022 14:24:18 -0700
Message-ID: <CAKRnqNLQDC8HCO873+_KiFC2zg_CyibsteGC_URLQoyYaCEO6A@mail.gmail.com>
Subject: Re: Trying to rescue a RAID-1 array
To:     Wol <antlists@youngman.org.uk>
Cc:     brucekorbreply <bruce.korb+reply@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 1, 2022 at 2:02 PM Wol <antlists@youngman.org.uk> wrote:
> Read up on loopback devices - it's in the wiki somewhere on recovering
> your raid ...

Not in the index nor findable by google. :(

> What that does is you stick a file between the file system and
> whatever's running on top, so linux caches all your writes into the file
> and doesn't touch the disk.

Yeah, I'll need some guidance there. :( What commands do I need to run
to get sdc1 or sde1 mounted under a loopback?

> Let's hope xfs_recover didn't actually write anything or we could be in
> trouble.

All it ever did was print dots and say that something that might have been
a superblock wasn't really. It didn't sound like it did anything.

> The whole point about v1.0 is - hallelujah - the file system starts at
> the start of the partition!

with the RAID superblock at the end and the file system layout at the start,
it should be good. Fingers crossed. Please point me to where I can learn
how to loopback mount an XFS file system within a RAID partition. :)

Thank you so much!!

Regards,Bruce
