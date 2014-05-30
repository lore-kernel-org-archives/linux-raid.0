From: Mark Knecht <markknecht@gmail.com>
Subject: Home desktop/server RAID upgrade
Date: Fri, 30 May 2014 12:04:07 -0700
Message-ID: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   My main home machine is a Gentoo machine built around a 5-disk
RAID6 using this WD 500GB RAID Edition drive:

http://www.amazon.com/gp/product/B001EMZPD0

I get about 1.4TB of storage after removing some space for boot and
swap. I have only about 100GB left which will be used up in the next
few months so I need to make some changes. The current RAID uses mdadm
and the motherboard SATA2 ports.

   Even using RAID6 I never run out of compute cycles and have lots of
memory so I'm fine with overall performance of the machine. I'm just
short of storage. The predominate use of this machine is trading in
the stock market, but nothing fast. It stores a lot of stock market
data but it's not doing anything like high-speed trading. Just a lot
of numerical analysis using R and then running a couple of Windows VMs
for the trading part.

   I have no issues if the machine was to go down for a day or two as
I have backups and other machines that can get me through a rough spot
until this box runs again.

   After looking at a few options (like just adding NAS externally,
RAID10, hardware RAID, etc.) I'm thinking I'll go the simple route,
use RAID1 with two or possibly three SATA3 3TB drives hooked to the
existing SATA2 ports. The two drives I'm considering and want to ask
here about are WD Red and WD Se versions:

WD Red 3TB:

http://www.amazon.com/dp/B008JJLW4M

WD Se 3TB:

http://www.amazon.com/dp/B00CYSYZZC

   I expect that either of these in RAID1 will be considerably faster
than my existing RAID6 and at 3TB will basically double my storage
which is more than I will likely need on this machine over the next
couple of years. If I need more I'll probably do some sort of NAS and
expect I'll use my current 500GB drives as a first pass on that.

   Anyway, I've got a few questions:

1) Are the WD Red drives appropriate for this sort of desktop/server
application or does the power saving stuff cause problems like the
older WD Green drives did? I.e. - Are the Red drives really just for
NAS applications?

2) Assuming the Red drives are OK then for roughly the same cost I
could get 3 WD Red or 2 WD Se drives. In a RAID1 would a 3-drive Red
RAID1 possibly be faster than the 2-drive Se RAID1 and at the same
time give me more safety? (Eliminating issues like whether all the
drives come from the same manufacturing lot and all fail at the same
time, etc.) This isn't overly important. I could always buy a 3rd Se
drive later.

3) If down the road I decided to buy a hardware SATA3 RAID controller
can I just plug these drives in and expect the new RAID1 to work on a
hardware controller or does that require a complete rebuild?

   For now that's it. Please let me know if I should supply more info.

Thanks in advance,
Mark
