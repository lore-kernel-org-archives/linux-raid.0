From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: booting from a HW RAID volume
Date: Wed, 26 Jan 2005 20:15:27 -0500
Message-ID: <200501270113.j0R1DU908227@www.watkins-home.com>
References: <41F7D75B.1040806@mail.fsix.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41F7D75B.1040806@mail.fsix.com>
Sender: linux-raid-owner@vger.kernel.org
To: cknowlton@science.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Many hardware based RAID systems allow you to create more that 1 virtual
disk.  This is done with luns.  If your hardware supports it, you could
split your monster disk (2.75TB) into 2 or more virtual disks.  The first
would be very small, just for boot, or maybe the OS.

Or you could split the 2.75TB into virtual disks that are all smaller than
2TB.

Just some ideas.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Carlos Knowlton
Sent: Wednesday, January 26, 2005 12:46 PM
To: linux-raid@vger.kernel.org
Subject: booting from a HW RAID volume

Hello,


I'm using a 3Ware 9500 12 Hardware RAID controller that has 12 of 250GB 
S-ATA drives (total storage = 2.75TB).  To my 64bit FC3 box, this looks 
like a single huge SCSI disk (/dev/sda).  I used parted to create GPT 
partitions on it, (because nothing else would work on a volume that 
big).  This seems to work fine, except that grub doesn't seem to 
recognize GPT partitions.
So here's my question:  Does anyone know a way to boot from huge volumes 
(where "huge" =  >2TB)?   even if it doesn't involve grub, or GPT, I'm 
open to suggestions.  Any clues?


Thanks!
-Carlos Knowlton
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

