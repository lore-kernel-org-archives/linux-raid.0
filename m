From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: high mismatch count after scrub
Date: Tue, 6 Mar 2007 03:06:45 +0100
Message-ID: <200703060306.46082.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I practiced what I learned today and scrubbed the array.
Getting this:

xerxes:/sys/block/md0/md# cat mismatch_cnt
147248

4x 250GB Samsung sATA, smartctl says all fine.

Need to worry?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
