Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65034C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 20:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbiDAU0t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352528AbiDAU0e (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Apr 2022 16:26:34 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382742BC2
        for <linux-raid@vger.kernel.org>; Fri,  1 Apr 2022 13:24:10 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e203so6932954ybc.12
        for <linux-raid@vger.kernel.org>; Fri, 01 Apr 2022 13:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=uWtA0OjKlW1InkKbmNfKENi4oKvqCw5gfDkLjuUWlcA=;
        b=imeTUbOvZPmEuBqOEDID8OOjP5iJGe3WHJg4m7a31E8NuZNUuv/YWxjnNhhro9ImKW
         yclUg6Dr2ZuTpJfcAyuMLGDc/HNM6lkjEZFMJ2CRXli1AZ8v0Ij1NvZFqP/lUhAW83/s
         0R2k7qtJHOM0ce2SgthueIExMXBpUGvyaHvZWL1U0T1HoZZxaPNgTHmQdLT9n1iRLsnK
         rSCcJx935nYwKhESSIrLYk9r4Yc3odcPoCchwe//VghCoxc4ZwAwa2awAfZw1li8B2bE
         xotCHRSRbxpuHJ8g8NyE+5lB736bSqfxMqN2ViCZkbVEGcTdZjkO8Q6/pTAwUCCSkgfB
         lwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=uWtA0OjKlW1InkKbmNfKENi4oKvqCw5gfDkLjuUWlcA=;
        b=y5fVF9MK9+COxOLAOlUk2NiFfEwZOCfmrXt1At2yRTLwXrbwlvIgoqcg9KAKxwYT5t
         bRgBf/ey0Exza1AjwkTkL7Md8wHkUJXTDkcagjSLjl+SGD8O5yqgZd944nxyxNle4M6X
         z4BnmodUrQoDV1Ae22Rszq2qXmXlzKOTJ6s1wslRUbaxSmrvCBNdRAPFB+lBpREE2ldk
         K5vZ/eMjGS35qcGMK+rsJhF1kq4rTm2A2H0gQceAOmYvQkI0uGOhB/GWamV+JGyDY/2N
         cpOGfd/RQvylij6ffXRK+HjEmoc/EAlXANANIInEwaUrYxCjRFV8UKqWZBpacMl2jeuE
         OAwg==
X-Gm-Message-State: AOAM533cRBi8OrOBSdo83ADFTvcfsBW1jyXYKSZuWTCevr3zNT2B6cOV
        ocQQaCZEALnLlcZs6ccKs4UVJBQ+Inbfn0vJbBw=
X-Google-Smtp-Source: ABdhPJx8dyt6xJtyFX7qugg6mvxDN/jHSQYAtCW44+k8Qai43kPEib+8znyqYfYwZcDLaTHzkffpGcEdBYMfMA2s9ek=
X-Received: by 2002:a25:7a06:0:b0:63d:88fe:38f1 with SMTP id
 v6-20020a257a06000000b0063d88fe38f1mr2168029ybc.529.1648844649424; Fri, 01
 Apr 2022 13:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk> <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk> <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com> <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk>
In-Reply-To: <776f85f6-33a2-f226-f6ff-09e736ccefd1@youngman.org.uk>
Reply-To: bruce.korb+reply@gmail.com
From:   Bruce Korb <bruce.korb@gmail.com>
Date:   Fri, 1 Apr 2022 13:23:33 -0700
Message-ID: <CAKRnqNL0aNWGHFgcz-KVKn3dpVpUa1oN5miu+oiv16vdJx3OHw@mail.gmail.com>
Subject: Re: Trying to rescue a RAID-1 array
To:     Wol <antlists@youngman.org.uk>
Cc:     brucekorbreply <bruce.korb+reply@gmail.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

 - Bruce

On Fri, Apr 1, 2022 at 12:45 PM Wol <antlists@youngman.org.uk> wrote:
>
> Hmmm... what drives are the damaged array on? There's an intact raid1
> there ...

In my script, I focused on /dev/sd[ce]1 because those partitions have
(or had) the data.
I'm guessing they're toast, but I never intentionally had a new RAID
formatted, let alone a new FS installed.
Given that the installer did stuff I did not intend for it to do, I
cannot really guarantee anything anymore.

> On 01/04/2022 19:21, Bruce Korb wrote:
>
> So sda5 has a raid1 on it  ...
new disk, no data -- same with sdb5.

> and mounted as /home.
New disks, new /home hierarchy.

> > =E2=94=9Cscsi 2:0:0:0 ATA      HGST HMS5C4040AL {PL1331LAHEZZ5H}
> > =E2=94=82=E2=94=94sdc 3.64t [8:32] Partitioned (gpt)
> > =E2=94=82 =E2=94=9Csdc1 3.20t [8:33] MD raid0 (0/2) (w/ sde1) in_sync '=
any:1'
> > {f624aab2-afc1-8758-5c20-d34955b9b36f}
> > =E2=94=82 =E2=94=82=E2=94=94md1 6.40t [9:1] MD v1.0 raid0 (2) clean, 64=
k Chunk, None (None)
> > None {f624aab2:-afc1-87:58-5c20-:d34955b9b36f}
> > =E2=94=82 =E2=94=82                 xfs 'User' {fe716da2-b515-4fd6-8ea6=
-f44f48038b78}
>
> This looks promising ... dunno what on earth it thought it was doing,
> but it's telling me that on sdc1 we have a raid 0, version 1.0, with an
> xfs on it. Is there any chance your install formatted the new raid?

Chance? Sure, because it didn't do what I was expecting. It was never,
ever mounted.
During the install, I made certain that no mount point was associated with =
it.

Once the install was done, I did do a manual "mount /dev/md1 /mnt",
but said I needed
to run the "xfs_recover" program. I started it, but then I realized
that it was looking at
7TB of striped data, whereas it was actually 3.5TB of redundant data.
That wasn't going to work.

> Because if it did your data is probably toast, but if it didn't we might
> be home and dry.

If I can figure out how to mount it (read only), then I can see if a
new FS was installed.
If it wasn't, then I've got my data.

> Can you mount the raid? This just looks funny to me though, so make sure
> it's read only.
>
> Seeing as it made it v1.0, that means the raid superblock is at the end
> of the device and will not have done much if any damage ...

+1 !!

> It's probably a good idea to create a loopback device and mount it via
> that because it will protect the filesystem.
>
> Does any of this feel like it's right?

I don't remember back all those years ago about which file system
openSUSE decided to use as default.
I'm pretty sure it was either XFS or EXT4. I did file systems many
years ago, but that was back in the mid-80s.
IOW, I don't know how to look for the file system layout data to
figure out how to mount this beast.
I thought I could rely on the install detecting the RAID and doing the
right thing. Obviously not. :(
