From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware bad write speed.
Date: Mon, 24 Mar 2003 09:18:39 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303240912080.2059-100000@chaos.egr.duke.edu>
References: <004f01c2f0b3$f72478d0$df01010a@moon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004f01c2f0b3$f72478d0$df01010a@moon>
To: Donghui Wen <dhwen@protegonetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 22 Mar 2003 at 12:45pm, Donghui Wen wrote

> Hi,
>  We used 3ware 7500-4 as ide raid controler on a redhat advanced server
> machine.
> (kernel 2.4.9-e12, lastest 3ware driver). But we got a pretty bad write
> speed.
> 
> Sequential Writes
>                               File  Blk   Num                   Avg
> Maximum      Lat%     Lat%    CPU
> Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency
> Latency      >2s      >10s    Eff
> ---------------------------- ------ ----- ---  ------ ------ --------- -----
> ------  -------- -------- -----
> 2.4.9-e.12enterprise          1792  4096    1    8.99 6.920%     0.394
> 29064.03   0.00240  0.00218   130
> 2.4.9-e.12enterprise          1792  4096    2   10.55 17.61%     0.637
> 23474.59   0.00480  0.00218    60
> 2.4.9-e.12enterprise          1792  4096    4    1.94 11.22%     0.156
> 1861.13   0.00000  0.00000    17
> 2.4.9-e.12enterprise          1792  4096    8    0.83 7.171%     0.274
> 995.19   0.00000  0.00000    12

The card is capable of much better than that.  Here are my numbers from a 
7 disk RAID5 array (8th is a hot spare) on a 7500-8 board:

Sequential Writes
                              File  Blk   Num                   Avg      
Maximum
      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    
Latency
      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- 
---------
--  -------- -------- -----
2.4.18-17SGI_XFS_1.2pre3smp   4096  4096    1   49.50 20.52%     0.068     
2915.
71   0.00124  0.00000   241
2.4.18-17SGI_XFS_1.2pre3smp   4096  4096    2   45.17 23.21%     0.141     
7873.
45   0.00343  0.00000   195
2.4.18-17SGI_XFS_1.2pre3smp   4096  4096    4   39.98 23.29%     0.335    
13338.
23   0.00887  0.00010   172
2.4.18-17SGI_XFS_1.2pre3smp   4096  4096    8   39.23 24.30%     0.631     
7887.
96   0.01535  0.00000   161

Obviously I've got more spindles, but your speeds shouldn't be *that* bad.  
Some things to check:

1) You said latest drivers, but make sure that you upgraded everything -- 
a driver set from 3ware is driver+firmware+3dm.  Specifically, make sure 
your firmware is up to date with your driver.

2) Make sure that your kernel supports HIGHIO.  I don't know if that 
enterprise kernel does (do you need to run it?), but it makes a *big* 
difference.  The latest 3ware drivers support HIGHIO, but the kernel needs 
to as well.

3) Make sure your drives are listed as compatible.

4) Try a different FS.  The numbers above are with XFS -- with ext3 I was 
getting write speeds of only half that (at best).

Good luck.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

