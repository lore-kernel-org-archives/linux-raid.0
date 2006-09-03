From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: serious trouble - raid5 won't assemble properly, vgscan sees no volumes - solved
Date: Sun, 3 Sep 2006 14:57:35 +0200
Message-ID: <200609031457.35485.Dexter.Filmore@gmx.de>
References: <200609021847.06938.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609021847.06938.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Array is online, degraded for the moment but I can access the file systems for 
backups.

I passed -A --force to mdadm, seems that did the trick. 

What puzzles me still is that I had a degraded array for the third time now 
and never could tell why it happened in the first place.
This time the machine crashed for no apparent reason, tho I suspect heat 
issues. Will investigate and eventually move the disks to another machine.

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
VGER BF report: S 0.991633
