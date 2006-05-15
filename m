From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid and multiple distros
Date: Mon, 15 May 2006 13:50:06 +0200
Message-ID: <200605151350.06175.Dexter.Filmore@gmx.de>
References: <Pine.LNX.4.44.0605141438340.7486-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605141438340.7486-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Sonntag, 14. Mai 2006 20:42 schrieben Sie:
> > Now the devices have all two superblocks, the one left from the first try
> > which are now kinda orphaned and those now active.
> > Can I trust mdadm to handle this properly on its own?
>
> I'm not sure what "properly" means.  you should not leave around 0xfd

Well, properly means properly. As opposite of "f!ck up".
Here: chose the superblocks from the partitions instead of from the entire 
hdd.
There is everything fine with those fs partitions and the array, but there 
seems some old superblocks lying to be around behind those partitions.

> or zero the superblock or both...

More questions: is the raid superblock the same as an "ordinary" file system 
superblock? 
"Zero" the superblock - the orphaned one, I assume? This is not like "zero it 
and linux makes a new one" or so?

Dex


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
