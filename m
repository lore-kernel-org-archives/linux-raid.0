From: Chris Webb <chris@arachsys.com>
Subject: Assume-clean for md grow
Date: Wed, 25 Feb 2009 14:22:29 +0000
Message-ID: <20090225142229.GI32722@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use md arrays made up of slots synthesized through device mapper from
physical storage distributed across a cluster of machines. When these slots
are created, they are guaranteed to be zero-initialised, so I can safely do
mdadm --create --assume-clean to avoid an initial resync.

When I grow the backing slots, the new storage space is also
zero-initialised, so I'd like to be able to do the equivalent of
mdadm --grow --size=max --assume-clean. However, --assume-clean isn't
supported for grow operations.

Is there some way I can tell the kernel driver (perhaps through sysfs) that
the resync is clean/already complete to avoid unnecessary heavy IO on every
grow? I tried things like

  echo idle >/sys/block/mdX/md/sync_action

without success.

Cheers,

Chris.
