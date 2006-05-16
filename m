From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: softraid and multiple distros
Date: Tue, 16 May 2006 14:24:48 +0200
Message-ID: <200605161424.49057.Dexter.Filmore@gmx.de>
References: <Pine.LNX.4.44.0605141048330.7486-100000@coffee.psychology.mcmaster.ca> <200605161216.00477.Dexter.Filmore@gmx.de> <17513.47199.99460.746601@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17513.47199.99460.746601@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So in the very simple one-array situation, this is probably safe.
> But it doesn't generalise.  If you have two array of distinct devices,
> then something like
>
>  ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1
>  ARRAY /dev/md1 devices=/dev/sde1,/dev/sdf1,/dev/sdg1,/dev/sdh1
>
> is not safe.  If /dev/sda1 fails, you pull it out and reboot, then md1
> won't be assembled properly as everything will get renamed.
> In general it is safer to use UUIDs
>
>   DEVICE /dev/sd[a-z][0-9]
>   ARRAY /dev/md0 uuid=whatever
>   ARRAY /dev/md1 uuid=whatever:else
>
> Hope that makes it reasonably clear.

Absolutely, thanks.


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
