From: Tomka Gergely <gergely@tomka.hu>
Subject: strange test results
Date: Mon, 19 Mar 2007 20:47:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703192018130.18749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I am running tests on our new test device. The device has 2x2 core Xeon, 
intel 5000 chipset, two 3ware sata raid card on pcie, and 15 sata2 disks, 
running debian etch. More info at the bottom.

The first phase of the test is probing various raid levels. So i 
configured the cards to 15 JBOD disks, and hacked together a testing 
script. The script builds raid arrays, waits for sync, and then runs this 
command:

iozone -eM -s 4g -r 1024 -i0 -i1 -i2 -i8 -t16 -+u

The graphs of the results here:

http://gergely.tomka.hu/dt/index.html

And i have a lots of questions.

http://gergely.tomka.hu/dt/1.html

This graph is crazy, like thunderbolts. But the raid50 is generally slower 
than raid5. Why?

http://gergely.tomka.hu/dt/3.html

This is the only graph i can explain :)

http://gergely.tomka.hu/dt/4.html

With random readers, why raid0 slowing down? And why raid10 faster than 
raid0?

http://gergely.tomka.hu/dt/2.html

Why raid6 cant became faster, with multiple disks, as raid5 & 50?

So lots of questions. I am generally surprised by the non-linearity of 
some results and the lack of acceleration with more disks on other 
results. And now, the details:

Hardware:

Base Board Information
        Manufacturer: Supermicro
        Product Name: X7DB8
Processor Information
        Socket Designation: LGA771/CPU1
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel
        ID: 64 0F 00 00 FF FB EB BF
        Signature: Type 0, Family 15, Model 6, Stepping 4
(two cpus)
Memory Device
        Array Handle: 0x0017
        Error Information Handle: No Error
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 1
        Locator: DIMM x 4
        Bank Locator: Bank1
        Type: DDR2
        Type Detail: Synchronous
        Speed: 533 MHz (1.9 ns)
        Manufacturer: Not Specified
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified
(two of this also)

ursula:~# tw_cli show

Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
------------------------------------------------------------------------
c0    9590SE-8ML   8       7        7       0        1       1       -        
c1    9590SE-8ML   8       8        8       0        1       1       -        

The tests generally:
mdadm
mkfs.xfs
blockdev --setra 524288 md (maybe not a good idea for multiple arrays)
do iozone test

raid10 is two disks raid1s in raid0 and raid50 is three disk raid6s in 
raid0.

These test runs for a week, and now slowly finishing. For this reason, 
replicatong the test to filter out accidents not a good option.

Any comments?

-- 
Tomka Gergely, gergely@tomka.hu
