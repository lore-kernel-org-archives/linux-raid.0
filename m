From: "John Stoffel" <stoffel@lucent.com>
Subject: Re: degraded raid5 at bootup
Date: Fri, 13 Aug 2004 16:19:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16669.8785.592904.686201@gargle.gargle.HOWL>
References: <411D1B3E.9050306@tupshin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411D1B3E.9050306@tupshin.com>
To: Tupshin Harper <tupshin@tupshin.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Tupshin> I have a 5 disk raid5 using autodetect partitions. If I have
Tupshin> a clean array when I shut down, I always have a degraded
Tupshin> array with one disk removed when I boot back up. Below I
Tupshin> include the relevant dmesg output.  hdi1 is always the
Tupshin> problem. If I do a "mdadm -a /dev/md0 /dev/hdi1", then the
Tupshin> array rebuilds without a problem, and runs clean until I
Tupshin> reboot again. Any suggestions?

Are all your disks setup with partition 1 setup as 'Linux Raid'
properly?  Check /dev/hdi using 'cfdisk' and see what partition 1 has
for a type. 

Tupshin> Kernel is 2.6.8-rc2-mm2, but I've tried it with a few other
Tupshin> recent kernels (mm and not) and all have the same
Tupshin> problem. Distro is Debian Sid.

Tupshin> -Tupshin

Tupshin> md: considering hdl1 ...
Tupshin> md:  adding hdl1 ...
Tupshin> md:  adding hdj1 ...
Tupshin> md: hdi1 has different UUID to hdl1

This is a key line here!  You need to update the superblocks on the
raid elements to have the proper stuff.  My personal system is down,
so I can't tell you the exactl command, but make sure you've got the
same setup on all five disks.

I assume they're all the same size, right?  If so, just make sure
they're all the same partition stuff, etc.  

If need be, reboot your system and zero out the first few blocks on
/dev/hdi (say 32 or 64 blocks) and then re-partition the disk, and
then make sure partition 1 is set to Linux Raid.  

Then use the mdadm command to update the superblocks.

John

