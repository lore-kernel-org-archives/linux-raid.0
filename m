From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid and multiple distros
Date: Tue, 16 May 2006 12:16:00 +0200
Message-ID: <200605161216.00477.Dexter.Filmore@gmx.de>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca> <200605151454.27974.Dexter.Filmore@gmx.de> <17512.64468.813293.673836@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17512.64468.813293.673836@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> An alternative is to use the --size option of mdadm to make the array
> slightly smaller than the smallest drive.  

timtowtdi, as usual

> > > However as you should be listing the uuids in /etc/mdadm.conf, any
> > Umm... yeah, should I?
> What else would you use to uniquely identify the arrays?  Not device
> names I hope.

Right now all that's in mdadm.conf is:

DEVICE /dev/sd[abcd]1
ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
MAILADDR root@localhost

Something important missing..?

> > Should get me some sedatives for the day when this all explodes :P
>
> Just make sure it happens on your day off, then someone else will
> need the sedatives :-)

Yeah, the landlord.

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
