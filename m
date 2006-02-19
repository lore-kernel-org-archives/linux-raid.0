From: Alex Davis <alex14641@yahoo.com>
Subject: re: Raid on USB2 ?
Date: Sun, 19 Feb 2006 07:36:42 -0800 (PST)
Message-ID: <20060219153642.53095.qmail@web50210.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, ken.walker@manchester.ac.uk
List-Id: linux-raid.ids

>Anybody tried a Raid1 or Raid5 on USB2.
>
>If so did it crawl or was it usable ?
>
>Many thanks
>
>Ken :o)

I have a USB raid5 consisting of 4 200GB drives. hdparm -t on the md device
gives 42 MB/s, which is nearly twice as fast as the internal drive (this is
a laptop). Since the RAID is storing large files (smallest file is about 1.5
MB), I used a stripe size of 128 K, and specified '-T largefile' to mke2fs.
All the disks, USB-to-IDE converters, and the hub are in one ATX case. It's
used to store pics from hi-res digital cameras, and video from camcorders.

I've been using the RAID for 6 months with no problems.

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
