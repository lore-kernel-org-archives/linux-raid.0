From: Adrian Sandor <aditsu@yahoo.com>
Subject: Re: "mdadm -Dsv" output
Date: Tue, 29 Jun 2010 16:39:47 -0700 (PDT)
Message-ID: <221904.67920.qm@web32407.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I figured out a few things after spending some time with the mdadm man page:
- the "_0" suffix is possibly related to the "homehost" (I guess the computer's hostname was modified) and auto-assembly; I have both "n" and "n_0" symlinks in /dev/md on those machines, pointing to the same "/dev/mdn" devices
- I can use /proc/mdstat for info instead; it looks decent, uses "mdn" names, can be accessed as a normal user, and doesn't require mdadm
- there's also /proc/partitions - very nifty

Still, I would like the output of mdadm -Dsv to be improved (regarding formatting and consistency).

Adrian


________________________________

Hi, this is not a big issue, but I'm unsatisfied with the output of mdadm -Dsv. I'm using mdadm 3.0.
Here's the output on one machine:

ARRAY /dev/md/0level=raid1 num-devices=2 metadata=0.90 UUID=91407351:9059f7b0:38ae7154:38049e4e
   devices=/dev/sdb1,/dev/sda1
ARRAY /dev/md/1level=raid1 num-devices=2 metadata=0.90 UUID=d1776dd8:db91f423:99830b25:d3f7cedd
   devices=/dev/sdc1,/dev/sdb3

The devices are shown as "/dev/md/n" instead of "/dev/mdn", and there's no space before "level".

On another machine I got:

ARRAY /dev/md1level=raid1 num-devices=2 metadata=0.90 UUID=88c8442e:4f17f837:bde095a2:d13819de
   devices=/dev/sdc1,/dev/sdd1
ARRAY /dev/md0level=raid10 num-devices=4 metadata=0.90 UUID=95e59d50:2eae3beb:bde095a2:d13819de
   devices=/dev/sda3,/dev/sdb1,/dev/sdc2,/dev/sdd2

Here it's showing "/dev/mdn", but again there's no space before "level", and the devices are not in order.

Third machine:

ARRAY /dev/md/0_0level=raid1 num-devices=2 metadata=0.90 UUID=24302b7f:d959dadb:5af0b895:7edd2b0f
   devices=/dev/sdb1,/dev/sda1
ARRAY /dev/md/3_0level=raid10 num-devices=4 metadata=0.90 UUID=19f4b34c:0ec56553:6bb0b7af:9ec1922b
   devices=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3
ARRAY /dev/md/2_0level=raid1 num-devices=2 metadata=0.90 UUID=d232d5b6:7d276c52:b7fe7b09:538f0c09
   devices=/dev/sdc2,/dev/sdd2
ARRAY /dev/md/1_0level=raid1 num-devices=2 metadata=0.90 UUID=2337ad91:997bfcc0:53f8cadc:1d167f18
   devices=/dev/sdc1,/dev/sdd1

Back to "/dev/md/n", but now there's an extra "_0" ?! Where did that come from?
Again, no space and not in order.
And on a 4th machine, the output is similar to the 3rd one.

All machines are running Gentoo Linux amd64 and the same mdadm version (3.0)

Another question is whether there's another way to output this information, that's more consistent, and more suitable for parsing by a program.

Thanks
Adrian


      
