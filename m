From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Hardware advice for software raid
Date: Tue, 1 Apr 2014 14:09:02 -0500
Message-ID: <CAPSPcXjo5J-Omj+94RkKPXSNUwBHT4GWKmkYuWV9htniZNf+sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a dedicated, consumer hw, media/file server with a 6 drive
raid6 of 2tb drives, all plugged directly into the sata ports on my
motherboard, an asrock z77.  A while back I had a problem which seemed
like cascade failure of drives, but Stan Hoeppner and Phil Turmel
helped me to figure out it was a PSU having gone bad and delivering
dirty power.

After replacing the PSU things worked fine, or so I thought.  At some
point I noticed I have quite a bit of trouble making it through a
resync without the machine locking up.  When I realized it wasn't tied
to a resync in particular but any extended heavy I/O, I lowered the
sync_speed_max to 10,000, I was able to get through a repair (no
mismatches found!).

I'm guessing that the motherboard has some problem (perhaps
originating from the bad PSU?), and I want to switch to a dedicated
HBA card to make this more modular.

Stan had suggested the LSI SATA/SAS 9211-8i in many threads in the
archives.  If I use this card as my HBA, is there any particular
motherboard which would be better suited than others?

thanks
