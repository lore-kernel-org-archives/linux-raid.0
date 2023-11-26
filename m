Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5adNXRt"
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9E4F7
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 01:18:06 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-332e58d4219so1713632f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 01:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700990284; x=1701595084; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcRPwS1OqIWfnPb1rnQDXn5gxoEQxzVjF09Gjzc3VyA=;
        b=T5adNXRtne7gj3iqgwP2RNx5q7gG+LZhvWya8/xalFq8Hgr8bYzlwP5POOwoLiB2xm
         wQlUW+0ovtjFx3wvxmEef/eH2KPh1prfMIkFJsiEbddp75RKdqYD8e8W71FqGDl+ylcV
         G6LTaefq1ch1uRfVAGOnhwPzKMKJSu0M53AtIuK0If8TGvb7IuOhsk97afOSMz8fZnlb
         KZvQBoqQOT8fgZdghTf6XNiC/5jnzuz9qUmCMqgGlAAhVGS1YyM/HkCLY5RjFE+fWUVN
         N0fx/3mmQZRutQo62XoooWu6A4CzwUPwKwiwlMXHO3fA4CBQuGLg8ID1OJfBukSYhnRV
         v4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700990284; x=1701595084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dcRPwS1OqIWfnPb1rnQDXn5gxoEQxzVjF09Gjzc3VyA=;
        b=hOC9WZksTwyJcLdal9fBwH+TiFnASn6VXeWRCtxTy3PFFi2M/NK6jML9e4Ig/r2qE2
         FUM+vwdqGHoSItx860q7vohceH2e4E0l1ENe62Vkcj11/4oHFz9LZoM4NDB7ic+ncAMV
         JoDMT/F0ulkljC2pARHyB5BhcXcAY2JBDaAdH5cl6WPGNdzJtt6UUjqhkDDOH/T0yb8h
         ngb0iACHDGzl5jc04PpUIoxT/q20nZpecM6J/5KHeXuJz9wmas1WE9xPutt1QGqpqvrL
         ErnZcJ48M7y32Oo/N+WeZpVYOeERQIIz1TBsZC27bUNmXdo+UR9f26Xvj+RPFZdj9uuh
         gSBg==
X-Gm-Message-State: AOJu0YwR9hI0FZBvbDuqjcIJa4h8AXlSMN6SfIGRbKQh8bSEI5Bqkd19
	7thOaK2x0FrSV8J13qxbbT3vBtxiC5XHABr77G6H09KFaTA=
X-Google-Smtp-Source: AGHT+IH2nWn2G6daJFwiL5OBNq1FYCiSvHnl9tCzpcUTsIMI7kfvgJ4KCo+GCx99wMqAlR42Tc1LFrsIPwtqHVuW7nI=
X-Received: by 2002:adf:e84b:0:b0:321:68fa:70aa with SMTP id
 d11-20020adfe84b000000b0032168fa70aamr6178353wrn.9.1700990284294; Sun, 26 Nov
 2023 01:18:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
In-Reply-To: <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
From: Alexander Lyakas <alex.bolshoy@gmail.com>
Date: Sun, 26 Nov 2023 11:17:59 +0200
Message-ID: <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Song,

Thank you for your response.

On Fri, Nov 24, 2023 at 1:58=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Alexander,
>
> Thanks for the report.
>
> On Wed, Nov 22, 2023 at 1:42=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gm=
ail.com> wrote:
> >
> > Hello Song Liu,
> >
> > We had a raid6 with 6 drives, all drives marked as In_sync. At some
> > point drive in slot 5 (last drive) was marked as Faulty, due to
> > timeout IO error. Superblocks of all other drives got updated with
> > event count higher by 1. However, the Faulty drive was still not
> > ejected from the array by remove_and_add_spares(), probably because it
> > still had nr_pending. This situation was going on for 20 minutes, and
> > the Faulty drive was still not being removed from the array. But array
> > continued serving writes, skipping the Faulty drive as designed.
> >
> > After about 20 minutes, the machine got rebooted due to some other reas=
on.
> >
> > After reboot, the array got assembled, and the event counter
> > difference was 1 between the problematic drive and all other drives.
> > Even count on all drives was 2834681, but on the problematic drive it
> > was 2834680. As a result, mdadm considered the problematic drive as
> > up-to-date, due to this code in mdadm[1]. Kernel also accepted such
> > difference of 1, as can be seen in super_1_validate() [2].
>
> Did super_1_validate() set the bad drive as Faulty?
>
>                 switch(role) {
>                 case MD_DISK_ROLE_SPARE: /* spare */
>                         break;
>                 case MD_DISK_ROLE_FAULTY: /* faulty */
>                         set_bit(Faulty, &rdev->flags);
>                         break;
>
> AFAICT, this should stop the bad drive from going bad to the array.
> If this doesn't work, there might be some bug somewhere.
This can never happen. The reason is that a superblock of a particular
device will never record about *itself* that it is Faulty. When a
device fails, we mark it as Faulty in memory, and then md_update_sb()
will skip updating the superblock of this particular device. I have
discussed this also many years ago with Neil[1].

Can you please comment whether you believe that treating event counter
difference 1 as "still up to date" is safe?

Thanks,
Alex.



[1]
Quoting from https://www.spinics.net/lists/raid/msg37003.html
Question:
When a drive fails, the kernel skips updating its superblock, and
updates all other superblocks that this drive is Faulty. How can it
happen that a drive can mark itself as Faulty in its own superblock? I
saw code in mdadm checking for this.
Answer:
It cannot, as you say. I don't remember why mdadm checks for that.
Maybe a very old version of the kernel code could do that.
