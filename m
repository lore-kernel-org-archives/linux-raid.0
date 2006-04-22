From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: disks becoming slow but not explicitly failing anyone?
Date: Sat, 22 Apr 2006 17:05:34 -0300
Message-ID: <17482.35982.996526.551753@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We've been hit by a strange problem for about 9 months already. Our
main server suddenly becomes very unresponsive, the load skyrockets
and if demand is high enough it collapses. top shows many processes
stuck in D state. There are no raid or disk error messages, either in
the console or logs.

The machine has 4 IDE disks in a software raid5 array, connected to a
3Ware 7506. Only once I saw warnings of scsi resets of the 3Ware due
to timeouts.

This 3Ware card has leds which are on when there's activity in the IDE
channel. As expected, all leds turn on and off almost simultaneously
during normal operation of the raid5, however when the problem appears
one of the leds stays on much longer than the others for each burst of
activity. This shows that the disk is getting much slower than the
others, holding the whole array.

Several times a smart test of the disk shows read failures but not
always. I've changed cables, 3Ware card and even connected the slow
disk in the IDE channel of the motherboard to no avail. Changing the
disk and reconstructing the array restores normal operation.

This has happened with 7 (seven!!) disks already, 80GB and 120GB,
Maxtor and Seagate. Has anyone else seen this?
