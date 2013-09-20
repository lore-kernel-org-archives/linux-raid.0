From: Ian Pilcher <arequipeno@gmail.com>
Subject: Testing /proc/mdstat parsing
Date: Fri, 20 Sep 2013 18:03:21 -0500
Message-ID: <l1ik7i$epk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For my NAS monitoring daemon, I have decided to check the status of my
RAID arrays by parsing /proc/mdstat.  (I did consider using sysfs,
ioctls, or mdadm, but /proc/mdstat seems to be the most efficient way
to get a "snapshot" of the state of all the arrays.)

I've played around with various setups and failure scenarios in a VM,
and I've also reviewed md_seq_show() in md.c.  Based on this, I've
written parsing code that can handle everything that I've been able to
come up with so far.  But that's just me ...

Does anyone know of or have a collection of /proc/mdstat examples that
can be used for testing?

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

