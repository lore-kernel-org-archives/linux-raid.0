From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: How to backup of large md raid volumes?
Date: Sat, 20 May 2017 20:14:16 +0200
Message-ID: <7349ab95-a06b-36af-6a27-159b63bd0a5d@thelounge.net>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
 <28a4540b-c5ac-bd8d-c030-6d718a02fdfc@thelounge.net>
 <59208443.7080404@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59208443.7080404@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 20.05.2017 um 20:00 schrieb Wols Lists:
> I'd be inclined to try and get an e-SATA or USB-3 dock, and just back up
> on to independent 8TB drives. Mind you, at £70 for a 3TB Barracuda, $500
> for 16TB of disk doesn't sound pricey at all ...

yes but it don't make much fun if you need to spread your backups to 
several disks when you can have just one with all

> One thing to watch out for, it sounds like the OP has mostly music and
> videos, so compression is likely to INCREASE the disk space required...

yo are confusing "compress-force=zlib" with "compress=zlib" - read the 
BTRFS manuals, it's practically the same as comp-lzo for openvpn - 
uncompressable data are not compressed
