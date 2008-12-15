From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: behavior different from mdadm 2.6.4 and 3.0?
Date: Mon, 15 Dec 2008 08:54:56 -0600
Message-ID: <cccedfc60812150654u2e841bf8na517a75820d0c463@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mdadm --incremental seems to behave differently for me between mdadm
2.6.4 and 3.0

With 2.6.4, mdadm --incremental /dev/nbd0 does this:

mdadm: /dev/nbd0 attached to /dev/md10 which is already active.

With 3.0, it does this:

mdadm: /dev/md10 is already in use.

and does *not* add it to the array.

-- 
Jon
