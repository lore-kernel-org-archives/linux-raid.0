From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: slackware -current softraid5 boot problem
Date: Tue, 9 May 2006 00:06:32 +0200
Message-ID: <200605090006.32615.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Finally got me a bunch of disks as a raid 5, I don't even want to boot from 
it, plain data array. four sata-II samsungs on a sil3114 controller, all fine 
so far.

Booting the machine I get "no superblock on /dev/sdd, stopping 
assembly" (or assembly aborted or so)
After boot has completed, running mdadm --assemble --scan --verbose manually 
works just fine and doesn't tell a thing about missing superblocks. 

Ideas, anyone?

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
