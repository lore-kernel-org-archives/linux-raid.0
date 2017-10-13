From: Caspar Smit <c.smit@truebit.nl>
Subject: INITRDSTART replacement
Date: Fri, 13 Oct 2017 14:16:32 +0200
Message-ID: <CADvHm=a3haC3xVKJ5QuOSftw5ttU=wJq2_bp8LJfMDVn1g6=Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've always used the INITRDSTART directive in the /etc/default/mdadm
config file to prevent any md from starting during the initram phase
of boot (INITRDSTART=none). Some disk controller drivers do not always
present their disks in time before the md_mod, raid1, etc.. drivers
are loaded, leaving you with a degraded assembled array. I do not need
to boot from an md device so i don't need the md drivers during the
initram phase.

I noticed in the changelog that INITRDSTART support was dropped in
version 3.4-2 (I'm using debian Jessie)

Is there any new method to prevent md's from starting in the initram
phase or am i doing something completely wrong here?

Kind regards,
Caspar
