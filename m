From: Louwrentius <louwrentius@gmail.com>
Subject: Showcase and thanks to the developers
Date: Sun, 2 Aug 2009 23:12:04 +0200
Message-ID: <f13bf29a0908021412h6ab1d976y81154d6b0b88596d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've build a storage system based on Debian Linux with a 2.6.28
kernel. It houses 18 GB of storage based on 20 disks in RAID 6 using
software RAID.

The funny thing is that this box does read speeds of 1.1 GB/s, which
beats many hardware-based RAID cards.

I am impressed. Of course IO would be another issue, this is only
linear reads. But it's nice. It should go faster, it did 1.1 GB/s with
10 disks, it should do more with 20. I think there is some hardware
bottleneck, but I don't know for sure. Anyway, it is a NAS and the
Gigabit NIC is the limit here, so who cares anyway.

I like to thank the developers for enabling me to build a relatively
cheap and large storage array without the need for a special hardware
controller.

For pictures, additional specs etc. please visit my blog-post (no ads).

http://louwrentius.blogspot.com/2009/07/20-disk-18-tb-raid-6-storage-based-on.html
