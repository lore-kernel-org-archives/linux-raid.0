From: Mark Knecht <markknecht@gmail.com>
Subject: Any risk switching mdadm to static?
Date: Wed, 26 Dec 2012 09:57:39 -0800
Message-ID: <CAK2H+ee_u3bc7ZgN9z9CJbuSN+8HVyeTLwRaCn5hCP1fB3w8NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I run a bunch of home Gentoo systems most of which use mdadm,
currently version 3.1.4. I do not currently use initramfs's on any of
these systems but figure it's time for me to crawl out of my dark ages
swamp and try to become more enlightened.

   QUESTION: Is there an significant risk that a normal Gentoo system
of the stable variety (I.e. - not ~amd64) would encounter any problems
booting if mdadm-3.1.4 was rebuilt using the static flag? If it
matters most of my RAIDs are metadata-0.9. One is 1.2.

   If I did encounter a problem and couldn't boot is there a way to recover?

   Please note, I'm not asking right now about using mdadm from within
an initramfs. I'm only trying to ensure that if I rebuild mdadm with
the static flag the current system is still likely to boot OK.

   Folks on the Gentoo list say they didn't have any problems
switching, but they switched a long, long time ago so I'm just trying
to be extra sure.

Thanks in advance,
Mark
