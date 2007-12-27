From: "Cody Yellan" <cody@mochamail.com>
Subject: raid5 grow reshaping speed is unchangeable
Date: Wed, 26 Dec 2007 21:22:42 -0800
Message-ID: <380-220071242752242883@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a 4x500GB SATA2 array, md0.  I added one 500GB drive and
reshaping began at ~2500K/sec.  Changing
/proc/sys/dev/raid/speed_limit_m{in,ax} or
/sys/block/md0/md/sync_speed_m{in,ax} had no effect.  I shut down all
unnecessary services and the array is offline (not mounted).  I have
read that the throttling code is "fragile" (esp. with regard to
raid5) but does this make sense?  I will wait (in)patiently for it to
finish, but I do wonder why the configuration parameters have no
effect.  This is a dual quad 2GHz Xeon machine with 8GB of memory
running RHEL5.  Is this the maximum speed?

