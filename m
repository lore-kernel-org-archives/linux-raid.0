From: Paul Phillips <paulp@improving.org>
Subject: new raid system for home use
Date: Sat, 17 Apr 2004 20:34:19 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404171926100.3103@spoon.loc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm building a new system to be my home media server (as well as web,
mail, etc.) I already have a terabyte of data so I'm aiming at about a
three terabyte capacity.  My tentative plan is to use 8 of the new Hitachi
Deskstar 7K400 400 GB SATA drives in a RAID-5 configuration, and 2
additional drives in a RAID-1 configuration as the boot device and higher
priority data storage.  I'd like to use debian unstable and kernel v2.6.

I've never built anything like this before though so I'm a bit nervous
I'll make unwise hardware choices.  So I appeal to the locals for any
specific or general advice you may care to offer.  Once it's running I'll
document my setup for fellow degenerate home multi-terabyte data amassers.
I did not find the web overflowing with instances of people building such
large linux RAID servers in non-business settings.

Important:

  * top-notch linux support for { RAID card, gigabit ethernet chipset, ??? }
  * components with proven linux functionality/reliability
  * easy expandability
  * no bottlenecks if I want to stream video to up to four locations
  * doesn't demand rack-mount

Would be nice:

  * open source drivers for all components if possible, or most if not
  * all things being equal, the quieter and cooler-running version

Not particularly important:

  * endless oodles of CPU (I'd think 2x3GHz would be megaplenty)
  * hot swap
  * uptime > 99.9%
  * drive reliability (willing to keep spares handy and drop them
      in as the occasion warrants)
  * price (not cost-unconscious, but not spend-averse)

Other matters of interest:

  * Would RAID-6 be overkill? I doubt I'll be backing up the big array,
      ever.  Losing it would suck a lot but not end my existence.
  * Is EVMS mature enough to use if I'm bleeding edge averse in that
      area? I'd never heard of it before reading this list.
  * Software vs. Hardware RAID? I imagine this is a good place for
      Hardware if I buy the right card, but maybe Software would require
      less expertise and fiddling to get running in peak form.
  * Would I be smarter to settle for kernel 2.4 at this time?
  * I'm probably failing to consider the five most important factors...

Examples of the items I might land on if I had to buy this today without
wise feedback:

  *  Chassis: http://www.baber.com/cases/mpe_ft2_black.htm
  *     RAID: http://www.3ware.com/products/serial_ata9000.asp
  * 10 Disks: http://www.hitachigst.com/hdd/desk/7k400.html
  *     MoBo: ???
  * CPU, RAM: TBD based on MoBo

Many many thanks for all replies.

-- 
Paul Phillips      | All zork and no slay makes Jack a troll boy.
Analgesic          |
Empiricist         |
pull his pi pal!   |----------* http://www.improving.org/paulp/ *----------
