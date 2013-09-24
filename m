From: Ian Pilcher <arequipeno@gmail.com>
Subject: Detecting that an array has been stopped
Date: Tue, 24 Sep 2013 15:20:24 -0500
Message-ID: <l1ss60$fun$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've successfully gotten my NAS monitoring program to check the status
of my RAID arrays by parsing /proc/mdstat.  (Definitely a PITA, but I
did get to learn about RAID 10 layouts ans POSIX regular expressions.)

I'm now thinking about how to make the program robust in the situation
where the array names (in /proc/mdstat) aren't necessarily stable.  For
example, a couple of arrays might be stopped for some sort of
maintenance activity and "swap" names when they are reassembled.

The obvious answer is to use mdadm to check the UUIDs of the arrays, but
I don't want to do that every time I check the RAID status (currently
every 30 seconds).  So my plan is to only read the UUID of an array
when it first appears in /proc/mdstat (i.e. it wasn't there the last
time I read the file).

This will work as long as the program notices that an array has been
stopped before a (possibly different) array appears with the same name.
So it would be nice if there were a simple way to reliably detect that
a particular array has been stopped -- even if a different array has
since been started with the same name.  It appears that I can do this
pretty easily with sysfs.

From my initial testing, it looks like I can open each array's
array_state file when I first detect the array, and lseek/read will
return ENODEV if the array is ever stopped -- even if the array is
restarted (with the same or a different name) or if a different array is
started with the same name.

It seems almost too easy.

Is there any reason that this approach won't work?

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

