From: Richard Scobie <richard@sauce.co.nz>
Subject: 3ware JBOD
Date: Mon, 01 Mar 2004 15:00:32 +1300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40429940.9000408@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3ware 7506-4LP with 4 x 250 which when first installed showed 
up in the system as SCSI devices sda-d.

I built and tested various software RAID arrays on it, then decided to 
try various hardware arrays, which tested fine.

Wishing to go back and build some more linux software arrays, I used the 
3ware CLI utility to delete the array.

Now, when I boot up, although all 4 drives show up in the 3ware BIOS, 
dmesg now shows:

SCSI subsystem driver Revision: 1.00
3ware Storage Controller device driver for Linux v1.02.00.037.
3w-xxxx: No valid units for card 0.
scsi0 : Found a 3ware Storage Controller at 0x7000, IRQ: 28, P-chip: 1.3
scsi0 : 3ware Storage Controller.

Can anyone please tell me how I get to see sda-d again?

Regards,

Richard

