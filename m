From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: is there any way to delay reconstruction?
Date: Tue, 14 May 2002 16:09:54 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205141557330.5308-100000@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

this weekend i was trying to diagnose a system instability, and i kept on
having to hard cycle my system.

i was generally doing this from "init=/bin/sh" boots with all filesystems
mounted ro ... however i've got LVM on top of md here, and perhaps LVM was
doing some writing even when the filesystems were ro.

because of the hard cycle, every time i booted, md was convinced the disks
were out of sync and it went and reconstructed parity.

one of the things i was attempting to do with this system was reduce it
from ata5 to ata2 -- because i suspect my main issues are with cable
length.  the only way i see to do this presently is with "hdparm -X66",
but hdparm won't be able to do this successfully when md is busy doing
reconstruction...

and i saw no way to stop or delay reconstruction.

is there a way to stop reconstruction?

is there a way to force md to be read-only?

it'd be rad if there was an inexpensive bit of battery backed ram which
could be added to a system so md had somewhere to keep track of the state
of the raid... so that a hard cycle doesn't necessarily require parity
reconstruction :)

-dean

