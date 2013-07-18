From: Michael Heide <lkml662@der-he.de>
Subject: write-mostly vs. write-behind
Date: Thu, 18 Jul 2013 09:25:10 +0200
Message-ID: <20130718092510.6f4a6fd6@tbb-phenom>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

the md manpage says there are write-mostly and write-behind options for 
md raid1 and you can use write-behind on devices where write-mostly
is activated. 

I'm using a small low-power home-server with a HDD and an usb flash drive, 
where one HDD partition (with important data) is mirrored (raid1) to 
the flash drive. (other data is not that important)

The flash drive (usb-stick / pen-drive / usb-key) is faster in reads and 
slower in writes than the HDD. So read requests are slow because of the
slower HDD and write requests are even slower because of the slow flash
drive.

I would like to use "write-mostly" with the HDD and "write-behind" with
the flash drive. That's impossible with Linux MD Raids, right?

Regards
Michael

(I'm not subscribed)
