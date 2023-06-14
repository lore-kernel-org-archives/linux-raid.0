Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0020EB64D9
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 08:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbjFNIrr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 04:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbjFNIrq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 04:47:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3E8E6C
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 01:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686732419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E01jCt7vmyFg3Ui6rRlhnDx1yXGM4s6eZ7oqY6CToYE=;
        b=Kc0cEqdt1qomdA4uUQut4Ms11TmjrljuIAOyig/A4qRWgAhrPAPWm3hnNlrbda0lSPKdH7
        mmw84/wBuoH11YaueCBZ2ii/sKqUH7YnMJXvDu7anAtAf5FwLBP78OP1zvk/Prv5wFqIdl
        tMX9UOxZLjoPGOaRL0KPEfV1XOUHxDs=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-eU79W-gkMMeLPf7JmFREbQ-1; Wed, 14 Jun 2023 04:46:56 -0400
X-MC-Unique: eU79W-gkMMeLPf7JmFREbQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-39ceb9a76b1so2095556b6e.3
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 01:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686732416; x=1689324416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E01jCt7vmyFg3Ui6rRlhnDx1yXGM4s6eZ7oqY6CToYE=;
        b=QLA2Fx9FQ+7PTklRWknJuDZJjgX0nKeuoyRlTRIYsJhgtnGKgorBr7Mi0RPlUy1/iD
         9gHBtRcpNlGNIkL0jMDlILqYjXsK+shuwYTdSU5mT9yQ44NthDI32F7LOZNo5RWxYvv/
         v2LlLPo5+Cy7y0o+nfX8IGDgHyCuQ0Ck9G370li1QMtshw4UqS6XZ0KYsTbCP11RuQe8
         p49FtI6VhSDauZtXTdrbVAgvLlM7D8g6g9pChGU5dC1VlkA4xNXrG9XjQwUXjFllFbWu
         D7mgVenO0isqYSYevfGWxDd1gjGJ/oKjPyyuefWVEoo9xr6evVZPXrfrYOP9LpkfbNUO
         JkDQ==
X-Gm-Message-State: AC+VfDy79nxxFG++dp4IYGG9l3qcK1dn2udoIT5HI8hqsvEQ50KtvxYf
        wc35TMaV5rVpPIrwZkAaiaZqWTKQJk9/2TnOvO2ikpwpk5XdTCcGzHGdT+ALaFxIDpUlNOifJJJ
        leM6OvJJQHEd63UwbsdckciYOVluUfbB8hJ2TnA==
X-Received: by 2002:a05:6358:51de:b0:12e:f63c:57a with SMTP id 30-20020a05635851de00b0012ef63c057amr320303rwl.14.1686732416004;
        Wed, 14 Jun 2023 01:46:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4HHuN2nI3NmaZarDlPPXNDl/E7qcYL2XLRqDmaiJuuwQZNvDlbZkSoog9HBmpTfEhy9ohKF5LAniHD3e1MRPU=
X-Received: by 2002:a05:6358:51de:b0:12e:f63c:57a with SMTP id
 30-20020a05635851de00b0012ef63c057amr320295rwl.14.1686732415727; Wed, 14 Jun
 2023 01:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev> <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev> <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev> <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
 <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev> <CALTww2_vmryrM1V+Cr8FKj3TRv0qEGjYNzv6nStj=LnM8QKSuw@mail.gmail.com>
 <73b79a2d-95fe-dac0-9afc-8937d723ffdf@linux.dev> <495541d3-3165-6d4b-f662-3690139229e9@huaweicloud.com>
 <CALTww2_wphLSHV6RAOO05gs0QO8H9di-s_yJRm0b=D7JmjjbUg@mail.gmail.com>
 <d3e3ccdf-3384-b302-7266-8996edee4ca8@linux.dev> <CALTww2_7PFmmCk1bGMco3a1cMJTxJtUiOs-i764qp0vnQRZJkw@mail.gmail.com>
 <36d04bfe-adbd-2ec8-6e8b-d977fbbfb84c@linux.intel.com>
In-Reply-To: <36d04bfe-adbd-2ec8-6e8b-d977fbbfb84c@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 14 Jun 2023 16:46:44 +0800
Message-ID: <CALTww2_CcqVLpHXXNtBzATMStdR3jv-g0uZJe=w55mtLafXefw@mail.gmail.com>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 14, 2023 at 4:29=E2=80=AFPM Kusiak, Mateusz
<mateusz.kusiak@linux.intel.com> wrote:
>
> Hi Xiao,
> looks like this mail thread has gone silent for a while, were you able
> to determine the issue source?
>
> Thanks,
> Mateusz
>

Hi Mateusz

Sorry, I'm still trying to figure out the root cause.

Regards
Xiao

