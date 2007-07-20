From: Al Boldi <a1426z@gawab.com>
Subject: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 08:13:03 +0300
Message-ID: <200707200813.03553.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

As always, a good friend of mine managed to scratch my partion table by 
cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
at least the first 100MB are gone.  I can probably live without the first 
partion, but there are many partitions after that, which I hope should 
easily be recoverable.

I tried parted, but it's not working out for me.  Does anybody know of a 
simple partition recovery tool, that would just scan the disk for lost 
partions?


Thanks!

--
Al

