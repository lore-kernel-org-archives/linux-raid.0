From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: excessive IO reported by kernel 2.6
Date: Sat, 15 Apr 2006 13:58:34 -0300
Message-ID: <17473.9786.98946.529932@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've just switched our main server from kernel 2.4 to 2.6. Now I have
more info displayed by iostat, and the numbers look strange:

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
md0              14,46        57,17       104,96   18050544   33136016
md2              71,53       145,46       519,37   45922192  163968648
md1               0,05         0,19         0,19      60592      58688

md0 is /, md1 swap and md2 /home.

What I find strange is that the Blk_read for md0 is not negligible
compared to md2; md0 only has bin, console, dev, etc, lib, proc, root,
sbin, sys and usr. These should be read mostly soon after boot and
afterwards the partition should have very small io. The whole /
partition has only 2.4GB. Note also that Blk_wrtn for md0, though
smaller than for md2, shows about 33GB, which is more than an order of
magnitude more than the space used. And worse, it's bigger than Blk_read.

There's surely something I'm missing here...
