From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: how to set stride / raid-howto still up to date?
Date: Sun, 24 Sep 2006 15:03:09 +0200
Message-ID: <200609241503.09808.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Want to change a partition from xfs to ext3 but can't tell what to put for 
stride.

man page says:

"stride=stripe-size
                          Configure  the  filesystem  for  a  RAID  array with
                          stripe-size filesystem blocks per stripe."

So, what is stripe size anyway? The same as chunk size? 

Is the example in the raid howto section 5.11 still valid? (It still tells 
about -R instead of -E. Seems a bit old.)

So going with -b 4096 for the ext3 with a 32k chunk size still comes down to a 
stride of 8, correct?

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
