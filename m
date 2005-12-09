From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question BUGREPORT!
Date: Fri, 9 Dec 2005 05:03:25 +0100
Message-ID: <001101c5fc75$a28cb230$0400a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs><17300.56329.638969.509384@cse.unsw.edu.au><004201c5f9fe$50cc41a0$0400a8c0@dcccs><17300.58327.193597.248431@cse.unsw.edu.au><035b01c5fc4b$416c98f0$0400a8c0@dcccs> <17304.50474.390938.734714@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

After i get this on one of my disk node, imediately send this letter, and go
to the hosting company, to see, is any message on the screen.
But unfortunately nothing what i found.
simple freeze.
no message, no ping, no num lock!

The full message of  the node next reboot is here:
http://download.netcenter.hu/bughunt/20051209/boot.log

Next step, i try to restart the whole system. (the concentrator is hangs
too, caused by lost the st-0001 node)
The part of the next reboot message of the concentrator is here:
http://download.netcenter.hu/bughunt/20051209/dy-boot.log

Next step, i stops everything, to awoid more data lost.
Try to remove the possible bitmap from the md0 of  node-1 (st-0001).

The messages is there:
http://download.netcenter.hu/bughunt/20051209/mdadm.log

At this time i cannot remove the broken bitmap, only deactivating the use of
it.
But on next reboot, the node will try to use it again. :(

I have try to change the array to use an external bitmap, but the mdadm
failed to create it too.
The external bitmap file is here: (6 MB!)
http://download.netcenter.hu/bughunt/20051209/md0.bitmap

The error message is the same of internal bitmap creation.

I dont know exactly, what caused the fs-damage, but here is my "possible
list": (sorted)
1. the mdadm  (wrong bitmap size)
2. the kernel (wrong resync on startup)
3. the half written data, caused by first crash.

One question:
On a working array doing the bitmap creation is safe and race-free?
(I mean race between the bitmap-create and bitmap update.)

My data lost finally, really minimal. :-)

Cheers,
Janos


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, December 09, 2005 12:43 AM
Subject: Re: RAID5 resync question BUGREPORT!


> On Friday December 9, djani22@dynamicweb.hu wrote:
> > Hello, Neil,
> >
> > [root@st-0001 mdadm-2.2]# mdadm --grow /dev/md0 --bitmap=internal
> > mdadm: Warning - bitmaps created on this kernel are not portable
> >   between different architectured.  Consider upgrading the Linux kernel.
> >
> > Dec  8 23:59:45 st-0001 kernel: md0: bitmap file is out of date (0 <
> > 81015178) -- forcing full recovery
> > Dec  8 23:59:45 st-0001 kernel: md0: bitmap file is out of date, doing
full
> > recovery
> > Dec  8 23:59:46 st-0001 kernel: md0: bitmap initialized from disk: read
> > 12/12 pages, set 381560 bits, status: 0
> > Dec  8 23:59:46 st-0001 kernel: created bitmap (187 pages) for device
md0
> >
> > And the system is crashed.
> > no ping reply, no netconsole error logging, no panic and reboot.
>
> Hmmm, that's unfortunate :-(
>
> Exactly what kernel were you running?
>
> NeilBrown

