From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: Known good eSATA CardBus controllers
Date: Thu, 29 May 2008 09:31:56 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C5855871@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I bought an ST Labs CardBus controller with 2 ports to drive my 2 WD MyBooks in RAID1, and I have previously asked for help on this list about implementing RAID1, but it now seems that I have issues with my controller.

Can anyone recommend an eSATA CardBus controller that is known to work very well with Linux?

I ran badblocks on both disks simultaneously for 24 hours and then badblocks read the discs to verify the data and this worked perfectly, not a single error.

However, the discs spin down, and when I try to access them again, one of the ports (not any specific port) hangs trying to access the disc.  I can sort of get around this with sdparm -C start and a cron job, but it happens at boot time as well, which is not so easy to fix.

Would appreciate and tips on good known controllers.

Thanks
Andrew.
