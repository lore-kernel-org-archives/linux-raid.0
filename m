From: micah anderson <micah@debian.org>
Subject: Raid1 element stuck in (S) state
Date: Mon, 27 Oct 2014 10:18:47 -0400
Message-ID: <87k33lwq7s.fsf@muck.riseup.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

i've got a raid1 setup, where one drive died, it was replaced with a new
one, but its stuck in a (S) state and I can't seem to get it added into
the array, /proc/mdstat looks like this:

md3 : active raid1 sdc1[2](S) sdd1[1]
      976759672 blocks super 1.2 [2/1] [_U]

where sdc1 is the replaced drive.

What is the right way to get this added back?

thanks!
micah

