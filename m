From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: raid5 resize in 2.6.17 - how will it be different from raidreconf?
Date: Mon, 22 May 2006 13:17:36 +0200
Message-ID: <200605221317.37083.Dexter.Filmore@gmx.de>
References: <200605220034.49858.Dexter.Filmore@gmx.de> <17520.61194.529436.322401@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17520.61194.529436.322401@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Will it be less risky to grow an array that way?
>
> It should be.  In particular it will survive an unexpected reboot (as
> long as you don't lose and drives at the same time) which I don't
> think raidreconf would.
> Testing results so far are quite positive.

Write cache comes to mind - did you test power fail scenarios?

> > (And while talking of that: can I add for example two disks and grow
> > *and* migrate to raid6 in one sweep or will I have to go raid6 and then
> > add more disks?)
>
> Adding two disks would be the preferred way to do it.
> Add only one disk and going to raid6 is problematic because the
> reshape process will be over-writing live data the whole time, making
> crash protection quite expensive.
> By contrast, when you are expanding the size of the array, after the
> first few stripes you are writing to an area of the drives where there
> is no live data.

Let me see if I got this right: if I add *two* disks and go from raid 5 to 6 
with raidreconf, no live data needs to be overwritten and in case something 
fails I will still be able to assemble the "old" array..?


-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C+++(++++) UL+>++++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS++(+) PE(-) Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D G++ e* h>++ r%>* y?
------END GEEK CODE BLOCK------

http://www.stop1984.com
http://www.againsttcpa.com
