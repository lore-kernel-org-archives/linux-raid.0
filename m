From: Mike Myers <mikesm559@yahoo.com>
Subject: Adaptec raid congtrollers for SATA disks under software raid
Date: Thu, 30 Oct 2008 21:37:00 -0700 (PDT)
Message-ID: <47751.64665.qm@web30802.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  I'm moving my NAS to a new motherboard and disk controller to increase the number of ports.  Right now I feed a couple PMP's worth of SATA disks with a marvell '7042 based controller, but am migrating to a supermicro 775 motherboard that has a few PCI-X slots.  I can get a couple adaptec 16 port SATA  PCI-X controllers on the cheap, but want to migrate my existing software raid arrays to the new ports, so I don't want to use the adaptec RAID software (software raid should be faster in any case).

I believe if I configure the adaptec's BIOS to use JBOD mode instead of the card's RAID that each of the attached disks looks like a normal SATA port in linux that will allow them to be used with software raid in the normal way.  The question I have for the group is how good is the performance of these controllers when used as "dumb" ports in software raid mode?  

Are the LSI megaraid cards better?

I'm curious as to what people think the best SATA controller is these days that has 8 or 16 ports per card driving software raid?

thanks much!
mike


      
