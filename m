From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: access *existing* array from knoppix
Date: Wed, 13 Sep 2006 16:32:04 +0200
Message-ID: <200609131632.04840.Dexter.Filmore@gmx.de>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <200609121637.53998.Dexter.Filmore@gmx.de> <45037.192.168.0.1.1158155288.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45037.192.168.0.1.1158155288.squirrel@bymeinc.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Rob Bray <raid@bymeinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Mittwoch, 13. September 2006 15:48 schrieb Rob Bray:
> > Am Dienstag, 12. September 2006 16:08 schrieb Justin Piszcz:
> >> /dev/MAKEDEV /dev/md0
> >>
> >> also make sure the SW raid modules etc are loaded if necessary.
> >
> > Won't work, MAKEDEV doesn't know how to create [/dev/]md0.
>
> mknod /dev/md0 b 9 0
> perhaps?

Uh huh, go and try. Next boot it's gone again.
running that command in /lib/udev/devices however made it permanent. 

Took way too long to figure tho. If the kernel devs feel like they need to 
hurl over a working system they better release proper docs for the 
replacement. And stop screwing with the syntax.
(Yes, wrong list, I know...)


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
