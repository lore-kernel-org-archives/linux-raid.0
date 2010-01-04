From: Adam Megacz <adam@megacz.com>
Subject: anybody using the gc-ramdisk?
Date: Mon, 04 Jan 2010 21:16:51 +0000
Message-ID: <xuu2aawtfu4c.fsf@nowhere.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Has anybody tried using the GC-Ramdisk (aka iRAM -- four DDR DIMMs on a
PCI card with a battery backup)

  http://www.gigabyte.com.tw/Products/Storage/Products_Overview.aspx?ProductID=2180
  http://en.wikipedia.org/wiki/I-RAM

Performance is much better than flash memories, but the price per
gigabyte is much greater and maximum capacity is far less.  It's really
closer to the nvram cache on a hardware raid card than an SSD.  The fact
that it loses data after 16 hours without power is a little worrisome,
although it uses a standard nimh battery so you can replace that with
something that lasts a lot longer...

Anyways, I'd be interested in hearing about anybody's experience with it.

I'm thinking of using this for my md write intent bitmap and ext4
journal, with "-o data=ordered" so close() and fsync() return as soon as
the data hits the DIMMs -- no need to wait for the disk to rotate around.

Any comments?

So often I hear debates about "hardware raid" versus "software raid"
which are actually debates over whether or not you ought to have some
sort of battery-backed write cache around.

  - a

