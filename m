From: Derek Yeung <dky@utcc.utoronto.ca>
Subject: Raid 1 / Multiple Reboot Problem
Date: Wed, 13 Aug 2003 10:35:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0308131028050.11694-100000@gpu.utcc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi software raid experts!

I'm currently running on Redhat 9 Stock kernel/Raid 1 (mirroring) with 2 
disks

I was testing one of my boxes last night and decided to set initdefault to
6, thus letting the machine to reboot infinitely.  The theory is that the
machine should boot non-stop.  After a few reboots, one of the devices
would fail and the machine will drop to a single user prompt requesting
that the raid set be repaired.  (all it looked like was that the mirrors
wanted to resync)..  Is this the correct behaviour?  I thought that the 
machine (mirror) should survive this?

I'd also like to know how would i be able to set the parameter in 
/proc/sys/dev/raid/speed_limit_max to be a large number automatically?  
Where should I set this parameter?  Should I do it in /etc/sysctl.conf?  
How would I go about doing it?


Thanks very, very much in advance!

