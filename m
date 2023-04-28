Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF04C77B7E
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 09:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345627AbjD1JNA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 05:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjD1JM6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 05:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1227173B
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 02:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682673132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUoPDYRuFSTRaSDLA9zBBXu2fYOjmClEHt9D2Mn6jiE=;
        b=dKAIbcJ9QknAGP5B4XBiFgGD0pM2eA4OeY+Y4cDmD93EbU5CH75TdcjzrEew9hoZ4EiAv4
        bZqJlpKYmIbSYX7iRcHmrASXi7xK1xd6QyRDHfYTJpdRsxvnhJXquuTIsx3PxZ3ZYSAStI
        21ufJUnk8Nk31gwzautHXHIR99u38gM=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-G9fkUhtMMuGaqmbl_N6s7w-1; Fri, 28 Apr 2023 05:12:11 -0400
X-MC-Unique: G9fkUhtMMuGaqmbl_N6s7w-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-24b27b7f627so5336784a91.1
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 02:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682673130; x=1685265130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUoPDYRuFSTRaSDLA9zBBXu2fYOjmClEHt9D2Mn6jiE=;
        b=HED7oJIpHk26YeJDo95y0XJgrgDf9vbJrDSBleVva21PO6n0BEsCyRBXah1IhBdE14
         4MBDA3HsN/PZBLPcJnWteLuQrOy/b35xmIJgNUf0yINAHFMtn4VleJ/Ry0Li/cP3am2Z
         QYUMiFq17og1WlNohfze8KdTY7N32fpaetR2Ca4rq6Co4bz6BI40TMnny4ZS8SUNmmMb
         OgvaZqFuio54H8RlONHRy32T42SNvDx/6sFRoqgwTeHkLqyLonpfpFOAVUdE1yMG42HM
         DD1tf0e1P4aAQRNUIsRGnHu7UGEnBWe6f2kgpDIqpTH9zvcJnMjXgxjd+nP9KnBMnfup
         DBMA==
X-Gm-Message-State: AC+VfDxYGnMcZRrfTHZ+VhCmpctB+DmBUr6ngGNKK8D3Wpz+ldOhJXEn
        Ex5QChjvwAHimgZ/uwNd/1pk49jNs10Tfpt+g9w3VRJT+yiIKjbBAyXb9Gon3ediErzRBJWkT3s
        S5YX6/q2WiEiTMS2TuKBu3AnLHLGv5Y2XfYfitzJIv+VGzcvKn+jSqQ==
X-Received: by 2002:a17:90b:3b50:b0:23d:4229:f7cf with SMTP id ot16-20020a17090b3b5000b0023d4229f7cfmr4711140pjb.41.1682673130143;
        Fri, 28 Apr 2023 02:12:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4voUwkksLE552s16TjVT8H457ylsglCiD83RoXUWCCjSlbDW1Rj9vBqqp+ZNpe6b7nA4X56JmDWhnYqwkgoRY=
X-Received: by 2002:a17:90b:3b50:b0:23d:4229:f7cf with SMTP id
 ot16-20020a17090b3b5000b0023d4229f7cfmr4711122pjb.41.1682673129860; Fri, 28
 Apr 2023 02:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
 <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com> <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
In-Reply-To: <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 28 Apr 2023 17:11:58 +0800
Message-ID: <CALTww28Z94iN6srV2axvaiVxJ=1xryHqLiM6G-OuNWjXqdZJ9g@mail.gmail.com>
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Apr 27, 2023 at 3:13=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/04/27 14:53, Xiao Ni =E5=86=99=E9=81=93:
> >> for example, null-ptr-dereference:
> >>
> >> t1:                             t2:
> >> raid10_write_request:
> >>
> >>    // read rdev
> >>    rdev =3D conf->mirros[].rdev;
> >>                                  raid10_remove_disk
> >>                                   p =3D conf->mirros + number;
> >>                                   rdevp =3D &p->rdev;
> >>                                   // reset rdev
> >>                                   *rdevp =3D NULL
> >>    raid10_write_one_disk
> >>     // reread rdev got NULL
> >>     rdev =3D conf->mirrors[devnum].rdev
> >>       // null-ptr-dereference
> >>      mbio =3D bio_alloc_clone(rdev->bdev...)
> >>                                   synchronize_rcu()
> >
> > Hi Yu kuai
> >
> > raid10_write_request adds the rdev->nr_pending with rcu lock
> > protection. Can this case happen? After adding ->nr_pending, the rdev
> > can't be removed.
>
> The current rcu protection really is a mess, many places access rdev
> after rcu_read_unlock()...

Hi Yu Kuai

It looks like a problem that is it safe to access rdev after adding
rdev->nr_pending and rcu_read_unlock. Because besides raid10, other
personalities still do in the same way. After reading the related
codes, I have the same question.

>
> For the above case, noted that raid10_remove_disk is called before
> nr_pending is increased, and raid10_write_one_disk() is called after
> rcu_read_unlock().
>
> t1:                             t2:
>
> raid10_write_request
>   rcu_read_lock
>   rdev =3D conf->mirros[].rdev
>                                 raid10_remove_disk
>                                  ......
>                                  // nr_pending is 0, remove disk
>   // read inside rcu
>   rcu_read_unlock
>
>   raid10_write_one_disk
>   // trigger null-ptr-dereference
>                                 synchronize_rcu()

Function remove_and_add_spares sets RemoveSynchronized, calls
synchronize_rcu and calls raid10_remove_disk. So the right position of
synchronize_rcu in your case should be before raid10_remove_disk?

But it still can't resolve the problem. raid10_remove_disk can set
rdev to NULL between rcu_dereference and adding ->nr_pending

raid10_write_request                     remove_and_add_spares

                                                       set RemoveSynchroniz=
ed
                                                       synchronize_rcu
rcu_read_lock
rdev =3D rcu_dereference
                                                     <-------     *rdevp =
=3D NULL
atomic_inc rdev->nr_pending
rcu_read_unlock

raid10_write_one_disk
// trigger null-ptr-dereference

Can we check RemoveSynchronized in pers->make_request? It can't submit
bio to this rdev after synchronize_rcu. For the
pers->hot_remove_disk(raid10_remove_disk) side, as you said in the
second solution, maybe it needs a new method to know all
pers->make_request(raid10_make_request) exit.


Best Regards
Xiao Ni

>
> Thanks,
> Kuai
> >
> >>
> >> for example, data loss:
> >>
> >> t1:
> >> // assum that rdev is NULL, and replacement is not NULL
> >
> > How can trigger this? Could you give the detailed commands?
> >
> > Best Regards
> > Xiao Ni
>

