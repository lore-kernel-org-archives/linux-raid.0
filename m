From: <danfisher@bwkip.com>
Subject: Raid Boot problem
Date: Tue, 1 Apr 2003 23:47:49 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2809.204.250.25.205.1049258869.squirrel@webmail.bwkip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: danfisher@bwkip.com
List-Id: linux-raid.ids

I have raid up and running again but for some reason when I switched the
drives resynced them and typed lilo to re-add a boot sector the freshly
raided hdb it just tells me

boot = /dev/hda, map = /boot/map.0301
Added linux *



It would normally say:

boot = /dev/hda, map = /boot/map.0301
Added linux *
boot = /dev/hdb, map = /boot/map.0341
Added linux *

Which tells me both drives are  bootable now.  The "map.0341" is still in
the boot directory but where do I add it?

Thanks!


