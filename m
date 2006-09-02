From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: serious trouble - raid5 won't assemble properly, vgscan sees no volumes
Date: Sat, 2 Sep 2006 18:47:06 +0200
Message-ID: <200609021847.06938.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My file server crashed *again* (think there's some harware faulty)
Now at boot time the array is not assembled, I get an I/O error.

/proc/mdstat looks like this:

Personalities : [raid5]
md0 : inactive sda1[0] sdd1[3] sdc1[2]
      732563712 blocks

unused devices: <none>

I am missing something like [UUUU] or so - what's going on here?

Before the server crash I had [U_UU] and vgscan didn't see any volumes.

Dex



-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com

-- 
VGER BF report: U 0.499989
