Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD72CA0FEC
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 20:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbjIAUow (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 16:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244442AbjIAUov (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 16:44:51 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1DA170B
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 13:44:40 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-500a8b2b73eso4064785e87.0
        for <linux-raid@vger.kernel.org>; Fri, 01 Sep 2023 13:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693601079; x=1694205879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWJLzxrmHZCc9Ei1vBSibzFHnFbR5wY3EYmJRhu2KBA=;
        b=LANbaSGM4+zuFH9hYY4iFhm6ONZPuYdGrrfZBfAUiW7sOEG6ScLjkYXZpcRATIEUTx
         cKNe9ku4gvYSU8yQksAqoWvVRrRi2TDfRrGnbHmE1R46vYbeFzqItt3mLCIm7e8AU4Ud
         jWTKi6H0Vpbg49Cabi/svO6rLvWFeIg7FWgy4ikBCcl6WSCrx9RXlVxNnlOw1DQnKUJD
         M5XYe6huefx4dz/NQ4BHkuiDs1X+5A//MpHlsCHYlov4wW8pATaffTpF+5e+3A9H57lW
         FhawUBcQ3BaNLLGwe6qnDy/ESKxLIu9H+9mxX1RSysRULuVQoYOiT5CqKUqEhSkVkdn4
         fbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693601079; x=1694205879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWJLzxrmHZCc9Ei1vBSibzFHnFbR5wY3EYmJRhu2KBA=;
        b=DCo5Ed3IB0K7jy1dt1J4Y5+ggC8LBqVBfMeeDhOYzez2msvYLTb5Zp2gexyJ8yxeIv
         MryQTDlExgNSz4Ykh1u59Gmmm85w9Tyl551DLA3qJuF7mH+UkyiHh2IEALzFFbZOfdNr
         P0CRxNPsWB5iqd3uGM9XGfOPYPWewQqamlJ5RJSafZaZ3RmLoJcxHNJWmKGVn9LuUPF4
         8IyVnwnFkP3JavTLBF3YKk+PVK5V3EXjOrWRQlcV9nKd65U8IiFLR+5joAKKjtuhp7Qk
         hrpU7j+zKehJyc+l2ackL/jTYBDa6mJnZNMpkEsCgWYqeTWonY7kBNHK1BY8lJTpC468
         2cbA==
X-Gm-Message-State: AOJu0YyevSmp0hCoYqCkEBSCn6CA/YHF7uhk2d4epwaHf/JNpcZI54nA
        2Nmy6FXGS9DeL/ICG7eaoadM5JjbFWzZI8lUn1PnL5qQOLKobA==
X-Google-Smtp-Source: AGHT+IGLHwzsT/oGa2paOyq9udIKaWZTOZcMMAyAmo3oJXtVhjAfwjMrMGH0LODAvrIvugi2swT0pMqzhVxzia/oy9Y=
X-Received: by 2002:a19:7918:0:b0:500:ac71:8464 with SMTP id
 u24-20020a197918000000b00500ac718464mr1832447lfc.66.1693601078472; Fri, 01
 Sep 2023 13:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7qBPeW0Ua1xgiU+p9aDwWMTvc-28iC8kuTzc654wrnmgQ@mail.gmail.com>
 <20230902013700.4c969472@nvm>
In-Reply-To: <20230902013700.4c969472@nvm>
From:   CoolCold <coolthecold@gmail.com>
Date:   Sat, 2 Sep 2023 03:43:42 +0700
Message-ID: <CAGqmV7reuaeGNY3jz-8BjrmwTR3kmNzCXEa7JxouZ8v7t9QqnA@mail.gmail.com>
Subject: Re: raid10, far layout initial sync slow + XFS question
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Sep 2, 2023 at 3:37=E2=80=AFAM Roman Mamedov <rm@romanrm.net> wrote=
:
>
> Hello,
>
> On Sat, 2 Sep 2023 03:23:00 +0700
> CoolCold <coolthecold@gmail.com> wrote:
>
> > So the strange thing I do observe, is its initial raid sync speed.
> > Created with:
> > mdadm --create /dev/md3 --run -b none --level=3D10 --layout=3Df2
> > --chunk=3D16 --raid-devices=3D4 /dev/nvme0n1 /dev/nvme4n1 /dev/nvme3n1
> > /dev/nvme5n1
> >
> > sync speed:
> >
> > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> >       7501212288 blocks super 1.2 16K chunks 2 far-copies [4/4] [UUUU]
> >       [=3D>...................]  resync =3D  6.2% (466905632/7501212288=
)
> > finish=3D207.7min speed=3D564418K/sec
>
> Any difference if you use e.g. --chunk=3D1024?
Goes up to 1.4GB

md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
      7501209600 blocks super 1.2 1024K chunks 2 far-copies [4/4] [UUUU]
      [>....................]  resync =3D  0.4% (35959488/7501209600)
finish=3D86.4min speed=3D1438382K/sec

>
> How about a newer kernel (such as 6.1)?
Not applicable in my case- there is no test machine unluckily to play
around with non LTS and reboots. Upgrading to next HWE kernel may
happen though, which is 5.15.0-82-generic #91-Ubuntu.
Do you know any specific patches/fixes landed since 5.4?

>
> --
> With respect,
> Roman



--=20
Best regards,
[COOLCOLD-RIPN]
