From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: RAID 1 (boot), RAID5 (root) and Lilo, Boot from Raid 1 (/dev/md0)
Date: Thu, 7 Oct 2004 16:28:52 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041007162852.2ef1b003@zrr.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: John Coffman <johninsd@san.rr.com>
List-Id: linux-raid.ids

Hi 

Just for the books:

After help from John Coffman and Bernd Fischer my Raid1 / Raid5 is now up and running.

This is what I had to do.

1. Install Lilo 22.6
2. mdadm -a /dev/md0 /dev/sda1
3. mount /dev/md1 /mnt/newroot
4. mount /dev/md0 /mnt/newroot/boot
5. Edit lilo.conf so boot = /dev/md0
6. Lilo -x mbr (Thanks John!!)

Paff!

also see:
http://www.ywesee.com/index.cgi?Software_Raid

Thanks for all the help.
Zeno
