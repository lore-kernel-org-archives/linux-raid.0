From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: raid5 performance - 2.4.28
Date: Mon, 10 Jan 2005 08:26:34 -0800
Message-ID: <41E2ACBA.6030503@nsr500.net>
References: <Pine.LNX.4.44.0501091639260.13461-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0501091639260.13461-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mark Hahn <hahn@physics.mcmaster.ca>
List-Id: linux-raid.ids



Mark Hahn wrote:
>>Here's a data point in favor of raw horsepower when considering
>>software raid performance.
> 
> 
> mostly sw r5 write performance, right?

Correct.  Writes increased by 3X, Rewrites by 50%, Reads about the same.

>>Athlon K7 (18u) @ 840MHz, 1GB PC133, Abit KA7
>>Athlon XP 2800 @ 2075MHz, 1GB PC2700, Asus A7V400-MX
> 
> 
> so your dram bandwidth (measured by stream, say) went from maybe 
> .8 GB/s to around 2 GB/s.  do you still have boot logs from the 
> older configuration around?  it would be interesting to know 
> the in-cache checksumming speed gain, ie:
> 
> raid5: using function: pIII_sse (3128.000 MB/sec)

The Abit KA7 was the first consumer mobo to use leading+trailing mem clock 
and bank interleaving, so memory speed has only slightly more than doubled:

Athlon slot-A @ 850MHz + PC133 SDRAM
------------------------------------
kernel: raid5: measuring checksumming speed
kernel:    8regs     :  1285.600 MB/sec
kernel:    32regs    :   780.800 MB/sec
kernel:    pII_mmx   :  1972.400 MB/sec
kernel:    p5_mmx    :  2523.600 MB/sec
kernel: raid5: using function: p5_mmx (2523.600 MB/sec)
kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27

Athlon XP @ 2075MHz + PC2700 DDR
--------------------------------
kernel: raid5: measuring checksumming speed
kernel:    8regs     :  3172.800 MB/sec
kernel:    32regs    :  1932.400 MB/sec
kernel:    pIII_sse  :  3490.800 MB/sec
kernel:    pII_mmx   :  4868.400 MB/sec
kernel:    p5_mmx    :  6229.200 MB/sec
kernel: raid5: using function: pIII_sse (3490.800 MB/sec)
kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27

I'm also experimenting with this patch to see if the xor hardwire for 
modern intel/AMD architectures is still valid.  With the old processor 
p5_mmx was always picked and always within a few MB/s.  The new XP is all 
over the map.

pre-patch: always pIII_sse (35xx)
post-patch: always p5_mmx (62xx)

--- ./include/asm-i386/xor.h.orig       Fri Aug  2 17:39:45 2002
+++ ./include/asm-i386/xor.h    Sun Jan  9 22:32:37 2005
@@ -876,3 +876,8 @@
     deals with a load to a line that is being prefetched.  */
  #define XOR_SELECT_TEMPLATE(FASTEST) \
         (cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
+
+/* This may have been true in 1998, but lets try what appears to be
+   nearly 4x faster */
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+       (cpu_has_xmm ? &xor_block_p5_mmx : FASTEST)

