From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: access array from knoppix
Date: Sat, 16 Sep 2006 12:26:11 +0200
Message-ID: <200609161226.11722.Dexter.Filmore@gmx.de>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <45098066.6020303@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45098066.6020303@maine.edu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> His advice 
> was valid.

Maybe valid but not helping with my problem since the problem is/was, 
that /dev/md0 didn't exist at all. mdadm -C won't create device nodes.

But I figured the workaround meanwhile, so it doesn't matter anymore.
(In case someone wanna know: mknod in /lib/udev/devices does it on a hard disk 
install, I guess could work in /dev on knoppix, too, haven't tried yet.)


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
