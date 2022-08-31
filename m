Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE31ECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 31 Aug 2022 17:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiHaRsv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Aug 2022 13:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiHaRsj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 Aug 2022 13:48:39 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D73C0B4B
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 10:48:38 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id e195so6572134iof.1
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 10:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=nOmIRgJMPsKPXJtAbRsSaORqXOLzNEMzNYhEvWqshVs=;
        b=SqDdN5SLkrT68nsQ/UJ1lEM1acSuCa9N5Yqgm8QI/vk5NGRYQQNn4sje7w5VhcnK6P
         PoBQp2aOH+54CKspaDQ6Z3gNuppgcOc+5AmFw9r603+4dI7zVIfK4INs1in04qWxFXVz
         ANRp1VUFmHl2VjFSbbHVofNcLaTR9fJr8EDM94vJCPqnPceYEu4f85z/QOl2PR3hkcSC
         MZ/nGYSIZUZKeGGG55fw4fSuMwmaXtJUg1jXclS4tJSIR7QpEnSrwsjo2ZssSGQd3P2E
         VaBLlVPp0ruO7zijqgdtsxHgzYe0ULFu9uJrDNjge1dQu+yZCVtC9rKpuxnSIfdb86eQ
         Up7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=nOmIRgJMPsKPXJtAbRsSaORqXOLzNEMzNYhEvWqshVs=;
        b=l60fETIW0woCIRZPScrLYQYDhQpAvygHI4z+GBWkue3kaQmixLlzyMIcRolkv87jMC
         z7Q3ZcvLcb2UBH4UhiJE8AOo63HVtjmmADsZe8xJKEA0kqcaMo8/sgo+xNUUC0te3yE0
         NLF3u3Aix18rmxnghPtUpbXM0u/4THeXVMXOAw0Tcg3AKZjV7rs57TJCA4wpCPYJwIl/
         mN6hsGsbMkiLAbKbu/xxY8bMyYKZbzp2MD2v2vT3wbzloc8Iz2E/RKqW2aJTKWwQJoIp
         yta+2XRrxu5JkrpZJwHlO6cnYGty5iuD7HekaL6R4/aGQNlno6cd8//l/I20de302YhV
         M3KQ==
X-Gm-Message-State: ACgBeo2UXivgrT7zGbPt5YfnxrMcB6BRuiI48Nnh2XqKkh5rOhD6m0gq
        ruQ9z+os6E2isgppU+kVNXgP4ZdN/C7Zj1NwBy/HSl1Qpg==
X-Google-Smtp-Source: AA6agR5rqK3CbWkbcYbcWmNUYWpClqG6EMrpzfcRbNOyAgF/jvBbcEbw1t0TYmPQi/rzAqQId21F3iXsOk+8PwHHxZc=
X-Received: by 2002:a05:6638:150f:b0:343:3db6:433c with SMTP id
 b15-20020a056638150f00b003433db6433cmr16254457jat.34.1661968117784; Wed, 31
 Aug 2022 10:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk> <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
 <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org> <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
 <25355.47062.897268.3355@quad.stoffel.home> <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
 <25355.50871.743993.605394@quad.stoffel.home> <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
 <25357.13191.843087.630097@quad.stoffel.home> <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
 <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
 <CAKAPSkK1bTf+7GOxmB-odjr2zej6XBCT_VGhfNC1KnSXZHjeRw@mail.gmail.com> <8e994200-146e-61ce-bb4a-f7f111f47b10@youngman.org.uk>
In-Reply-To: <8e994200-146e-61ce-bb4a-f7f111f47b10@youngman.org.uk>
From:   Peter Sanders <plsander@gmail.com>
Date:   Wed, 31 Aug 2022 13:48:26 -0400
Message-ID: <CAKAPSkKQA3cV1rcj9cNrdKorOOqyjHf_4BCLxbEx8ibusJP5nA@mail.gmail.com>
Subject: Re: RAID 6, 6 device array - all devices lost superblock
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Eyal Lebedinsky <fedora@eyal.emu.id.au>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

encountering a puzzling situation.

dmsetup is failing to return.

root@superior:/mnt/backup# dmsetup status
sdg: 0 5860533168 snapshot 16/8388608000 16
sdf: 0 5860533168 snapshot 16/8388608000 16
sde: 0 5860533168 snapshot 16/8388608000 16
sdd: 0 5860533168 snapshot 16/8388608000 16
sdc: 0 5860533168 snapshot 16/8388608000 16
sdb: 0 5860533168 snapshot 16/8388608000 16

dmsetup remove sdg  runs for hours.
Canceled it, ran dmsetup ls --tree and find that sdg is not present in the =
list.

dmsetup status shows:
sdf: 0 5860533168 snapshot 16/8388608000 16
sde: 0 5860533168 snapshot 16/8388608000 16
sdd: 0 5860533168 snapshot 16/8388608000 16
sdc: 0 5860533168 snapshot 16/8388608000 16
sdb: 0 5860533168 snapshot 16/8388608000 16

dmsetup ls --tree
root@superior:/mnt/backup# dmsetup ls --tree
sdf (253:3)
 =E2=94=9C=E2=94=80 (7:3)
 =E2=94=94=E2=94=80 (8:80)
sde (253:1)
 =E2=94=9C=E2=94=80 (7:1)
 =E2=94=94=E2=94=80 (8:64)
sdd (253:2)
 =E2=94=9C=E2=94=80 (7:2)
 =E2=94=94=E2=94=80 (8:48)
sdc (253:0)
 =E2=94=9C=E2=94=80 (7:0)
 =E2=94=94=E2=94=80 (8:32)
sdb (253:5)
 =E2=94=9C=E2=94=80 (7:5)
 =E2=94=94=E2=94=80 (8:16)

any suggestions?



On Tue, Aug 30, 2022 at 2:03 PM Wols Lists <antlists@youngman.org.uk> wrote=
:
>
> On 30/08/2022 14:27, Peter Sanders wrote:
> >
> > And the victory conditions would be a mountable file system that passes=
 a fsck?
>
> Yes. Just make sure you delve through the file system a bit and satisfy
> yourself it looks good, too ...
>
> Cheers,
> Wol
