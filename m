Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB4FC7619A
	for <linux-raid@archiver.kernel.org>; Wed, 12 Apr 2023 20:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjDLUX2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjDLUXW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Apr 2023 16:23:22 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC5097
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 13:22:58 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id x11so8449950vsq.2
        for <linux-raid@vger.kernel.org>; Wed, 12 Apr 2023 13:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681330977;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4GGyTck8fxI1KSV1gaUWs6Fr1laaRuKgx8R8DYJnUC8=;
        b=GDZB9zeKvo62DqvIIec8ihwtLagK8dazQooEGzCpmrGRNmEibO2cEpxk7L8wVeTmnN
         nOmAXciaF3pphka7rNrSl6PsWb5nKtC080P88uInfJM4iu0seZ98YmNTS4p6Tco+ZWpg
         gDkGGz/zZepWSEgeeiLKFjpU3XxlmCcLYZi4lLGTEHBhmQIBuOJj+ZTNw/qdu7Nb7tvL
         BwZTGZk4OWW++4ztvVZ8ZK3beAql84EWVxLCJhazegO3js4WuOWza2ERsAqtiR0zS9kv
         Cnjt/6wrAqLXQKoaRfnfHpax7+9HDJYrPRwBH7GRNee+LTZccSG4fCVrgyWrfuNTbMmP
         +tdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681330977;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4GGyTck8fxI1KSV1gaUWs6Fr1laaRuKgx8R8DYJnUC8=;
        b=bBgFbadqsouxOGdrIc5B58zGFHaAI5/Zg6Qj+ZDyL3xdY3x7J/8bWJD9egu9l1gRqS
         vWOSRh8f1pvfzclW7De3TvZdQwdCtEzsRaZ8URQ9R2rxMI1uHacOkRh732HcIloawJ7n
         Ap6nJpZbLHiwqeRktDe2f3v/KV+6BpyB8gBZf3/eEMM5k2+4DwNMBTCFBM1xsqWgl8K/
         Mecb0bR7OjGpHj+PwbvJ57n0KQT/WTuZmVhHvCDks09+A4d4GVc3LMAQNQbaYz3WbR6q
         s0OAqgYxPJnwwcg2Z5XA7sV72t2DN7H+OkWAdpokZlNvLzXUVXb9oZDgBaCqF/hnpXtn
         1XHQ==
X-Gm-Message-State: AAQBX9dci5zWtTiSRNuVYUJetUmmCDv0xrQibjvvaArELmV/Q6zWELw7
        w2PoLrgsUxcPAZYCRYoebTwS3m84jMgjUG7asb/DvMkQ
X-Google-Smtp-Source: AKy350YtJ66OXcCISIhVoCqLyKnoy4y/7339w+sDbDMi6Kn/4UHQtY6228f81sKKjtp4usbnqCxlLt634EyO5TdxO3w=
X-Received: by 2002:a67:d588:0:b0:425:b978:efb7 with SMTP id
 m8-20020a67d588000000b00425b978efb7mr5040212vsj.2.1681330977091; Wed, 12 Apr
 2023 13:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <c0a9e08b91e86c86038be889907f0796@itrosinen.de>
 <25653.47458.489415.933722@quad.stoffel.home> <21b0a1ef-6389-8851-f6f9-17f3ca6d96c0@youngman.org.uk>
 <14ccbf12-0254-b0b8-4c9a-8949c947a63c@thelounge.net> <da9f8739-f923-de3f-2a4e-320c757f3139@turmel.org>
In-Reply-To: <da9f8739-f923-de3f-2a4e-320c757f3139@turmel.org>
From:   Mark Wagner <carnildo@gmail.com>
Date:   Wed, 12 Apr 2023 13:22:45 -0700
Message-ID: <CAA04aRTJ4RreJtOnZcvvTqcc5ZGU5T5WbBt0X0str210CcMo8g@mail.gmail.com>
Subject: Re: Recover data from accidentally created raid5 over raid1
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 12, 2023 at 5:45=E2=80=AFAM Phil Turmel <philip@turmel.org> wro=
te:
>
> What is nonsense?  A two-disk raid5 does have exactly the same content
> on both disks, just like a mirror.  The parity for any given single byte
> is that same byte.

Only if it's using even parity.  If it's using odd parity, the second
disk is the inverse of the first.

(I think Linux RAID uses even parity, but if it's documented anywhere,
I haven't found it.)

--=20
Mark
