From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: FR1 for kernel 2.6
Date: Sun, 26 Dec 2004 07:09:15 +0100 (MET)
Message-ID: <200412260609.iBQ69FQ31979@inv.it.uc3m.es>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I ported the FR1 (fast raid 1, bitmapped) driver to 2.6 kernels.  The
patch is in the patches directory in the archive

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.15b.tgz

I left out async writes this time round. 

I actually developed and tested on 2.6.3, and then did a further
(untested) port forward to 2.6.8.1, so reports welcome.  The kernel raid
architecture seems to have continued changing somewhat through the 2.6
series.

I've only tested mirrors with two components, no spares.

For reads, the 2.6 raid seems to have a new scheme (nearest head instead
of swapping drives every 128 requests).  I modified it slightly so that
"nearest" is weighted by measured the latency of the drives.

Peter

