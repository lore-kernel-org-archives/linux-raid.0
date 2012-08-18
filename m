From: Mark Knecht <markknecht@gmail.com>
Subject: Inexpensive RAID1 controller for home server?
Date: Sat, 18 Aug 2012 12:18:23 -0700
Message-ID: <CAK2H+eeLncyi6tCrM-vEhDzT7ykOA6LJP+Qka56rxUFGv2_urw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I wonder if there is direct knowledge here about this controller?

http://www.amazon.com/HighPoint-Rocket-SATA-PCI-Express-Controller/dp/B002VEWBGO

   I'm looking to add an inexpensive 2-port controller for a home
server that's out of ports on the MB but has room in the chassis for a
couple more drives running RAID1. The machine has been successfully
running mdadm for the last couple of years and the power supply is
plenty big enough to take on the new hardware.

   According the the Highpoint site is has native Linux support so it
doesn't appear there are any major driver availability issues. The one
problem I've read about that concerns me is it may conflict with
existing on-board Marvell eSATA controllers which this machine has.

   If this is a bad type of controller for a sinple RAID1 addition
please feel free to point me at an alternative. Amazon or NewEgg is
preferred.

Thanks,
Mark
