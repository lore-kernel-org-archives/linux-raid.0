From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: unknown ioctl32 cmd
Date: Sun, 31 Dec 2006 00:20:46 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612310014080.32449@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,



this line in mdadm-2.5.4

Detail.c:
185:  ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 &&

causes a dmesg warning when running `mdadm -D /dev/md0`:

ioctl32(mdadm:2946): Unknown cmd fd(7) cmd(50000915){10} arg(ff2905d0) 
on /dev/md0

on Aurora Linux corona_2.90 with 2.6.18-1.2798.al3.1smp(sparc64). The 
raid array was created using `mdadm -C /dev/md0 -l 1 -n 2 missing 
/dev/sdb2 -e 1.0`. Given that "case GET_BITMAP_FILE" is handled in 
(2.6.18.5), I wonder what exactly is causing this.


Keep me on Cc, but you always do that. Thanks :)

	-`J'
-- 
