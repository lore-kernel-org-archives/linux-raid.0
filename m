From: Ian Pilcher <arequipeno@gmail.com>
Subject: Small chunk size read performance penalty
Date: Sun, 18 Aug 2013 17:05:01 -0500
Message-ID: <kurge6$qi0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can anyone point me to a good explanation of the read performance impact
of small (RAID-5 and RAID-6) chunk sizes?

I understand why large chunks hurt write performance, but I haven't been
able to reason through the small-chunk/read case, and my Interweb
searches haven't really turned anything up.

The "read penalty" is definitely there; I can see it in the test data
from my NAS.  I just don't understand *why* it's there.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

