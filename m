From: Matthias Julius <jnews@julius-net.net>
Subject: Re: Raid5 with 2 bad drives
Date: Wed, 23 Feb 2005 08:35:13 -0500
Message-ID: <877jkzbdri.fsf@julius-net.net>
References: <u650k4kbd.fsf@julius-net.net> <Pine.LNX.4.56.0502221656160.4157@lion.drogon.net>
 <87fyzoaz31.fsf@julius-net.net> <421C216B.8050209@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy <mhardy@h3c.com> writes:

> I posted a raid5 parity calculator implemented in perl a while back (a
> couple weeks?) that is capable of taking your disk geometry, the RAID
> LBA you're interested in, and finding the disk sector it belongs to.
>
> I honestly don't remember if it can go the other way, but I'm not sure
> why it couldn't? Its possible that bad blocks may simply be in the
> parity chunk of the stripe too. Once you've got the RAID LBA you can
> use the methods in the BadBlockHowto to find the file

That helps.  Although there is a typo in line 139.  See diff below.

When I know the RAID LBA how do I find out to which LV it belongs and
which sector it is in there?  But, I guess I better ask that on a LVM
list.

Matthias

--- raid5calc.orig      2005-02-23 08:26:43.721332354 -0500
+++ raid5calc   2005-02-23 08:30:12.673100526 -0500
@@ -136,7 +136,7 @@
 # Testing only -
 # Check to see if the result I got is the same as what is in the block
 open (DEVICE, "<" . $component{"device"})
-    || die "Unable to open device " . $compoent{"device"} . ": " . $! . "\n";
+    || die "Unable to open device " . $component{"device"} . ": " . $! . "\n";
 seek(DEVICE, $device_offset, 0)
     || die "Unable to seek to " . $device_offset . " device " . $xor_devices{$i} . ": " . $! . "\n";
 read(DEVICE, $data, ($sectors_per_chunk * 512))

