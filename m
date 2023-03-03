Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAFBC7EE2D
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjCCQKE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCCQKD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:10:03 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A210559F3
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:10:02 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id d7so2843677vsj.2
        for <linux-raid@vger.kernel.org>; Fri, 03 Mar 2023 08:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677859801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbMp3DLztwglwPUt7HBJ0cjsz/tRxK7DzxpYTAHxTog=;
        b=ML28dBIVhIA+sQYhd7Ehdi/7U3cqkApmAI5j55/z0qQLa4iBLtB4Hbq7BUgrvtgpgC
         7dQe9+OsP1ycEo32weVZmNEDylAn5H3JShAGOlmFlT8HYEj9sh6kxp7cFK+CKYJ52pD9
         8wPJ0nDVK2iY6QtBVOiKmA8egpAk2K6qj78SSz3dLrMuaBeAe/9RUXw8ExZmP1VyDEle
         beP9qOf1QarYvlEvd8/+QapZcS9Y57NZoq3GytItD1p3FCOanu2JoTdb+tfqhswl0Y+L
         JABWh127WijAIZRDMvg7k3kufvj34BQwWRB2c2z38e9a+UjXQ1ludMMjt11NzcDNAd6T
         Ijzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677859801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbMp3DLztwglwPUt7HBJ0cjsz/tRxK7DzxpYTAHxTog=;
        b=ImsuE7M/fPMAzUWTMNIAwOTF6oxgKr7vUXnT3XY8vYkyChDHKranj0IDURLzsOVDrn
         zMjXkQfOgMTkF/eSIDt3Hj4DBhx/InXAgGcWJte7oHQ+cs/45BDU63R2FDYhT8iAQYd1
         ciqCx++XYHW6OHXmINdvBV+/l4B5f7R6Su67jeYcgBpaE2QVy2Uy3SjTvoccFWXv5cN1
         iXNeqOnz0K84b5PmFRkJuyVPUdAoV4GOhIPeIEMbC8e9AzE9f7dMF8eY74LAla8jAUFq
         pO4Y4Z9jcYX0gTBUbSSfqOIJQINRc7vi7r+8gUe7cjLz/EGbZyBIp3iclt6Xpvhl6PWl
         h4xg==
X-Gm-Message-State: AO0yUKW7+IbQTW1DGsqiTQSedKlfwZywkFcTzV/PkdwTA97//DNpuxEE
        uHmaq7cSMTAnvb/xXdk58e4DXvfqVIu8MvfYksmwoVYZ6uQqlQ==
X-Google-Smtp-Source: AK7set/1VwKLUlBky/Xz3u03Fq/tfM1z2EQ9+cmAIzD/zrnvIPqvhN8xJSU/dqKxLimr8CajcPXD4j4xRewi2fyte24=
X-Received: by 2002:a05:6102:21ae:b0:412:364c:68be with SMTP id
 i14-20020a05610221ae00b00412364c68bemr1482986vsb.7.1677859801578; Fri, 03 Mar
 2023 08:10:01 -0800 (PST)
MIME-Version: 1.0
References: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
In-Reply-To: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 3 Mar 2023 10:09:50 -0600
Message-ID: <CAAMCDedsGtWcwe4KY9SgdciXoHYeM+YO4U7v-QCRnL5PqQTs9A@mail.gmail.com>
Subject: Re: [bug report] md: range check slot number when manually adding a spare.
To:     Dan Carpenter <error27@gmail.com>
Cc:     neilb@suse.de, linux-raid@vger.kernel.org,
        cip-dev <cip-dev@lists.cip-project.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 3, 2023 at 8:31=E2=80=AFAM Dan Carpenter <error27@gmail.com> wr=
ote:
>
> [ Ancient code, but you're still at the same email address...  -dan ]
>
> Hello NeilBrown,
>
> The patch ba1b41b6b4e3: "md: range check slot number when manually
> adding a spare." from Jan 14, 2011, leads to the following Smatch
> static checker warning:
>
> drivers/md/md.c:3170 slot_store() warn: no lower bound on 'slot'
> drivers/md/md.c:3172 slot_store() warn: no lower bound on 'slot'
> drivers/md/md.c:3190 slot_store() warn: no lower bound on 'slot'
>
> drivers/md/md.c
>     3117 static ssize_t
>     3118 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
>     3119 {
>     3120         int slot;
>     3121         int err;
>     3122
>     3123         if (test_bit(Journal, &rdev->flags))
>     3124                 return -EBUSY;
>     3125         if (strncmp(buf, "none", 4)=3D=3D0)
>     3126                 slot =3D -1;
>     3127         else {
>     3128                 err =3D kstrtouint(buf, 10, (unsigned int *)&slo=
t);
>
> slot comes from the user.
>
>     3129                 if (err < 0)
>     3130                         return err;
>     3131         }

kstrtouint is string to unsigned int, it has this code:

if (tmp !=3D (unsigned int)tmp)
return -ERANGE;

And so will not return a negative number without an error, so 0 is the
lower limit as enforced by the function.
