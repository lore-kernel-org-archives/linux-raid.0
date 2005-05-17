From: Jay Strauss <me@heyjay.com>
Subject: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 10:11:31 -0500
Message-ID: <428A09A3.9000802@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just installed a simple raid-1.  I have a single HD on each 
controller.  ie. 2 controllers 2 HDs. That's it, no CD players or DVD 
drives...

I did a fresh install of Sarge.  After reboot I unplugged the CD drive, 
and let the array sync overnight.  It took 10hrs to sync 160GiB, which 
seemed pretty long, so I executed the "dd if=/dev/hda of=/dev/null 
bs=64k count=10000" command I've seen posted on this list.

It took about a minute and change to complete, which is long.  So out of 
curiosity I plugged in a CD player and booted Knoppix.  When I ran the 
same command it took only 30 seconds (which is still not as quick as 
some of the numbers on this list, but it's an old celeron 466MHz).

I'm very unfamiliar with options for speeding up hard drive access. 
What might Knoppix be setting (and how would I look for it), that it's 
getting 100% better drive performance than a plain jane Sarge install?

Thanks
Jay

******** Knoppix Run ***********

root@ttyp0[~]# for i in 1 2 3; do
 > time dd if=/dev/hda of=/dev/null bs=64k count=10000
 > done
10000+0 records in
10000+0 records out
655360000 bytes transferred in 46.301872 seconds (14154071 bytes/sec)

real    0m46.754s
user    0m0.480s
sys     0m29.710s

10000+0 records in
10000+0 records out
655360000 bytes transferred in 49.852186 seconds (13146063 bytes/sec)

real    0m51.075s
user    0m0.430s
sys     0m26.610s

10000+0 records in
10000+0 records out
655360000 bytes transferred in 46.237684 seconds (14173720 bytes/sec)

real    0m47.928s
user    0m0.480s
sys     0m31.770s

************** Sarge Run *************

sandy:~# for i in 1 2 3; do
 > time dd if=/dev/hda of=/dev/null bs=64k count=10000
 > done
10000+0 records in
10000+0 records out
655360000 bytes transferred in 66.004525 seconds (9929016 bytes/sec)

real    1m6.052s
user    0m0.637s
sys     1m2.888s

10000+0 records in
10000+0 records out
655360000 bytes transferred in 63.797226 seconds (10272547 bytes/sec)

real    1m3.886s
user    0m0.678s
sys     1m0.732s

10000+0 records in
10000+0 records out
655360000 bytes transferred in 64.729628 seconds (10124575 bytes/sec)

real    1m4.822s
user    0m0.616s
sys     1m1.668s

