From: Roberto Spadim <roberto@spadim.com.br>
Subject: md - cache
Date: Wed, 16 Feb 2011 13:01:09 -0300
Message-ID: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys, i was thinking about cache insues
since md = multiple devices
could we implement a new device used for caches? (port bcache to md,
or flashcache (facebook))
something like:
mdadm --create /dev/md1 --level=cache --cache-device=/dev/XXX
--data-device=/dev/ZZZZ

-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
