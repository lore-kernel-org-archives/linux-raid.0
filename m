From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 19:53:37 -0500
Message-ID: <4A31A711.1030302@gmail.com>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk> <20090611081909.GA16250@cthulhu.home.robinhill.me.uk> <20090611160741.GG30825@rlogin.dk> <20090611194552.GQ30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090611194552.GQ30825@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Ole Olsen wrote:
> Here is some new info (iostat) about the 7MB/s slowness on my reshape
> with 3x sata disks on pci32bit controller and 6x sata on onboard sata2.
> 
> sata_sil and sata_nv
> 
> 
> sda                                                                                                                                                                                                                                                                      
> 200+0 records in                                                                                                                                                                                                                                                         
> 200+0 records out                                                                                                                                                                                                                                                        
> 209715200 bytes (210 MB) copied, 2,46597 s, 85,0 MB/s                                                                                                                                                                                                                    
> sdb                                                                                                                                                                                                                                                                      
> 200+0 records in                                                                                                                                                                                                                                                         
> 200+0 records out                                                                                                                                                                                                                                                        
> 209715200 bytes (210 MB) copied, 1,66641 s, 126 MB/s                                                                                                                                                                                                                     
> sdc                                                                                                                                                                                                                                                                      
> 200+0 records in                                                                                                                                                                                                                                                         
> 200+0 records out                                                                                                                                                                                                                                                        
> 209715200 bytes (210 MB) copied, 2,51205 s, 83,5 MB/s                                                                                                                                                                                                                    
> sdd                                                                                                                                                                                                                                                                      
> 200+0 records in                                                                                                                                                                                                                                                         
> 200+0 records out                                                                                                                                                                                                                                                        
> 209715200 bytes (210 MB) copied, 2,33702 s, 89,7 MB/s                                                                
> 
> Here the 3 of them are the ones on pci32 controller, 
> the other faster ones are on onboard non limited bus.
> 
> 
> 
> mfs:/sys/block/md0/md# cat /proc/mdstat 
> Personalities : [raid6] [raid5] [raid4] 
> md0 : active raid5 sdd[7] sdb[8] sda[0] sdi[6] sdh[5] sdg[4] sdf[3] sde[2] sdc[1]
>       8790830976 blocks super 0.91 level 5, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
>       [==========>..........]  reshape = 51.1% (749118592/1465138496) finish=1652.2min speed=7221K/sec
>       
> unused devices: <none>
> 
> 
> 
> iostat about 50% in the reshape process:
> 
> mfs:/sys/block/md0/md# iostat -x
> Linux 2.6.29.3mfs_diskless (mfs)        2009-06-11      _i686_
> 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0,16    0,00   15,15    6,41    0,00   78,28
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
> sda            3704,06  1627,96   80,37   42,38  3992,51 13379,26   141,52     1,71   13,95   6,20  76,05
> sdb              26,39  1082,62   30,03   62,18 13813,39  9170,85   249,26     0,21    2,23   1,78  16,43
> sdc            3724,00  1631,34   70,22   39,28  4072,93 13382,07   159,40     2,28   20,79   7,90  86,48
> sdd              23,03  1108,80   28,68   36,31 11215,20  9173,71   313,71     0,84   12,87   8,40  54,63
> sde            3632,20  1616,12  166,13   55,42  4102,69 13387,29    78,94     0,75    3,39   1,29  28,48
> sdf            3630,85  1615,61  166,97   55,42  4097,89 13383,03    78,60     0,71    3,18   1,24  27,60
> sdg            3625,92  1614,66  168,60   56,45  4071,61 13383,51    77,56     0,65    2,88   1,17  26,36
> sdh            3615,89  1613,62  168,65   57,71  3991,22 13385,10    76,77     0,63    2,76   1,15  26,09
> sdi            1457,20  3823,78   66,63   90,17 12200,35  5030,01   109,88     0,74    4,69   2,16  33,89
> md0               0,00     0,00    0,01  720,25     0,09 25050,75    34,78     0,00    0,00   0,00   0,00
> dm-0              0,00     0,00    0,01  720,25     0,08 25050,75    34,78    15,42   21,41   0,25  17,96
> dm-1              0,00     0,00    0,00    0,00     0,00     0,00     8,00     0,00    7,95   3,21   0,00
> 
> sda,sdc,sdd = addon pci sata_sil pci32 card
> the rest are onboard sata2 controller.
> 
> seems there is a lot of wait for those disks, and that it is the pci controller which is the cause
> 
> there seems to be only 2-4ms wait time for onboard sata disks, but 12-20ms on addon pci board.
> 
> also the %util is almost 100% on each of the 3 disks on the pci controller
> 
> but I still don't understand it, but somehow the whole system must be waiting for the pci bus :)
> 
> it seems there is 21ms wait time for each request due to this pci slowness. (await is in miliseconds)
> 
> might be the controller that isnt so fast to do simultaneous read and writes, 
> perhaps because its NCQ support might be bad?
> 
> so I don't really have more ideas, except to buy a new controller card from a better brand (Adaptec) :(
> 
> Im planning another reshape and I dont want it to take 3 days again.
> 
> Best Regards,
> Michael Ole Olsen


It does not really matter what kind of 32bit PCI card that yout put in 
a desktop pci bus.

A standard pci-32 control has in theory about 133 mb/second, in 
reality it has around 90mb/second.     Unless you are changing to a 
pci-x (500mb/second+ at 66mhz-but only on "server" boards) or a 
pcie-x1 (266mb/second) or pcie-x4 (1024mb/second) I would not expect a 
major improvement.   And *ALL* of the pci bus bandwidth is shared 
between all of the slots so more cards won't help on a desktop pci 
board, on the server boards the pci-x slots only usually share 
bandwidth with at most one other slot.   With pcie of almost any type 
they don't share bandwidth so multiple cards help when the slots are 
not sharing bandwidth, but may actually make things worse if you are 
sharing bandwidth.

If you really want to open your eyes to how bad things are run 3 dd's 
at the same time on the 3 pci disk, and then do the same with 3 disks 
on the motherboard controller, and things will look much much worse, I 
would predict that the disks on the pci controller will each do about 
25mb/second, where as the 3 on the mb controller will likely slow down 
very little over the single disk speed.

