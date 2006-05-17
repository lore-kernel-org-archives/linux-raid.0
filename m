From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: copying data over NFS to raid5 array is jumpy
Date: Wed, 17 May 2006 23:38:03 +0200
Message-ID: <200605172338.03486.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

copying from a local standalone disk to a raid5 array works smooth at a 
constant 30MB/s. So far, so good.

Now, copying data from a machine on the network over 100MBit NFS is kinda 
jerky. It works, but within a second or two, the transfer rate reported goes 
from a few 100k/s up to 22MB/s (which is bogus - 100MBit=12.5MB/s max) and 
back, varying all over.
Copying to the single disk works is constant around 10MB/s.

I use "sync" in exportfs for all shares.

What could cause this behaviour?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
