From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: second controller: what will my discs be called, and does it matter?
Date: Thu, 6 Jul 2006 20:12:14 +0200
Message-ID: <200607062012.14684.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Currently I have 4 discs on a 4 channel sata controller which does its job 
quite well for 20 bucks. 
Now, if I wanted to grow the array I'd probably go for another one of these.

How can I tell if the discs on the new controller will become sd[e-h] or if 
they'll be the new a-d and push the existing ones back?

Next question: assembling by UUID, does that matter at all?
(And while talking UUID - can I safely migrate to a udev-kernel? Someone on 
this list recently ran into trouble because of such an issue.)

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
