Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C41C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 14:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbiFXOJl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiFXOJe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 10:09:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B83427D5
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 07:09:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v14so3301643wra.5
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 07:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=DIZo7geFnYKryuz/no1Gj0TmLP+QB5jT3YpoHBl9+N8=;
        b=M0+p30a0E/Ov7mBh9ePz+d1XOl+l2q+jdvpwhiBlCGsyTP0peJLMNAUBSgHO1rf/c3
         SSFShHlm3Pr7Kf+WTdq87/90eOw+v5+TxgjDPG8WkeB7maz7xj4/xCq6tDR0MZIyLjhC
         nSiufZllz7j7SyJMHWS3qvdZwzJdVhukYRhuxEe3y7It5UGK6kkw9EpY/QMwHrBJBU17
         n6JNR5lRh1FAlYUy/J+iK0RTSYpBga3Qx+oz72RIKKPhD53VMoG8wSZwvh81BuhgYaZN
         Ay01rk0cKP29Qaumeq0fK16V1/7GLXoTsH7ksbKNqKaB5OsJtqP8xkInpmglO2UOfTvF
         rTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=DIZo7geFnYKryuz/no1Gj0TmLP+QB5jT3YpoHBl9+N8=;
        b=MpcaMOBoUg6Au6iSuSdB9m6C9lniM88/WTJbTRpOj+igPblSBC3HLXeXGHcE1nxdAV
         ZHBI5G6mlSIJHOqRZKgLCvtuxBEHqyhTxfa1H3OjpO9I3FaEjWGvOqGYqtSc4fWEge3R
         TBJc3jEr5Akw8hfXYlEPT+pDa0FQXue6vaA+PHoPwBsj3pXTFn7SyljCuuNarmsTGDc8
         Uae5n9EXHORQZe6mEDFJJbIg2kTDjaazwFh35FxRZsV/mAdaJQR+Auk2fg5jMIBeJyQp
         +x1x6voN5J5gWNKFOG2uAfGORBVKfpMEtSSoCw7u8VxT8I3JH8l3NyhK9AAbBMCqtcXq
         V6FA==
X-Gm-Message-State: AJIora/VhA6TG6Wd5T0h7BWKl92EvSdJcmPSRPWLqlz2s81z4yqjLFpf
        4a+r2L6nAlRxjyQ+QNt4sko=
X-Google-Smtp-Source: AGRyM1urXfRBUyrBNZAoZDzAOgBH29ub43RGMy59mDU3vqNItbDujM3UdBSmyM03POC7UtHm/ghC+A==
X-Received: by 2002:adf:dd41:0:b0:21b:8201:4b66 with SMTP id u1-20020adfdd41000000b0021b82014b66mr13275868wrm.706.1656079771804;
        Fri, 24 Jun 2022 07:09:31 -0700 (PDT)
Received: from Debian-Testing-WilsonJAcer.lan ([213.31.80.117])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d654b000000b0021b8c554196sm2514274wrv.29.2022.06.24.07.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 07:09:31 -0700 (PDT)
Message-ID: <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
Subject: Re: moving a working array
From:   Wilson Jonathan <i400sjon@gmail.com>
To:     o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
Date:   Fri, 24 Jun 2022 15:09:30 +0100
In-Reply-To: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
References: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 2022-06-24 at 08:38 -0500, o1bigtenor wrote:
> Greetings
>=20
> I have a working (no issues) raid-10 array in one box.
>=20
> Want to move it to another (new) box.
>=20
> Please - - - a list of the software steps?
>=20
> (the physical moving is the easy part - - - the new box has room
> for a lot of drives and is ready for these 4 easily)
>=20
> Just don't want a fubar situation because I've taken the wrong order
> or even wrong steps.

First make a backup...

Second check the backup...

Third make another backup...

Fourth check that backup as well...

Move disks... (I personally have just amended the /etc/mdadm/mdadm.conf
file to include the uuid prior to moving disks and been good to go. BUT
if I'd have lost all the data, without backups, I'd not have been
fussed as it could all have been recreated/downloaded so I guess it all
depends on how important or unique the data is.)

But if you've got a new machine, why not get new disks and set up a
nice new clean raid and then just rsync the data accross. That way your
old disks become the backup, to the data you've newly transfered to
clean a clean array.=20

>=20
> The section 'using the array' has information but I'm not sure how
> that will work moving from one box to the other.
>=20
> (One question would be if the uuid of the array will remain the same
> as that would make things easier - - - I could copy the uuid from the
> existing and then just do the # mdadm --scan --assemble --uuid=3D
> blahblah )
>=20
> TIA

