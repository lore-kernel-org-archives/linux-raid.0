From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Autodetect problem w/ SCSI
Date: Tue, 1 Jun 2004 20:39:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040601183951.GA22078@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



I made plenty of RAID1 systems w/ ide disk: OK.
Now I tried a SCSI system and I can't make the kernel recognize the partition
to make into an array. Of course partitions are 'fd': raid autodetect.

Kernel recognizes the scsi hw (aic7xxx compiled in), then starts  
"md: Autodetecting RAID arrays"  that will just fail to find the arrays.

If I start from a live CD, I can "mdadm -A /dev/md0 /dev/sda6 /dev/sdb6" and
the array starts and I can mount it.

Is there something peculiar of SCSI systems I'm just ignoring?



TYA

sandro
*:-)


I'm sorry to admit it's quite URGENT to me to get to a solution... this is a
replacement for a customer after 4 ide disks failure in 5 months...



-- 
Sandro Dentella  *:-)
e-mail: sandro.dentella@tin.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
