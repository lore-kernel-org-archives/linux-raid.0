From: <peter.greis@ubs.com>
Subject: RE: Fresh setup....
Date: Tue, 21 Sep 2004 11:26:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E3CB7@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: thunder7@xs4all.nl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

An excellent idea. Maybe someone has insight into the next hurdle... it looks like there is nVidia nForce3 support in 2.6.8.1 (sata_nv). I have built this kernel (make oldconfig and the like), but on boot I get a slew of messages (ata_) which seem to indicate that libata is not loaded. Which option do I need in my .config to get this built in ?

I have also come across http://www.amdzone.com/modules.php?op=modload&name=PNphpBB2&file=viewtopic&t=2300 which would make me think I'm sol anyway...

Thanks to everyone for all of the help,

-Peter

-----Original Message----- 
From: Jurriaan [mailto:thunder7@xs4all.nl]
Sent: 20 September 2004 19:21
To: Greis, Peter
Cc: linux-raid@vger.kernel.org
Subject: Re: Fresh setup....


From: peter.greis@ubs.com <peter.greis@ubs.com>
Date: Mon, Sep 20, 2004 at 03:21:26PM +0200
> OK, I believe that I have determined that I need a newer kernel (2.6.7 or later) to get this new mobo running (Asus K8N-E deluxe) with RAID-1 OS disks. Is my only option here to build up the system on a normal IDE drive, get the kernel rebuilt and up to date, configure the raid, then "dd" the partitions over ?
> 
Why not just unplug one of the drives and resync when you have your new
kernel up and running? The usual precautions apply (tested backups etc).

Good luck,
Jurriaan
-- 
Linux is obsolete
	Andrew Tanenbaum
Debian (Unstable) GNU/Linux 2.6.9-rc1-mm4 2x6209 bogomips load 1.38
