From: Gordon Henderson <gordon@drogon.net>
Subject: ext3 ..
Date: Mon, 3 Jan 2005 19:20:13 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501031754180.16453@lion.drogon.net>
References: <200501031734.j03HYO914483@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501031734.j03HYO914483@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Been folowing this with interst as just about everything I'm building
these days has raid1 to boot and data (typical small server setup), and
raid5 in larger boxes for data and ext3 ...

No problems with this yet - several power failures and disks lost and it's
all generally behaved as I expected it to. I've hot-chanaged SCSI drives
which have failed and cold changed IDE drives at a convenient time for the
server...

I did have a problem recently though - had a disk fail in an 8-disk
external SCSI array, arranged as a 7+1 RAID5 ... Then 5 minutes later had
a 2nd disk fail.

So to the upper layers, ext3, userland, etc. that should look like a
catastrophic hardware failure -- anything trying to read/write to it
should (IMO) have simply returned with IO errors.

What actually happened was that the kernel panicked and the whole box
ground to a halt. The server could have carried on doing usefull stuff
without this disk partition, but a big oops and halt wasn't useful.

(This is 2.4.27 in-case it matters)

I didn't have time to work out the why/what/wherevers of the problem, the
box was power cycled and brought online minus the external array. Ext3 did
its thing and enabled the box to come up in seconds rather than hours
(it's a big Dell - it boots Linux faster than it goes through its BIOS!)

As for the external array, well, that was resurected with mdadm with no
data lost, but thats another story...

Gordon
