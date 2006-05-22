From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: 4 disks in raid 5: 33MB/s read performance?
Date: Mon, 22 May 2006 17:46:38 +0200
Message-ID: <200605221746.38122.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
Isn't that a little slow?
System is a sil3114 4 port sata 1 controller with 4 samsung spinpoint 250GB, 
8MB cache in raid 5 on a Athlon XP 2000+/512MB.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
