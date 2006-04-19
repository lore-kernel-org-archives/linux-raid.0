From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: replace disk in raid5 without linux noticing?
Date: Wed, 19 Apr 2006 16:31:04 +0200
Message-ID: <200604191631.04305.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Let's say a disk in an array starts yielding smart errors but is still 
functional.
So instead of waiting for it to fail completely and start a sync and stress 
the other disks, could I clone that disk to a fresh one, put the array 
offline and replace the disk? 

 
-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
