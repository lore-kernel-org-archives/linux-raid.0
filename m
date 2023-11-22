Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEoip+OQ"
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819CDD65
	for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 01:42:22 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9fa2714e828so566631066b.1
        for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 01:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700646140; x=1701250940; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lFJJ0BbQctXsk/rlSD/JHqrKKrUvsKd+O6BVu2CMXUY=;
        b=iEoip+OQj9lUwyC3YE7Vrg5r3T7gTWgRdUObqM/GOwr64LQV0p7wVaQCNMYbbN3tJI
         Azldkg9VJSvkret26GJLO8ODlCX8HvTfBxUuvL/Y6VmhPSMG3AgAOwlI7idlbgWDAmve
         e7J1sIKvX1EadmXWfEG4ExSS49GrgmN+RksnTBNCzK6M7p1VIIaHx8CZVE6clhFO+J/8
         J4UntXUb7iaDaAfDlfj3fjyU8e5pe0A7dGYos293qaCvjm1+1UZUcbzti4bOXrM4Cxx4
         VJxywzlJoyWUkKivL2BPfPk8DGjPEGbRpCXZnpXfEitxMhyhPU5CT252c4Z4BmwgvS72
         /8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700646140; x=1701250940;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFJJ0BbQctXsk/rlSD/JHqrKKrUvsKd+O6BVu2CMXUY=;
        b=wPYropc7XE1IaJlS96p5OGy4pOl0Lc9QcPifgevr9SbW0cGPh8urEGTawQDZwItHQI
         TiWElLv5J7jcbhM50+fgUE12jO/g1WP7sffQUFdvxbWGj5g+JUW0F7ViPp2hwJq6Z4Tv
         T0yUun/jEu/ZqEpemHGJJpj+7AdJcibd0ZnN4FNQMTbkrPi9Qfw5tzaHC2Sf/qes59+i
         IKFSC8G5JC2bTVkiTROT4SO0KnlaiSjTjmSp+dbOiH7HaQtnrx8HwAnluocJDXn+PCpe
         bC22Vlnwn6vVNtqbvr0vyGQZ5H3KQ9QH/cWigMpQxHnj1w0s7ZhXoHcRpt/lQ5NAaDdn
         WBDQ==
X-Gm-Message-State: AOJu0YzDSMB5XKYybzrlvoP3jwYijpru80qJuy7QWk0Fr2I3UQa4fXOz
	Z1byYNe8lHUnodrYMsiuqaBaSBXNYdX46tCEJPtuvrLUoA0=
X-Google-Smtp-Source: AGHT+IEBmY1vs3XjqseIeoag4/LznRkg0OIFpZnu+V40mXWV4rZtpvL+iB2QuaZ8qgJNMjL224S2FOpOTFp0Oyi8NtA=
X-Received: by 2002:a17:907:3c13:b0:9e0:5dab:a0f1 with SMTP id
 gh19-20020a1709073c1300b009e05daba0f1mr973743ejc.36.1700646139899; Wed, 22
 Nov 2023 01:42:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alexander Lyakas <alex.bolshoy@gmail.com>
Date: Wed, 22 Nov 2023 11:42:09 +0200
Message-ID: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
Subject: raid6 corruption after assembling with event counter difference of 1
To: song@kernel.org, linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello Song Liu,

We had a raid6 with 6 drives, all drives marked as In_sync. At some
point drive in slot 5 (last drive) was marked as Faulty, due to
timeout IO error. Superblocks of all other drives got updated with
event count higher by 1. However, the Faulty drive was still not
ejected from the array by remove_and_add_spares(), probably because it
still had nr_pending. This situation was going on for 20 minutes, and
the Faulty drive was still not being removed from the array. But array
continued serving writes, skipping the Faulty drive as designed.

After about 20 minutes, the machine got rebooted due to some other reason.

After reboot, the array got assembled, and the event counter
difference was 1 between the problematic drive and all other drives.
Even count on all drives was 2834681, but on the problematic drive it
was 2834680. As a result, mdadm considered the problematic drive as
up-to-date, due to this code in mdadm[1]. Kernel also accepted such
difference of 1, as can be seen in super_1_validate() [2].

In addition, the array was marked as dirty, so RESYNC of the array
started. For raid6, to my understanding, resync re-calculates parity
blocks based on data blocks. But many data blocks on the problematic
drive were not up to date, because this drive was marked as Faulty for
20 minutes and writes to it were skipped. As a result, REYNC made the
parity blocks to match the not-up-to-date data blocks from the
problematic drive. Data on the array became unusable.

Many years ago, I asked Neil why event count difference of 1 was
allowed. He responded that this was to address the case when the
machine crashes in the middle of superblock writes, so some superblock
writes succeeded and some failed. In such case, allowing event count
difference of 1 is legitimate.

Can you please comment of whether this behavior seems correct, in
light of the scenario above?

Thanks,
Alex.

[1]
int event_margin = 1; /* always allow a difference of '1'
       * like the kernel does
       */
...
/* Require event counter to be same as, or just less than,
* most recent.  If it is bigger, it must be a stray spare and
* should be ignored.
*/
if (devices[j].i.events+event_margin >=
    devices[most_recent].i.events &&
    devices[j].i.events <=
    devices[most_recent].i.events
) {
devices[j].uptodate = 1;

[2]
} else if (mddev->pers == NULL) {
/* Insist of good event counter while assembling, except for
* spares (which don't need an event count) */
++ev1;
if (rdev->desc_nr >= 0 &&
    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
    (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
     le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL))
if (ev1 < mddev->events)
return -EINVAL;
