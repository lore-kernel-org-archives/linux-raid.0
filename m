From: Maxwell Bottiger <mbotti1@gl.umbc.edu>
Subject: recovery of software raid0
Date: Fri, 14 Jun 2002 18:06:29 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.31L.02.0206141758490.21148-100000@linux1.gl.umbc.edu>
References: <3D0A3100.9010506@umich.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D0A3100.9010506@umich.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, my system was hacked today and everything is a mess.  I need to get to
two raid 0 partitions and recover the data off of them before I wipe and
clean the system.

The problem is that I have no root partition or much of any other system
directories.  It appears all my raid partitons are in good shape, but I
need to mount them from something like my rescue disk.  How can I go about
doing this?  I no longer have a raidtab or fstab, but I know which
partitons go together and I'm 99% sure they all have persistant
superblocks so they shoud be easily reccognized.

If this is simply a matter of putting in a temporary raidtab file could
someone please send me a sample one?  Also, would someone please give me
an example of what arguments to give mount in order to mount the disks
propperly.

If it is possible to get back to me about this quickly please do.  I
really need to get this box back online, everything I have is in those
home directories.


Maxwell (SleepyLight) Bottiger
Theatre and Computer Science Undergrad at UMBC
       (o_   (o_
  (o_  //\   //\
  (/)_ V_/_  V_/_  If at first you don't succeed, redefine success.



