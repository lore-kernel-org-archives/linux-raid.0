From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid and multiple distros
Date: Mon, 15 May 2006 14:54:27 +0200
Message-ID: <200605151454.27974.Dexter.Filmore@gmx.de>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca> <200605142000.56659.Dexter.Filmore@gmx.de> <17511.46222.221460.337788@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17511.46222.221460.337788@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I always use entire disks if I want the entire disks raided (sounds
> obvious, doesn't it...)  I only use partitions when I want to vary the
> raid layout for different parts of the disk (e.g. mirrored root, mirrored
> swap, raid6 for the rest).   But that certainly doesn't mean it is
> wrong to use partitions for the whole disk.

The idea behind this is: let's say a disk fails, and you get a replacement, 
but it has a different geometry or a few blocks less - won't work. 
Even the same disk model might vary after a while.
So I made 0xfd partitions of the size (whole disk minus few megs).

>
> > Now the devices have all two superblocks, the one left from the first try
> > which are now kinda orphaned and those now active.
> > Can I trust mdadm to handle this properly on its own?
>
> You can tell mdadm where to look.  If you want to be sure that it
> won't look at entire drives, only partitions, then a line like
>    DEVICES /dev/[hs]d*[0-1]
> in /etc/mdadm.conf might be what you want.
> However as you should be listing the uuids in /etc/mdadm.conf, any

Umm... yeah, should I?

> superblock with an unknown uuid will easily be ignored.
>
> If you are relying nf 0xfd autodetect to assemble your arrays, then
> obviously the entire-disk superblock will be ignored (because they
> wont be in the right place in any partition).

So mdadm --assemble --scan is fine for my scenario even with those orphaned 
superblocks.

Should get me some sedatives for the day when this all explodes :P

-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
