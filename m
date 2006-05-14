From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid and multiple distros
Date: Sun, 14 May 2006 20:00:56 +0200
Message-ID: <200605142000.56659.Dexter.Filmore@gmx.de>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Sonntag, 14. Mai 2006 16:50 schrieben Sie:
> > What do I need to do when I want to install a different distro on the
> > machine with a raid5 array?
> > Which files do I need? /etc/mdadm.conf? /etc/raittab? both?
>
> MD doesn't need any files to function, since it can auto-assemble
> arrays based on their superblocks (for partition-type 0xfd).

I see. Now an issue arises someone else here mentioned: 
My first attempt was to use the entire disks, then I was hinted that this 
approach wasn't too hot so I made partitions. 
Now the devices have all two superblocks, the one left from the first try 
which are now kinda orphaned and those now active. 
Can I trust mdadm to handle this properly on its own?

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
