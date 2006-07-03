From: Sevrin Robstad <quack@online.no>
Subject: RAID 5 crash, is there any way to recover some data ?
Date: Mon, 03 Jul 2006 19:31:36 +0200
Message-ID: <44A95478.2050004@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I *had* a RAID 5 consisting of 6 x 200GB drives. After a power failure, 
my motherboard failed and I replaced it with some old crap I had.
After some lockups on this platform I suddenly had more than one disk 
marked as bad.

And then, after some googling around - I tried "mdadm --assemble 
--force" ... It seemed fine when rebuilding, but after some time the 
hardware failed again..
Now my raid was GONE.

 I have tried some "mdadm --build" things, but I cannot get any data out 
of it, it stops on "no Ext3 filesystem found" ...

Is there *any* way for me to recover at least some of the data ?


Sevrin Robstad,
Norway
