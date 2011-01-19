From: FLD <fld@r00t3d.com>
Subject: I wonder what the bad blocks were storing
Date: Wed, 19 Jan 2011 16:03:13 +0200
Message-ID: <20110119140313.GB18805@r00t3d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After dd_rescuing a device that belongs to a degraded raid-5 array I got
a summary like this:

Summary for /dev/sdb1 -> /dev/sdg1:
dd_rescue: (info):
ipos: 976760001.0k,
opos: 976760001.0k,
xferd: 976760001.0k,
errs: 48,
errxfer: 24.0k,
succxfer: 976759977.0k

Since it's a degraded array I'm guessing there is gonna be 24 KiB worth
of damage to the filesystem. But I do have fairly recent full filesystem 
level backups, it would be nice if I could figure out what those 48 bad 
sectors contained, so I could restore just those things from my backups.

So basically I would need to figure out which blocks are the 48 damaged
ones on /dev/md0 and then ask my filesystems debugging tools to tell me
what those blocks should contain.

And to make it a bit more fun there is a luks crypto layer between the
md and filesystem, but that should be a simple luks header sized offset.
